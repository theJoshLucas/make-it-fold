# Duo-native design: the bar, the scorecard, the patterns

"Nothing is cut off" is the floor. The bar is: **someone who opens this app on a Duo believes it was
designed for a Duo.** A phone layout stretched across the inner screen fits and still fails.

This file is the plugin's own summary of Apple's live pages. Apple wins: `duo-docs` tells you when
Apple's design page has changed, and then you read Apple's page (`duo-docs path design`) and follow it
over this file. Every rule below that is Apple's carries Apple's own words in quotes, and `duo-docs`
checks each quote is still on Apple's pages. A rule marked **plugin rule** is this plugin's own,
learned on real jobs: never present it as Apple's.

## The two screens want different things
| | Cover (folded) | Inner (unfolded) |
|---|---|---|
| Space | 466 x 678 points: wider and much shorter than a normal iPhone | 669 x 951 upright, 951 x 669 sideways: a small tablet |
| Size class | compact width | regular width |
| Held | one hand, a quick look | two hands, or half-open on a table |
| Wants | the main thing and the main action with no scrolling; bars in the side rail | one more level of the app on screen at once: list and detail, content and controls, more columns |

Unfolding a cover held upright gives the inner screen **sideways** (951 x 669). That is the first
thing every Duo owner sees. Design it first, not last.

## The rules, in short (read Apple's live page for the detail)
1. **One app, two sizes.** A compact layout for the cover and a regular layout for the inner screen
   cover every pose. Do not draw a layout per pose. Apple: "A compact width layout for the outer
   display and a regular width layout for the inner display give you the fundamentals for every pose."
2. **Expand, do not reinvent.** The inner layout is the cover layout plus one more level of the
   hierarchy (the list AND the open item). Same features, same state, things stay roughly where
   they were. Apple: "Don’t reinvent your app when it resizes; allow the existing layout to expand
   based on the available space instead." and "show an additional level of hierarchy on the larger
   inner display if it makes sense for your content". Small moves when folding, never a reshuffle.
   Apple: "favor small adjustments over rearrangement".
3. **Let the system place the bars.** Tab bars, toolbars and navigation controls move to a side rail
   on the cover and on the inner screen sideways. Apple: "In general, don’t override the default bar
   placement." Every bar item gets an icon AND a title. Apple: "If your item has a title and doesn’t
   have an icon, the system doesn’t present it vertically." Most-used items get a visibility priority
   so they overflow last. Apple: "Assign each item a visibility priority to change that order".
4. **Controls live beside what they change** (plugin rule). A pane's own controls sit with that pane,
   not in the rail on the far edge.
5. **Respect the fold and the cameras.** Half-open, the middle of the inner screen is a dead strip.
   Two panes meet at the fold. Grids use an even number of columns. Apple: "In a grid-style layout,
   prefer an even number of columns so content divides cleanly." Custom drawing asks for the
   reserved regions.
6. **Full width only for things that are not lists.** A calculator, a player, a map or a game can
   use the whole screen and re-flow its grid (fewer rows, more columns on the short cover).
   Scrolling content stays inset. Apple: "letting a background image or header span the full width
   while scrollable content stays inset".
7. **Sizes may change; the room must not sit empty** (plugin rule, from a real job). For apps, Apple
   says only that "content may move or change size as the interface adapts to the available area".
   Apple's "keep text and control sizes as consistent as possible" is in its advice for games, in the
   same paragraph as "be sure to fill the screen"; it is not a rule for apps. So: show more first. If
   the inner screen still leaves large areas empty (an app with little to show, at the owner's own
   text size), draw it a step larger, about 1.1 to 1.25 times the cover size, the way the app looks on
   the biggest ordinary iPhone. Never scale with the window width without a cap (trap G-05).

## The scorecard (for every screen, on BOTH screens)
The **duo-judge** agent fills it in from the screenshots, never the agent that built the layouts
(SKILL.md step 4). One line per screen, each question **yes**, **no**, **minor**, **n-a** or **unsure**.
A **no** is something a person would notice as "this was not made for this screen": a stretched phone
column, a large area the layout leaves empty, nothing more shown than on the cover, a full-width tray
of a form, text or buttons on the crease when half-open, a bar covering content. A **minor** is polish
that does not change that impression: a label wrapping, a gap slightly uneven, a control a little far
from its label. The bar is Apple's own apps on the Duo: a plugin that demands more than Apple's own
apps do would send every job round its three build rounds and still not finish. Anything Apple's apps
also do is at most a minor. Doubt about whether a problem is a no or a minor is a no. Pictures of an
empty app prove nothing about the room: when the screen's main content is an empty state (a "No items"
message, a blank list or a blank day where the app is meant to show the person's things), questions 1
and 2 are "unsure", and the pictures are taken again with realistic made-up data (trap T-20). One empty
section on an otherwise full screen ("0 favorites" under a map) is not an empty app: judge the screen. Doubt about what a picture shows (too small or unclear to be sure) is "unsure", not a no.
Answer each question only from the pictures it is about: question 3 from cover pictures, question 5 from
half-open (book, laptop) pictures, the rest from the screen named in the row.

