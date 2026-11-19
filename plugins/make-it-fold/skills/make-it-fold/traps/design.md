# Design traps: fits, but does not look made for a Duo

Load for every job except a fit-only one. Ordered by how often each one bites, most first.
The scorecard and the patterns are in `references/design.md`.

### G-01 Calling it done because nothing is cut off
- **Went wrong:** A whole job's screenshots were graded on one question, "is anything broken?", and every one passed. The owner opened the app on the inner screen and found a phone layout blown up wide: it worked, and it looked like nobody had designed it. The report had said "passes in every pose".
- **Spot it:** a report with no design verdict per screen; "after" pictures that look like the "before" pictures, only wider.
- **Fix:** score every screen on both screens with the scorecard, from the pictures. A screen that fits but fails the scorecard is "fits only", and the job is not done.
- **Check:** the report has one scorecard line per screen for the cover and one for the inner screen, each with a verdict, and every "fits only" is either fixed or listed under Still open.
- **Applies to:** all

### G-02 The stretched phone
- **Went wrong:** On the inner screen a single phone column ran edge to edge: two choice buttons became bars 300 points wide, a list stretched across 951 points with a word at each end of every row, and a form was a tray as wide as the whole screen.
- **Spot it:** any button, field, card or row wider than about 560 points; a row whose left and right text are a hand-span apart; one column at 600 points and up.
- **Fix:** give the wide layout a second pane or more columns (the patterns table), and hold single columns and controls to a phone-like width.
- **Check:** in the inner-screen pictures no control is wider than about 560 points and the screen shows a level of the app that the cover cannot.
- **Applies to:** all

### G-03 The unfolded-sideways screen designed last
- **Went wrong:** Layouts were tuned for the inner screen held upright. But unfolding a phone held upright gives the inner screen sideways, 951 wide and only 669 tall. That first view had the main buttons half under the tab bar and the important number below the fold.
- **Spot it:** the inner-landscape picture needs scrolling to reach the main action; something sits under a bar.
- **Fix:** design inner-landscape first: two columns, with the main action in the first screenful.
- **Check:** in the inner-landscape picture of each main screen, the main information and the main action are visible without scrolling and nothing is under a bar.
- **Applies to:** all

### G-04 Fence posts
- **Went wrong:** A row of six small indicators made for a phone was spread evenly across the wide screen, each one alone with a gap either side. A row of four round buttons did the same.
- **Spot it:** small items with gaps much wider than the items.
- **Fix:** keep the group at its natural width and place the group (leading, or in its own column); or turn the row into a grid.
- **Check:** the gap between items in a group is the same on the cover and the inner screen, within a few points.
- **Applies to:** all

### G-05 Filling the room by making everything bigger
- **Went wrong:** An app scaled its type and controls with the window's width. On the inner screen everything came out about one and a half times the size: giant text, the same amount on screen as the cover.
- **Spot it:** a scale factor multiplied by the screen or window width; inner-screen text visibly larger than cover text.
- **Fix:** cap any size scale at the phone value, and spend the extra room on more content.
- **Check:** the same label measures the same height in the cover and inner pictures (allowing for pixel density).
- **Applies to:** all

### G-06 The full-width tray
- **Went wrong:** Entry forms and menus that slide up from the bottom on a phone slid up 951 points wide on the inner screen, covering everything, with one short field in the middle.
- **Spot it:** a sheet or menu whose width equals the inner screen's width.
- **Fix:** on a wide screen present the form as a side panel, a column or a centred card (native: sheet placement and sizing, or a second pane; web: a width limit and a side or centre position), and menus as popovers anchored to their button. On the cover it stays a sheet. The form is the same view with the same state in both.
- **Check:** open each form on the inner screen: it is under about 560 points wide and the screen behind is still visible. Fold with half-typed text: the text is still there in the cover's sheet.
- **Applies to:** all

### G-07 The wide layout leaks onto ordinary phones
- **Went wrong:** A two-pane layout keyed to "regular width" also appeared on a large ordinary iPhone turned sideways (also regular width), where the app had always shown one column. A web layout keyed to 600 px also changed small tablets the owner never asked about.
- **Spot it:** the switch is a size class or breakpoint that ordinary devices also reach.
- **Fix:** switch on wide AND tall, which only the inner screen (and tablets) are: native, regular width and regular height; web, `(min-width: 620px) and (min-height: 480px)`. A phone turned sideways is wide but short and keeps its layout. If the person wants sideways phones to change too, that is their call: say so in the report.
- **Check:** the normal-phone pictures (upright and sideways, on the largest phone) match the "before" pictures.
- **Applies to:** all

