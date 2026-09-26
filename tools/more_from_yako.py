#!/usr/bin/env python3
"""Writes the "More from Yako" grid into a package README.

    python3 tools/more_from_yako.py <package> <path/to/README.md>

The grid shows every other Yako package with its tile from this repo. It goes
between the more-from-yako markers; on the first run it replaces the old
"Check out other Yako packages" list, or goes above "## License", or at the end.
"""
import re
import sys

TILES = "https://raw.githubusercontent.com/yako-dev/.github/main/tiles"

# name, link, file, one line for people, alt text (what the tile shows).
PACKAGES = [
    ("settings_ui", "https://pub.dev/packages/settings_ui", "settings_ui.gif",
     "Settings screens that look native on every platform.",
     "Animated demo of the settings_ui Flutter package: an iOS-style settings "
     "screen with Appearance and General sections; turning on Dark mode "
     "switches the whole list to dark."),
    ("badges", "https://pub.dev/packages/badges", "badges.gif",
     "Badges for any widget: counters, dots, shapes and animations.",
     "Animated demo of the badges Flutter package: a count badge on a cart "
     "icon goes from 1 to 4, a notification badge pops in, and a Twitter-style "
     "verified badge, a NEW label and an Instagram-shaped badge appear."),
    ("yako_celebrations", "https://pub.dev/packages/yako_celebrations",
     "yako_celebrations.webp",
     "Full-screen celebrations in one line: confetti, coins, fireworks, flames.",
     "Animated demo of the yako_celebrations Flutter package: an epic "
     "celebration fills a dark screen with fireworks, flames, spinning coins, "
     "confetti and popping Yako logos under a LEVEL UP! title."),
    ("status_alert", "https://pub.dev/packages/status_alert", "status_alert.gif",
     "Apple-style status alerts that hide themselves.",
     "Animated demo of the status_alert Flutter package: liking a song shows "
     "an Apple-style blurred Loved popup with an icon and a subtitle, which "
     "then fades away."),
    ("full_screen_menu", "https://pub.dev/packages/full_screen_menu",
     "full_screen_menu.gif",
     "A full-screen menu with round gradient buttons.",
     "Animated demo of the full_screen_menu Flutter package: a blurred "
     "full-screen overlay opens over a weather app with five round gradient "
     "buttons and a close button."),
    ("yako_theme_switch", "https://pub.dev/packages/yako_theme_switch",
     "yako_theme_switch.gif",
     "An animated switch between light and dark themes.",
     "Animated demo of the yako_theme_switch Flutter package: a toggle whose "
     "sun thumb rolls into a moon as the screen changes from light mode to "
     "dark mode."),
    ("diagonal_decoration", "https://pub.dev/packages/diagonal_decoration",
     "diagonal_decoration.png",
     "Diagonal-line and mesh backgrounds for boxes.",
     "Screenshot of the diagonal_decoration Flutter package: one card filled "
     "with fine diagonal lines (DiagonalDecoration) and one with a curved line "
     "mesh (MatrixDecoration)."),
]

START = "<!-- more-from-yako:start -->"
END = "<!-- more-from-yako:end -->"


def grid(current):
    others = [p for p in PACKAGES if p[0] != current]
    cells = [
        f'    <td align="center" valign="top" width="33%">\n'
        f'      <a href="{link}"><img src="{TILES}/{file}" width="220" alt="{alt}"></a><br>\n'
        f'      <a href="{link}"><b>{name}</b></a><br>\n'
        f'      <sub>{line}</sub>\n'
        f'    </td>'
        for name, link, file, line, alt in others
    ]
    rows = [cells[i:i + 3] for i in range(0, len(cells), 3)]
    body = "\n".join("  <tr>\n" + "\n".join(r) + "\n  </tr>" for r in rows)
    return (f"{START}\n## More from Yako\n\nOther Flutter packages from the same team:\n\n"
            f"<table>\n{body}\n</table>\n{END}\n")


def main():
    current, path = sys.argv[1], sys.argv[2]
    text = open(path).read()
    section = grid(current)
    if START in text:
        text = re.sub(re.escape(START) + ".*?" + re.escape(END) + r"\n?",
                      lambda _: section, text, flags=re.S)
    else:
        old = re.search(r"^(#+ *)?Check out other Yako packages:?.*\Z", text,
                        flags=re.M | re.S)
        lic = re.search(r"^## License", text, flags=re.M)
        if old:
            text = text[:old.start()] + section
        elif lic:
            text = text[:lic.start()] + section + "\n" + text[lic.start():]
        else:
            text = text.rstrip("\n") + "\n\n" + section
    open(path, "w").write(text)


if __name__ == "__main__":
    main()
