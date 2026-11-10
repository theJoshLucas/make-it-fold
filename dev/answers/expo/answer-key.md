# Answer key: practice/expo (Pocket Chores on Expo SDK 58, Expo Router)

Planted Duo bugs. The practice folder never contains this file, so the agent under test can't
read it. Graders in `case.yaml` check each one. The app is a source tree only (no `node_modules`,
nothing installed), on `"expo": "~58.0.0"`, so the version gate in `references/expo.md` passes
and the job is the layout work. The agent cannot run a native build in the eval; a correct
report says so instead of claiming Duo proof.

Versions in `package.json` come from Expo's own `bundledNativeModules.json` on the `sdk-58`
branch of the Expo repository (react-native 0.88.1, react 19.3.0, expo-router ~58.0.30,
react-native-safe-area-context ~5.11.1, react-native-screens ~4.30.1). `expo` itself is the range
the SDK 58 changelog gives (`expo@^58.0.0`).

| # | Bug | Where | What fixed looks like |
|---|---|---|---|
| X1 | Custom JavaScript bottom tab bar (`TabBar`, a row of `Pressable`s) stays where it was drawn and collides with the Duo's vertical rail | `app/_layout.tsx` | Expo Router `NativeTabs` (system draws the bar, moves it into the rail). If the agent judges that too big, it must pad the custom bar on all four sides AND list it under "still open" |
| X2 | `Dimensions.get("screen")` read once at module load; rows are sized `SCREEN_WIDTH - 32`, which is the cover width (466) even on the inner screen | `app/index.tsx` | `useWindowDimensions()` or no pixel width at all (rows stretch with the container) |
| X3 | Safe areas used for top and bottom only: `edges={["top", "bottom"]}`; the 84 pt rail inset on the left (or right) is never respected | `app/_layout.tsx` | left and right handled too (`edges` with all four sides, or `useSafeAreaInsets()` with left/right padding), or the system handles it through `NativeTabs`/native navigation |
| X4 | The New screen switches between `CompactForm` and `WideForm` at 600 pt; each owns its own `useState`, so a fold remounts and erases typed text | `app/new.tsx` | form state lives above the switch (in `NewChore`, or a shared hook/context) and is passed down |
| X5 | `"orientation": "portrait"` in `app.json`: the inner display ignores it, and nothing in the app was ever built for landscape | `app.json` | lock removed (or changed to `default`), and the screens verified or fixed to work in landscape |

A correct run also: reports per tier (what code reading proved, what a native build on the Duo
simulator would prove, what needs the phone), does not redesign the app, does not upgrade or
downgrade dependencies, and does not invent bugs outside this list. `NativeTabs` is imported from
Expo Router; the exact import path is read from the SDK 58 docs, not from memory.
