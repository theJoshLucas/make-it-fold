# Websites inside a native app (WKWebView shells)

Two layers, two checklists: the native shell (`native.md`) and the web page (`web.md`).
- **Shell**: the web view should fill the safe area or pass the insets to the page. A shell that
  calls `.ignoresSafeArea()` and turns off `contentInsetAdjustmentBehavior` hands every inset to
  the page, so the page's CSS must pad all four sides with `env(safe-area-inset-*)` and its
  viewport tag needs `viewport-fit=cover`.
- **Page**: test it with `duo-shot web` against a local copy.
- **Which page does the shell load?** Many shells hard-code the live site. Then "prove the app
  shows the fix" is only possible after the page is published, or with a debug-only setting that
  points the shell at the local server (never enabled in release builds). Say which one you used.
- Rebuild and run the shell on the Duo simulator after the page fix: `duo-shot native`.
