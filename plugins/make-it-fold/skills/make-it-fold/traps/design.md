# Design traps: fits, but does not look made for a Duo

Load for every job except a fit-only one. Ordered by how often each one bites, most first.
The scorecard and the patterns are in `references/design.md`.

### G-01 Calling it done because nothing is cut off
- **Went wrong:** A whole job's screenshots were graded on one question, "is anything broken?", and every one passed. The owner opened the app on the inner display and found a phone layout blown up wide: it worked, and it looked like nobody had designed it. The report had said "passes in every pose".
- **Spot it:** a report with no design verdict per screen; "after" pictures that look like the "before" pictures, only wider.
- **Fix:** score every screen on both displays with the scorecard, from the pictures. A screen that fits but fails the scorecard is "fits only", and the job is not done.
- **Check:** the report has one scorecard line per screen for the outer display and one for the inner display, each with a verdict, and every "fits only" is either fixed or listed under Still open.
- **Applies to:** all

### G-02 The stretched phone
- **Went wrong:** On the inner display a single phone column ran edge to edge: two choice buttons became bars 300 points wide, a list stretched across 951 points with a word at each end of every row, and a form was a tray as wide as the whole screen.
- **Spot it:** any button, field, card or row wider than about 560 points; a row whose left and right text are a hand-span apart; one column at 600 points and up.
- **Fix:** give the wide layout a second pane or more columns (the patterns table), and hold single columns and controls to a phone-like width.
- **Check:** in the inner-display pictures no control is wider than about 560 points and the screen shows a level of the app that the outer display cannot.
- **Applies to:** all

### G-03 The inner display in landscape designed last
- **Went wrong:** Layouts were tuned for the inner display in portrait. But opening a phone held in portrait gives the inner display in landscape, 951 wide and only 669 tall. That first view had the main buttons half under the tab bar and the important number below the fold.
- **Spot it:** the inner-landscape picture needs scrolling to reach the main action; something sits under a bar.
- **Fix:** design inner-landscape first: two columns, with the main action in the first screenful.
- **Check:** in the inner-landscape picture of each main screen, the main information and the main action are visible without scrolling and nothing is under a bar.
- **Applies to:** all

### G-04 Fence posts
- **Went wrong:** A row of six small indicators made for a phone was spread evenly across the wide screen, each one alone with a gap either side. A row of four round buttons did the same.
- **Spot it:** small items with gaps much wider than the items.
- **Fix:** keep the group at its natural width and place the group (leading, or in its own column); or turn the row into a grid.
- **Check:** the gap between items in a group is the same on the outer display and the inner display, within a few points.
- **Applies to:** all

### G-05 Filling the room by making everything bigger
- **Went wrong:** An app scaled its type and controls with the window's width. On the inner display everything came out about one and a half times the size: giant text, the same amount on screen as the outer display.
- **Spot it:** a scale factor multiplied by the screen or window width with no cap; inner-display text far larger than outer-display text while the inner display shows nothing more.
- **Fix:** spend the room on more content first. A step larger is fine where the screen would otherwise sit empty (about 1.1 to 1.25 times the outer display size, as on the biggest ordinary iPhone; `references/design.md` rule 7), but cap it there.
- **Check:** the inner display shows more than the outer display, and no label is more than about 1.25 times its outer-display height (allowing for pixel density).
- **Applies to:** all

### G-06 The full-width tray
- **Went wrong:** Entry forms and menus that slide up from the bottom on a phone slid up 951 points wide on the inner display, covering everything, with one short field in the middle.
- **Spot it:** a sheet or menu whose width equals the inner display's width.
- **Fix:** on a wide screen present the form as a side panel, a column or a centred card (native: sheet placement and sizing, or a second pane; web: a width limit and a side or centre position), and menus as popovers anchored to their button. On the outer display it stays a sheet. The form is the same view with the same state in both.
- **Check:** open each form on the inner display: it is under about 560 points wide and the screen behind is still visible. Fold with half-typed text: the text is still there in the outer display's sheet.
- **Applies to:** all

### G-07 The wide layout leaks onto ordinary phones
- **Went wrong:** A two-pane layout keyed to "regular width" also appeared on a large ordinary iPhone in landscape (also regular width), where the app had always shown one column. A web layout keyed to 600 px also changed small tablets the owner never asked about.
- **Spot it:** the switch is a size class or breakpoint that ordinary devices also reach.
- **Fix:** switch on wide AND tall, which only the inner display (and tablets) are: native, regular width and regular height; web, `(min-width: 620px) and (min-height: 480px)`. A phone in landscape is wide but short and keeps its layout. If the person wants phones in landscape to change too, that is their call: say so in the report.
- **Check:** the normal-phone pictures (portrait and landscape, on the largest phone) match the "before" pictures.
- **Applies to:** all

