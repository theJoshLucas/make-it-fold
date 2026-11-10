---
description: Optimize this app for the iPhone Duo (scan, fix only what's broken, prove it in every fold position)
argument-hint: "[app folder or local URL]"
---

Optimize the app in $ARGUMENTS (or the current folder if nothing was given) for the iPhone Duo.

Use the `make-it-fold` skill and follow its job exactly, in order: setup check, scan, read only
the recipes and traps the scan names, a "before" check on the Duo simulator, the smallest fixes,
an "after" check plus a normal-phone check, then the four-part report. Do not redesign anything.
Never test against live data, and ask before publishing anything.

The plugin's scripts are in `${CLAUDE_PLUGIN_ROOT}/scripts/`.
