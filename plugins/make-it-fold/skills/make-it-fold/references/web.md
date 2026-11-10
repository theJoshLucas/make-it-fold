# Web route (Safari on the Duo)

A responsive site that already works on phones and tablets mostly works on the Duo. What breaks
is code that assumes the window never changes size, that the screen is the window, or that safe
areas live only at the top and bottom. Sizes are in `facts.md`.

## viewport
`<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">`.
Without `viewport-fit=cover`, every `env(safe-area-inset-*)` reads 0. Remove `user-scalable=no`
and `maximum-scale=1`: they block zoom (an accessibility bug) and fix nothing on the Duo.

## height
Never size a screen with `100vh` / `h-screen`: on iOS it is the height with the toolbar hidden,
so bottom content sits behind the toolbar. Use `100dvh` for things that should track the
toolbar, `100svh` for a stable full-screen shell, or no fixed height at all (normal page flow)
where possible. Tailwind: `h-dvh`, `min-h-svh`. Keep a `100vh` line before it only as a fallback
for old browsers.

## safe areas
Pad pinned bars and full-bleed content on all four sides separately:
`padding: max(12px, env(safe-area-inset-top)) max(16px, env(safe-area-inset-right))
max(12px, env(safe-area-inset-bottom)) max(16px, env(safe-area-inset-left));`
In Safari, settled safe areas on the cover read 0 (Safari keeps the page clear of its side bar);
the inner screen has 34 px at the bottom (home indicator). Home-screen apps and web views in native
apps have no Safari chrome: there, side insets can be real (not measured yet). `duo-shot` reads them after the page settles.

## breakpoints and widths
The Duo lands between phone and tablet: 382, 594, 669 and 951 CSS px wide. Choose each layout
switch from the space the component actually needs, then test just below and above each
threshold. With Tailwind's defaults: 594 is below `sm` (640), 669 is `sm` but not `md` (768),
951 is `md` but not `lg` (1024). That is a risk to check, not a bug to "fix" by default.
- Never lay out by `screen.width`/`screen.height` (they report the cover size on the inner screen),
  by orientation media queries, or by device type. Use the viewport width, container queries
  (`@container`), or the element's own size (`ResizeObserver`).
- No fixed widths wider than 382 px. Wide content scrolls inside its own box, not the page.

## script layout
Anything that reads `innerWidth`, `matchMedia(...)` or element sizes must re-read on change
(`resize`, `matchMedia(...).addEventListener("change", ...)`, `ResizeObserver`), not once at load.
A resize must never rebuild forms or views from scratch: typed text, focus, scroll position and
open dialogs must survive a fold. Re-layout in place.

## zoom
Inputs, selects and textareas need a computed font size of at least 16 px, or Safari zooms in when
they are tapped. Fix the input size; do not block zoom.

## touch
Anything that appears only on `:hover` is invisible on a phone. Show it always, or under
`@media (hover: none)`. Touch targets at least 44 x 44 points.

## user agent
Tag every user-agent check: **layout** (picks a layout from the device: replace with width-based
rules), **capability** (deep links, app-store links: usually fine), **logging** (fine). The Duo
simulator reports a plain iPhone user agent; the real phone is unconfirmed.

## short screens
Cover landscape is only 368 px tall with toolbars shown. Pinned headers plus pinned footers plus a
banner can leave almost nothing. Check the main action is visible without scrolling there, with the
keyboard open on any form (keyboards cover content without changing `vh`/`dvh`/`innerHeight`).
