# Native route (SwiftUI and UIKit iPhone apps)

Apple's `app-resizability` skill (inside the person's Xcode; how to find it is in `apple-docs.md`)
is the base. Use it cheaply: `duo-scan` already found the patterns, so read only the matching
task files. Then cover what that skill does not: reserved regions, two-pane layouts, bar items,
sheets, and keeping state across a fold.

## Apple's prerequisites (read them, fix carefully)
- Launch screen key missing: add `UILaunchScreen` (an empty dictionary is enough). Uploads built
  with the iOS 27 SDK are rejected without one (ITMS-90870).
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
bar.** Keep every such control reachable another way (an icon item, a menu, in-content button).
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

## checks
`duo-shot native --bundle <id> --app <path to .app> --label before|after`, then look at every
screenshot. XCUITest screenshots only capture the cover display, and XCUITest cannot fold: use
`duo-sim pose <name>` from the host between test steps (`traps/testing.md` T-02, T-11), and find
elements by accessibility identifier, never fixed points.
