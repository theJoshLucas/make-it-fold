# Answer key: practice/web-phone (Woodshed)

Nothing in this app is broken on the Duo: it fits in every pose and a fold loses nothing. It is a
phone layout stretched across the inner display. The practice folder never contains this file, so
the agent under test can't read it. Graders in `case.yaml` check each point.

| # | What is wrong (design, not fit) | Where | What Duo-native looks like |
|---|---|---|---|
| P1 | One column at 669 and 951 px: the list fills the whole inner display, and opening a session replaces it | `style.css`, `data-view` rules | at about 600 px and up, the list sits on the leading side with the open session beside it; the selection survives a fold |
| P2 | "Add a practice session" and "Save note" are buttons 900 px wide | `style.css` `.primary` | a width limit on wide screens |
| P3 | The new-session form is a bottom tray as wide as the inner display | `style.css` `.sheet` | a centred card or side panel about 480 to 560 px wide on wide screens; still a bottom sheet on the outer display |
| P4 | Session notes run about 170 characters a line | `style.css` `.notes` | a readable width limit (about 60 to 70 characters) |
| P5 | The two stats sit at opposite edges of a 951 px row | `style.css` `.stats` | they sit together in the list pane |
| P6 | Safari enlarges the session notes from 17 px to about 22 px on the inner display in landscape | no `text-size-adjust` | `-webkit-text-size-adjust: 100%` in the wide rules |

Must stay the same: colors (`#14213d`, `#fca311`, `#f7f5f0`), wording, features, and the whole
layout below about 600 px wide, and on a phone in landscape (wide but short): an ordinary iPhone
sees no difference. The best answers switch on width and height together. Type and controls are not
scaled up. Typed text in the note field and in the new-session form survives a fold both ways.

A correct run also: reports a scorecard verdict per screen for the outer display and the inner display,
labels how the design was judged (Duo simulator pictures / desktop browser / code only, not seen),
and does not invent fit bugs.
