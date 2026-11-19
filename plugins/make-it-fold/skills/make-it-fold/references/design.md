# Duo-native design: the bar, the scorecard, the patterns

"Nothing is cut off" is the floor. The bar is: **someone who opens this app on a Duo believes it was
designed for a Duo.** A phone layout stretched across the inner screen fits and still fails.

This file is the plugin's own summary, written 2026-11-18 from Apple's live pages. Apple wins:
`duo-docs` tells you when Apple's design page has changed since then, and then you read Apple's page
(`duo-docs path design`) and follow it over this file.

## The two screens want different things
| | Cover (folded) | Inner (unfolded) |
|---|---|---|
| Space | 466 x 678 points: wider and much shorter than a normal iPhone | 669 x 951 upright, 951 x 669 sideways: a small tablet |
| Size class | compact width | regular width |
| Held | one hand, a quick look | two hands, or half-open on a table |
| Wants | the main thing and the main action with no scrolling; bars in the side rail | one more level of the app on screen at once: list and detail, content and controls, more columns |

Unfolding a cover held upright gives the inner screen **sideways** (951 x 669). That is the first
thing every Duo owner sees. Design it first, not last.

## Apple's rules, in short (read the live page for the detail)
1. **One app, two sizes.** A compact layout for the cover and a regular layout for the inner screen
   cover every pose. Do not draw a layout per pose.
2. **Expand, do not reinvent.** The inner layout is the cover layout plus one more level of the
   hierarchy (the list AND the open item). Same features, same state, things stay roughly where
   they were. Small moves when folding, never a reshuffle.
3. **Let the system place the bars.** Tab bars, toolbars and navigation controls move to a side rail
   on the cover and on the inner screen sideways. Use the system's bars and do not override where
   they sit. Every bar item gets an icon AND a title. Text-only and custom-view items do not appear
   in the rail. Most-used items get a visibility priority so they overflow last.
4. **Controls live beside what they change.** A pane's own controls sit with that pane, not in the
   rail on the far edge.
5. **Respect the fold and the cameras.** Half-open, the middle of the inner screen is a dead strip.
   Two panes meet at the fold. Grids use an even number of columns. Custom drawing asks for the
   reserved regions.
6. **Full width only for things that are not lists.** A calculator, a player, a map or a game can
   use the whole screen and re-flow its grid (fewer rows, more columns on the short cover).
   Scrolling content stays inset.
7. **Same sizes.** Text and controls keep their normal size on the inner screen. The extra room
   shows more, it does not blow things up.

## The scorecard (fill it for every screen, on BOTH screens)
Score from screenshots, not from the code. One line per screen, each question yes or no.

1. **Uses the room.** No phone column stretched edge to edge. No button, field, card or bar wider
   than a phone would make it (about 560 points) unless it is a real full-width surface.
2. **Shows more, not bigger.** The inner screen shows something the cover cannot: a second pane,
   more columns, the list beside the open item. Type and controls are the same size as on the cover.
3. **Built for short.** On the cover (678 tall upright, 466 tall sideways) the main information and
   the main action are visible without scrolling, and nothing needed sits under the side rail.
4. **Bars are the system's.** Navigation, tabs and toolbar actions sit where iOS puts them in this
   pose, every item is reachable, and no custom bar fights the rail or hides behind the tab bar.
5. **Clear of the fold.** In book and laptop poses nothing important straddles the middle, and
   panes or columns divide at the fold.
6. **Forms and sheets sized for the screen.** On the inner screen a form is a side panel, a column
   or a centred card, not a tray as wide as the whole screen. Text lines stay readable
   (45 to 90 characters).
7. **Same app.** Same features, colors, type, wording and state as on the cover and as on an
   ordinary iPhone. Folding mid-task keeps what was typed, selected, open and scrolled.
8. **Looks deliberate.** Even spacing, aligned edges, no fence-post gaps (a few small items spread
   across a wide row), no lonely block floating in empty space, touch targets at least 44 points.

Verdict per screen: **native** (all yes), **fits only** (nothing broken, but a no on 1, 2, 5, 6 or 8),
**broken** (a fit failure). A layout you built but could not look at (no simulator, no browser) is
**built, not seen**, never native. The job is done when every screen is native on both screens, or the
ones that are not are listed under "Still open" with the reason.

## What each kind of screen becomes
Pick the pattern from what the screen IS. Width words: *narrow* = under about 600 points (cover),
*wide* = 600 and up (inner). Decide by the space the view actually gets, never by device name.

| Screen | Narrow (cover) | Wide (inner) |
|---|---|---|
| List that opens an item | list, push to the item | list on the leading side, the open item beside it; the selection survives a fold |
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