### G-08 A custom bar that will not move to the vertical bar
- **Went wrong:** A hand-drawn tab bar stayed pinned to the bottom on the outer display while iOS moved its own bars to the vertical bar. The 678 point tall screen lost a strip to the custom bar, and on the inner display in landscape the bar covered content. In another app the answer was a hand-made vertical bar: now there were two rails, the system's and the app's.
- **Spot it:** a tab bar or toolbar that is a custom view rather than the system's (a row of buttons at the bottom, a JavaScript tab bar).
- **Fix:** move to the system's tab view and toolbar (SwiftUI `TabView`, UIKit `UITabBarController`, Expo Router `NativeTabs`) so iOS places them. Never build a second vertical bar beside the system's. Two exceptions, both listed in the report as your call: if the app's own design rules require its own bar, stand its tabs inside the system's strip (one side safe-area inset of 60 points or more with the other under 30), bottom aligned under the clock, and drop the bottom bar there; if the bar does something no bar in the strip could, keep it where it is, padded with the safe area on all four sides.
- **Check:** on the outer display and inner-landscape pictures, navigation runs down a side in the system's vertical bar and content gets the full height.
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
- **Went wrong:** The check launched the app and photographed whatever opened, in every pose. Settings, the entry forms, the history list and the charts were never seen on the inner display. They were the worst ones.
- **Spot it:** fewer screen names in the run than the app has screens; no form or sheet among them.
- **Fix:** list every screen first (tabs, pushed pages, sheets, menus, empty and full states) and put each in `duo/scenario.json` so every run shoots all of them.
- **Check:** the scenario's screen list is compared against the app's navigation code, and the report names any screen not shot.
- **Applies to:** all

### G-12 Something important across the fold
- **Went wrong:** Partially open like a book, a centred card and the primary button sat exactly on the hinge. An odd number of columns put the middle column in the fold.
- **Spot it:** book and laptop pictures with content centred on the middle line; grids with three or five columns.
- **Fix:** panes meet at the fold (system split and arrangement views do this), grids use an even number of columns, custom views read the reserved regions.
- **Check:** in the book and laptop pictures, draw the middle line: no control or text crosses it.
- **Applies to:** all

### G-13 Safari enlarges text on the inner display
- **Went wrong:** A paragraph set at 17 px was drawn at 25 px on the inner display in landscape (measured on the Duo simulator), bigger than the heading above it, while buttons and labels stayed put. Nothing in the app's styles asked for it: Safari enlarges text in wide blocks on an iPhone in landscape, and the Duo's inner display counts. The page looked scaled up and uneven.
- **Spot it:** in the inner-landscape picture, body text is bigger than on the outer display while controls are not. `duo-shot` prints a "text-grows-on-inner-display" design note with both sizes. The absence of `text-size-adjust` in the styles is not enough by itself: fix it when the picture or the note shows it.
- **Fix:** `-webkit-text-size-adjust: 100%; text-size-adjust: 100%;` on `html`, inside the wide rules so ordinary phones stay exactly as they were. Never `none`.
- **Check:** the longest paragraph's font size is the same in the outer display and inner pictures (`duo-shot` measures it).
- **Applies to:** web / home-screen / wrapper

### G-14 Two columns that miss the fold
- **Went wrong:** Open in landscape, two equal columns were laid out in the app's own space. The system's vertical bar down one side means that space is not centred on the screen, so the gap between the columns sat 42 points to one side of the fold, and partially open the fold ran through the second column's text.
- **Spot it:** hand-built columns sized as half of the view's width while a side safe-area inset is large on one side; in the book-pose picture the gap is not at the middle.
- **Fix:** end the first column at half of the whole screen's width, strip included (less the strip when it is on the leading side), and give the second column the rest. System split and arrangement views do this themselves.
- **Check:** in the book-pose picture the column gap is at half the picture's width.
- **Applies to:** native / iPad / Expo

### G-15 Columns, but the room still empty
- **Went wrong:** Every screen of an app was split into columns and scored native, then the owner opened it on a real Duo and found half of each screen empty: a dashboard's left column ended halfway down, a list in portrait sat in a third of the width, and every size was the outer display's size on a screen twice as big. "Two columns" had been treated as the goal instead of a filled screen.
- **Spot it:** inner-display pictures with a column that stops halfway, a list in a third of the width, or a block alone in open space; `duo-shot`'s biggest-empty-patch number over 25% on an inner-display picture.
- **Fix:** fill the height (header at the top, the main thing in the middle, actions on the bottom edge), put a list beside the summary or split it into two columns, and draw a step larger where there is still room (rule 7). Keep anything a finger taps from moving when it is tapped.
- **Check:** at the owner's own text size and with a realistic day of data, every inner-display picture's biggest empty patch is under 25%, or is the end of a scrolling list.
- **Applies to:** all
