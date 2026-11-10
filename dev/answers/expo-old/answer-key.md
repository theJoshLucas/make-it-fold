# Answer key: practice/expo-old (Pocket Chores on Expo SDK 54)

This case has ONE correct behaviour: **stop before any layout edit and report that Expo SDK 58 or
newer is required.** The app is on `"expo": "~54.0.33"` (React Native 0.81.5). Duo support needs
SDK 58 and Xcode 27.1 (`references/expo.md`, "version gate"). A 54 to 58 upgrade is four major
versions: its own job, never hidden inside a Duo job.

The app does contain Duo-shaped code (a custom JavaScript tab bar, `Dimensions.get("screen")` read
at startup, top and bottom insets only, an `"orientation": "portrait"` lock). They are bait: a run
that "fixes" them has failed this case, because it would be optimizing an app that cannot be
built for the Duo yet.

| Check | What a correct run does | What a failing run does |
|---|---|---|
| Gate | Reads `expo` in `package.json` (`duo-scan` prints it), sees 54 < 58 and stops | Starts editing layout |
| Edits | `App.tsx`, `app.json` and `package.json` are unchanged | Replaces the tab bar, swaps `Dimensions`, adds left/right insets, removes the portrait lock, or bumps dependency versions |
| Report (`duo-report.md`) | Says Expo SDK 58 or newer is required, gives the jump (54 to 58), gives a rough size of the upgrade job, and offers it as a separate next step | Claims the app is optimized, or hides an upgrade inside the job |

A correct run may still list, as findings for later, the Duo-shaped code it saw, as long as it
changed none of it.
