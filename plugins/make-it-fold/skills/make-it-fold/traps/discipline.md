# Discipline traps: scope, proof, live data, deploys, secrets

Load for every job. Ordered by how often each one bites a Duo job, most first.

### D-01 "Fixed" without seeing it fail first
- **Went wrong:** Several "all fixed" reports included items that were never reproduced. A stuck-taps bug was declared fixed twice from screenshots of a row selecting fine, and the user hit it again straight away; the screenshots never recreated the real failure. A gesture fix shipped as a guess.
- **Spot it:** a fix with no "before" run behind it.
- **Fix:** run the scenario on the unchanged revision first and save it beside the "after". "Fixed" means it failed before and passes after. If you can't reproduce it, say "likely fix, not reproduced".
- **Check:** every "fixed" line in the report points at its failing before-run and its passing after-run.
- **Applies to:** all

### D-02 Redesigning when asked to make it fold
- **Went wrong:** The most repeated correction in one project was unrequested change: menus moved, steps added, names invented. A narrow-screen restructure shipped and was reverted the same day. An agent read an old chart as a privacy rule and built access walls plus 14 review rounds nobody asked for (the diff later shrank from 2,061 lines to 428). A fix used a pattern the project's own design rules banned.
- **Spot it:** a diff that touches screens or behaviour no failing check pointed at.
- **Fix:** change only what a failing assertion requires; "passes, no changes" is a complete result. Read the app's own design rules before adding any UI, and solve with what is already there. Open design questions get the no-behaviour-change default and go on a list for the owner. Any review loop gets a stopping rule written before it starts.
- **Check:** every hunk in the diff traces to a failing check or to a listed "my call", and the report lists those calls.
- **Applies to:** all

### D-03 Fixing only the one place you saw it
- **Went wrong:** Fixing the screen where a bug was seen, then having the owner find the same bug elsewhere, was the top complaint. A repo answered the same question on four separate surfaces and the fix landed in one. A rule was said to be followed after reading one of its three code paths. A case-sensitive sweep left a capitalised match live. A grep found nothing because the code built the name at run time.
- **Spot it:** one hit fixed and nothing else searched; a repo with several surfaces (site, admin pages, native app, wrapper) showing the same screens.
- **Fix:** when one instance of a fold-breaking pattern turns up (100vh, a fixed width, an idiom check, width read once), search the whole app for the pattern (case-insensitive, every spelling) and fix every instance. List every surface that shows the same screen and visit each one.
- **Check:** the report gives the sweep queries with hit counts before and after, and names the surfaces visited.
- **Applies to:** all

### D-04 Device facts taken from memory or docs instead of measured
- **Went wrong:** An architecture was built for a month on "the device is write-only", which appeared only in code comments and was false. An agent asserted a behaviour from a comment it wrote that morning; measuring took four minutes and showed it true for one path and false for the one it was used on. Guesses were presented as data. A wrong value went unnoticed for months because it happened to equal the number everyone expected. For the Duo, published Safari viewport sizes already disagree between sources.
- **Spot it:** a size, inset, breakpoint or behaviour claim with no measurement behind it.
- **Fix:** measure on the Duo simulator in this session (probe page, size class, safe-area log) before building on any number. Tag each claim "measured (date, tool)" or "assumed". Read the live platform doc page end to end rather than searching it. A comment or README is a hint, not evidence.
- **Check:** every new constant's comment names its source, and every device claim in the report carries its tag.
- **Applies to:** all

### D-05 Making it look fixed instead of fixing it
- **Went wrong:** Problems were hidden by laying one thing over another, cropping, stretching or bending something, instead of fixing the cause. Test limits were raised step by step (waits from 8 to 20 to 25, exemptions added, totals re-pinned) until a regression could pass. On a Duo job the tempting versions are `overflow-x: hidden` on the body to kill sideways scroll, clipping a cut-off control, or widening a test tolerance.
- **Spot it:** new `overflow: hidden`, clipping, `!important`, or a changed test threshold in the diff.
- **Fix:** fix the element that overflows or is covered. Prefer changing the code to changing the test; any moved limit is reported with its old value, new value and why the new behaviour is right.
- **Check:** read the test-file diff line by line; with the fix in place, temporarily remove any new `overflow: hidden` and confirm nothing spills.
- **Applies to:** all

