---
description: Photograph every screen of an app in every iPhone Duo fold position and score each for fit and design (changes nothing)
argument-hint: "[local URL, or a native app's bundle id]"
---

Check $ARGUMENTS on the iPhone Duo simulator without changing any code.

- A web app: make sure it is running locally (start its dev server if needed, never against live
  data), then run `${CLAUDE_PLUGIN_ROOT}/scripts/duo-shot web --url <local url>` (add
  `--scenario duo/scenario.json` if the app has one, `--poses all` to include half-open).
- A native app: build it for the simulator and run
  `${CLAUDE_PLUGIN_ROOT}/scripts/duo-shot native --bundle <id> --app <path to .app>` (add
  `--scenario duo/scenario.json` so every screen is shot, not just the first one).
- Look at every picture at full size. Read `references/design.md` in the `make-it-fold` skill and
  fill the `review.md` that duo-shot wrote: the eight scorecard questions per screen, on the cover
  and on the inner screen.
- Report in plain words, per screen: **native**, **fits only** (works, but looks like a stretched
  phone: say what a native layout would be) or **broken** (say what and where). Add what only the
  real phone can prove, and give the path to `contact.html`.
