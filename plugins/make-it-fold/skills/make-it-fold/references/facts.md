# iPhone Duo facts (measured, with units)

Measured in the iPhone Duo simulator (Xcode 27.2, iOS 27.2) with this plugin's probe page,
2026-11-09, unless marked. Re-measure with `duo-shot` or the probe page if something looks off;
the real phone may differ in small ways.

## Screens
| | Cover (folded) | Inner (unfolded) |
|---|---|---|
| App space, points | 466 x 678 portrait, 678 x 466 landscape | 669 x 951 portrait, 951 x 669 landscape |
| Screenshot / App Store size, pixels | 1398 x 2034 (or 2034 x 1398) | 2007 x 2853 (or 2853 x 2007) |
| Size classes | portrait: compact width, regular height; landscape: compact/compact | regular/regular |
| Simulator display ID (`simctl --display`) | 1 | 3 |

- Unfolding a portrait cover gives a **landscape** inner screen (the inner screen sits a quarter
  turn from the cover), and folding an inner portrait gives a cover landscape.
- Half-open: **book** = inner landscape at about 90 degrees (fold runs down the middle);
  **laptop** = inner portrait at about 90 degrees (fold runs across).
- Apple: the inner display does not honor an app's supported interface orientations.

## Safari (CSS pixels; toolbars shown, then toolbars hidden in brackets)
| Pose | Width x height | Safe areas (top right bottom left) |
|---|---|---|
| Cover portrait | 382 x 580 (618) | 0 0 0 0 |
| Cover landscape | 594 x 368 (406) | 0 0 0 0 |
| Cover landscape, the other way round | 594 x 368 (406) | 0 0 0 0 (settled; see note) |
| Inner portrait | 669 x 867 (902) | 0 0 34 0 |
| Inner landscape | 951 x 585 (620) | 0 0 34 0 |
| Inner split view, each half (Apple's figure, not measured) | 385 x 571 (609) | |

- These match the WebKit blog's table. One blog post reported other cover-landscape numbers; ignore it.
- **`screen.width` / `screen.height` report the cover size (466 x 678) even on the inner screen.** Never lay out by `screen`.
- Half-open looks exactly like open to a web page (same size, no event).
- Folding fires `resize` and does **not** reload the page (checked with an in-page marker).
- User agent: a plain iPhone string (`iPhone; CPU iPhone OS 18_7 like Mac OS X`, Safari 27.2). Simulator only; check the phone.
- Device Posture and Viewport Segments APIs: not available by default (Safari feature flags, off). Never depend on them.
- In Safari the side bar never covers the page: Safari shrinks the page to 594 px and keeps it clear of its side
  controls in both cover-landscape directions, so settled safe areas read 0. While the phone is still turning, one
  direction briefly reports 84 px on the left: measure only after the page has settled (duo-shot waits for it).
- Home-screen apps and web views inside native apps have no Safari chrome; their side insets on the Duo are not
  measured yet. Pad all four sides there.

## Deadlines (Apple, month only; recheck the exact day before submitting)
- April 2027: App Store uploads must be built with the iOS 27 SDK.
- April 2027: Duo screenshots required for apps built with the iOS 27.1 SDK or later (optional before; they earn an "optimized for iPhone Duo" badge).
- Building with the iOS 27 SDK makes resizing mandatory (`UIRequiresFullScreen` then only gives "discrete" resizing). No launch-screen key: upload rejected (ITMS-90870).
