# 📱📖 make-it-fold

**Your app was built for a phone that doesn't bend. The iPhone Duo bends.**

make-it-fold is a [Claude Code](https://claude.com/claude-code) plugin. Point it at a website or an
iPhone/iPad app, type `/duo`, and it makes the app look and work like it was **designed for** Apple's
foldable iPhone: it fixes what breaks, lays out every screen again for the Duo's two screens, and
proves it by folding a simulated Duo back and forth and scoring a picture of every screen.

**Jump to:** [Install](#-install) · [Your first job](#-your-first-job) · [The commands](#%EF%B8%8F-the-commands) · [Safety](#%EF%B8%8F-safety) · [Update or remove](#-update-or-remove)

---

## 🤔 What actually changes on a Duo

Picture a paperback book that is also a phone.

- **Closed**, you use the small screen on the cover: **466 x 678** points, a bit wider and a lot
  shorter than a normal iPhone.
- **Open**, the same app, still running, stretches onto the big inner screen: **669 x 951** points,
  close to a small tablet.

Three things trip apps up:

1. 🔄 **The screen changes size while someone is using the app.** Folding doesn't restart anything.
   If your app only measures the screen once, or rebuilds a form when the size changes, people lose
   what they were typing.
2. 📏 **A bar can run down the side.** The status bar and toolbars sometimes sit in a vertical strip
   on the left or right, not just at the top and bottom. Buttons that hug a side edge can end up
   underneath it.
3. 📷 **Some spots are off limits.** The camera and, when half-open, the fold line are "reserved
   regions": nothing important should live there.

## 🎨 "It fits" is not the goal

An app can survive all of that and still look wrong: a phone layout stretched across the big
screen, buttons as wide as a ruler, a form covering everything. Nothing is cut off, and nobody
would believe it was made for a Duo.

So the plugin aims higher than "nothing broke". Each screen should look **Duo-native**:

- 🤏 **On the cover**, the main thing and the main button are there without scrolling, and the bars
  sit in the side rail where iOS puts them.
- 📖 **On the inner screen**, the app shows *more*, not the same thing bigger: the list beside the
  open item, settings beside the page you picked, a form as a panel instead of a full-width tray.
- 🎭 **It is still your app.** Same colors, fonts, wording and features. An ordinary iPhone sees no
  difference at all.

## ✅ What the plugin does

When you type `/duo` inside an app's folder, Claude:

1. 🩺 **Checks your Mac** has what it needs (Xcode, the Duo simulator, the fold tool).
2. 🍎 **Downloads Apple's current Duo pages** and reads Apple's design rules fresh, every time, so it
   is never working from an old copy. It also reads its own notebook of lessons from earlier jobs.
3. 🔍 **Scans the code** for patterns that usually break on a Duo. These are suspects, not convictions.
4. 📸 **Takes "before" pictures of every screen**, folding the simulator into every position: cover
   upright, cover sideways (both ways), inner upright and inner sideways. It asks whether you also want
   the two half-open positions (book and laptop: they show what sits on the crease, and take a few more
   minutes). It uses your own text size and settings, waits for each screen to stop moving, and retakes
   any picture that comes out blank.
5. 🧐 **A separate judge scores each screen for design**, on the cover and on the inner screen, with
   eight plain questions (does it use the room? does it show more? is the form sized for the screen?)
   and a measured "biggest empty patch" on every picture. The judge sees only the pictures, never the
   code or the plan, so the Claude that built the layout never grades its own work. Each screen gets a
   verdict: **native**, **fits only** or **broken**.
6. 🔧 **Fixes what broke, then builds the Duo layouts** for every screen that is not native yet.
7. 📸 **Takes "after" pictures**, puts them side by side with the "before" ones, has the judge score
   them again, and checks an ordinary iPhone looks exactly as it did. For a website that check draws
   every screen at ordinary iPhone sizes in your Mac's own Safari engine and compares each picture
   with "before", pixel for pixel. Any screen the judge doesn't score native goes back for another
   round, up to three.
8. ✨ **Polishes once**, when every screen passes: it fixes the small things the judge noted (an edge
   that doesn't line up, a gap left empty), then shoots and judges again. If the polish makes anything
   worse, it puts the passing version back.
9. 📝 **Reports in plain words**: what each screen looks like now, the scorecard, what the simulator
   proved, what only a real phone can prove, and the exact step to publish. Then it **asks before
   publishing**.
10. 📓 **Writes down what it learned**, so the next job on your Mac starts smarter.

Only want the safety net? Type `/duo fit`: it fixes what breaks, changes no layouts, and still tells
you how each screen scores.

### 🧠 Which Claude does what

| Part of the job | Model | Why |
|---|---|---|
| The job itself: reading, planning, building | The newest **Opus**, high effort | The hard part |
| Taking the pictures (the `duo-shooter` helper) | The newest **Sonnet** | It only runs one command. In a test of 2 runs each, Haiku came out cheaper per word but wandered off the instructions both times; Sonnet followed them both times |
| Scoring the pictures (the `duo-judge` helper) | The newest **Fable**, low effort, or **Opus** | A different Claude from the builder, shown only the pictures, one screen at a time. Its bar is Apple's own apps: it scores Apple's Settings, Photos and Maps native |

At the start of each job the plugin reads Anthropic's live list of models and checks which model
each name ("opus", "sonnet", "fable") points to in your Claude Code. If your Claude Code is behind,
it tells you and **asks before updating**; it never updates anything by itself.

Before your first job it asks once whether the judge may run on Fable. On some plans Fable bills
**usage credits**, which is money on top of your plan; say no and the judge runs on Opus. When Fable
isn't available (a usage limit, or no Fable on your plan), the judge runs on Opus for that job and the
report says so. If you answer a question in the middle of a job, Claude Code goes back to your own
model; type `/duo continue` to put the job back on Opus.

## 🚀 Install

It takes about five minutes, plus one big download if you don't have the Duo simulator yet.

### What you need first

| You need | How to check | If you don't have it |
|---|---|---|
| A Mac on **macOS 26.6 or newer** | Apple menu (top-left corner) > About This Mac | System Settings > General > Software Update |
| **Xcode 27.1 or newer** | Open Xcode, then Xcode menu > About Xcode | Free in the Mac App Store. Open it once after installing so it can finish setting up. |
| **Claude Code** | You can open it and chat | [Get it here](https://claude.com/claude-code) |
| Room for the **iPhone Duo simulator** (several GB) | Don't check, step 4 does it for you | Step 4 offers the download |

No Xcode? You can still install. See [Without Xcode](#without-xcode) below.

### The steps

Open Claude Code (the desktop app, or type `claude` in Terminal). Type each line below into the
message box, the same place you'd type a question, and press Return after each one.

**1. Tell Claude Code where the plugin lives.**

```
/plugin marketplace add theJoshLucas/make-it-fold
```

**2. Install it.** The name appears twice on purpose: the plugin, then the shelf it came from.

```
/plugin install make-it-fold@make-it-fold
```

**3. Quit Claude Code and open it again**, so the new commands load.

**4. Check your Mac.**

```
/duo-setup
```

You get a checklist like this one (shortened here):

```
  OK  macOS 26.6 or newer (Xcode 27.1+ needs it): 26.6.1
  OK  Xcode 27.1 or newer: 27.2
  NO  iPhone Duo simulator runtime: missing
       fix: Download it (several GB) ...
  OK  duoctl (fold, rotate, tap) at the reviewed version: c6ff3e961a ...
  NO  'Duo Kit' simulator: not created
       fix: Run: duo-setup --install ...

Not ready yet. ...
```

- **OK** means that piece is ready.
- **NO** comes with its fix. Small things Claude sets up itself: the fold tool, and a simulator
  named **Duo Kit**. Big things it explains and waits for your yes: the simulator download
  (several GB), a macOS update, an Xcode update. macOS and Xcode updates ask for your Mac password,
  so those two are yours to do.

When the last line says **Ready for Duo simulator jobs**, you're done.

<details>
<summary>Slash commands not working? Use Terminal instead.</summary>

Steps 1 and 2 also work as regular Terminal commands:

```
claude plugin marketplace add theJoshLucas/make-it-fold
claude plugin install make-it-fold@make-it-fold
```

Then open Claude Code and carry on from step 4.
</details>

### Without Xcode

The plugin still scans and fixes web apps, and Claude can check them at Duo sizes in a regular
desktop browser. It can't fold a simulator, so the report labels those checks "desktop browser
only" and lists what was left unproven.

## 🎬 Your first job

1. Open Claude Code **in your app's folder**. In Terminal: `cd` into the folder, then `claude`.
   In the desktop app: pick that folder when you start a session.
2. Want to look before anything changes? Type `/duo-shot`. It takes the pictures, lists the
   problems and scores every screen, and changes nothing.
3. Ready for the real thing? Type `/duo`.

The first run on an app takes a while: Claude starts your app on your own computer, folds the
simulator through every position, and reads every screenshot. You'll see the **Duo Kit**
simulator open and move by itself. That's normal.

## 🕹️ The commands

| Command | What it does | Changes your code? |
|---|---|---|
| `/duo` | The whole job: make this app Duo-native, and prove it | Yes: fixes and new layouts |
| `/duo fit` | Only fix what breaks. No layout changes | Yes, only what's broken |
| `/duo-new` | Start a brand-new app designed for the Duo from the first screen | It writes the new app |
| `/duo-shot` | A photo shoot of every screen in every fold position, each scored for fit and design | No |
| `/duo-setup` | Gets your Mac ready, or tells you what's missing | No |

Results land in your app's `duo/shots/` folder, one dated folder per run: full-size screenshots
(the exact pixel sizes the App Store asks for), small copies for a quick look, a `contact.html`
page showing every position at a glance, a `review.md` scorecard, and after a fix a `compare.html`
page with before and after side by side. Websites also get `phone-before` and `phone-after` folders
from the ordinary-iPhone check. Add `duo/shots/` to your `.gitignore` if
you don't want the pictures saved with your code.

## 🧭 What kinds of apps

| | Status |
|---|---|
| Websites and web apps (Safari) | ✅ fully tested |
| Home-screen web apps | ✅ fully tested |
| A website inside an iPhone app | ✅ fully tested |
| Native iPhone apps (SwiftUI, UIKit) | ✅ fully tested |
| iPad and universal apps | ✅ fully tested |
| Expo / React Native | ✅ fully tested, code only (needs Expo SDK 58 or newer) |
| Flutter, Capacitor, games | 🧭 guided, less proven |
| A brand-new app (`/duo-new`) | 🧭 guided, less proven |
| Mac desktop apps | 🏗️ a port, not a tune-up: it gives you an estimate first |

**"Fully tested"** means the plugin ships a practice app of that kind, and a fresh Claude session,
told only "optimize this for Duo", has to pass an exam on it. There are 9 exams:

- 🐛 **Six apps with Duo bugs planted on purpose.** Every bug has to be found and fixed, and the app
  has to keep its own colors and wording.
- 🎨 **One app with nothing broken** that is a phone layout stretched across the big screen. The
  right answer is a Duo layout: the list beside the open item, a form that is not a full-width
  tray, and a phone layout left exactly as it was.
- 🧘 **One already-fixed app, given as a "fit only" job.** The right answer is "passes, no changes".
- 🚧 **One app on an Expo version too old for the Duo.** The right answer is to stop and say so.

The whole exam reruns with one command whenever the plugin changes. In v0.2.0 all 9 pass on their
latest runs (three of them twice in a row). It took three rounds to get there: the first full run
passed 5 of 9, and each miss changed the plugin's instructions. One or two runs is a small sample:
it shows the plugin can do the job, not how often. Each run cost $0.44 to $1.60 of Claude usage.

Three honest limits on that:

- The exam sessions run in a locked-down sandbox that cannot reach the simulator, so they grade
  the code and the honesty of the report. A layout nobody has seen is reported as "built, not
  seen", never "native".
- What "native" looks like was checked separately, by hand, on the Duo simulator: the web and
  native practice answers were photographed in all 7 positions with a task in progress, before
  and after, and judged from the pictures.
- The Expo practice app was graded on its code only. It has not been built and run on the
  simulator yet.

## 🧪 What it can't prove

The simulator is very good, but it isn't a phone in your hand. It can't tell you how the fold
feels, how the camera behaves, how fast it runs, or what the crease looks like. Split view (two
apps side by side) also only works on a real Duo. The report always lists what still needs a real
phone.

Everything here was measured on the iPhone Duo **simulator** (Xcode 27.2, iOS 27.2). The plugin's
own checks have not been run against a real Duo yet.

📏 **Got a real Duo?** Open [thejoshlucas.github.io/make-it-fold](https://thejoshlucas.github.io/make-it-fold/)
in Safari, then fold, unfold and turn the phone. The page checks each position against the simulator's
numbers. If anything is different, tap **Share results** and
[post them in an issue](https://github.com/theJoshLucas/make-it-fold/issues), so the plugin can be corrected.

## 🛡️ Safety

- **Your live data stays out of it.** Claude is told to run your app on your own computer with
  made-up data, and to fake or skip payments, emails, messages and paid AI calls. The screenshot
  tool backs that up: it refuses any web address that isn't on your own computer. (It can be told to
  look at one public page, and then it leaves your logins behind.)
- **Asks before publishing.** Every time.
- **Never updates anything on your Mac by itself.** Not Claude Code, not Xcode, not macOS: it says
  what is out of date and asks.
- **Your code is only changed by `/duo`** (and `/duo-new`, which writes a new app). `/duo-shot` and
  `/duo-setup` don't touch it. Commit your work first, so every change `/duo` makes shows up as a
  clean diff you can undo.
- **It redesigns the layout, not your brand.** Colors, fonts, wording and features stay. The new
  layouts only switch on at Duo sizes, and the job checks an ordinary iPhone still looks the same.
- **Apple's docs, fresh every run.** At the start of every job the plugin downloads Apple's current
  Duo pages (only from developer.apple.com) and reads Apple's design rules again. If Apple's page
  and the plugin's own notes disagree, Apple wins.
- **One outside tool, locked to a version we read.** Folding and tapping the simulator uses
  [duoctl](https://github.com/skarol/duoctl) (MIT). `/duo-setup` installs one exact copy of it,
  the one whose code was read in full, never "whatever is newest".
- **It uses its own simulator.** Everything happens in the one named **Duo Kit**. Your other
  simulators are left alone.

## 🔄 Update or remove

**Get updates by themselves** (do this once): in Claude Code type `/plugin`, go to
**Marketplaces**, pick **make-it-fold**, and choose **Enable auto-update**. Claude Code turns this
off by default for plugins that don't come from Anthropic, so nothing updates until you switch it on.
After that, new versions arrive on their own the next time you open Claude Code.

**Update by hand** (in Terminal, then quit and reopen Claude Code):

```
claude plugin marketplace update make-it-fold
claude plugin update make-it-fold@make-it-fold
```

Not sure if you're behind? `/duo-setup` tells you when a newer version is out.

**Remove** (in Terminal):

```
claude plugin uninstall make-it-fold@make-it-fold
claude plugin marketplace remove make-it-fold
```

Removing the plugin leaves three things behind that it created. Delete them if you want a clean
Mac:

- The **Duo Kit** simulator: in Xcode, Window > Devices and Simulators > Simulators, right-click
  Duo Kit > Delete.
- Three small folders in your home folder: `.cache/make-it-fold` and `.cache/duoctl` (the fold tool
  and saved copies of Apple's pages), and `.config/make-it-fold` (the notebook of lessons).
- A `duo/` folder inside each app you ran it on (your screenshots and test steps).

## 🤖 For AI agents reading this

Start with the `make-it-fold` skill (`plugins/make-it-fold/skills/make-it-fold/SKILL.md`). Follow
its job in order, read only the recipe and trap files `duo-scan` names (plus `references/design.md`
and `traps/design.md`, which every job reads), and never load every file. "Nothing is cut off" is
not done: every screen needs a design verdict from the duo-judge agent, which sees only the pictures.
You never score layouts you built.
Scripts are in `plugins/make-it-fold/scripts/`; each one explains itself with `--help`.

Changing the plugin itself? Read `AGENTS.md` first, and run `dev/check` before you push.

## 🪤 Traps, and how it gets smarter

The plugin learns in three ways:

- 🍎 **From Apple, every run.** It downloads Apple's current Duo pages at the start of each job and
  notices when Apple has changed one or added a new one. Every rule the plugin credits to Apple
  carries Apple's exact words, and each run checks those words are still on Apple's pages, so a rule
  the plugin made up can't pass itself off as Apple's.
- 📓 **From your own jobs.** When a job hits something new, Claude writes the lesson into a notebook
  on your Mac (`~/.config/make-it-fold/notebook.md`) without being asked, and reads that notebook
  at the start of the next job. It survives plugin updates.
- 🪤 **From everyone.** The plugin ships with 79 hard-won lessons ("traps"): what went wrong, how to
  spot it, the fix, and a check. Fifteen of them are about design: the ways an app can fit and
  still look wrong. After saving a lesson, Claude offers to send it here as
  [an issue](https://github.com/theJoshLucas/make-it-fold/issues) (it asks first), so the next
  version can teach it to everyone.

## 🙏 Credits

- [duoctl](https://github.com/skarol/duoctl) by Karolina Samorek: folds, rotates and taps the Duo simulator.
- Apple's iPhone Duo documentation, design guidelines and Xcode's `app-resizability` skill.
- The WebKit team's Safari 27.1 notes.

MIT license. Not affiliated with Apple.
