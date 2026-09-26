import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

final outDir = Platform.environment['TILE_OUT']!;

Future<void> loadFonts() async {
  final fr = Platform.environment['FLUTTER_ROOT']!;
  final mf = '$fr/bin/cache/artifacts/material_fonts';
  Future<void> load(String family, List<String> files) async {
    final l = FontLoader(family);
    for (final p in files) {
      l.addFont(Future.value(ByteData.sublistView(File(p).readAsBytesSync())));
    }
    await l.load();
  }

  await load('Roboto', [
    '$mf/Roboto-Regular.ttf',
    '$mf/Roboto-Medium.ttf',
    '$mf/Roboto-Bold.ttf',
  ]);
  await load('MaterialIcons', ['$mf/MaterialIcons-Regular.otf']);
  const sf = '/System/Library/Fonts/SFNS.ttf';
  for (final fam in [
    'CupertinoSystemText',
    'CupertinoSystemDisplay',
    '.SF Pro Text',
    '.SF Pro Display',
    '.SF UI Text',
    '.SF UI Display',
    'SFNS',
  ]) {
    await load(fam, [sf]);
  }
  // cupertino_icons lives in the pub cache; find it through package_config.
  final config = jsonDecode(
      File('.dart_tool/package_config.json').readAsStringSync()) as Map;
  final root = (config['packages'] as List)
      .cast<Map>()
      .firstWhere((p) => p['name'] == 'cupertino_icons')['rootUri'] as String;
  await load('packages/cupertino_icons/CupertinoIcons', [
    '${Uri.parse(root).toFilePath()}/assets/CupertinoIcons.ttf',
  ]);
}

/// Records a [RepaintBoundary] frame by frame into a raw RGBA file.
class Recorder {
  Recorder(this.name, {this.size = const Size(380, 380), this.dpr = 2});

  final String name;
  final Size size;
  final double dpr;
  final int fps = 25;
  final key = GlobalKey();
  late final RandomAccessFile _raf;
  int frames = 0;

  Widget wrap(Widget child) => RepaintBoundary(key: key, child: child);

  Future<void> start(WidgetTester t) async {
    await loadFonts();
    t.view.physicalSize = size * dpr;
    t.view.devicePixelRatio = dpr;
    _raf = File('$outDir/$name.rgba').openSync(mode: FileMode.write);
  }

  Future<void> frame(WidgetTester t) async {
    final b = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await t.runAsync(() async {
      final img = await b.toImage(pixelRatio: dpr);
      final bd = await img.toByteData(format: ui.ImageByteFormat.rawRgba);
      _raf.writeFromSync(bd!.buffer.asUint8List());
      img.dispose();
    });
    frames++;
  }

  /// Advances fake time by [d], capturing a frame every 1/fps.
  Future<void> record(WidgetTester t, Duration d) async {
    final step = Duration(microseconds: 1000000 ~/ fps);
    var el = Duration.zero;
    while (el < d) {
      await t.pump(step);
      el += step;
      await frame(t);
    }
  }

  void finish(WidgetTester t) {
    _raf.closeSync();
    final w = (size.width * dpr).round(), h = (size.height * dpr).round();
    File('$outDir/$name.json')
        .writeAsStringSync('{"w":$w,"h":$h,"frames":$frames,"fps":$fps}');
    t.view.reset();
  }
}