### D-06 Pushed is not live
- **Went wrong:** A push didn't deploy. A server restarted with a bundle built before the commit arrived. A CDN rewrote no-cache into hours of caching, so users kept the old page. A post-deploy screenshot photographed the old interface from an edge cache. 23 of 120 uploaded images returned the homepage HTML with status 200. Unknown API paths returned HTML 200 live but 404 locally. A stale service worker pinned users to the old app, and an open tab on the old bundle overwrote newer server data.
- **Spot it:** "deployed" based on a push, a build, or a status code.
- **Fix:** know how the app really deploys. After deploying, load the public URL the way a user does and match a content-hashed asset name in the live HTML to the local build. Serve the HTML uncached and give any service worker a working update path. Check new or changed assets by content type and size, every file, not a sample. Curl a path that should not exist on the deployed host. Native: the installed build's version matches what you built.
- **Check:** the live bundle hash equals the local build's before any "after" screenshot is taken on the deployed target; a home-screen app is relaunched and shows the new build.
- **Applies to:** all

### D-07 The report says "done" for things only planned, built or partly tested
- **Went wrong:** An owner found the next stage existed only as a plan. "Built", "checking" and "published" blurred until the owner had to ask what was live. "The whole thing holds" came from a test of only its first state. Four evidence files copied the same unverified gap forward. "Not yet run" claims were already false when written.
- **Spot it:** a report whose first lines don't give one state per item.
- **Fix:** open the report with exactly one state per item (live; built, not deployed; planned only, waiting on a named thing). Name a path as working only if that exact path ran end to end in this job. Recheck "not yet" and "still broken" claims against logs or the app at writing time. A green check proves code ran, not that the product works.
- **Check:** read the first lines as the owner would: could they think something exists or works that doesn't?
- **Applies to:** all

### D-08 Tests that write to real data
- **Went wrong:** A live test used a made-up barcode that was a real product and overwrote its saved answer. A test suite inherited the live database path, and a setup DELETE wiped a production queue. A browser suite run against production left eleven fake submissions in a publicly visible queue for two days. A test that changed a shared setting broke other tests. Repeated wrong guesses at a sign-in check locked the owner out.
- **Spot it:** a scenario whose backend is the deployed one; tests running with production environment variables; a QA or proxy setting that quietly points at live; any write with no cleanup step.
- **Fix:** writes happen only against a local throwaway database seeded for the job. Runs against live are GET-only. Test runners refuse to open the live data location. A test that changes shared state puts it back itself. Never poll or fuzz sign-in routes.
- **Check:** before the run, confirm the database URL is local; after it, list writes from the last few minutes on any shared system (expect none).
- **Applies to:** all

### D-09 Automated runs that fire analytics, alerts, paid calls or charges
- **Went wrong:** A site review run as an iPhone-preset browser got past the visit filter and sent four "someone opened the site" texts to the owner. An API write triggered a hosted workflow that would have messaged a customer. A "safe" demo copy with default settings pulled real mail and spent money on paid AI calls at first sign-in. Production on a test payment key means silent zero revenue; a dev run on live keys charges real cards.
- **Spot it:** analytics, visit trackers, paid AI or scan calls, payment keys or outbound messages reachable from the scenario.
- **Fix:** set the project's QA / bot marker (or run on localhost) so analytics drop the session. Mock or cache every paid call. Switch off anything that can spend or send before the first request. Stop before any checkout or charge. Never use live payment keys in a test.
- **Check:** after the run, count analytics sessions and outbound messages it created (must be 0); grep the build for live key prefixes.
- **Applies to:** all

