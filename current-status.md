# Current status

## 2026-11-09: v0.1.0 built and reviewed, all 8 exams pass
- Home: `github.com/theJoshLucas/make-it-fold`. Publishing steps (making the repo public, a version
  bump, hosting the probe page) are always asked first.
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
  - A fresh install from a clean clone (marketplace add, install, `/duo-setup`) loads all three commands.
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
- NOT done / unverified: a second Mac (everything above ran on one machine); the probe page is not hosted
  publicly yet (publish step); real iPhone Duo checks (day one: open the probe page in every pose); Expo
  practice apps never installed or built (source only); `--allow-remote` cookie stripping was tested
  against a stand-in server, not a real logged-in site.
