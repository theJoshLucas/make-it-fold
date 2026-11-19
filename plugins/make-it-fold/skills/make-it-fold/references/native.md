# Native route (SwiftUI and UIKit iPhone apps)

Apple's `app-resizability` skill (inside the person's Xcode; how to find it is in `apple-docs.md`)
is the base. Use it cheaply: `duo-scan` already found the patterns, so read only the matching
task files. Then cover what that skill does not: reserved regions, two-pane layouts, bar items,
sheets, and keeping state across a fold.

## Apple's prerequisites (read them, fix carefully)
- Launch screen key missing: **add it, always, even when nothing can be built or run in this
  session**: `UILaunchScreen` (an empty dictionary is enough) or the build setting
  `INFOPLIST_KEY_UILaunchScreen_Generation = YES`. Uploads built with the iOS 27 SDK are rejected
  without one (ITMS-90870). It is safe on every iPhone and no picture can show it, so it is never
  left as a note for the developer.
- `UIRequiresFullScreen`: **never delete it, and never add `UIRequiresFullScreenIgnoredStartingWithVersion`,
  until the app's resize checks pass.** Apple's skill says so, because deleting it makes the app
  resizable at once. Report it as a step for the developer.
- Scene lifecycle: required for resizing. An app still on `UIApplicationDelegate` windows needs
  the scene migration (Apple's skill has the task file). That is a larger change: say so first.

## uiscreen / orientation / idiom
- `UIScreen.main` is the wrong screen on the Duo. Use the view's or window's own bounds and
  `traitCollection.displayScale`, read in `layoutSubviews` / `viewDidLayoutSubviews` /
  `viewWillTransition(to:with:)` or SwiftUI's layout (GeometryReader only where needed).
- Orientation checks (`UIDevice.current.orientation`, `interfaceOrientation`): use the size and
  size classes instead.
- `userInterfaceIdiom == .pad` never fires on the Duo (it is an iPhone), so an iPad layout never
  shows on the big inner screen. Switch to `horizontalSizeClass == .regular` (SwiftUI
  `@Environment(\.horizontalSizeClass)`). An iPhone can now have any size-class combination.

## safe-areas
Use the safe area or layout margins, never hand-tuned numbers (`safeAreaInsets.bottom + 78`,
`.padding(.bottom, 92)`). Insets are asymmetric on the Duo and change while the app runs, because
the vertical bar sits on the leading or trailing side. `.ignoresSafeArea()` only on backgrounds,
never on content or controls.

## bars
On the Duo, toolbars, tab bars and navigation bars can become a vertical bar. Bar items show
icon-only there; **title-only items and custom-view items (`ToolbarItem(placement: .principal)`
with a custom view, `titleView`, `UIBarButtonItem(customView:)`) are not shown in the vertical
bar.** Keep every such control reachable another way **on the same screen and in plain sight**: an
icon bar item with a title, or a button in the content. A long-press or a menu on some other
screen does not count.
iOS 27.1 adds `toolbarVerticalEdge`, `toolbarVerticalBehavior`, `axisBehavior` and
`visibilityPriority` (read Apple's overview live before using them; guard with `#available`).

## reserved regions
Framework views avoid the camera and the fold automatically. Custom views that place content by
hand must ask: UIKit `view.reservedRegions(kind: .occlusion / .division)`, SwiftUI
`GeometryProxy.reservedRegions(...)` (iOS 27.1). The fold is a division only while half-open.

## two-pane layouts
On the inner screen, a list-plus-detail or content-plus-inspector layout fits side by side. Prefer
the system: `NavigationSplitView`, or iOS 27.1's `ArrangementView` / `UIArrangementViewController`
(split or overlay). Do not nest an arrangement in a list, scroll view or another split view.

## navigation
One `NavigationStack` per column. A side column that brings its own `NavigationStack` inside an
existing stack pops the screen back to the root when it appears (trap N-06).

## keyboard
Never call `resignFirstResponder()` / `endEditing` inside SwiftUI's `updateUIView` / `body`: it can
freeze the app in a layout loop. Defer it (`DispatchQueue.main.async`) and guard it (trap N-02).

## state across a fold
Folding resizes the same running scene. Open sheets, half-typed text, scroll position, zoom and
selection must survive. Switching between a compact and a regular layout must move the same
state to the new view, not create fresh state (trap N-01). A sheet on the cover may become a
column on the inner screen and back: keep it open in both, unless the person says otherwise.

## sizes
No fixed point sizes for whole screens or panes. Let panes size from the space they get.

## scenes
Multiple windows of one app are inner-screen only; new windows cannot be created on the cover.

## duo-native layout
The phone layout stays exactly as it is in compact width. Add a regular-width arrangement of the
SAME views (`design.md` has the pattern for each kind of screen).
- **Switch on space, not device.** The inner screen is regular width AND regular height, both
  ways up. Use both size classes (`horizontalSizeClass == .regular && verticalSizeClass == .regular`;
  UIKit: trait changes): a large ordinary iPhone held sideways is regular width but compact height,
  so it keeps its phone layout (trap G-07). Use the screen's own size (`onGeometryChange`,
  `ViewThatFits`) where size classes are too coarse.
- **One screen, one state, two arrangements.** State lives above the switch; both branches use the
  same child views. Proven on the Duo simulator (an item opened on the cover is still open, with
  its half-typed text, after unfolding):
  ```swift
  @State private var selection: Item.ID?      // above the switch: survives a fold
  @Environment(\.horizontalSizeClass) private var width
  @Environment(\.verticalSizeClass) private var height
  var body: some View {
      if width == .regular && height == .regular {          // the inner screen
          HStack(spacing: 0) {
              NavigationStack { ItemList(selection: $selection) }.frame(width: 320)
              Divider()
              NavigationStack { ItemDetail(id: selection) }   // or a "nothing selected" view
          }
      } else {                                              // the cover, ordinary iPhones
          NavigationStack(path: Binding(get: { selection.map { [$0] } ?? [] },
                                        set: { selection = $0.last })) {
              ItemList(selection: $selection)                // rows push with NavigationLink(value:)
                  .navigationDestination(for: Item.ID.self) { ItemDetail(id: $0) }
          }
      }
  }
  ```
  Text being typed belongs in a model object or above the switch too, never in `@State` inside
  one arrangement.
- **List plus detail, settings:** the two-pane switch above, or `NavigationSplitView`, which does
  both arrangements by itself and collapses on the cover (it also splits on a large ordinary
  iPhone held sideways: say so if you use it). Keep the selection in state above it.
- **Home or dashboard:** two columns in regular width (summary and status one side, actions and the
  recent list the other). Sideways (669 tall) the main action must be in the first screenful.
- **Forms and sheets:** `.sheet` in compact width. In regular width show the same form view, with
  the same state object, as a trailing column or `.inspector`, or as a sized sheet
  (`.presentationSizing(.form)`; iOS 27.1's `.presentationPlacement(.leading)` or `.trailing` puts a
  sheet on one side so the screen behind stays visible: `duo-docs path sheet-placement`).
  Never a tray as wide as the inner screen (trap G-06).
- **Content plus controls (player, map, camera, canvas):** `ArrangementView` (iOS 27.1): `.split`
  where the two sit side by side or stacked, `.overlay` where controls float over content. It
  moves them to either side of the fold when half-open. Keep navigation containers outside it.
- **Grids:** even column counts on the inner screen, so nothing sits in the crease.
- **Width limits:** hold single columns, buttons and fields to a phone-like width
  (`.frame(maxWidth: 560)`), aligned or centred on purpose.
- **Bars:** use `TabView` and `.toolbar` so iOS moves them to the rail. Every item is a
  `Label(title, systemImage:)`. Set `visibilityPriority` on the items that must stay visible.
  A hand-drawn tab bar moves to the system's (trap G-08); never draw your own rail.
- **Keep each screen's code where it is.** New arrangements go in the screen's own file. Do not
  move its controls, alerts or wording to another screen to make the layout easier.
- **Do not scale type or controls with the window's width** (trap G-05).

## checks
`duo-shot native --bundle <id> --app <path to .app> --scenario duo/scenario.json --label before|after`.
Without a scenario it photographs only the screen the app opens on: list every screen in
`duo/scenario.json` (`scenario.md`, "native screens") so each one is shot in every pose. Then look at every
screenshot at full size and fill `review.md`. XCUITest screenshots only capture the cover display, and XCUITest cannot fold: use
`duo-sim pose <name>` from the host between test steps (`traps/testing.md` T-02, T-11), and find
elements by accessibility identifier, never fixed points.
