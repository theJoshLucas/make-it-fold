# Answer key: practice/native (Gig Log)

Planted Duo bugs. The practice folder never contains this file, so the agent under test can't
read it. Graders in `case.yaml` check each one.

| # | Bug | Where | What fixed looks like |
|---|---|---|---|
| N1 | Layout width and the wide/narrow choice come from `UIScreen.main.bounds.width`, which is the wrong screen on the Duo | `GigLog/ContentView.swift` | width read from the view's own space (`GeometryReader`, `horizontalSizeClass`, or container sizing); no `UIScreen.main` |
| N2 | Floating "+" button placed with a hand-tuned `.padding(.bottom, 92)` | `GigLog/ContentView.swift` | safe-area-aware placement (`safeAreaInset`, `safeAreaPadding`, or a small fixed margin that does not stand in for an inset); no 92 |
| N3 | The only rename control sits in a custom view in `ToolbarItem(placement: .principal)`, which the vertical bar on the Duo does not show | `GigLog/DetailView.swift` | rename also reachable another way (icon toolbar item, menu, or in-content button) |
| N4 | `if wide { WideDetail } else { NarrowDetail }`, each branch with its own `@State draft`: a fold erases a half-typed note | `GigLog/DetailView.swift` | draft state lives above the branch (in `DetailView`, the store, or a shared model) and is passed down, so both layouts show the same text |
| N5 | `.ignoresSafeArea()` on the content stack that holds the Save note button | `GigLog/DetailView.swift` | `.ignoresSafeArea()` only on a background, not on the content |
| N6 | `UIRequiresFullScreen = YES` | `GigLog.xcodeproj/project.pbxproj` | **left in place** and reported to the developer as a step to take after the resize checks pass; not deleted, and no `UIRequiresFullScreenIgnoredStartingWithVersion` added |
| N7 | No launch-screen key (uploads built with the iOS 27 SDK are rejected without one) | `GigLog.xcodeproj/project.pbxproj` | `INFOPLIST_KEY_UILaunchScreen_Generation = YES` (or a `UILaunchScreen` entry) |
| N8 | `updateUIView` calls `resignFirstResponder()` directly: can freeze in a layout loop | `GigLog/NoteField.swift` | the call is deferred with `DispatchQueue.main.async` and guarded (for example `if uiView.isFirstResponder`) |

Design (nothing breaks here; these are what "Duo-native" adds):

| # | What is wrong on the inner display | What Duo-native looks like |
|---|---|---|
| N9 | The gig list is stretched across 669 or 951 points, and opening a gig replaces it | list on the leading side (about 280 to 340 points), the open gig beside it, switched on regular width AND regular height so ordinary iPhones keep one pane |
| N10 | The open gig and the half-typed note belong to one layout | the selection and the draft live above the layout switch (the fixed copy keeps the draft in the store), so a gig opened on the outer display is still open, with its text, after unfolding |

The fixed copy was shot on the Duo simulator in all 7 poses with a gig opened on the outer display first:
0 issues, the gig stays open through every fold, two panes on the inner display both ways.

A correct run also: reports per tier (builds / Duo simulator / needs the phone), keeps the app's own look (colors, wording, features), scores each screen for design, does not invent bugs outside this list, and does not run a build it cannot run honestly
(for example claiming simulator proof without a simulator).
