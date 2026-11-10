# Answer key: practice/ipad (Studio Planner)

Planted Duo bugs. The practice folder never contains this file, so the agent under test can't
read it. Graders in `case.yaml` check each one.

| # | Bug | Where | What fixed looks like |
|---|---|---|---|
| P1 | The big layout is chosen with `UIDevice.current.userInterfaceIdiom == .pad`, which is never true on the Duo (an iPhone), so the inner screen gets the phone layout | `StudioPlanner/ContentView.swift` | choice made by size class (`@Environment(\.horizontalSizeClass) == .regular`) or by available width; no idiom check |
| P2 | Three-column board with fixed widths 300 + 440 + 320 = 1,060 pt, wider than the 951 pt inner screen | `StudioPlanner/BoardColumns.swift` | columns size from the space they get (flexible frames, `NavigationSplitView`, or collapsing by width); no fixed widths summing over 1,000 |
| P3 | Landscape-only assumption: `UIScreen.main.bounds.width > UIScreen.main.bounds.height` picks the layout, and `UIScreen.main` is the wrong screen on the Duo | `StudioPlanner/TabletLayout.swift` | layout picked by the view's own size or size classes; works in both orientations; no `UIScreen.main` |
| P4 | Selected room lives in `@State` inside `TabletLayout` (the iPad branch only), so the selection is lost when the layout switches to the phone branch, and the phone branch keeps its own separate path | `StudioPlanner/ContentView.swift`, `TabletLayout.swift`, `PhoneLayout.swift` | selection state owned above the branch (in `ContentView` or a shared model) and passed to both layouts, so a fold keeps the same room selected |

A correct run also: reports per tier (builds / Duo simulator / needs the phone), does not redesign
the app, does not invent bugs outside this list, and does not claim simulator proof it did not get.
