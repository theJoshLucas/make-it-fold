# New app: designed for the Duo from the first screen

Nothing to convert, so nothing to break. Build both layouts of every screen together.

1. **What is it?** If the person gave no brief, ask one question: what should it do, and for whom?
   Then write the screen list (5 to 10 lines): each screen, what kind it is in `design.md`'s
   patterns table, and its outer and inner display layouts. Show it, then build.
2. **Pick the kind of app.** Native SwiftUI unless the person wants a website: system views get
   the vertical bar, split views and fold handling for free. Web: follow `web.md`.
3. **Native skeleton** (read Apple's overview first: `duo-docs path overview`):
   - Build with the iOS 27.1 SDK; deployment target is the person's call (say what you chose).
   - SwiftUI `App` with scenes; `UILaunchScreen` in Info.plist; all orientations; no
     `UIRequiresFullScreen`.
   - Navigation from system pieces: `TabView` for top-level places, `NavigationSplitView` for
     list plus detail, `.toolbar` items as `Label(title, systemImage:)`. iOS then draws the vertical bar.
   - Every screen: state above the layout switch, one set of child views, two arrangements
     (`native.md#duo-native-layout`). `ArrangementView` wherever two views pair up.
   - Custom drawing reads the reserved regions. No fixed screen sizes, no device checks.
   - Debug-only launch arguments that open any screen with made-up sample data (for example
     `-screen settings`). They make every screen photographable: list them in `duo/scenario.json`.
4. **Web skeleton:** viewport tag with `viewport-fit=cover`, `dvh`/`svh` heights, safe-area padding
   on all four sides, inputs at 16 px, container queries for the wide layouts
   (`web.md#duo-native-layout`), state kept outside the layout.
5. **Look and feel.** Use the person's brand or design rules if they have any. If not, use the
   system's components, type and colors and say so. Do not invent a brand.
6. **Build one screen at a time, with proof.** After each screen: run it on the simulator,
   `duo-shot` with the scenario (the duo-shooter agent), the duo-judge agent's scorecard, fix until it
   scores native on both displays. Then
   the next screen. Finish with the skill's steps 6 to 8.
7. **Made-up data only**, and no real accounts, payments or messages (`scenario.md`).
