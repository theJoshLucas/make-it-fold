---
name: make-it-fold
description: "Make an app look and work like it was designed for Apple's foldable iPhone Duo. Converts an iPhone, iPad or web app so every screen is laid out for the small outer display and the big inner display (keeping the app's own look), or starts a new Duo app from scratch. Fixes what breaks, redesigns the layouts, and proves it with pictures of every screen in every pose on the Duo simulator, each scored for design. Reads Apple's current Duo documentation on every run. Use whenever someone says optimize / convert / redesign / prepare / fix / test this for the iPhone Duo, the foldable iPhone, folding, the outer display (or 'cover screen') or the inner display, a pose (book, laptop, tent), asks whether an app works or looks right on the Duo, or wants a new app built for it. Handles websites, home-screen web apps, web views in native apps, SwiftUI/UIKit, iPad and universal apps, Expo/React Native, and guided routes for Flutter, Capacitor, games and Mac ports."
argument-hint: "[folder or URL] [fit] [continue]"
model: opus
effort: high
---

# make-it-fold

The iPhone Duo folds. Folded, the app runs on a small **outer display** (466 x 678 points).
Unfolded, the same app, still running, resizes to a big **inner display** (669 x 951 points).
Toolbars and tab bars can sit in the **vertical bar** down one side, and the cameras and the fold are
**reserved regions** content must not need.

**Words.** Use Apple's, and read the person's through them (`references/words.md` has the full list).
A **display** is the glass (outer, inner); a **screen** is a page of the app. Apple's poses: closed,
tent, open wide, book, open tall, laptop; the fold states are closed, partially open and open. If the
person says "cover" they mean the outer display; "sidebar" to Apple is the list column of a split view,
not the vertical bar; "split view" is one app's two panes, "Split View multitasking" is two apps.

Two bars to clear, in this order:
- **It fits (the floor).** Nothing is cut off, covered or lost in any pose, and folding in the
  middle of a task loses nothing.
- **It is native (the goal).** Each screen is laid out for the display it is on: the outer display gets a
  layout built for wide-and-short, the inner display shows more of the app at once. Someone opening
  it on a Duo believes it was designed for a Duo.

**"It fits" is not done.** A phone layout stretched across the inner display passes every fit check
and is the exact failure this plugin exists to prevent.

