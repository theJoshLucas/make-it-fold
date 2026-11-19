# make-it-fold architecture

A Claude Code plugin, published from this repo as its own marketplace.

## Layout
- `.claude-plugin/marketplace.json`: the marketplace (one plugin, source `./plugins/make-it-fold`).
- `plugins/make-it-fold/`: everything users install.
  - `skills/make-it-fold/SKILL.md`: the job (setup and fresh knowledge, scan, route, before, design review
    and layout plan, build, after, report, learn). Two bars: it fits (the floor) and it is native (the goal).
    `references/*.md` are read on demand only; `references/design.md` (the scorecard and the layout
    patterns) and `traps/design.md` are read by every job except a fit-only one. `traps/*.md` hold the
    trap notebook (no private sources).
  - `commands/duo.md` (native by default, `fit` for fit-only, `continue` to resume on Opus), `duo-new.md`,
    `duo-setup.md`, `duo-shot.md`. `duo.md`, `duo-new.md` and the skill set `model: opus` and `effort: high`
    for the turn (Claude Code returns to the person's own model on their next message).
  - `agents/duo-shooter.md` (`model: sonnet`, Bash only): runs the duo-shot command it is handed, in the
    foreground, and answers with duo-shot's RESULT line. `agents/duo-judge.md` (`model: fable`,
    `effort: low`; Read, Write, Glob): scores ONE screen of a run folder against `references/design.md` and
    writes `judge/<screen>.md` there; the builder makes one call per screen (one agent holding a whole
    big app's pictures stops seeing the early ones), and `duo-shot verdicts <run>` gathers them into
    `judge.md`, naming any screen missing or "unsure" (never a pass). `dev/judge-check` (costs usage)
    proves the judge on four apps whose verdict is known, Apple's own Settings among them. The builder hands it only the run folder, the scorecard path, the owner's
    settings and one sentence about the app; it calls it with model "opus" when `duo-models` says Fable
    is unavailable or was not chosen. Plugin agents are invoked as `make-it-fold:<name>`.
  - `scripts/`: `duo-setup` (checks the Mac, installs the pinned duoctl, creates "Duo Kit"),
    `duo-sim` (poses via duoctl, verified from duoctl's readback; refuses a duoctl copy that is not
    exactly the pinned commit; two locks, see below),
    `duo-scan` (static suspects + surfaces + which recipes to read),
    `duo-shot` (web: proxies the app through `duo-listen`, injects `duo-reporter.js`, measures in every pose;
    native: install, then one launch per scenario screen (launch arguments, environment values, a link,
    taps) and a screenshot of each in every pose, or with `--order pose` one fold per pose and every screen
    started in it; `compare` puts two runs side by side),
    `duo-listen` (localhost-only server/proxy), `duo-reporter.js`,
    `duo-docs` (downloads Apple's Duo pages on every run; see below), `duo-notes` (the local lessons notebook),
    `duo-models` (which model each part of the job runs on; see below).
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

## Fit issues and design notes are different things
`duo-shot` counts **issues** (something is cut off, covered, lost or reloaded) and its exit code follows
them. It also prints **design notes** from `duo-reporter.js` (one column on a wide screen, controls wider
than 560 px, lines past about 95 characters, under 60% of the width used, touch targets under 44 px, and
type that is bigger on the inner screen than on the cover). Notes never change the exit code: they are
prompts. Design is judged by whoever runs the job, from the pictures, in the `review.md` scorecard that
every run writes (one block per screen, a row for the cover and one for the inner screen). The duo-judge agent
fills it in, never the agent that built the layouts. Native runs have no measured notes from inside the app.

Every picture, web and native, is also measured from a 160-pixel copy made by `sips` (no extra libraries):
the **biggest empty patch** (the largest rectangle of the most common color, as a share of the picture; over 25%
on the inner screen is flagged in `review.md`) and **blank** (one color on 99% of it, an issue). Native runs take
captures until two in a row differ on under 3% of their pixels (at most 9 captures, 0.6 s apart), so a sheet still
sliding in is not the picture; with `--order pose` a blank or still-moving picture is retaken from a fresh launch,
twice. A scenario's `defaults` are written with `simctl spawn ... defaults write` before the first launch. The last
line of every run is `RESULT {json}` (run folder, picture count, blank, moving, reshot, issues, settings).

## Fresh knowledge on every run
- `duo-docs` reads `tools/apple-docs.tsv` (name, core or topic, address, purpose), fetches each page from
  developer.apple.com (nothing else, no cookies), and saves it in `~/.cache/make-it-fold/apple-docs/` (a
  temporary folder when that is not writable). The two core pages are always marked READ. A topic page is
  marked "changed" when its hash differs from `tools/apple-docs.baseline.json` (what the recipes were written
  from; rewritten by `duo-docs --write-baseline` whenever the recipes are brought up to date) or from the
  last run on this computer. New links on the core pages since the last run are listed.
- `duo-notes` keeps `~/.config/make-it-fold/notebook.md`: one entry per lesson, numbered L-001 and up. It
  refuses entries that hold a key, an email address or a home-folder path, and skips a repeated title.
  The notebook is outside the plugin folder, so it survives updates.
- `duo-setup` compares this copy's version with the one on `main` (4 second limit, silent when offline)
  and prints the update line when a newer one is out.
- `duo-docs` (and `duo-docs quotes`, which `dev/check` runs) checks that every quoted phrase in
  `references/design.md` that follows the word "Apple" appears on a saved Apple page (curly quotes and line
  breaks evened out). A missing one is reported as the plugin's own rule.
- `duo-models` reads `platform.claude.com/docs/en/about-claude/models/overview.md` (the newest id per family),
  then asks this Claude Code for one tiny answer on "opus", "sonnet" and, when the judge is Fable, "fable" at low
  effort (`claude -p --output-format json`, reading `modelUsage`), at most once a day per Claude Code version
  (`~/.cache/make-it-fold/models.json`; a failed check is not cached). The judge choice lives in
  `~/.config/make-it-fold/models.json`. It never updates anything: "behind" tells the builder to ask.

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
(measured 2026-11-09, Xcode 27.2 / iOS 27.2 simulator). `references/design.md` is the plugin's own summary of
Apple's design page as of the baseline date; the live page wins.
