# Layout traps: native SwiftUI / UIKit, iPad and universal apps, Expo / React Native

Load for any job with native screens. Ordered by how often each one bites a Duo job, most first.
Duo sizes: cover 466 x 678pt (compact width), inner 669 x 951pt (regular width and height). The Duo reports itself
as an iPhone. A system bar can sit down one side, and the camera and fold have reserved regions.
Also read W-08 and W-11 in `layout-web.md`; they apply to native apps too.

### N-01 Switching layouts on a fold throws away the user's state
- **Went wrong:** Drafts and view state that lived only inside a mounted view were lost when it remounted. A layout written as `if horizontalSizeClass == .regular { A } else { B }` gives the two branches different identities, so a fold destroys every `@State`, scroll position and focus inside them.
- **Spot it:** size-class `if / else` that swaps whole subtrees holding `@State`; the same content shown as a sheet when compact and a column when regular; text fields whose text lives only in the view.
- **Fix:** keep drafts, selection and open-panel flags in a model that outlives the view (or `@SceneStorage`). Share one child view between both layouts so only its container changes. Decide on purpose what an open sheet becomes after the fold (stays, becomes a column, or closes) and make it the same every time.
- **Check:** the fold-mid-task step: type half a sentence, open the sheet, scroll and zoom, then fold and unfold; the text, scroll, zoom, selection and undo history all survive.
- **Applies to:** native / iPad / Expo

### N-02 Dismissing the keyboard from inside a view update freezes the app
- **Went wrong:** `resignFirstResponder` called inside `updateUIView` started keyboard tracking, which ran a UIView animation, which re-entered SwiftUI in the middle of its update. The editor froze for good about 1 run in 6; a `sample` of the hung process showed `AG::Graph::print_cycle` repeating (an AttributeGraph cycle). A fold runs an update pass on every wrapped UIKit view, so this kind of call fires at exactly the wrong moment.
- **Spot it:** any `becomeFirstResponder` / `resignFirstResponder`, `endEditing`, `UIView.animate`, window or keyboard call inside `updateUIView` / `updateUIViewController`. Also suspect, because each reproduced the same stall in one editor: a standalone `UITabBar` outside a tab bar controller, a custom `Binding` wrapped around a sheet, `.inspector`, and `onGeometryChange` feeding `@State`.
- **Fix:** defer the call until after the update pass (`DispatchQueue.main.async`), and skip it if the state it was meant for has been replaced in the meantime.
- **Check:** repeat the UI test that reaches that screen at least 10 times, folding once mid-flow, and report N of N. A "main thread busy" watchdog failure, or `print_cycle` in a `sample`, is the signal.
- **Applies to:** native / iPad

### N-03 Writing state while a view is being built rebuilds it forever
- **Went wrong:** A navigation destination closure called a function that changed an `@Observable` property. Any write counts as a change, so SwiftUI rebuilt, which wrote again, and the app froze while typing. In another app, a window probe published an observed property straight from the platform view's update method, raising a runtime warning on every launch. Fold detectors and "measure my width into @State" helpers are this exact pattern.
- **Spot it:** mutating calls inside `body`, destination closures or `updateUIView`; `onGeometryChange` that writes every time instead of only on change; side effects in `@State` default values.
- **Fix:** read state in `body`; change it only in `onAppear`, `onChange` or actions. A bridge that reports size from an update callback publishes on the next run-loop turn, and only when the value changed. Prefer size classes or `ViewThatFits` over measuring width into state.
- **Check:** grep bodies and destination closures for mutating calls; launch, fold and unfold with the console open and confirm no "Modifying state during view update" warning; a `sample` of any hang must not show the same view being recreated over and over.
- **Applies to:** native / iPad

### N-04 The iPad layout is chosen by device type, so the Duo never shows it
- **Went wrong:** (From research, not yet from a job.) Code that picks the big layout with `userInterfaceIdiom == .pad` never shows it on the Duo, which reports itself as an iPhone even at 669 x 951pt unfolded. An iPad-only app does not run on iPhone at all until iPhone is added as a target.
- **Spot it:** grep for `userInterfaceIdiom`, `UIDevice.current.model`, `isPad`, and (React Native / Expo) `Platform.isPad` or `isTablet` deciding layout.
- **Fix:** choose layout from the horizontal size class or the available width (the inner screen is regular / regular). Keep idiom checks only for real capability differences.
- **Check:** on the Duo simulator, unfolded shows the wide layout and folded shows the compact one, switching live without a relaunch.
- **Applies to:** iPad / native / Expo

