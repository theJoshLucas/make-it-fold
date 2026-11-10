# Expo / React Native route

Read Expo's live guide first: https://expo.dev/blog/supporting-iphone-duo (and the Expo SDK 58
changelog). The summary below was true on 2026-11-09; the live page wins.

## version gate (do this first)
- Duo support needs **Expo SDK 58 or newer** and **Xcode 27.1 or newer**. Check `expo` in
  `package.json` (duo-scan prints it).
- Below SDK 58: stop. Report "needs an Expo SDK upgrade first", with the version jump (for example
  54 to 58 is four major versions) and a rough size of the job. An upgrade is its own job, never
  hidden inside a Duo job.
- Bare React Native without Expo: needs a React Native version built against the iOS 27 SDK; read
  that version's release notes live, and treat the route as guided.

## checks
- Test with the app's **own native build** (`npx expo run:ios --device "Duo Kit"`, or a
  development build), never Expo Go: Expo Go does not behave like the shipped app on the Duo.
- `duo-shot native --bundle <id> --label before|after`, then look at every screenshot.

## what to fix
- **Navigation: let iOS draw it.** Expo Router's `Stack` and `NativeTabs` use the system's bars, which
  move into the Duo's vertical rail by themselves. **Custom JavaScript headers or tab bars do not**:
  they stay where they were drawn and collide with the rail. Prefer moving to the native
  navigators; if that is too big, pad them with the safe area on all sides and list it as open.
- **Safe areas on all four sides**: wrap screens with `react-native-safe-area-context`
  (`SafeAreaView` / `useSafeAreaInsets`) and use the left and right insets, not just top and bottom.
- **Sizes from the window, live**: `useWindowDimensions()` (re-renders on change), never
  `Dimensions.get("screen")` or values read once at startup.
- **State survives a fold**: changing layout must not remount screens or reset form state. Keep
  state above the layout switch.
- **Orientation lock**: `"orientation": "portrait"` in `app.json` is ignored on the inner display.
  Layouts must work in landscape there. Keep the lock unless the person asks (removing it changes
  ordinary iPhones too) and say so in the report.
- Split layouts: Expo Router's `<SplitView>` or `<ArrangementView>` (SDK 58) for list-plus-detail on
  the inner screen. Optional, only where it clearly helps.