### G-08 A custom bar that will not move to the rail
- **Went wrong:** A hand-drawn tab bar stayed pinned to the bottom on the cover while iOS moved its own bars to the side rail. The 678 point tall screen lost a strip to the custom bar, and on the inner screen sideways the bar covered content. In another app the answer was a hand-made side rail: now there were two rails, the system's and the app's.
- **Spot it:** a tab bar or toolbar that is a custom view rather than the system's (a row of buttons at the bottom, a JavaScript tab bar).
- **Fix:** move to the system's tab view and toolbar (SwiftUI `TabView`, UIKit `UITabBarController`, Expo Router `NativeTabs`) so iOS places them. Never build your own side rail. Only if the bar does something the system's cannot: keep it where it is, pad it with the safe area on all four sides, keep every item, and list the move to system bars under Still open.
- **Check:** on the cover and inner-landscape pictures, navigation runs down a side in the system's rail and content gets the full height.
- **Applies to:** native / iPad / Expo

### G-09 Two layouts, two copies of the screen
- **Went wrong:** The wide layout was built as a second screen with its own state. Folding swapped one for the other: the open item closed, the typed text vanished, the list jumped to the top.
- **Spot it:** `if wide { WideScreen() } else { NarrowScreen() }` (or two routes) where each owns state.
- **Fix:** one screen, one state, two arrangements of the same child views. See N-01 and W-04.
- **Check:** the fold-mid-task step: type, select, scroll, fold, unfold. Everything is as it was.
- **Applies to:** all

### G-10 A new look smuggled in
- **Went wrong:** Asked for a Duo layout, an agent also changed colors, renamed buttons, swapped a font and added a feature it thought the big screen deserved. The owner had to pick the redesign apart from the Duo work.
- **Spot it:** changed color values, font names, wording or new features in the diff; a normal-phone picture that differs from "before".
- **Fix:** layout changes only, built from the app's own pieces and its own design rules. Anything else is a suggestion in the report.
- **Check:** the diff has no changed colors, fonts or wording; the normal-phone "after" matches "before".
- **Applies to:** all

### G-11 Only the first screen was looked at
- **Went wrong:** The check launched the app and photographed whatever opened, in every pose. Settings, the entry forms, the history list and the charts were never seen on the inner screen. They were the worst ones.
- **Spot it:** fewer screen names in the run than the app has screens; no form or sheet among them.
- **Fix:** list every screen first (tabs, pushed pages, sheets, menus, empty and full states) and put each in `duo/scenario.json` so every run shoots all of them.
- **Check:** the scenario's screen list is compared against the app's navigation code, and the report names any screen not shot.
- **Applies to:** all

### G-12 Something important across the fold
- **Went wrong:** Half-open like a book, a centred card and the primary button sat exactly on the hinge. An odd number of columns put the middle column in the crease.
- **Spot it:** book and laptop pictures with content centred on the middle line; grids with three or five columns.
- **Fix:** panes meet at the fold (system split and arrangement views do this), grids use an even number of columns, custom views read the reserved regions.
- **Check:** in the book and laptop pictures, draw the middle line: no control or text crosses it.
- **Applies to:** all

### G-13 Safari enlarges text on the inner screen
- **Went wrong:** A paragraph set at 17 px was drawn at 25 px on the inner screen sideways (measured on the Duo simulator), bigger than the heading above it, while buttons and labels stayed put. Nothing in the app's styles asked for it: Safari enlarges text in wide blocks on an iPhone held sideways, and the Duo's inner screen counts. The page looked scaled up and uneven.
- **Spot it:** in the inner-landscape picture, body text is bigger than on the cover while controls are not. `duo-shot` prints a "text-grows-on-inner-screen" design note with both sizes. The absence of `text-size-adjust` in the styles is not enough by itself: fix it when the picture or the note shows it.
- **Fix:** `-webkit-text-size-adjust: 100%; text-size-adjust: 100%;` on `html`, inside the wide rules so ordinary phones stay exactly as they were. Never `none`.
- **Check:** the longest paragraph's font size is the same in the cover and inner pictures (`duo-shot` measures it).
- **Applies to:** web / home-screen / wrapper

