# make-it-fold architecture

A Claude Code plugin, published from this repo as its own marketplace.

## Layout
- `.claude-plugin/marketplace.json`: the marketplace (one plugin, source `./plugins/make-it-fold`).
- `plugins/make-it-fold/`: everything users install.
  - `skills/make-it-fold/SKILL.md`: the job (setup, scan, route, before, fix, after, report, traps loop).
    `references/*.md` are read on demand only; `traps/*.md` hold the trap notebook (no private sources).
  - `commands/duo.md`, `duo-setup.md`, `duo-shot.md`: the three slash commands.
  - `scripts/`: `duo-setup` (checks the Mac, installs the pinned duoctl, creates "Duo Kit"),
    `duo-sim` (poses via duoctl, verified from duoctl's readback; refuses a duoctl copy that is not
    exactly the pinned commit; two locks, see below),
    `duo-scan` (static suspects + surfaces + which recipes to read),
    `duo-shot` (web: proxies the app through `duo-listen`, injects `duo-reporter.js`, measures in every pose;
    native: install, launch, screenshot every pose), `duo-listen` (localhost-only server/proxy), `duo-reporter.js`.
  - `tools/duoctl.pin`: the reviewed duoctl commit. `/duo-setup` clones exactly that commit into
    `~/.cache/make-it-fold/duoctl/<sha>`.
  - `probe/index.html`: the Duo Screen Check page. Recognises the five positions from the page's own size,
    compares each with the simulator numbers in `references/facts.md` (copied into the page; update both
    together), and posts to `/report` only when its address is localhost. Published on its own to GitHub
    Pages by `.github/workflows/pages.yml` (only this folder goes on the site).
  - `practice/<type>/`: practice apps with planted bugs. `evals/<type>/`: `case.yaml` and a scaffold script.
- `dev/answers/<type>/`: answer keys and fixed reference copies, OUTSIDE the plugin so exam sessions cannot read them. `dev/check-graders <case.yaml> <folder>` checks regex graders for free.

## How a web check works
Simulator Safari -> `http://localhost:8787/...` -> `duo-listen` (proxy) -> the app's own local dev server.
HTML responses get `<script src="/__duo/reporter.js">`. The reporter posts measurements on load and resize and
answers commands (rect, value, setValue, text, calibrate) by polling `/__duo/cmd`. Taps are real taps through
duoctl, mapped from page pixels to screen points with one calibration tap on a transparent pane.

## Two locks, one simulator
There is one "Duo Kit" simulator per Mac, and several Claude sessions may want it.
- Run lock (`~/.cache/make-it-fold/duo-run.lock`): `duo-shot` holds it for a whole check, so a second
  session waits instead of folding the phone mid-screenshot. It sets `DUO_RUN_HELD=1` so its own `duo-sim`
  calls skip the wait.
- Command lock (`duo-sim.lock`): held for one `duo-sim` command, so two fold commands never interleave.
- `duo-sim shutdown` shuts down only the simulator id it recorded booting itself.

## Trust boundaries
- `duo-listen` binds loopback only (127.0.0.1 and ::1) and answers only requests whose Host is localhost,
  so a web page elsewhere cannot point its own name at it and read the app. Anything else gets a 403.
- `duo-listen --proxy` accepts only an app on this computer. `--allow-remote` lifts that for a read-only
  page; then Cookie and Authorization are not sent on, and Set-Cookie is not passed back.
- The probe page's plain `/report` address is only taken over in folder mode; behind the proxy an app keeps
  its own `/report`.
- `duo-shot` accepts only a path that starts with one `/`, and re-checks that the address it is about to
  open is on localhost.
- The pin is enforced twice: `duo-setup --install` downloads beside the final folder and moves it in only
  once it is the reviewed commit with no changed files; `duo-sim` checks the same thing before every run.
- duoctl's helper runs inside the simulator only (HID events); it has no network or file access beyond its cache.
- The repo is public: nothing in it may name the maintainer's other apps, customers, business or private paths (`dev/check` greps for it).

## Measured facts
Device and Safari numbers live in `plugins/make-it-fold/skills/make-it-fold/references/facts.md`
(measured 2026-11-09, Xcode 27.2 / iOS 27.2 simulator).
