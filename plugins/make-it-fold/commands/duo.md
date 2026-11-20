---
description: Make this app Duo-native (fix what breaks, lay out every screen for both Duo displays, prove it with scored pictures)
argument-hint: "[app folder or local URL] [fit] [continue]"
model: opus
effort: high
---

Make the app in $ARGUMENTS (or the current folder if nothing was given) look and work like it was
designed for the iPhone Duo.

Use the `make-it-fold` skill and follow its job exactly, in order: setup and fresh Apple docs, scan,
read the route and the design rules, "before" pictures of EVERY screen in every pose, the
design scorecard and a layout plan, the fit fixes and the new layouts, "after" pictures with the
side-by-side page and a normal-phone check, up to three fix rounds, one polish round once every screen
is native, then the five-part report.

"Nothing is cut off" is not done: every screen must score **native** on the outer display and on the inner
display, judged from the pictures by the duo-judge agent, never by you. The duo-shooter agent takes the
pictures. Keep the app's own colors, fonts, wording and features; an
ordinary iPhone must look the same as before.

If the arguments include the word `fit`, do the fit-only job: fix what breaks, change no layouts,
and still report each screen's design verdict.

If the arguments include the word `continue`, a job is already under way in this conversation: pick it
up at the step where it stopped (this command only puts the job back on Opus at high effort).

Never test against live data, and ask before publishing anything.
The plugin's scripts are in `${CLAUDE_PLUGIN_ROOT}/scripts/`.
