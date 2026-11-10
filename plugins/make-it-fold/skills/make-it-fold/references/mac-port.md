# Mac desktop apps: a port, not a tune-up

A Mac app does not run on an iPhone. Say that first, give a rough size of the job, and get a yes
before touching anything.
- **SwiftUI Mac app**: the easiest case. Add an iOS target (or a multiplatform target), share the
  model and most views, then adapt input (touch, no hover, no menu bar), file access, and window
  assumptions. Then follow `native.md`.
- **AppKit app**: the screens have to be rebuilt in UIKit or SwiftUI; the model and logic can often
  be shared. Estimate per screen.
- **Mac Catalyst** goes the other way (iPad to Mac) and does not help here.
- **Electron app**: it is a web app in a desktop shell. Ship the web part as a website or a
  home-screen web app first, then follow `web.md`.
