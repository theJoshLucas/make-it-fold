---
name: make-it-fold
description: "Make an app work on Apple's foldable iPhone Duo in one session: scan it, fix only what is actually broken, and prove it in every fold position on the Duo simulator. Use whenever someone says optimize / prepare / fix / test this for the iPhone Duo, the foldable iPhone, folding, the cover screen or the inner screen, or asks whether an app works on the Duo. Handles websites, home-screen web apps, websites inside a native app, native SwiftUI/UIKit iPhone apps, iPad and universal apps, and Expo/React Native (fully tested routes), plus guided routes for Flutter, Capacitor, games and Mac desktop ports."
argument-hint: "[folder or URL, optional]"
---

# make-it-fold

The iPhone Duo folds. Folded, the app runs on a small **cover screen** (466 x 678 points).
Unfolded, the same app, still running, resizes to a big **inner screen** (669 x 951 points).
The status bar and toolbar can sit in a **vertical bar** down one side, and the camera and the
fold line are **reserved regions** content must not need. Everything here follows from that:
**an app on the Duo must survive being resized while someone is using it.**

Scripts live in `${CLAUDE_PLUGIN_ROOT}/scripts/`. Recipes live in
`${CLAUDE_SKILL_DIR}/references/`, traps in `${CLAUDE_SKILL_DIR}/traps/`. Read only the files
this job needs (step 2 tells you which). Never load every file.

## The job, in order

**0. Setup.** Run `${CLAUDE_PLUGIN_ROOT}/scripts/duo-setup`. If it is not ready, say what is
missing in one line each, offer the fixes it prints (`duo-setup --install` is safe; downloads
and macOS or Xcode updates need the person's yes), and continue with what is possible:
without the simulator you can still do the code fixes and desktop-browser checks, labelled as such.
If the simulator tools are *unreachable* (a sandboxed session), say "could not reach the simulator from
this session", never "not installed", and do not ask for the download.

**1. Scan.** Run `${CLAUDE_PLUGIN_ROOT}/scripts/duo-scan <app folder>`. It names the app's
surfaces (web, home-screen, wrapper, native, ipad, expo, ...) and lists suspects. A suspect is
not a bug: you fix it only if a check in step 3 or 5 fails, or the code plainly does what the
trap describes.

**2. Read the route.** Read `references/routes.md` (short) to confirm the route, then exactly
the recipe and trap files the scan named, plus `references/facts.md`. Native routes also use
Apple's own `app-resizability` skill from the person's Xcode (see `references/native.md`).
Apple's docs are read live, never from memory: `references/apple-docs.md` maps which page to
fetch for which problem. If a live Apple page disagrees with a recipe, Apple wins: follow it and
note the stale recipe in the report.

**3. Before.** Get the app running locally (never against live data: `references/scenario.md`)
and run `${CLAUDE_PLUGIN_ROOT}/scripts/duo-shot web --url <local url> --label before` (or
`duo-shot native --bundle <id> --app <path> --label before`). If the app has no
`duo/scenario.json`, write a short one first (`references/scenario.md`): 3 to 6 key screens and
one fold-in-the-middle-of-a-task step. Look at every screenshot, at full size where an issue is
flagged.

**4. Fix.** Fix only what failed or what a trap names exactly. Smallest change that works. Keep
the design: no redesigns, no new features, no "while I'm here" cleanup. Fix the whole class of a
bug (every place, not the one you saw). Native: guard iOS 27.1 APIs with `if #available(iOS 27.1, *)`.

**5. After.** Run the same `duo-shot` with `--label after`, plus a normal-phone check (web: 390 px
desktop browser and the app's desktop width; native: an iPhone 17 Pro simulator on iOS 27 and on
the app's minimum iOS). Up to 3 fix-and-recheck rounds. Still failing after 3: stop and report.

**6. Report** in this exact shape (plain words; the reader may not be an engineer):
- **What changed**: one line per fix, in plain words.
- **Proof, by tier**: what the Duo simulator proved (with the contact sheet path); what a desktop
  browser proved; what only the real phone can prove (feel, camera, crease, real hinge, split view).
- **Still open**: anything that failed, could not be checked, or needs a decision. A design
  question gets the no-behavior-change default applied, and is listed with that default.
- **Publish step**: the exact step to make it live, then ask before doing it. Pushed is not live.

When the job is over, run `${CLAUDE_PLUGIN_ROOT}/scripts/duo-sim shutdown` so the simulator is not
left running (it only shuts down a simulator it booted itself).

**7. Teach the plugin.** If you hit something the traps did not warn about and it cost time,
draft one trap entry (`references/traps-loop.md`) and offer it.

## Hard rules
- "Done" = the scenario passes in every required pose, folding mid-task loses nothing, normal
  phones are no worse, the tested revision is named, evidence is labelled by tier, and nothing
  was changed that did not need changing. "Passes, no changes" is a complete, good answer.
- Never test against live data, real payments, real messages or analytics; never put real
  passwords in a scenario. Never publish without asking.
- Never run `xcrun simctl io ... screenConfig` on the Duo (it crashes the simulator).
- Measure device facts with the probe or duo-shot; do not trust memory or blog posts.
- A framework upgrade (for example an old Expo SDK) is its own job: stop and say so, with an estimate.
