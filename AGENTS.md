# make-it-fold: rules for agents working ON this repo

Agents USING the plugin start at the "For AI agents" section of `README.md`. This file is for
changing the plugin itself.

## 1. READ ORDER (hard rule)
Before changing anything:
1. `README.md`: what the plugin promises its users. Every promise there must stay true.
2. `docs/architecture.md`: the layout, how a web check works, the trust boundaries.
3. `current-status.md`: what is proven, on what, and what is not.
4. Only then open source code.

## 2. CHECK COMMANDS (verbatim)
- Everything fast (no Claude usage, no simulator): `dev/check`
- Manifests only: `claude plugin validate . && claude plugin validate plugins/make-it-fold`
- Scripts on a real Mac: `plugins/make-it-fold/scripts/duo-setup` (exit 0 = Mac ready) and
  `plugins/make-it-fold/scripts/duo-scan plugins/make-it-fold/practice/web`
- Exam (slow, costs Claude usage; run per case, ask before running the whole set):
  `claude plugin eval plugins/make-it-fold --case <name> --runs 1 --scaffold --allow-tools Bash Write Edit --ablation none`
  `<name>` is the `name:` line inside `plugins/make-it-fold/evals/<folder>/case.yaml`, not the folder name.
  Outside an interactive terminal, add `--trust-plugin`.

## 3. DEFINITION OF DONE
Do not report a task complete until ALL of:
- `dev/check` exits green, AND
- you covered EVERY affected surface (all 7 poses, all routes the change touches; no sampling), AND
- you tried it WRONG, not just right (missing Xcode, no simulator, a bad URL, a second run), AND
- every sentence in `README.md` the change touches is still true, AND
- if the shape of the system changed, `docs/architecture.md` says so now, AND
- `current-status.md` says what is proven and what is not.
- A green check proves the code ran, not that the plugin worked. Say which one you have.

Project done-check: a script change is proven on the Duo simulator against the practice apps
(`duo-shot web` on `practice/web` reports issues; on `dev/answers/web/fixed` it reports none).
A skill, recipe or trap change is proven by rerunning the exam case it affects.

## 4. PERMISSIONS
- Always OK: read anything, run `dev/check`, edit source.
- Ask first: add dependencies, change the pinned duoctl commit (read the new code in full first),
  anything that spends money, publishing (a version bump people will install, hosting a page).
- NEVER: force-push, `git add -A`, commit secrets, or pass `--no-verify`. If a gate is wrong,
  fix the gate.
- This repo is PUBLIC. Nothing in it may name the maintainer's other apps, customers, business
  or private paths. Trap entries are written generically; where a lesson came from stays out.
  `dev/check` enforces it: two generic patterns always run, plus the maintainer's own names from
  `dev/private-words.txt` (git-ignored, so the list is never published; absent on a fresh clone).

## 5. MEMORY IS A HINT, NOT A FACT
Any claim about how this repo CURRENTLY works must cite a line of live code read THIS session.
Device numbers come from `references/facts.md` or a fresh measurement, never from memory.

## 6. WHO WRITES WHAT
- `current-status.md` and `docs/architecture.md` are kept current by whoever changes the code.
- New traps go in `plugins/make-it-fold/skills/make-it-fold/traps/`, in the format
  `references/traps-loop.md` describes. Answer keys stay in `dev/answers/`, outside the plugin,
  so exam sessions cannot read them.
- No instruction file (this one, the README, SKILL.md) is ever regenerated wholesale.

## 7. TWO-STRIKES rule for new rules
Only formalize a new standing rule after the SAME mistake happens twice. One-offs get fixed, not
enshrined. EXCEPTION: a failure that reaches a user becomes a trap entry on strike one.

## 8. RELEASE REALITY ("pushed is not live")
- Users install from the `main` branch of `github.com/theJoshLucas/make-it-fold`.
- An existing install only picks up a change when `version` in
  `plugins/make-it-fold/.claude-plugin/plugin.json` goes up and the user updates the plugin.
  A push without a version bump reaches new installs only.
- "Shipped" means: a fresh `/plugin marketplace add` + `/plugin install` from GitHub loads the
  change. Check that, not the local folder.
