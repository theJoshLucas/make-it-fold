# Current status

## 2026-11-19: v0.2.1, after the first full job on a real app
- The full native job ran end to end on a real 16-screen SwiftUI app (the one that exposed v0.1.0's miss):
  before and after pictures in three positions, a scorecard, new layouts, a fold in the middle of a form, dark
  mode, the largest text size, and an ordinary-iPhone comparison. The owner has the pictures; not yet judged by
  them, and not yet on a real Duo.
- From that job: `duo-shot native --order pose` (48 pictures in 5 minutes where screen-by-screen was heading for
  an hour), traps T-18 and G-14, and G-08 now allows an app whose own design requires a custom bar to stand its
  tabs inside the system's strip. 75 traps.
- Not rerun: the exams (the instruction changes are two new traps and one widened fix line).

## 2026-11-18: v0.2.0, the job is now "Duo-native", not "nothing broke"
- Why: v0.1.0 told agents "no redesigns" and graded every picture on fit only. Run on a real app it reported
  "passes in every pose" while the inner screen showed a stretched phone layout. v0.2.0 changes what done means.
- What changed:
  - `SKILL.md`: two bars (fits, then native), three jobs (native by default, `fit` only on request, new app),
    a design-review step with a scorecard verdict per screen for the cover and the inner screen
    (native / fits only / broken, or "built, not seen" when no picture could be taken), a five-part report.
  - New: `references/design.md` (the scorecard, Apple's rules in short, a pattern per kind of screen),
    `references/new-app.md`, `traps/design.md` (13 design traps), a "duo-native layout" section in the web,
    native and Expo recipes, `commands/duo-new.md`. Trap D-02 rewritten; N-12 added. 73 traps in all.
  - Scripts: `duo-docs` (Apple's pages downloaded on every run, changed pages flagged), `duo-notes` (a lessons
    notebook on the user's computer, written without asking), `duo-setup` (says when a newer version is out),
    `duo-scan` (must-do items, design hints), `duo-shot` (native: one launch per scenario screen; web: named
    states and measured design notes; every run writes `review.md`; `compare` builds a before/after page).
  - New practice app `practice/web-phone` (fits, but a stretched phone) with exam `web-woodshed-native`.
    `web-setlist-no-changes` is now the fit-only exam. The native exam gained a design check (N9).
    Grader names `no-redesign-*` are now `look-kept-*`.
- Proven on the Duo simulator (this laptop, Xcode 27.2, iOS 27.2), each also tried wrong:
  - `duo-shot web`: buggy Setlist still 26 issues (exit 1), fixed Setlist 0 (exit 0).
  - Woodshed before (practice copy): 0 fit issues in all 7 poses, 19 design notes (one column on the wide screen,
    controls up to 919 px wide, a paragraph set at 17 px drawn at 25 px on the inner screen sideways), and the
    scenario's "list still visible beside the open session" step fails. After (`dev/answers/web-phone/fixed`):
    0 issues, 0 design notes, typed text survives every fold in both the note field and the new-session form.
    Pictures looked at: list beside the open session both ways up, form as a card (on the trailing half when sideways).
  - Native: `duo-shot native --scenario` shot two screens of Gig Log (the second reached by a tap) in all 7 poses.
    The fixed Gig Log is now two panes on the inner screen (regular width and regular height), one pane on the
    cover; a gig opened on the cover is still open after unfolding. 0 issues. Bad input refused: duplicate screen
    names, `--env` without `=`, `compare` on a missing folder (all exit 2).
  - `duo-shot native` with `env` screens was run on a real 6-screen app against a local test copy of its data.
  - `duo-docs`: all 10 pages fetched and stable between fetches; offline with a saved copy and offline with none;
    a read-only cache folder; an unknown page name. `duo-notes`: add, repeat title (skipped), private-looking text
    (refused), empty field (refused), read-only folder (lesson printed instead of lost).
    `duo-setup`: a pretend older copy is told "0.1.0 is out"; silent when offline.
- Exams (`claude plugin eval`, sandboxed: no simulator, no network, so they grade code and report honesty):
  all 9 pass at 1.00 on their latest runs. `web-setlist` and `native-gig-log` 2 runs of 2, the rest 1 run.
  It took three rounds. Round 1 (after the rewrite): 5 of 9. The misses and what changed:
  the fit-only job "fixed" two guesses (now: a fit fix needs a must-do item, a failed check or code that plainly
  does what a trap says; a guess goes under Still open); the native run hid a control behind a long-press on another
  screen (now: reachable on the same screen, in plain sight); the Expo run drew its own side rail (now: move to the
  system's bars, never draw a rail); a launch-screen key was left "for the developer" (now a must-do item in the scan).
  Round 2: 7 of 9; an orientation rule was kept "for phones" (now: phones keep their look, not their bugs), and one
  grader demanded a color stay in one particular file (loosened: it accepts the background or the accent there, so
  it no longer proves the page background survived a move to system tabs).
  The last three instruction edits (phones keep their look not their bugs, the web orientation line, carry colors
  across in Expo) were made after six of the nine cases had their final run; those six were not rerun on them.
  Total exam usage for this version: about $32 of Claude plan usage across 28 completed runs.
- NOT done / unverified:
  - No exam session has ever seen a picture, so no exam proves a design verdict from pictures. The simulator
    proofs above are the only "seen" evidence, and they are of the plugin's own answers, not of a fresh session's work.
  - The full `/duo` job has not yet been run end to end on a real app with this version. The real app that
    exposed v0.1.0's miss is the first job to run next.
  - `/duo-new` (a new app from scratch) has a recipe and no practice app or exam.
  - Half-open poses on the web: a page cannot tell half-open from open, so a pane can cross the fold. Listed as
    a limit in `references/web.md`.
  - Real iPhone Duo checks; the work Mac (older macOS and Xcode); the Expo practice apps (never built).

## 2026-11-09: v0.1.0 built and reviewed, all 8 exams pass
- Home: `github.com/theJoshLucas/make-it-fold`, public since 2026-11-09. Publishing steps (a version
  bump, a new hosted page) are always asked first.
- Duo Screen Check (the probe page) is live at https://thejoshlucas.github.io/make-it-fold/ (2026-11-09),
  published by `.github/workflows/pages.yml` (only the probe folder). Proven: duo-shot on the Duo simulator,
  0 issues in all 5 poses with all five positions matching; the live address opened on the Duo simulator;
  a regular iPhone 17 Pro simulator (dark mode) gets the not-a-Duo message; desktop browsers get the
  visitor view (light and dark). Share and copy were not pressed on a real phone.
- Install from the public address proven 2026-11-09 on a throwaway Claude Code setup: marketplace add,
  install, all three commands present, `duo-setup` reports ready.
- Plugin contents: skill + 14 reference files + 4 trap files (59 traps, written generically), 3 commands,
  scripts (`duo-setup`, `duo-sim`, `duo-scan`, `duo-shot`, `duo-listen`, `duo-reporter.js`), probe page,
  7 practice apps + 8 exam cases. Answer keys and fixed copies live in `dev/answers/` (outside the plugin).
- Proven on one laptop (macOS 26.6.2, Xcode 27.2, iOS 27.2 Duo simulator, "Duo Kit" sim):
  - duoctl pinned at c6ff3e96 (read in full before use); `duo-sim` 100/100 verified poses (50 fold cycles).
  - all 7 poses reachable, incl. book/laptop at about 93 degrees and apps locked to portrait.
  - inner-screen taps land (probe button test); Safari sizes measured and match WebKit's table (`references/facts.md`).
  - `duo-shot web`: buggy Setlist 26 issues (exit 1), fixed Setlist 0 (exit 0). `duo-shot native`: Gig Log, 0 issues.
  - the fixed Setlist was changed late (its compact layout now measures the song list's own width, trap W-08)
    and re-proven afterwards: 0 issues in 5 poses (cover upright, cover sideways both ways, inner upright, inner sideways).
  - Exam graders checked for free with `dev/check-graders`: every bug grader fails on the buggy app and passes on the fixed copy.
- Pre-publication review (2026-11-09), each item tried right and wrong on the simulator:
  - the pinned duoctl is re-checked at run time: a changed or added file in the cached copy is refused, and
    `duo-setup --install` swaps in a clean copy without leaving a half-download at the trusted path;
  - `duo-listen` answers only requests addressed to localhost (403 otherwise), proxies only apps on this
    computer unless `--allow-remote`, and with that flag drops cookies and logins in both directions;
  - `duo-shot` rejects paths that could point at another site, and URLs that are not local;
  - two sessions cannot drive the simulator at once (a run lock around a whole check, a short lock per command);
  - `duo-sim shutdown` only shuts down the exact simulator it booted itself.
- Exam sessions run inside Claude Code's eval sandbox, which cannot drive the simulator: exams prove the code fixes
  and the honesty of the report, not simulator driving. Simulator driving is proven by the manual runs above.
- Exams (`claude plugin eval`, latest, on the final files): all 8 pass at 1.00. `web-setlist-no-changes` 4 runs of 4,
  `web-setlist` 2 of 2, the other six 1 run each. One run is a small sample: a pass shows the skill can do it,
  not how often. Each run cost $0.32 to $0.88 of Claude usage.
- Simulator findings folded in: Safari settles to 0 side insets in both cover-landscape directions (84 px appears
  only mid-turn); old Safari tabs answer test questions and add a 48 px tab bar (duo-shot now resets Safari and
  targets one page); another app can hold the IPv6 localhost port (duo-listen binds both).
- NOT done / unverified: the work Mac is installed but not ready (macOS 26.5.2, Xcode 26.6); real iPhone
  Duo checks (day one: open the Duo Screen Check page in every position); Expo
  practice apps never installed or built (source only); `--allow-remote` cookie stripping was tested
  against a stand-in server, not a real logged-in site.