## Which job
- **Native (the default).** "Optimize / convert / redesign / make this work for the Duo", or `/duo`.
- **Fit only.** Only when the person says so in words ("just make sure nothing breaks", "don't
  change the design", `/duo fit`). Skip step 4's layout plan, build no new layouts, skip the polish round, and do not
  read `traps/design.md`. Change the code only for a must-do item, a failed check, or code that
  plainly does what a fit trap describes: with none of those, the right answer is "passes, no
  changes". Still score each screen in step 6 and say what a native job would change.
- **New app.** Nothing to convert yet: follow `references/new-app.md`, then steps 3 to 8.

Scripts live in `${CLAUDE_PLUGIN_ROOT}/scripts/` (each explains itself with `--help`). Recipes live
in `${CLAUDE_SKILL_DIR}/references/`, traps in `${CLAUDE_SKILL_DIR}/traps/`. Read only the files
this job needs (step 2 says which).

**Three parts, three models.** You are the builder: the newest Opus at high effort (this skill sets it
for the turn; after the person replies mid-job, `/duo continue` puts it back). Pictures are taken by the
**duo-shooter** agent (the newest Sonnet), which only runs the duo-shot command you give it. Design
verdicts come from the **duo-judge** agent (the newest Fable at low effort, or Opus), which sees only
the pictures. **You never score your own layouts** (trap D-15).

## The job, in order

**0. Setup, and fresh knowledge. Every run.**
- `${CLAUDE_PLUGIN_ROOT}/scripts/duo-setup`. Not ready: say what is missing in one line each, offer
  the fixes it prints (`duo-setup --install` is safe; downloads and macOS or Xcode updates need the
  person's yes), and continue with what is possible, labelled as such. Simulator tools
  *unreachable* (a sandboxed session): say "could not reach the simulator from this session", never
  "not installed". If it says a newer make-it-fold exists, tell the person the update line it prints.
- `${CLAUDE_PLUGIN_ROOT}/scripts/duo-docs`. It downloads Apple's current Duo pages and says which
  have changed. Read every page it marks **READ**, from the path it prints. Apple's pages beat this
  plugin's recipes: follow Apple and say in the report which recipe was stale.
- `${CLAUDE_PLUGIN_ROOT}/scripts/duo-docs` also checks that every rule the design guide credits to
  Apple is in Apple's own words on Apple's pages. A quote it lists as missing is the plugin's rule, not
  Apple's: never tell the person "Apple says" it.
- `${CLAUDE_PLUGIN_ROOT}/scripts/duo-models`. It reads Anthropic's live model list and checks what
  this Claude Code maps "opus", "sonnet" and "fable" to. **behind**: tell the person in one line and ask
  whether to update Claude Code; never update without a yes, and carry on with what is there. Judge
  **not chosen yet**: ask once whether the judge may run on Fable (on some plans Fable bills usage
  credits, which is money past the plan), then `duo-models judge fable` or `duo-models judge opus`.
  Judge **unavailable** (a usage limit, no Fable access): use the duo-judge agent with model "opus"
  this run and say so in the report.
- `${CLAUDE_PLUGIN_ROOT}/scripts/duo-notes show`. This computer's own notebook of lessons from
  earlier Duo jobs. Also read the app's `duo/notes.md` if it has one.

**1. Scan.** `${CLAUDE_PLUGIN_ROOT}/scripts/duo-scan <app folder>` names the app's surfaces and
lists three things. **Must-do** items are Apple's requirements that no picture can show: always do
them. **Suspects** are not bugs yet: you fix one if a check fails or the code plainly does what
the trap describes. **Design hints** say where the inner display will get a stretched phone.

**2. Read the route.** `references/routes.md` (short), then exactly the recipe and trap files the
scan named, plus `references/facts.md`, `references/design.md` and (not for a fit-only job)
`traps/design.md`. Native routes
also use Apple's own `app-resizability` skill from the person's Xcode (`references/native.md`).
Read the app's own design rules if it has any (`DESIGN.md`, a style guide, design tokens).

**3. Before.** List **every screen** the app has: tabs, pushed pages, sheets, forms, menus, empty
and full states. Put them in `duo/scenario.json` (`references/scenario.md`) with one
fold-in-the-middle-of-a-task step. **Shoot what the owner sees** (trap T-20): find out, or ask, the
owner's text size and any set-up the app remembers (who is signed in, a first-run question already
answered), put them in the scenario's `defaults` (native) or the app's own state (web), and seed a
realistic amount of made-up data. **Ask the person once** whether to also photograph the three
partially open poses: book (inner display in landscape, bent like a book), laptop (inner display in
portrait, bent like a laptop) and tent (opened partway from closed and stood on its edges, outer display
in landscape). Book and laptop are the only pictures that show what sits on the fold; tent shows the app
keeps its outer-display layout with the hinge part open. They add about three folds plus a few seconds a
screen (say the minutes for this app). Write the answer in `duo/notes.md` for
next time; never skip them without asking. Run the app locally, never against live data. While the code
is still untouched, take the normal-phone "before" pictures yourself (seconds, no Duo simulator): web,
`duo-shot phone --url <local url> --scenario duo/scenario.json --label phone-before`; native, every screen
in portrait on an iPhone 17 Pro simulator on iOS 27 (status bar fixed first with `xcrun simctl status_bar <udid>
override --time 9:41 --batteryState charged --batteryLevel 100`), saved with `xcrun simctl io <udid> screenshot`.
Already changed the code? Take them from a `git worktree` of the starting commit. Then hand the
duo-shooter agent (`make-it-fold:duo-shooter`) the exact command:
`duo-shot web --url <local url> --scenario duo/scenario.json --label before` or
`duo-shot native --bundle <id> --app <path> --scenario duo/scenario.json --label before`
with full paths and `--poses` set to the poses agreed above. It runs the command in the background
and waits for it to finish. Its answer is duo-shot's `RESULT` line: every name under `blank` or `moving` gets
looked at before anything is judged. Run nothing else on the simulator while it shoots.

**4. The judge scores, then you plan.** `duo-shot` writes a `review.md` beside the pictures, with the
biggest empty patch measured on each one. Call the duo-judge agent (`make-it-fold:duo-judge`; model
"opus" if step 0 said the judge is unavailable) **once per screen**, several at a time: one agent
holding every picture of a big app stops seeing the early ones. Hand each call only these: the run
folder, the one screen to judge (its `## ` heading in `review.md`), the path to
`${CLAUDE_SKILL_DIR}/references/design.md`, the owner's settings, one sentence on what the app is
for, and any design choices the owner made before this job, quoted from the app's own design rules as
they were before you started (never something this job decided). Never your plan, your code or your
opinion of the screens. Each call writes `judge/<screen>.md`: the eight answers for the outer display and the
inner display, a verdict (**native**, **fits only**, **broken** or **unsure**) and the three worst things.
Then `duo-shot verdicts <run folder>` gathers them into `judge.md` and names any screen with no verdict
or an **unsure** one: judge those again (unsure is never a pass). Those verdicts are final: you may add
a line saying you disagree, never change one. (No simulator in this session: write the scorecard in
`duo/review.md` from the code yourself, every verdict **built, not seen**.) Then write the layout plan,
one line per screen that is not native: what it becomes on the outer display, on the inner display in
landscape (open wide, what an opening phone shows first) and in portrait (open tall), using the patterns table.
Show the person the plan in a few lines and keep going; stop for a yes only if the plan would
remove or rename something they use.

**5. Build.** Fit fixes first. A fit fix needs one of three things behind it: it is a must-do item
from the scan, a check failed, or the code plainly does what a trap describes (then fix the whole
class, every place). A worry you could not reproduce ("might", "could", "with more data") goes
under Still open and is never built (trap D-01). No simulator is not a reason to skip a must-do
item, and not a licence to fix guesses. Then the
layouts in the plan, using the route file's "duo-native layout" section. Rules: the app keeps its
own colors, fonts, wording, components and features; one screen and one state with two
arrangements, never two copies; the new layouts switch on only when the space is both wide and
tall, so an ordinary iPhone looks exactly as before, in portrait and landscape; no new features and no
unrelated clean-up. Phones keep their look, not their bugs: a rule that picks a layout by
orientation, device type or screen size is still replaced, with a width rule that gives phones
the same result. Native: guard iOS 27.1 APIs with `if #available(iOS 27.1, *)`.

**6. After.** The duo-shooter agent runs the same `duo-shot` with `--label after`, in the same poses
as "before" (book, laptop and tent too if the person said yes); then `duo-shot compare <before folder> <after folder>` for the side-by-side
page. The duo-judge agent scores the new run, one call per screen, the same way as in step 4. Then the
normal-phone check, the same way as "before". Web: `duo-shot phone ... --label phone-after`, then
`duo-shot compare <phone-before folder> <phone-after folder>`: every phone picture must come out **same**
(exit 0). A **CHANGED** one means the new layout reaches an ordinary iPhone: fix it (`diff/` marks the
changed pixels in red). The desktop window follows `references/web.md`. Native: the same screens in portrait
again, each checked with `duo-shot diff <before.png> <after.png>` (must say "same"), and on the app's
minimum iOS too. Landscape only if this session has a way to turn that simulator (no command-line tool
turns an ordinary iPhone): otherwise write "ordinary iPhone in landscape: not checked" under Still open.
Then fix: every screen the judge did not score native goes back to step 5 with the judge's "no" answers and its
three worst things as the list to fix, and the round repeats (build, shoot, judge, phone check). Up to 3
rounds. Still not native after 3: stop and report what is left.

**Then polish, once, when every screen is native.** The judge's minors and three worst things are a to-do
list too: an edge that does not line up, a gap left empty, a control far wider than what it holds. Save
the all-native version first (a commit, or a copy), then write the list, one line per item. Take every
item: fix it within step 5's rules, or skip it if it would add a feature, change the app's colors, fonts
or wording, or go against an owner's design choice, and say why. Keep the fixes separate, so each can be
undone alone. Before the shoot, look at every screen a fix touched and undo any fix that did not do what
you meant (web: `duo-shot phone --sizes duo` draws the Duo's four flat sizes in seconds; native: one
`duo-sim shot` of that screen in that pose). That look checks your own change; it never scores a screen.
Then shoot, judge every screen and run the normal-phone check. A screen that is no longer native, or a
phone picture that changed: undo the fixes behind it, keep the others, and shoot, judge and check once
more. Still not all native, or the phones still not the same: put the saved version back. Every item not
kept goes under Still open. That is the whole polish: never a second polish round. Nothing on the list:
skip it and say so.

**7. Report** in this exact shape (plain words; the reader may not be an engineer):
- **What changed**: one line per screen (how it is laid out now on each display), then one line
  per fit fix.
- **Scorecard**: every screen with the judge's before, after and after-polish verdicts, copied from the
  `judge.md` files word for word, which model judged, the path to `compare.html`, the polish items
  fixed and the ones left (with why), and the normal-phone result (same, or what changed).
- **Proof, by tier**: what the Duo simulator proved; what a desktop browser proved; what was only
  read in code; what only the real phone can prove (feel, camera, the fold's look, real hinge, Split View multitasking).
- **Still open**: anything not native, failed, unchecked, or needing a decision.
- **Publish step**: the exact step to make it live, then ask before doing it. Pushed is not live.

Then run `${CLAUDE_PLUGIN_ROOT}/scripts/duo-sim shutdown` (it only shuts down a simulator it
booted itself).

**8. Learn.** If anything bit that the traps and the notebook did not warn about, or a layout
choice worked well, save it now with `duo-notes add` (`references/traps-loop.md`). Do not ask
first: the notebook stays on this computer. Then offer to send the lesson to the plugin's
maintainers so every user gets it.

## Hard rules
- "Done" = every screen is **native** on both displays (or listed under Still open with the reason),
  the scenario passes in every required pose, folding mid-task loses nothing, ordinary phones look
  as before (the normal-phone pictures compare the same), the tested revision is named, and evidence is labelled by tier. For a fit-only job,
  "passes, no changes" is a complete, good answer.
- Design verdicts come from the duo-judge agent, from pictures taken in this job at the owner's
  settings. Never write, soften or "correct" a verdict yourself. With no simulator and no browser,
  still do the design work, but the verdict is **built, not seen** (never "native"), and the report
  says the design was read from code only.
- Never update Claude Code, Xcode, macOS or anything else on the person's computer without their yes.
- Never test against live data, real payments, real messages or analytics; never put real
  passwords in a scenario. Never publish without asking.
- Never run `xcrun simctl io ... screenConfig` on the Duo (it crashes the simulator).
- Measure device facts with the probe or duo-shot; do not trust memory or blog posts.
- A framework upgrade (for example an old Expo SDK) is its own job: stop and say so, with an estimate.
