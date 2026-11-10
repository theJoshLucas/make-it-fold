---
description: Check how an app looks and behaves in every iPhone Duo fold position (changes nothing)
argument-hint: "[local URL, or a native app's bundle id]"
---

Check $ARGUMENTS on the iPhone Duo simulator without changing any code.

- A web app: make sure it is running locally (start its dev server if needed, never against live
  data), then run `${CLAUDE_PLUGIN_ROOT}/scripts/duo-shot web --url <local url>` (add
  `--scenario duo/scenario.json` if the app has one, `--poses all` to include half-open).
- A native app: build it for the simulator and run `${CLAUDE_PLUGIN_ROOT}/scripts/duo-shot native --bundle <id> --app <path to .app>`.
- Then look at every screenshot (thumbnails first, full size for anything flagged) and report in
  plain words: what passed in each pose, what broke and where, and what only the real phone can
  prove. Give the path to `contact.html`.