### N-05 Hardcoded insets, or a reserved band honoured where nothing uses it
- **Went wrong:** A window reserved a 52pt inset across its full width for chrome that only filled the leading 142pt, which left a dead band above every page for months while agents told the owner the space was "reserved". A root view that ignored the safe area drew its first lines under the title bar.
- **Spot it:** hardcoded edge padding (`padding(.top, 44)` and similar); `.ignoresSafeArea()` on content rather than backgrounds; one inset value reused for all four edges.
- **Fix:** read the safe-area insets for every edge (the Duo's side bar makes left or right non-zero). Measure what actually occupies a reserved band, and let content use the part that is clear.
- **Check:** in every pose, screenshot and log `safeAreaInsets` for all four edges: no text or control sits under the bar or camera, and there is no empty band where nothing is drawn.
- **Applies to:** native / iPad / Expo

### N-06 A NavigationStack inside a side column pops the screen back
- **Went wrong:** On the unfolded Duo, tapping a control in the new side column sent the app back to the previous list. The column reused the view that had been a sheet, which wrapped its content in its own `NavigationStack`; a second stack inside a navigation destination popped the parent screen.
- **Spot it:** any view used both as a sheet and inline; `NavigationStack` or `NavigationView` inside a destination or a column.
- **Fix:** inline panels are plain stacks of views. Pull the shared list into a view with no navigation container, and let each host (sheet or column) add its own.
- **Check:** unfolded, tap every control in every inline panel: the screen behind must not change. Then fold and repeat with the sheet.
- **Applies to:** native / iPad

### N-07 Taps vanish in reserved regions and above inset bars
- **Went wrong:** Content drawn into a reserved top band rendered perfectly, but a search field there took no taps or focus and did not exist in the accessibility tree. Views drawn from inside a `safeAreaInset` bar but showing above it got no taps (they fell through to what was underneath). A button with an interactive glass effect plus its own drag never completed a press-and-slide. When the Duo's bar moves, floating rows get re-hosted and this breaks.
- **Spot it:** interactive controls inside safe-area or reserved regions; floating rows drawn from inside a `safeAreaInset`; `.glassEffect(.regular.interactive())` on views that have their own gestures.
- **Fix:** only static content (backgrounds, text) may extend into a reserved region; anything tapped or typed into stays in the safe area or is a real toolbar item. Draw floating rows from the screen root. Keep glass as a non-interactive background.
- **Check:** in every pose, drive each such control for real (tap, type, read its value back through accessibility); pixels prove nothing here.
- **Applies to:** native / iPad

### N-08 Panes and pages size themselves from their content, not the screen
- **Went wrong:** A split-view column took the full ideal height of its scroll view (3,700pt in a 700pt window), so nothing scrolled. A page's scroll container reported only the ideal width of its cards, and the split view left most of the window blank. A flexible frame centred a 2,400pt child so only its last line showed. Replaced content arrived scrolled to the bottom. Render tests passed every time. (Seen in a desktop SwiftUI app; the same containers are used on iPad and the Duo.)
- **Spot it:** `NavigationSplitView` or `HSplitView` columns whose content is a scroll view with no frame of its own; full pages without `maxWidth: .infinity, maxHeight: .infinity`.
- **Fix:** every column and full-page view explicitly claims the available width and height and pins its content top-leading. Each scroll view gets a top anchor and scrolls to it whenever its content is replaced.
- **Check:** in each pose, every scroll area scrolls, no column is taller than the screen, and content fills its column (judge from a whole-screen screenshot, not one region).
- **Applies to:** native / iPad

### N-09 System gestures steal the app's own drags near the edges
- **Went wrong:** iOS's swipe-to-go-back swallowed every left-to-right stroke on a drawing canvas and sent the app back mid-line.
- **Spot it:** canvases, maps, sliders, carousels or any free-form drag area inside a navigation stack or a sheet.
- **Fix:** a surface that takes free-form touches disables or out-ranks every overlapping system gesture (back swipe, sheet dismiss, edge swipes) while it is active, and restores them when it leaves.
- **Check:** in every pose, drag in all 8 directions from near each edge and from the middle; nothing navigates, dismisses or scrolls instead.
- **Applies to:** native / iPad / Expo / web

### N-10 One layout modifier blanks parts of the screen elsewhere
- **Went wrong:** A `fixedSize()` text inside a stack bounded by spacers blanked the sidebar rows, footer and page header, with a clean build, green tests and no warning. It was found only by opening the app, and pinned down only by removing modifiers one at a time.
- **Spot it:** `fixedSize()` inside `Spacer`-bounded stacks; any layout change that passed tests without a whole-screen look.
- **Fix:** prefer flexible frames. When something vanishes, undo the latest layout modifiers one at a time until it returns.
- **Check:** after any layout change, rebuild, relaunch and capture the entire screen in each pose; sidebar, header and footer are all present.
- **Applies to:** native / iPad

### N-11 Code that dictates its own size, or restores sizes saved on the other screen
- **Went wrong:** Layout code that set frames, ideal / max sizes or min sizes from view updates and timers made a window resize itself after launch, and once recursed until the process aborted (only with real content; blank test views passed). A pane width saved on a bigger display was restored far below its minimum on a smaller one and drew as an empty column.
- **Spot it:** frames or min / max sizes set from updates, timers or resize observers; saved split-view column widths or scroll positions restored without clamping.
- **Fix:** content declares one minimum on the root and lets the system size it. Clamp any saved width or position to the current screen when restoring. Never save a value that can fall below the readable minimum.
- **Check:** quit on the inner screen with a wide pane and reopen folded, then the reverse: every pane is readable and every handle reachable. Run with real content through a few background refreshes.
- **Applies to:** native / iPad
