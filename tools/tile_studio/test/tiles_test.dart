import 'package:badges/badges.dart' as badges;
import 'package:diagonal_decoration/diagonal_decoration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:material_ui/material_ui.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:status_alert/status_alert.dart';
import 'package:yako_celebrations/yako_celebrations.dart';
import 'package:yako_theme_switch/yako_theme_switch.dart';

import 'harness.dart';

const ms = Duration(milliseconds: 1);

Widget app(Widget home, {Color seed = Colors.indigo}) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: seed, useMaterial3: true),
      home: home,
    );

class Ctl extends ChangeNotifier {
  final Map<String, Object> v = {};
  T get<T>(String k, T d) => (v[k] as T?) ?? d;
  void set(Map<String, Object> m) {
    v.addAll(m);
    notifyListeners();
  }
}

Widget iconTile(IconData icon, Color bg, Color fg) => Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(icon, size: 42, color: fg),
    );

void main() {
  testWidgets('badges', (t) async {
    final rec = Recorder('badges');
    await rec.start(t);
    final c = Ctl();
    const white = TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15);
    await t.pumpWidget(rec.wrap(app(Scaffold(
      backgroundColor: Colors.white,
      body: ListenableBuilder(
        listenable: c,
        builder: (context, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  badges.Badge(
                    position: badges.BadgePosition.topEnd(top: -10, end: -10),
                    badgeAnimation: const badges.BadgeAnimation.slide(),
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: Color(0xFFE53935),
                      padding: EdgeInsets.all(8),
                    ),
                    badgeContent: Text('${c.get('cart', 1)}', style: white),
                    child: iconTile(Icons.shopping_cart_rounded,
                        const Color(0xFFEEF1FF), const Color(0xFF3F51B5)),
                  ),
                  const SizedBox(width: 36),
                  badges.Badge(
                    showBadge: c.get('bell', false),
                    position: badges.BadgePosition.topEnd(top: -10, end: -10),
                    badgeAnimation: const badges.BadgeAnimation.scale(),
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: Color(0xFFFF9800),
                      padding: EdgeInsets.all(8),
                    ),
                    badgeContent: const Text('3', style: white),
                    child: iconTile(Icons.notifications_rounded,
                        const Color(0xFFFFF3E6), const Color(0xFFEF6C00)),
                  ),
                  const SizedBox(width: 36),
                  badges.Badge(
                    showBadge: c.get('verified', false),
                    position:
                        badges.BadgePosition.bottomEnd(bottom: -6, end: -6),
                    badgeAnimation: const badges.BadgeAnimation.rotation(),
                    badgeStyle: const badges.BadgeStyle(
                      shape: badges.BadgeShape.twitter,
                      badgeColor: Color(0xFF1D9BF0),
                      padding: EdgeInsets.all(7),
                    ),
                    badgeContent:
                        const Icon(Icons.check, color: Colors.white, size: 14),
                    child: Container(
                      width: 84,
                      height: 84,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF42A5F5), Color(0xFF1E63D6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Text('Y',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  badges.Badge(
                    showBadge: c.get('new', false),
                    position: badges.BadgePosition.topEnd(top: -12, end: -18),
                    badgeAnimation: const badges.BadgeAnimation.size(),
                    badgeStyle: badges.BadgeStyle(
                      shape: badges.BadgeShape.square,
                      borderRadius: BorderRadius.circular(6),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      badgeGradient: const badges.BadgeGradient.linear(
                        colors: [Color(0xFF7C4DFF), Color(0xFFE040FB)],
                      ),
                    ),
                    badgeContent: const Text('NEW',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(children: [
                        Icon(Icons.music_note_rounded,
                            color: Color(0xFF6A1B9A), size: 22),
                        SizedBox(width: 6),
                        Text('Music',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ),
                  const SizedBox(width: 44),
                  badges.Badge(
                    showBadge: c.get('likes', false),
                    position: badges.BadgePosition.topEnd(top: -12, end: -12),
                    badgeAnimation: const badges.BadgeAnimation.scale(),
                    badgeStyle: const badges.BadgeStyle(
                      shape: badges.BadgeShape.instagram,
                      badgeColor: Color(0xFFE91E63),
                      padding: EdgeInsets.all(9),
                    ),
                    badgeContent: const Text('9', style: white),
                    child: const Icon(Icons.favorite_rounded,
                        size: 48, color: Color(0xFFE91E63)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ))));
    await rec.record(t, ms * 400);
    for (final step in <Map<String, Object>>[
      {'cart': 2},
      {'bell': true},
      {'cart': 3},
      {'verified': true},
      {'new': true},
      {'likes': true},
      {'cart': 4},
    ]) {
      c.set(step);
      await rec.record(t, ms * 400);
    }
    await rec.record(t, ms * 400);
    c.set({
      'cart': 1,
      'bell': false,
      'verified': false,
      'new': false,
      'likes': false,
    });
    await rec.record(t, ms * 800);
    rec.finish(t);
  });

  testWidgets('status_alert', (t) async {
    final rec = Recorder('status_alert');
    await rec.start(t);
    final c = Ctl();
    final bodyKey = GlobalKey();
    Widget song(String title, String artist, List<Color> art, bool loved) =>
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                    colors: art,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
              child: const Icon(Icons.music_note_rounded,
                  color: Colors.white70, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(artist,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF8E8E93))),
                ],
              ),
            ),
            Icon(
              loved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: loved ? const Color(0xFFFA2D48) : const Color(0xFFC7C7CC),
            ),
          ]),
        );
    await t.pumpWidget(rec.wrap(app(Scaffold(
      backgroundColor: Colors.white,
      body: ListenableBuilder(
        key: bodyKey,
        listenable: c,
        builder: (context, _) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Listen Now',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              song('Golden Hour', 'Morning Drive',
                  const [Color(0xFFFFB74D), Color(0xFFF4511E)], false),
              song('Blue Lights', 'Night Shift',
                  const [Color(0xFF4FC3F7), Color(0xFF3949AB)],
                  c.get('loved', false)),
              song('Green Fields', 'Open Road',
                  const [Color(0xFF81C784), Color(0xFF00897B)], false),
              song('Violet Sky', 'Late Show',
                  const [Color(0xFFBA68C8), Color(0xFF5E35B1)], false),
            ],
          ),
        ),
      ),
    ))));
    await rec.record(t, ms * 500);
    c.set({'loved': true});
    StatusAlert.show(
      bodyKey.currentContext!,
      duration: const Duration(milliseconds: 1600),
      maxWidth: 230,
      title: 'Loved',
      subtitle: "We'll recommend more like this For You.",
      configuration: const IconConfiguration(icon: Icons.favorite_border),
    );
    await rec.record(t, ms * 2800);
    c.set({'loved': false});
    await rec.record(t, ms * 400);
    rec.finish(t);
  });

  testWidgets('settings_ui', (t) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final rec = Recorder('settings_ui');
    await rec.start(t);
    final c = Ctl();
    Widget sf(String s) =>
        Text(s, style: const TextStyle(fontFamily: 'CupertinoSystemText'));
    Widget box(Color color, IconData icon) => Container(
          width: 29,
          height: 29,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(7)),
          child: Icon(icon, color: Colors.white, size: 19),
        );
    await t.pumpWidget(rec.wrap(app(ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        final dark = c.get('dark', false);
        return SettingsList(
          platform: DevicePlatform.iOS,
          brightness: dark ? Brightness.dark : Brightness.light,
          sections: [
            SettingsSection(
              title: sf('Appearance'),
              tiles: [
                SettingsTile.switchTile(
                  initialValue: dark,
                  onToggle: (_) {},
                  leading: box(const Color(0xFF5856D6), Icons.dark_mode),
                  title: sf('Dark mode'),
                ),
                SettingsTile.navigation(
                  leading: box(const Color(0xFF007AFF), Icons.text_fields),
                  title: sf('Text size'),
                  value: sf('Default'),
                ),
              ],
            ),
            SettingsSection(
              title: sf('General'),
              tiles: [
                SettingsTile.navigation(
                  leading: box(const Color(0xFF34C759), Icons.language),
                  title: sf('Language'),
                  value: sf('English'),
                ),
                SettingsTile.navigation(
                  leading: box(const Color(0xFFFF3B30), Icons.notifications),
                  title: sf('Notifications'),
                ),
                SettingsTile.navigation(
                  leading: box(const Color(0xFF8E8E93), Icons.lock),
                  title: sf('Privacy'),
                ),
              ],
            ),
          ],
        );
      },
    ))));
    await rec.record(t, ms * 1000);
    c.set({'dark': true});
    await rec.record(t, ms * 1600);
    c.set({'dark': false});
    await rec.record(t, ms * 1000);
    rec.finish(t);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('full_screen_menu', (t) async {
    final rec = Recorder('full_screen_menu');
    await rec.start(t);
    final bodyKey = GlobalKey();
    Widget item(IconData i, String label, Gradient g) => FSMenuItem(
          icon: Icon(i, color: Colors.white),
          text: Text(label, style: const TextStyle(color: Colors.white)),
          gradient: g,
          onTap: () {},
        );
    await t.pumpWidget(rec.wrap(app(
      Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: Padding(
          key: bodyKey,
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Weather',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              Container(
                height: 150,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4FACFE), Color(0xFF3F51B5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Row(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Kyiv',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      Text('24°',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 56,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 72),
                ]),
              ),
              const SizedBox(height: 14),
              Row(children: [
                for (final (d, i) in [
                  ('Mon', Icons.cloud),
                  ('Tue', Icons.grain),
                  ('Wed', Icons.wb_sunny),
                ]) ...[
                  Expanded(
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(d, style: const TextStyle(fontSize: 13)),
                          Icon(i, color: const Color(0xFF3F51B5)),
                        ],
                      ),
                    ),
                  ),
                  if (d != 'Wed') const SizedBox(width: 10),
                ],
              ]),
            ],
          ),
        ),
      ),
    )));
    await rec.record(t, ms * 500);
    FullScreenMenu.show(
      bodyKey.currentContext!,
      backgroundColor: Colors.black,
      items: [
        item(Icons.ac_unit, 'Make colder', blueGradient),
        item(Icons.wb_sunny, 'Make hotter', redGradient),
        item(Icons.flash_on, 'Lightning', orangeGradient),
        item(Icons.grain, 'Give a rain', lightBlueGradient),
        item(Icons.add, 'Add city', greenGradient),
      ],
    );
    await rec.record(t, ms * 2400);
    FullScreenMenu.hide();
    await rec.record(t, ms * 900);
    rec.finish(t);
  });

  testWidgets('yako_theme_switch', (t) async {
    final rec = Recorder('yako_theme_switch');
    await rec.start(t);
    final c = Ctl();
    await t.pumpWidget(rec.wrap(app(ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        final light = c.get('light', true);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: light ? const Color(0xFFF2F4F8) : const Color(0xFF15171E),
          alignment: Alignment.center,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Transform.scale(
              scale: 4,
              child: YakoThemeSwitch(
                enabled: light,
                onChanged: (v) => c.set({'light': v}),
              ),
            ),
            const SizedBox(height: 70),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 500),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: light ? const Color(0xFF1C1C1E) : Colors.white,
              ),
              child: Text(light ? 'Light mode' : 'Dark mode'),
            ),
          ]),
        );
      },
    ))));
    await rec.record(t, ms * 700);
    await t.tap(find.byType(YakoThemeSwitch));
    await rec.record(t, ms * 1800);
    await t.tap(find.byType(YakoThemeSwitch));
    await rec.record(t, ms * 1300);
    rec.finish(t);
  });

  testWidgets('diagonal_decoration', (t) async {
    final rec = Recorder('diagonal_decoration');
    await rec.start(t);
    Widget tile(String title, String subtitle, IconData icon) => Row(children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 3),
            Text(subtitle,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ]),
        ]);
    await t.pumpWidget(rec.wrap(app(Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            decoration: const DiagonalDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Main features',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                const SizedBox(height: 14),
                tile('Multi-currency account', '29 currencies', Icons.wallet),
                const SizedBox(height: 14),
                tile('Free cards', '1 virtual + 1 physical',
                    Icons.currency_exchange),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            decoration: const MatrixDecoration(),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Temperature',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text('in Kyiv', style: TextStyle(fontSize: 14)),
                SizedBox(height: 6),
                Text('32°C',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ]),
      ),
    ))));
    await rec.record(t, ms * 40);
    rec.finish(t);
  });

  testWidgets('yako_celebrations', (t) async {
    YakoCelebration.muted = true;
    YakoCelebration.hapticsEnabled = false;
    final rec = Recorder('yako_celebrations', size: const Size(560, 560), dpr: 1.4);
    await rec.start(t);
    final ctl = CelebrationController();
    await t.pumpWidget(rec.wrap(app(Scaffold(
      backgroundColor: const Color(0xFF101218),
      body: CelebrationOverlay(
        controller: ctl,
        child: const SizedBox.expand(),
      ),
    ))));
    await t.runAsync(() => precacheImage(
        const AssetImage('assets/yako_logo.png'),
        t.element(find.byType(CelebrationOverlay))));
    await rec.record(t, ms * 200);
    ctl.celebrate(
      tier: CelebrationTier.epic,
      title: 'LEVEL UP!',
      seed: 7,
      brand: const CelebrationBrand(
        name: 'Yako',
        image: AssetImage('assets/yako_logo.png'),
      ),
    );
    await rec.record(t, ms * 5200);
    rec.finish(t);
  });
}