1. **Uses the room.** No phone column stretched edge to edge. No button, field, card or bar wider
   than a phone would make it (about 560 points) unless it is a real full-width surface. No large
   empty area: `duo-shot` measures the biggest empty patch on every picture, and on the inner screen
   a patch over 25% of the screen is a no when the layout leaves it empty: a column that stops halfway
   down while the screen has room for more of the app, a list squeezed into a third of the width, a
   block alone in open space. Space below the last item of a list or below the end of a page, because
   the app has only that much to show, is not a no by itself (the test data should be realistic, trap
   T-20); say that is what it is.
2. **Shows more.** The inner screen shows something the cover cannot: a second pane, more columns,
   the list beside the open item. The same amount drawn bigger is a no, with one exception Apple's own
   apps make: a grid of pictures, a map, a calendar or a canvas that grows to fill the bigger screen
   (larger or more tiles, more of the map) is a yes.
3. **Built for short.** On the cover (678 tall upright, 466 tall sideways) the main information and
   the main action are visible without scrolling, and nothing needed sits under the side rail.
4. **Bars are the system's.** Navigation, tabs and toolbar actions sit where iOS puts them in this
   pose, every item is reachable, and no custom bar fights the rail or hides behind the tab bar. An app
   whose own design rules require its own tab bar may stand it inside the system's side strip (trap
   G-08): that is a yes when nothing is covered and every tab can be reached. Apple's icon-and-title
   rule is about items the system places in its own bars; it does not apply to tabs an app draws itself.
5. **Clear of the fold.** Judged from half-open (book, laptop) pictures only; with none in the run,
   n-a. The pictures do not show the crease: in a laptop picture it runs across the middle of the
   height, in a book picture down the middle of the width. In them, nothing being read or tapped (body text, a button, a field) sits on the crease, and two
   equal panes meet at the fold. An odd number of grid columns is a minor (Apple says to prefer an even
   number; its own Photos app uses odd ones). Lying flat, the fold does not matter: a slim list pane beside a wider
   detail pane is the normal flat layout.
6. **Forms and sheets sized for the screen.** On the inner screen a form is a side panel, a column
   or a centred card, not a tray as wide as the whole screen. A panel laid over a map or a canvas may
   run the width, as in Apple's Maps. Text lines stay readable
   (45 to 90 characters).
7. **Same app.** Same features, colors, type, wording and state as on the cover and as on an
   ordinary iPhone. Folding mid-task keeps what was typed, selected, open and scrolled.
8. **Looks deliberate.** Even spacing, aligned edges, no fence-post gaps (a few small items spread
   across a wide row), no lonely block floating in empty space, touch targets at least 44 points.

Verdict per screen: **native** (no answer is a no; minors are listed, not counted), **unsure** (an answer
could not be read from the pictures: judge it again, never a pass), **fits only** (nothing broken, but a no
on any question),
**broken** (a fit failure). A layout nobody could look at (no simulator, no browser) is **built, not
seen**, never native. Pictures taken at the default text size, with an empty data set or without the
owner's usual settings, when the owner uses something else, prove nothing about what the owner will
see: shoot with the owner's settings (`references/scenario.md`, `defaults`). The job is done when every screen is native on both screens, or the
ones that are not are listed under "Still open" with the reason.

## What each kind of screen becomes
Pick the pattern from what the screen IS. Width words: *narrow* = under about 600 points (cover),
*wide* = 600 and up (inner). Decide by the space the view actually gets, never by device name.

| Screen | Narrow (cover) | Wide (inner) |
|---|---|---|
| List that opens an item | list, push to the item | list on the leading side, the open item beside it; the selection survives a fold; with nothing picked yet, show the first or latest item, not an empty placeholder (plugin rule) |
| Home / dashboard (summary, actions, recent) | one column, summary and the main actions first | two columns: summary and status on one side, actions and the recent list on the other |
| Form / entry sheet | sheet from the bottom | a side panel or a centred card about 480 to 560 points wide; the screen behind stays visible |
| Settings | list, push to a page | menu on the leading side, the chosen page beside it |
| Cards, charts, photos | one column | a grid with an even number of columns |
| Player, map, canvas, camera | content, controls laid over it | content fills; half-open, content on one half and controls on the other |
| Long text | one column | one column held to a readable width, or text beside its pictures or notes |
| Table | fewer columns or cards | more columns, no sideways scroll |
| Menu or picker | sheet | a popover anchored to the button that opened it |
| Sign-in, empty state, onboarding | stacked | a centred card with a width limit; artwork beside it sideways |

Sideways and upright on the inner screen are both wide: two panes fit both ways. At 669 the
leading pane is slim (about 260 to 300 points); at 951 it can be 320 to 380.

## What stays the same (this is not a rebrand)
- Colors, fonts, icons, wording, the look of buttons and cards, and every feature.
- An ordinary iPhone, upright AND sideways: the new layouts switch on only when the screen is both
  wide and tall (native: regular width and regular height; web: about 620 px wide and 480 px tall),
  so a phone shows exactly what it showed before. Prove it with the normal-phone check.
- Read the app's own design rules (a `DESIGN.md`, a style guide, design tokens) before drawing
  anything, and build the new layouts out of the app's existing pieces.
- No new features, no renamed things, no clean-up that the Duo did not ask for.

## How to do it
Framework steps are in the route file: `native.md#duo-native-layout`, `web.md#duo-native-layout`,
`expo.md`, `ipad.md`. Design traps are in `traps/design.md`.
