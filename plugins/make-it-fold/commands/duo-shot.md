---
description: Photograph every screen of an app in every iPhone Duo pose and score each for fit and design (changes nothing)
argument-hint: "[local URL, or a native app's bundle id]"
---

Check $ARGUMENTS on the iPhone Duo simulator without changing any code.

- A web app: make sure it is running locally (start its dev server if needed, never against live
  data), then run `${CLAUDE_PLUGIN_ROOT}/scripts/duo-shot web --url <local url>` (add
  `--scenario duo/scenario.json` if the app has one, `--poses all` to add the partially open poses: book, laptop and tent).
- A native app: build it for the simulator and run
  `${CLAUDE_PLUGIN_ROOT}/scripts/duo-shot native --bundle <id> --app <path to .app>` (add
  `--scenario duo/scenario.json` so every screen is shot, not just the first one).
- Hand that one command to the duo-shooter agent (`make-it-fold:duo-shooter`) to run; its answer is
  duo-shot's RESULT line. Then run `${CLAUDE_PLUGIN_ROOT}/scripts/duo-models` and call the duo-judge
  agent (`make-it-fold:duo-judge`; model "opus" if the judge is unavailable or not chosen) once per
  screen, several at a time, handing each the run folder, its one screen, the path to
  `references/design.md` in the `make-it-fold` skill, and one sentence on what the app is for. Then
  `${CLAUDE_PLUGIN_ROOT}/scripts/duo-shot verdicts <run folder>` gathers `judge.md`; judge again any
  screen it lists as missing or unsure.
- Report in plain words, per screen, the judge's verdict word for word: **native**, **fits only**
  (works, but looks like a stretched phone: say what a native layout would be) or **broken** (say what
  and where), and which model judged. Add what only the
  real phone can prove, and give the path to `contact.html`.
