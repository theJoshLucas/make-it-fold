# iPhone Duo facts (measured, with units)

Measured in the iPhone Duo simulator (Xcode 27.2, iOS 27.2) with this plugin's probe page,
2026-11-09, unless marked. Re-measure with `duo-shot` or the probe page if something looks off;
the real phone may differ in small ways.

## Displays (Apple's names: outer display, inner display)
| | Outer display (closed) | Inner display (open) |
|---|---|---|
| App space, points | 466 x 678 portrait, 678 x 466 landscape | 669 x 951 portrait, 951 x 669 landscape |
| Screenshot / App Store size, pixels | 1398 x 2034 (or 2034 x 1398) | 2007 x 2853 (or 2853 x 2007) |
| Size classes | portrait: compact width, regular height; landscape: compact/compact | regular/regular |
| Simulator display ID (`simctl --display`) | 1 | 3 |

- Opening the phone from the outer display in portrait gives the inner display in **landscape** (the
  inner display sits a quarter turn from the outer one), and closing it from the inner display in
  portrait gives the outer display in landscape.
- Partially open (Apple's poses): **book** = inner display in landscape at about 90 degrees (the fold
  runs down the middle); **laptop** = inner display in portrait at about 90 degrees (the fold runs
  across); **tent** = opened partway from closed and stood on its edges, so the outer display stays on,
  in landscape. Measured 2026-11-20: from closed, the outer display stayed on at every angle tried from
  30 to 105 degrees (`duo-sim pose tent` asks for 75 and reads back about 73), and the simulator turned
  it to landscape-flipped as it opened. To an app, tent is the outer display in landscape: same size,
  same Safari page size, no fold across it.
- Apple: the inner display does not honor an app's supported interface orientations.

## Safari (CSS pixels; toolbars shown, then toolbars hidden in brackets)
| Pose | Width x height | Safe areas (top right bottom left) |
|---|---|---|
| Outer portrait | 382 x 580 (618) | 0 0 0 0 |
| Outer landscape | 594 x 368 (406) | 0 0 0 0 |
| Outer landscape, the other way round | 594 x 368 (406) | 0 0 0 0 (settled; see note) |
| Tent (measured 2026-11-20) | 594 x 368 (406) | 0 0 0 0 |
| Inner portrait | 669 x 867 (902) | 0 0 34 0 |
| Inner landscape | 951 x 585 (620) | 0 0 34 0 |
| Inner display, Split View multitasking, each half (Apple's figure, not measured) | 385 x 571 (609) | |

- These match the WebKit blog's table. One blog post reported other outer-landscape numbers; ignore it.
- **`screen.width` / `screen.height` report the outer display size (466 x 678) even on the inner display.** Never lay out by `screen`.
- Partially open looks exactly like open to a web page (same size, no event).
- Folding fires `resize` and does **not** reload the page (checked with an in-page marker).
- User agent: a plain iPhone string (`iPhone; CPU iPhone OS 18_7 like Mac OS X`, Safari 27.2). Simulator only; check the phone.
- Device Posture and Viewport Segments APIs: not available by default (Safari feature flags, off). Never depend on them.
- In Safari the vertical bar never covers the page: Safari shrinks the page to 594 px and keeps it clear of its side
  controls in both outer-landscape directions, so settled safe areas read 0. While the phone is still turning, one
  direction briefly reports 84 px on the left: measure only after the page has settled (duo-shot waits for it).
- Home-screen apps and web views inside native apps have no Safari chrome; their side insets on the Duo are not
  measured yet. Pad all four sides there.

## Deadlines (Apple, month only; recheck the exact day before submitting)
- April 2027: App Store uploads must be built with the iOS 27 SDK.
- April 2027: Duo screenshots required for apps built with the iOS 27.1 SDK or later (optional before; they earn an "optimized for iPhone Duo" badge).
- Building with the iOS 27 SDK makes resizing mandatory (`UIRequiresFullScreen` then only gives "discrete" resizing). No launch-screen key: upload rejected (ITMS-90870).
