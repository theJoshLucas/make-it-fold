# Routes: what kind of app is this?

`duo-scan` names the surfaces. An app can have several (a website inside a native app has two).
Run every route that applies and test every surface.

| Surface | Status | Read |
|---|---|---|
| Website / web app in Safari | fully tested | `web.md`, `components.md` (only the parts the scan flagged), `traps/layout-web.md` |
| Home-screen web app (has a web manifest) | fully tested | `web.md` + `home-screen.md` |
| Website inside a native app (WKWebView shell) | fully tested | `wrapper.md` + `web.md` + `native.md` (shell only) |
| Native iPhone app (SwiftUI or UIKit) | fully tested | `native.md`, `traps/layout-native.md` |
| iPad or universal app | fully tested | `native.md` + `ipad.md` |
| Expo / React Native | fully tested | `expo.md` (version gate first) |
| Flutter, Capacitor/Ionic, games (Unity, SpriteKit, Metal) | guided | `guided.md` |
| Mac desktop app (AppKit, SwiftUI for Mac, Electron) | port, not a tune-up | `mac-port.md` |
| Anything else | unproven | `guided.md`, and say "unproven route" in the report |

"Fully tested" means this plugin ships a practice app of that type with planted Duo bugs and an
exam that a fresh session must pass. "Guided" means the checklist starts by reading that
framework's own live Duo docs, and the report says the route is less proven.

Always also read `traps/testing.md` and `traps/discipline.md`.
