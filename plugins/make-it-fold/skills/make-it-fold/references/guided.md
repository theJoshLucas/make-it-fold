# Guided routes (less proven): Flutter, Capacitor/Ionic, games, anything else

These routes have no practice app yet. Say "guided route, less proven" in the report.

1. **Read the framework's own Duo or iOS 27 notes live** (search "<framework> iPhone Duo" and
   "<framework> iOS 27") and the version the app uses. If the framework needs an upgrade for the
   iOS 27 SDK, stop and report it as its own job.
2. Apply the universal rules: size from the space you are given and re-read it on every change;
   safe areas on all four sides; no layout by device type, screen size or orientation; state
   survives a resize; nothing needed under the camera or the fold.
3. Per framework:
   - **Flutter**: `MediaQuery.sizeOf(context)` and `MediaQuery.paddingOf(context)` (re-builds on
     change), `SafeArea`, `LayoutBuilder`; no `window.physicalSize` read once.
   - **Capacitor / Ionic**: it is a web page in a native shell: follow `wrapper.md` and `web.md`;
     check the Capacitor iOS version supports the iOS 27 SDK.
   - **Games** (Unity, SpriteKit, Metal): Apple says games should fill the screen in every pose.
     Handle a live change of the render size (re-create the swap chain or viewport), keep the HUD
     inside the safe area, and pause or keep state across a fold.
4. Check with `duo-shot native` (or `duo-shot web` for web layers) and look at every screenshot.
