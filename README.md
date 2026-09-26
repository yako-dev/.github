# Yako shared files

Files that every Yako Flutter package uses.

## `tiles/`

The preview tiles in the **More from Yako** grid at the bottom of each package
README. Each one is recorded from the package's real widget, so it shows
exactly what the package does.

| Package | Tile |
| --- | --- |
| [settings_ui](https://pub.dev/packages/settings_ui) | [`settings_ui.gif`](tiles/settings_ui.gif) |
| [badges](https://pub.dev/packages/badges) | [`badges.gif`](tiles/badges.gif) |
| [yako_celebrations](https://github.com/yako-dev/flutter-yako-celebrations) | [`yako_celebrations.webp`](tiles/yako_celebrations.webp) |
| [status_alert](https://pub.dev/packages/status_alert) | [`status_alert.gif`](tiles/status_alert.gif) |
| [full_screen_menu](https://pub.dev/packages/full_screen_menu) | [`full_screen_menu.gif`](tiles/full_screen_menu.gif) |
| [yako_theme_switch](https://pub.dev/packages/yako_theme_switch) | [`yako_theme_switch.gif`](tiles/yako_theme_switch.gif) |
| [diagonal_decoration](https://pub.dev/packages/diagonal_decoration) | [`diagonal_decoration.png`](tiles/diagonal_decoration.png) |

The READMEs load the tiles straight from this repo, so a new tile here shows
up in every README at once.

## Remake the tiles

`tools/tile_studio` renders each package's real widget in a headless Flutter
test, frame by frame, from the packages' GitHub sources. It needs macOS (it
uses the system San Francisco font for the iOS-style tiles), Flutter, `ffmpeg`
and `img2webp` (`brew install ffmpeg webp`).

```bash
tools/tile_studio/make_tiles.sh
```

The scenes are in `tools/tile_studio/test/tiles_test.dart`. Tiles are 480×480:
GIFs, a PNG for the still one, and an animated WebP for `yako_celebrations`,
whose particles would make a GIF too big.

## Add or update the grid in a README

```bash
python3 tools/more_from_yako.py settings_ui path/to/flutter-settings-ui/README.md
```

It writes the grid of every other package between the
`<!-- more-from-yako:start -->` and `<!-- more-from-yako:end -->` markers.
To add a package, add a tile and a row to `PACKAGES` in the script, then run
it for each README.
