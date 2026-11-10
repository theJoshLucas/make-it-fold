# Answer key: practice/home-screen (Practice Timer)

Planted Duo bugs. The practice folder never contains this file, so the agent under test can't
read it. Graders in `case.yaml` check each one. The app is a static page with a web manifest
(`"display": "standalone"`), so it is the home-screen route (`references/home-screen.md`) on top
of the web route.

| # | Bug | Where | What fixed looks like |
|---|---|---|---|
| H1 | Fixed bottom tab bar has no safe-area padding: the home indicator (34 px on the inner screen) and the 84 px left side bar in one cover-landscape direction sit on top of it | `style.css` `.tabbar` | `env(safe-area-inset-bottom)` plus left and right insets on the bar |
| H2 | `"orientation": "portrait"` in the manifest hides a broken landscape layout; the inner screen ignores the lock, and the landscape rule (`min-width: 900px` plus a fixed 480 px card) overflows the 594 px cover landscape | `manifest.webmanifest`, `style.css` `@media (orientation: landscape)` | the lock is removed AND the landscape layout is fixed (no 900 px minimum, the page does not scroll sideways at 594 px). Removing only the lock is a FAIL; fixing only the layout and keeping the lock is a FAIL |
| H3 | App shell is `height: 100vh`: bottom content hides behind Safari's toolbar (in the browser check) | `style.css` `.app` | `100dvh` / `100svh` / flow height, no bare `100vh` |
| H4 | Timer digits are `font-size: 24vw`: about 228 px tall at 951 px wide, overflowing the 480 px card (at the 594 px cover landscape they are about 142 px and fit: checked on the Duo simulator 2026-11-09) | `style.css` `.timer` | size capped or tied to height too (`clamp()` with a pixel maximum, or `rem`/`px`); not a bare `vw` size |
| H5 | `window.innerHeight` read once at load sizes the log list; it never updates after a fold | `app.js` | CSS sizing (flex / `dvh`), or the value re-read on `resize`; no one-time read |

Not planted (do not "fix"): the viewport tag already has `viewport-fit=cover`; the manifest is
valid; the third tab button is decoration.

A correct run also: reports per tier (desktop browser / Duo simulator / needs the phone), says
that the installed Home Screen app itself is a manual check (not scripted), does not redesign
the app, and does not invent bugs outside this list.