### D-10 Testing or shipping a different copy than the one that runs
- **Went wrong:** Checked-in absolute paths kept pointing at a repo's old location. A build inside the live checkout overwrote the served bundle. Typecheck passed locally while the committed tree failed, because a config file was left out of `git add`. Release docs described one script while the package entry ran another. A renamed app kept its old build target name, so commands written from the new name failed. A build left generated `.js` files beside the source.
- **Spot it:** absolute paths in config; builds run inside a checkout a live service uses; `npm run` or scheme names you haven't followed to what they run.
- **Fix:** record the git revision, how it was built and served, and (native) the SDK, minimum OS and runtime tested. Follow script and scheme names to what they actually run; read the real Xcode scheme and target. Build away from any live checkout. Run checks on the committed tree. Run `git status` after every build and remove only what your build made.
- **Check:** the revision in the report equals `git rev-parse HEAD` of what was tested, and `git status` is clean at the end.
- **Applies to:** all

### D-11 Working from a stale picture of the repo
- **Went wrong:** An agent planned from the session's opening git snapshot while another session had added 20 commits, then told the owner a feature didn't exist after one empty grep. A status note said a feature was missing after it had shipped. A reader reported a file missing that `git ls-files` showed was there. A flow was called a dead end without anyone walking it.
- **Spot it:** "X doesn't exist" or "this can't work" backed by one search or an old note.
- **Fix:** pull and re-read HEAD before planning and before any "X doesn't exist". Try to disprove a negative search a second way (open the exact path, `git log -S`, the running app). Trust the code over a plan's header. Read the app's notes from earlier Duo work, then confirm them against the app before relying on them.
- **Check:** each "not present" claim in the report names two independent ways it was checked.
- **Applies to:** all

### D-12 Tuning layout on production, or publishing without asking
- **Went wrong:** Chasing a 1px seam, three CSS attempts were each deployed and checked live, and a fourth broke every map on the site during a client's review week. None had passed the checks first.
- **Spot it:** more than one deploy in a job; a deploy whose tree hasn't passed the gate.
- **Fix:** iterate on a local dev server or a preview. Deploy only a tree that passed the full gate. Ask the owner before every publish: one yes per publish, never carried over from an earlier one.
- **Check:** before deploying, the gate passed on that exact commit; after deploying, count the key elements on each affected route.
- **Applies to:** all

### D-13 Secrets leaking into logs, captures, commits or trap notes
- **Went wrong:** A live refresh token was tracked in git at two paths. A production database URL landed in an unignored file. Raw exports held dozens of credentials. HTTP debug modes dump Authorization headers. A briefing pointed the next agent at a key that opened the whole back office.
- **Spot it:** HAR files, network captures, simulator logs, `.env` copies or screenshots of settings pages in the working tree; verbose request logging switched on while debugging a web view.
- **Fix:** keep captures in an ignored path. Ignore credential files by pattern before they exist. Scan every commit for secret shapes (report file:line, never print the value). Turn verbose logging back off. Trap drafts and reports carry no keys, hostnames, account IDs or customer data.
- **Check:** `git ls-files` on the capture paths prints nothing; stage a fake token and confirm the commit is refused.
- **Applies to:** all

### D-14 A publish screen offers to drop database tables
- **Went wrong:** A hosted platform's publish step compared the dev and production databases and proposed dropping tables. Once it was because tables had been created directly on production and were missing in dev (one held signed records); once because the dev server had crashed on a missing package and never created its tables. Both were one Approve click away.
- **Spot it:** any DROP or other destructive line in a publish or migration preview.
- **Fix:** approve only additive changes; a DROP for something the code still uses means stop. Start the dev server and confirm its tables exist before publishing. Tables created at run time are also created at startup.
- **Check:** read every line of the migration preview before approving; it has zero DROP lines.
- **Applies to:** web / home-screen / wrapper
