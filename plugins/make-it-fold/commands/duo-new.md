---
description: Start a new app designed for the iPhone Duo from the first screen
argument-hint: "[what the app should do]"
model: opus
effort: high
---

Build a new app for the iPhone Duo: $ARGUMENTS

Use the `make-it-fold` skill's **new app** job: read `references/new-app.md` and
`references/design.md`, run `duo-setup` and `duo-docs`, then build every screen with its cover
layout and its inner-screen layout together. Prove each screen with `duo-shot` and the scorecard
as you go (the duo-shooter agent takes the pictures, the duo-judge agent scores them), and finish
with the skill's five-part report.

If nothing was given above, ask one question: what should the app do, and for whom?
Never test against live data, and ask before publishing anything.
The plugin's scripts are in `${CLAUDE_PLUGIN_ROOT}/scripts/`.
