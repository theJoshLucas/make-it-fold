# Testing traps: simulator, screenshots, browser automation, verification

Load for every job. Ordered by how often each one bites a Duo job, most first.
Duo simulator facts used below: display ID 1 = cover, 3 = inner; cover screenshot 1398 x 2034, inner 2007 x 2853
(either orientation); folding is done in Device Hub or with a fold tool, never with `simctl`.

### T-01 Screenshots taken right after a fold come out black or half-drawn
- **Went wrong:** Screenshots grabbed straight after folding or unfolding came out black or mid-animation. Separately, an accessibility scan started at network idle while a 700ms reveal was still running and reported four contrast failures in colours that matched no token. Comparison shots were taken with a sheet open or a banner showing.
- **Spot it:** a fixed sleep (or none) between the fold and the capture; measured colours or sizes that are close to, but not equal to, the authored values.
- **Fix:** after every fold, wait until the app reports its new size (size class, or the reporter page's width) and two captures in a row match; on the web, also wait until every `document.getAnimations()` entry has finished. Judge only clean frames: no transient sheet, banner or animation.
- **Check:** reject any capture that is all black, or that differs from a second capture taken a moment later.
- **Applies to:** all

### T-02 Screenshots and taps hit the wrong display
- **Went wrong:** XCUITest screenshots capture only display 1 (the cover), so every "inner screen" shot from a UI test came out black while the Duo was unfolded. The Duo's displays are ID 1 and ID 3, not 0 and 1. In another project, code that picked "the first view" out of two chose the wrong one on one device class.
- **Spot it:** any capture or tap that doesn't name its display; a display or screen chosen by index.
- **Fix:** take inner-screen shots with `xcrun simctl io <udid> screenshot --display=3` (cover: `--display=1`). Address displays by ID or label, never by position. XCUITest can't fold either: the test pauses on a signal (a file or a local HTTP call), the host folds, then the test resumes.
- **Check:** each capture's pixel size matches its display (inner 2007 x 2853, cover 1398 x 2034, either way round) and it is not black.
- **Applies to:** all (simulator)

### T-03 A tap or fold "succeeded" but nothing happened
- **Went wrong:** Some simulator automation tools report success for taps that had no effect. Each Duo display has its own touch input, so taps can land on the cover while the inner screen is showing. Device Hub's own fold slider does not reflect folds made by other tools. Elsewhere, input sent before an app was ready was silently ignored, and clicks in a background browser tab landed on a stale frame.
- **Spot it:** an automation step whose only evidence is the tool's own "ok".
- **Fix:** before trusting a driver, tap a button on the inner screen and see it change (a driver whose taps land on the cover is out). Wait for an explicit ready signal before sending input. After every fold, confirm the pose from inside the app (size class, or the reporter's width), not from Device Hub's controls. Bring a browser tab to the front and reload it before acting.
- **Check:** every tap and fold in the run log is followed by a read of the screen, or of the app's reported state, that shows the change.
- **Applies to:** all (simulator)

### T-04 Never use `simctl io ... screenConfig` on the Duo
- **Went wrong:** `xcrun simctl io <udid> screenConfig --display=N power` (and `geometry`) crashed SpringBoard on the Duo simulator, repeatedly.
- **Spot it:** any script or helper that calls `screenConfig`; an agent looking for a command-line way to fold (`simctl` has none).
- **Fix:** fold, rotate and resize only through Device Hub or a fold tool that sends Device Hub's own events.
- **Check:** `grep -rn screenConfig` across every script the job will run returns nothing.
- **Applies to:** all (simulator)

### T-05 Proof from the wrong engine
- **Went wrong:** Web layouts passed every check in desktop Chromium while mobile Safari had a dead button and no keyboard. Text measured 400px in Chromium and 420px in WebKit and wrapped only on the phone. Desktop emulation "passed" keyboard handling because it shrinks the layout viewport, which real mobile Safari does not. A page animated in one engine and hard-cut in Safari. A stripped-down headless browser build was redirected where the full browser was not, so a correct page failed for two days.
- **Spot it:** any "works" claim backed only by desktop browser runs.
- **Fix:** desktop browsers are a layout smoke test only. Prove phone behaviour on the iOS engine: Safari on the Duo simulator for web, the simulator itself for native. Run text-fit checks in WebKit. When a check disagrees with what a person sees, test the checker against the person's exact setup before blaming the app.
- **Check:** every pass line in the report names engine, device and OS version.
- **Applies to:** web / home-screen / wrapper (the labelling applies to all)

### T-06 Checking some screens, or some poses
- **Went wrong:** A fix in a layer shared by six pages was checked on the one page in the screenshot and shipped broken on another (a native container underneath re-applied the safe area). One screenshot per page let through a bug that the agent's own screenshot showed. A statistic was drawn from page one of a list as if it were the whole set.
- **Spot it:** a shot list shorter than screens x poses; "checked the main screens".
- **Fix:** enumerate every screen in the scenario times every required pose (cover portrait, cover landscape, inner portrait, inner landscape, plus the fold mid-task), and capture each, top and bottom of long pages. A change to a shared shell is proven on every screen that uses it.
- **Check:** the report shows the full matrix with a result in every cell; the screenshot count equals screens x poses x scroll positions.
- **Applies to:** all

### T-07 Glancing at shrunken screenshots, or only at the part you changed
- **Went wrong:** Broken sprite edges and a clipped icon shipped after being checked on contact sheets at a quarter size. A check confirmed things appeared, not that the screen made sense (overlapping, floating, empty). A layout looked right where it was edited while the rest of the window had gone blank. Correct style values still rendered wrong. A review compared a form at rest with errors from a later moment.
- **Spot it:** review done only from contact sheets, or only of the edited region.
- **Fix:** open every screenshot at full size; zoom on the changed region until single pixels show; read the whole screen, all four corners and the bottom half. Write one line per region ("sidebar: against left edge, content not under it"); a line you can't write is a defect. Judge rendered pixels, not CSS or property values, and capture each piece of evidence in the state being judged.
- **Check:** the report names the full-size files opened and includes 1:1 crops of each changed region.
- **Applies to:** all

### T-08 Every pose tested from a fresh start, never mid-flow or in combination
- **Went wrong:** A blank screen on every reload came from code reading an object that didn't exist yet, and only when saved state was mid-flow; every check had started fresh. A nightly bot tested two paths separately but never their combination, where a skipped step's state was never set.
- **Spot it:** a test plan where every pose starts from launch; axes tested one at a time.
- **Fix:** fold in the middle of real tasks (sheet open, half-typed text, keyboard up, scrolled, zoomed), and relaunch into a restored mid-flow state. Walk the combinations that matter (pose x orientation x keyboard x entry path), not each axis alone.
- **Check:** the scenario has a fold-mid-task step and a relaunch-in-the-other-pose step, and both pass with no new console error.
- **Applies to:** all

### T-09 Claiming what the simulator cannot prove
- **Went wrong:** Desktop CPU counters were offered as evidence about phone heat. Keyboard behaviour was called green from an emulator. Features the simulator can't drive (a hardware button press, camera, haptics, sound) were reported as working.
- **Spot it:** claims about feel, haptics, camera, hinge angle, the crease, split view (the Duo simulator doesn't support it), real Safari bar behaviour, or performance.
- **Fix:** keep a "needs a real Duo" list in the report and put every such item on it. A check where the named browser or device wasn't actually exercised is "blocked", not "passed".
- **Check:** every claim in the report names its tool and device, and unprovable items appear only on the list.
- **Applies to:** all

### T-10 Tested with sample data that fits
- **Went wrong:** A panel tested with 7 items overflowed at 8. A 62-character email address forced sideways scroll. Counters read "1 items". A button that gained text pushed its row over a count at a narrower width.
- **Spot it:** fixtures full of short, typical values.
- **Fix:** size containers from the data's extremes, not the sample.
- **Check:** on the cover in both orientations, feed each screen its maximum item count, its longest real string, a 60+ character string with no spaces, nothing at all, and counters at 0, 1 and 2; no text overlaps a control, count, date or price. Run once more at the largest text size.
- **Applies to:** all

### T-11 UI tests that tap fixed points, or wait for one layout's marker
- **Went wrong:** Older UI tests tapped fixed coordinates sized for a 402 x 874pt phone, so they missed their targets on the Duo's 466 x 678pt cover. Another suite waited for two page markers that a redesign removed, and failed forever while the user was already signed in.
- **Spot it:** coordinate taps; waits keyed to text or elements that exist in only one layout.
- **Fix:** find elements by accessibility identifier or name; wait for a signal that doesn't depend on layout (URL, a state flag, an element by id).
- **Check:** run the UI tests in all four poses; a test that passes in only one pose is suspect before the app is.
- **Applies to:** all

### T-12 Scripted checks that never act like a person
- **Went wrong:** A feature was verified by scripted calls that read reply text, and passed; then the owner found literal asterisks, a dead gap above the input, and a chip that filled a box below the fold so nothing visibly happened. A test seeded its own gate condition and "proved" a broken feature. A test player that tapped Next the instant it appeared reported "no stuck screens" while real users got stuck behind an overlay.
- **Spot it:** proof that sets the fold state, size or app state directly instead of going through the UI; checks that only read text.
- **Fix:** drive the scenario with real taps in the real pose, and after each step ask "did what I just did visibly respond?". Include one slow, distracted pass (idle, tap late and twice, fold mid-animation). Label evidence "verified with pixels" or "code-level only".
- **Check:** remove any seeding step; the proof must still pass.
- **Applies to:** all

### T-13 One green run of a flaky flow
- **Went wrong:** A UI freeze happened about 1 run in 6 and was nearly called fixed after a single pass (after the real fix it went 12 of 12, and was still not declared closed). A step that failed 2 times in 6 looked fine in one run.
- **Spot it:** a bug that "went away" with no change aimed at its cause.
- **Fix:** repeat any flow touched by a fold or resize race at least 10 times and report N of N; one pass proves nothing.
- **Check:** loop the UI test or scenario and put the count in the report.
- **Applies to:** all

### T-14 A check that cannot fail
- **Went wrong:** An overflow check's "allowed to wrap" exemption also switched off its spill and clip checks; another only tested the screen edge and missed text clipped by its own box. A watch list of folders that didn't exist made every diff empty and green. A watchdog confirmed a run happened, not that its result arrived. A skipped test lane showed green. A fixture reused the code's own invented name. A stub couldn't refuse what the real tool refuses. A scanner read a renamed source, found nothing, and reported clean.
- **Spot it:** a new check that has never been seen failing; "no issues found" from a scanner on a non-trivial app.
- **Fix:** before trusting a checker, run it against a deliberately broken page or app at narrow and wide sizes and watch it fail. Read the actual assertions before saying what a test proves. An empty scan of a populated project is reported as suspicious, not clean. Know which checks actually ran.
- **Check:** plant one known defect of each kind (sideways overflow, clipped text, a control under the bar) and confirm each check catches its own.
- **Applies to:** all

### T-15 A green exit code that hid a failure
- **Went wrong:** `test 2>&1 | tail -5 && git commit && git push` pushed nine failing tests, because `tail` exits 0. A batch script logged errors and exited 0. `node --check a.js b.js` checks only the first file. A test count taken from the first summary line reported 2 of 131. A commit with nothing to stage exited 1 and silently stopped the rest of an `&&` chain. A page script crashed for hours because the engine-only tests never loaded it.
- **Spot it:** test commands piped into `tail`, `head` or `grep`; multi-file checks in one call; long chains joined by `&&`.
- **Fix:** run the test command bare (or with `set -o pipefail`), send output to a log, read its own exit code, and grep the log for failures. Check files one at a time in a loop. Count individual pass lines. Keep long-running work out of `&&` chains with commits. After editing page code, load each touched screen and read the console.
- **Check:** break one assertion on purpose and confirm the command reports failure.
- **Applies to:** all

### T-16 Running the whole matrix before one pose works; waits with no limit
- **Went wrong:** 110 sub-agents fanned out without the access they needed and all came back empty. A run produced 50 broken outputs where one probe would have found the bad path first. A 29-second test ran 37 minutes with nobody checking. A background run was thought dead for 28 minutes because its output was buffered.
- **Spot it:** a full screenshot or test matrix launched with no single-pose trial; background jobs with no deadline.
- **Fix:** run one pose end to end (fold, capture, assert) before the full matrix. Give every background job a deadline of about twice its normal time, and find out why when it passes. Judge progress by file times or a status command, not log silence. Resume from the failed step, not from the beginning.
- **Check:** the run log shows the single-pose trial passing before the matrix started, and every wait has a timeout.
- **Applies to:** all

### T-17 Reading the page mid-turn, or from an old tab
- **Went wrong:** Right after a fold or turn, Safari briefly reports sizes and safe areas that are not final (one cover-landscape direction showed 84 px on the left for a moment; settled, it is 0). Separately, Safari tabs left open by earlier test runs kept running and answered the test's questions, and their tab bar shrank the visible height by 48 px.
- **Spot it:** numbers that change between two readings a few seconds apart; inner-screen heights of 819 or 537 instead of 867 or 585; several open tabs in the simulator's Safari.
- **Fix:** start every check with a clean Safari (`duo-sim reset-safari`, done by `duo-shot`), send questions only to the page this run loaded, and read only after the page has stopped resizing for 2 seconds.
- **Check:** two readings 2 seconds apart agree, and the inner screen reads 669 x 867 / 951 x 585 with toolbars shown.
- **Applies to:** web / home-screen / wrapper
