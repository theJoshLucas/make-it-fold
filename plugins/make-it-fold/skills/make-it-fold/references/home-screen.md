# Home-screen web apps (added to the Home Screen from Safari)

Everything in `web.md` applies, plus:
- With `"display": "standalone"` there is no Safari toolbar, so the page owns the whole screen,
  including the area under the status bar, the side bar and the home indicator. Safe areas on all
  four sides matter even more.
- `"orientation"` in the manifest (for example `"portrait"`) is not honored on the inner screen.
  Fix the layout so it works sideways. Keep the lock itself unless the person asks: removing it
  also lets ordinary iPhones rotate the installed app, which is their decision. Say so in the report.
- Folding resizes the running app: no reload. State must survive the resize.
- Checks: `duo-shot web` proves the layout in Safari. The installed app itself (added to the Home
  Screen) is a manual check on the simulator or the phone until it is scripted: say so in the
  report.
