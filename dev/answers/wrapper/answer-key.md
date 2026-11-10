# Answer key: practice/wrapper (Trail Notes, SwiftUI shell around a bundled page)

Planted Duo bugs. The practice folder never contains this file, so the agent under test can't
read it. Graders in `case.yaml` check each one. The app is a tiny SwiftUI iPhone app
(`PracticeWrapper.xcodeproj`, bundle id `dev.makeitfold.practice.wrapper`) that loads the page in
`Web/` into a `WKWebView` (no network). It is the wrapper route (`references/wrapper.md`): a
native shell checklist plus a web page checklist.

| # | Bug | Where | What fixed looks like |
|---|---|---|---|
| R1 | Shell hands every inset to the page: `.ignoresSafeArea()` on the web view AND `scrollView.contentInsetAdjustmentBehavior = .never` | `PracticeWrapper/ContentView.swift`, `PracticeWrapper/WebView.swift` | Either leave the shell as is and make the page own all four insets (acceptable, and the shell's full-bleed is kept), or let the shell respect the safe area. Removing only one of the two shell settings while the page ignores insets is not a fix |
| R2 | Viewport tag lacks `viewport-fit=cover`, so every `env(safe-area-inset-*)` reads 0 | `Web/index.html` | `viewport-fit=cover` present |
| R3 | Header and floating action button use only top and bottom insets; the 84 px side bar (left, in one cover-landscape direction) overlaps the title and the button never clears it | `Web/style.css` `.top`, `.fab` | `env(safe-area-inset-left)` and `env(safe-area-inset-right)` on both the header and the button |
| R4 | Layout by `screen.width` (reports the cover size, 466, even on the inner screen) and the grid is forced to that width | `Web/app.js` `layout()` | width of the space the page actually has (`innerWidth`, a CSS media or container query, or plain CSS grid `auto-fit`); no `screen.width` |

A fix that adds `viewport-fit=cover` WITHOUT adding left/right padding is worse than the bug
(R3 then shows up as real overlap), so the graders check them together.

A correct run also: keeps the project building (`xcodebuild build -project
PracticeWrapper.xcodeproj -scheme PracticeWrapper -destination "generic/platform=iOS Simulator"
CODE_SIGNING_ALLOWED=NO`), says which page the shell loads (the bundled local copy), reports per
tier (Duo simulator / desktop browser / needs the phone), does not redesign the app, and does not
invent bugs outside this list.
