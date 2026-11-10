# iPad and universal apps

An iPad app already has big-screen layouts, which is exactly what the Duo's inner screen wants.
The catch: **the Duo is an iPhone.** Any code that asks "am I an iPad?" answers no, so the iPad
layout never appears on the inner screen.

1. **iPad-only app** (`TARGETED_DEVICE_FAMILY = 2`): it does not run on an iPhone at all. Adding
   iPhone (`1,2`) is a product decision: say so, and make sure the compact layouts exist before
   turning it on.
2. **Device-type checks** (`userInterfaceIdiom == .pad`, `UIDevice.current.model`): replace with
   size classes (`horizontalSizeClass == .regular`) so the inner screen gets the big layout and the
   cover gets the compact one. Apple's `app-resizability` idiom task covers the patterns. Keep a
   real idiom check only for true hardware differences, read from the view's own trait collection.
3. **Split view assumptions**: a three-column layout that fits a 1024 pt iPad may be too wide for
   951 pt. Let columns collapse by width.
4. **Orientation**: the inner display ignores supported orientations. iPad layouts that assume
   landscape-only or portrait-only must work both ways.
5. Then follow `native.md` for bars, reserved regions, state across a fold and checks.
