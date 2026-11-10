# 📱📖 make-it-fold

**Your app was built for a phone that doesn't bend. The iPhone Duo bends.**

make-it-fold is a [Claude Code](https://claude.com/claude-code) plugin. Point it at a website or an
iPhone/iPad app, type `/duo`, and it makes the app work on Apple's foldable iPhone: it finds what
breaks, fixes only that, and proves it by folding a simulated Duo back and forth while it watches.

**Jump to:** [Install](#-install) · [Your first job](#-your-first-job) · [The three commands](#%EF%B8%8F-the-three-commands) · [Safety](#%EF%B8%8F-safety) · [Update or remove](#-update-or-remove)

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

## ✅ What the plugin does

When you type `/duo` inside an app's folder, Claude:

1. 🩺 **Checks your Mac** has what it needs (Xcode, the Duo simulator, the fold tool).
2. 🔍 **Scans the code** for patterns that usually break on a Duo. These are suspects, not convictions.
3. 📸 **Takes "before" pictures**, folding the simulator into every position: cover upright, cover
   sideways (both ways), inner upright, inner sideways, and half-open on request.
4. 🔧 **Fixes only what actually failed**, with the smallest change that works. No redesigns.
5. 📸 **Takes "after" pictures**, and checks a normal iPhone isn't worse.
6. 📝 **Reports in plain words**: what changed, what the simulator proved, what only a real phone can
   prove, and the exact step to publish. Then it **asks before publishing**.

"Looks fine, nothing to change" is a perfectly good answer, and it will say so.

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
2. Want to look before anything changes? Type `/duo-shot`. It takes the pictures and lists the
   problems, and changes nothing.
3. Ready for the fix? Type `/duo`.

The first run on an app takes a while: Claude starts your app on your own computer, folds the
simulator through every position, and reads every screenshot. You'll see the **Duo Kit**
simulator open and move by itself. That's normal.

## 🕹️ The three commands

| Command | What it does | Changes your code? |
|---|---|---|
| `/duo` | The whole job: check, fix, prove, report | Yes, only what's broken |
| `/duo-shot` | A photo shoot in every fold position, with a list of problems | No |
| `/duo-setup` | Gets your Mac ready, or tells you what's missing | No |

Results land in your app's `duo/shots/` folder, one dated folder per run: full-size screenshots
(the exact pixel sizes the App Store asks for), small copies for a quick look, and a
`contact.html` page showing every position at a glance. Add `duo/shots/` to your `.gitignore` if
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
| Mac desktop apps | 🏗️ a port, not a tune-up: it gives you an estimate first |

**"Fully tested"** means the plugin ships a practice app of that kind with Duo bugs planted in it
on purpose. A fresh Claude session, told only "optimize this for Duo", has to find and fix every
one, and a second practice run on an already-fixed app has to come back "passes, no changes". The
whole exam reruns with one command whenever the plugin changes. In v0.1.0 all 8 exams pass: the
"already fixed" web exam 4 runs out of 4, the buggy web exam 2 out of 2, and the other six on one
run each. One run is a small sample: it shows the plugin can do the job, not how often. Each run
cost $0.32 to $0.88 of Claude usage.

Two honest limits on that: the exams grade the code fixes and the honesty of the report, and the
simulator folding was checked separately by hand. And the Expo practice app was graded on its
code only. It has not been built and run on the simulator yet.

## 🧪 What it can't prove

The simulator is very good, but it isn't a phone in your hand. It can't tell you how the fold
feels, how the camera behaves, how fast it runs, or what the crease looks like. Split view (two
apps side by side) also only works on a real Duo. The report always lists what still needs a real
phone.

Everything here was measured on the iPhone Duo **simulator** (Xcode 27.2, iOS 27.2). v0.1.0 has
not been run against a real Duo yet.

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
- **Your code is only changed by `/duo`.** The other two commands don't touch it. Commit your work
  first, so every change `/duo` makes shows up as a clean diff you can undo.
- **Apple's docs, live.** The plugin reads Apple's current documentation when it needs it, instead
  of trusting a copy that might be out of date.
- **One outside tool, locked to a version we read.** Folding and tapping the simulator uses
  [duoctl](https://github.com/skarol/duoctl) (MIT). `/duo-setup` installs one exact copy of it,
  the one whose code was read in full, never "whatever is newest".
- **It uses its own simulator.** Everything happens in the one named **Duo Kit**. Your other
  simulators are left alone.

## 🔄 Update or remove

**Update** (in Terminal, then quit and reopen Claude Code):

```
claude plugin marketplace update make-it-fold
claude plugin update make-it-fold@make-it-fold
```

**Remove** (in Terminal):

```
claude plugin uninstall make-it-fold@make-it-fold
claude plugin marketplace remove make-it-fold
```

Removing the plugin leaves three things behind that it created. Delete them if you want a clean
Mac:

- The **Duo Kit** simulator: in Xcode, Window > Devices and Simulators > Simulators, right-click
  Duo Kit > Delete.
- Two small folders in your home folder: `.cache/make-it-fold` and `.cache/duoctl` (the fold tool
  and its notes).
- A `duo/` folder inside each app you ran it on (your screenshots and test steps).

## 🤖 For AI agents reading this

Start with the `make-it-fold` skill (`plugins/make-it-fold/skills/make-it-fold/SKILL.md`). Follow
its job in order, read only the recipe and trap files `duo-scan` names, and never load every file.
Scripts are in `plugins/make-it-fold/scripts/`; each one explains itself with `--help`.

Changing the plugin itself? Read `AGENTS.md` first, and run `dev/check` before you push.

## 🪤 Traps, and how it gets smarter

The plugin carries a notebook of 59 hard-won lessons ("traps"): what went wrong, how to spot it,
the fix, and a check. When a job hits something the notebook didn't warn about, Claude drafts a new
entry. If you hit one, please [open an issue](https://github.com/theJoshLucas/make-it-fold/issues)
with the draft.

## 🙏 Credits

- [duoctl](https://github.com/skarol/duoctl) by Karolina Samorek: folds, rotates and taps the Duo simulator.
- Apple's iPhone Duo documentation, design guidelines and Xcode's `app-resizability` skill.
- The WebKit team's Safari 27.1 notes.

MIT license. Not affiliated with Apple.
