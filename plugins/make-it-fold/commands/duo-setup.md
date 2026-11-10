---
description: Check this Mac is ready for iPhone Duo work, and set up what's safe to set up
---

Run `${CLAUDE_PLUGIN_ROOT}/scripts/duo-setup` and show the checklist in plain words.

- If duoctl or the "Duo Kit" simulator is missing, run `${CLAUDE_PLUGIN_ROOT}/scripts/duo-setup --install`
  (it installs the pinned, reviewed copy of duoctl and creates the simulator), then check again.
- Anything bigger (a macOS update, installing or updating Xcode, the multi-GB simulator download
  with `xcodebuild -downloadPlatform iOS`) needs the person's yes first: say what it is, how big,
  and that macOS and Xcode updates need their password.
- When everything needed is OK, say "Ready for Duo jobs" and suggest `/duo` inside an app's folder.
