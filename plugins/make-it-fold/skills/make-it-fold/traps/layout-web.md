# Layout traps: web pages, home-screen web apps, web inside a native wrapper

Load for any job whose screens are HTML. Ordered by how often each one bites a Duo job, most first.
Duo sizes: cover 466 x 678pt, inner 669 x 951pt; the Safari viewport is smaller than these once browser bars are
counted, and the published numbers disagree, so measure (see D-04). A system bar can sit down one side of the screen.

### W-01 Full-height screens and bottom bars built on 100vh hide behind browser bars and the side bar
- **Went wrong:** Screens sized with 100vh were taller than the visible area in mobile Safari, so a bottom-pinned main button sat behind the toolbar; it passed in a desktop browser. A persistent shell built with `min-height: 100vh` inside a grid stretched invisibly on some routes. On the Duo the system bar can run down one side, so left or right loses space too, not just top and bottom.
- **Spot it:** grep CSS for `100vh`, `h-screen`, `min-h-screen`, and for `position: fixed` / `sticky` elements with no `env(safe-area-inset-*)` padding. If the page paints edge to edge, check `viewport-fit=cover` is in the viewport tag (without it the insets read as 0).
- **Fix:** use `dvh` (or `svh` / `lvh` on purpose). Pad fixed and full-bleed elements with `env(safe-area-inset-*)` on all four sides. Shells use `grid-template-rows: auto 1fr` and `align-self: start`.
- **Check:** in every pose, open each key screen right after navigating (toolbar expanded): the primary action is visible and tappable without scrolling, nothing sits under the side bar, and the shell's `offsetHeight` is the same on every route.
- **Applies to:** web / home-screen / wrapper

### W-02 Sideways scroll at the cover width
- **Went wrong:** A page scrolled 177px sideways at phone width because a grid child would not shrink below its min-content width (a map and a no-wrap label). A long link inside streamed text set the width of a grid track, so a chat measured 568px on a 375px screen and clipped its input. Multi-column grids with no narrow rule crushed or overflowed; half of one project's late-round bugs were missing narrow fallbacks.
- **Spot it:** `grid-template-columns` with several tracks and no narrow-width rule; grids holding maps, tables, `white-space: nowrap`, or user, model or third-party text; `overflow-wrap: break-word` (it does not shrink a grid track; `anywhere` does).
- **Fix:** `min-width: 0` on the children of every multi-column grid (fix the whole class of grids, not one page); `minmax(0, 1fr)` tracks; `overflow-wrap: anywhere` on text you don't control; an explicit narrow layout for every multi-column grid.
- **Check:** at the cover width, on every route, assert `document.documentElement.scrollWidth <= document.documentElement.clientWidth`. If it fails, walk up from the widest element to the first ancestor whose computed `min-width` is `auto`.
- **Applies to:** web / home-screen / wrapper

### W-03 Breakpoints tested at stock widths miss the Duo widths and the width where a rule flips
- **Went wrong:** Layouts that were fine at 390 and 1024 broke in between. A height cap on a decorative strip cut off content only above a certain width; all three "proof" widths sat below it, so it shipped with screenshots. Both Duo screens fall between common breakpoints, and the app crosses them live.
- **Spot it:** any breakpoint, clamp, cap, aspect ratio, or `cover` / `slice` scaling whose trigger sits near the Duo's widths.
- **Fix:** treat the narrow layout as its own pass, not a squeezed desktop. For each width-dependent rule, work out the width where it flips and test both sides of it.
- **Check:** run the layout checks at the viewport sizes measured on the Duo simulator for every pose, plus 1px either side of every existing breakpoint the Duo widths straddle.
- **Applies to:** web / home-screen / wrapper

### W-04 Folding mid-task loses typed text, filters or the open view
- **Went wrong:** Drafts and extra photos lived only in a mounted component, so a remount silently dropped them. A navigation step built from the older saved copy undid the page's local edits. Tab, filter and selection lived only in memory, so a refresh or relaunch reset them. A fold can remount components (any layout that swaps component trees by width in script), and a home-screen app may be relaunched at the new size.
- **Spot it:** form drafts in component-local state; script that renders different component trees per width; view state missing from the URL.
- **Fix:** keep anything typed and not yet submitted outside the mounted view (a store or `sessionStorage`, keyed to its item). Put returnable view state (tab, filter, selection) in the URL. Build any transition from the current state, not a saved copy.
- **Check:** the scenario's fold-mid-task step: type into the longest form, open a sheet, scroll, then fold and unfold. The text, scroll position and open sheet survive, and a marker set on `window` before the fold is still there after it (no hidden reload).
- **Applies to:** web / home-screen / wrapper

### W-05 The keyboard covers the input, because vh, dvh and innerHeight ignore it
- **Went wrong:** A chat panel sized in `dvh` with `overflow: hidden` was fine on a laptop and unusable on the phone. When the iOS keyboard opens, the layout viewport does not change (vh, dvh, svh, lvh and innerHeight all keep the full height), so the panel stayed tall inside a much smaller visible band and Safari panned and zoomed on every tap. A field made read-only "while busy" never raised the keyboard. Desktop emulation hides all of this, because it does shrink the layout viewport.
- **Spot it:** bottom sheets, composers or chat inputs sized with vh, dvh, svh or `innerHeight`; a focused field inside an `overflow: hidden` box; inputs set `readOnly` to mean "wait".
- **Fix:** size and place anything the keyboard can cover from `window.visualViewport` (height and offsetTop, listening to both its `resize` and `scroll` events). Pin with `top`, not `transform`. Disable the send button instead of making the field read-only. Use `type="text"` with `inputmode` for digit fields, never `type="number"` for identifiers.
- **Check:** on the Duo simulator with the software keyboard, focus every field in cover portrait and cover landscape (the shortest band): the field and its submit button stay visible. Mechanical proxy: no keyboard-coverable surface is sized in a unit that ignores the keyboard. How the real keyboard feels goes on the "needs a real Duo" list (T-09).
- **Applies to:** web / home-screen / wrapper

### W-06 Tapping a text field zooms the page
- **Went wrong:** Four separate causes: an input under 16px; the 16px rule written only inside `@media (pointer: coarse)`, so some devices missed it; the user's remembered Page Zoom (85%) turning a 16px field into 13.6px on glass; and a field inside any transformed ancestor, even an identity `translateX(0)` left behind by an animation with `fill-mode: both`. A probe that only alarmed above scale 1.01 missed the Page Zoom case.
- **Spot it:** inputs, selects or textareas under 16px anywhere; font-size rules that exist only for coarse pointers; animations with `fill-mode: both` or `forwards` on ancestors of form fields.
- **Fix:** every input, select and textarea is at least 16px on every device. Let entrance animations clear their transform when they finish. Set `-webkit-text-size-adjust: 100%`. Don't "fix" it by blowing up control sizes, and never use `user-scalable=no`. (`maximum-scale=1` in the viewport tag also stops the focus zoom and iOS still allows pinch, but fix the font size first.)
- **Check:** in the simulator's Safari, record `visualViewport.scale` before and after focusing one field of each kind on every page; it must not change in either direction.
- **Applies to:** web / home-screen / wrapper

### W-07 Layout picked by script from a one-time or late answer
- **Went wrong:** A screen chose its layout from a value that started empty while a request resolved, so the wrong layout flashed for a frame on every load. A 50ms poller then reported "no flash", because the 280ms transition started before its first sample. The same thing happens on the Duo when script reads the width once at load, waits on a late signal, or sniffs the user agent, instead of reacting to the resize.
- **Spot it:** `innerWidth`, `screen.width` or `matchMedia` read once with no change listener; user-agent checks that choose layout; layout gated on an async value.
- **Fix:** decide layout in CSS, or from what is known synchronously, and decide again on every resize or `matchMedia` change. Let a late answer correct only a rare case. Never pick layout from the user agent.
- **Check:** install an event hook (a resize listener, `animationstart`, or frame sampling every ~25ms) before the fold and record every frame: no frame shows the other pose's layout, and the layout after the fold matches a fresh load at that size.
- **Applies to:** web / home-screen / wrapper / Expo

### W-08 Layout sized from the window, not the space the content actually gets
- **Went wrong:** A wide window switched on a side rail and indents even though a list had already taken 380px, leaving a 234px editor. A grid's "equal split" collapsed into the middle of its workspace. A later fix centred a column inside an invisible allocation and put 155pt of dead air between groups. On the Duo's inner screen, a sidebar can leave the content less room than the cover gives.
- **Spot it:** viewport media queries (or window size classes) deciding the layout of something that sits beside a sidebar or another pane.
- **Fix:** measure the region actually left after rails and panes (container queries on the web; the column's own size natively). Keep a minimum reading width. Centre one content group and put spare width outside it as equal margins.
- **Check:** in inner landscape with every sidebar open, the content column is at least its minimum width and the outer margins are equal; look at the pixels, not just the numbers.
- **Applies to:** web / home-screen / wrapper / native / iPad

### W-09 Hover-only controls, and touch versions that take no space
- **Went wrong:** A hover-revealed delete button was made visible on touch by leaving the hover transform on. Transforms move pixels without taking space, so long names slid under the price column, and a real tablet user ran into it.
- **Spot it:** `:hover` rules that reveal controls; transforms used to show something.
- **Fix:** put hover effects behind `@media (hover: hover) and (pointer: fine)`. Give every touch version real layout space (margin, padding, flex basis) and work out truncation at the reduced width.
- **Check:** in a touch viewport at the cover width with the longest name, every action that desktop reaches by hover is visible and tappable, and its box does not overlap the neighbouring text.
- **Applies to:** web / home-screen / wrapper

### W-10 Persistent chrome and pop-up notices eat the short screen
- **Went wrong:** A four-column desktop footer stacked into 1,224px on a 664px phone (1.8 screens, over half of a short error page). A list printed every problem above its controls and pushed the work out of sight. An Undo notice shoved the work down, and a toast covered the Send button.
- **Spot it:** headers and footers that stack their columns at narrow widths; navigation repeated in the footer; notices inserted into the page flow; toasts anchored where a bottom bar lives.
- **Fix:** give persistent chrome a height budget on the short screen (more than about one screen is a bug). Collapse detail to counts, with the full reasons one tap away. Render notices out of flow, above the measured action bar (including a bar that wraps).
- **Check:** in cover landscape (the shortest pose), measure header plus footer as a share of the screen on every route, including the shortest page; with a notice showing, every action is still visible and tappable.
- **Applies to:** web / home-screen / wrapper

### W-11 A reused detail pane shows the previous record
- **Went wrong:** Going straight from one record's edit screen to the next reused the mounted view, so the second record opened with the first one's answers, and saving would have overwritten the wrong record. Unfolding into list-plus-detail keeps one detail pane alive while the selection changes, which is exactly this case.
- **Spot it:** a detail view not keyed by the record's id; state reset only on mount.
- **Fix:** key the detail view by record id (React `key`, SwiftUI `.id()`), or reset its state whenever the id changes.
- **Check:** in the two-pane pose, edit record A, then select record B without leaving the screen: B shows its own data, and saving does not touch A.
- **Applies to:** all

### W-12 New styles silently do nothing, or restyle something else
- **Went wrong:** A new class name was already used by existing sliders, which squeezed their labels on other pages. `hidden` on a component whose own classes set `inline-flex` lost on stylesheet order, and a recoloured main button shipped as an empty white pill. Tailwind v3-style `rounded-[--token]` compiled to invalid CSS under v4 and dropped 214 declarations, with no build error.
- **Spot it:** responsive visibility (`hidden md:flex`) passed to components that set their own display; new class names without a prefix; Tailwind v4 projects using bracket-variable syntax, or a colour alpha `/` outside the parentheses.
- **Fix:** search the codebase before naming a class, and prefix new ones. Put responsive visibility on a wrapper element. Grep the built CSS for `:--` and `)/` and fail on any hit.
- **Check:** after adding styles, rerun the layout checks on every existing screen, not just the changed one; at the cover width, confirm hidden elements are gone from layout, not just small.
- **Applies to:** web / home-screen / wrapper

### W-13 Popovers and overlays land in the wrong place after a resize or pinch
- **Went wrong:** After a pinch, `innerWidth` and every `getBoundingClientRect` shifted by the visual viewport offset, but positions inside a fixed layer did not, so an overlay landed 256px off its target. A card measured while parked near the right edge wrapped into a 10-line column, because the browser only offered it the space left of the edge.
- **Spot it:** overlays positioned from `innerWidth` / `innerHeight` or raw rects; content-sized popovers measured where they sit.
- **Fix:** position overlays relative to the layer they live in (subtract its rect), or use `visualViewport` offsets consistently. Measure content-sized elements at `left: 0` (or offscreen at the target width), then place them.
- **Check:** at the cover width, open each popover anchored at the far right edge, then again after a fold and after pinching in: it points at its target and keeps its normal shape.
- **Applies to:** web / home-screen / wrapper

### W-14 The pose class is on the element, but the change didn't happen
- **Went wrong:** A class meant to move a sheet set a transform, but the entrance animation's `fill-mode` kept holding `transform: none`, so nothing moved. Another animation never ran because the same property was also set with `!important`. A check for the class passed both times.
- **Spot it:** state classes toggled by script on elements that also animate; `!important` on animated properties.
- **Fix:** a state class that moves an animated element also sets `animation: none`. Never set an animated property with `!important`; use a more specific selector.
- **Check:** assert the computed style or bounding box (or compare two screenshots) before and after the class changes; `classList` alone proves nothing.
- **Applies to:** web / home-screen / wrapper

### W-15 Backgrounds and pictures tuned for one screen size
- **Went wrong:** A background image placed for a two-column desktop layout sat under the body text at phone width and made it unreadable. Art stretched 2x on a bigger screen looked blocky, and zooming out to "show everything" exposed art cropped at its own edges.
- **Spot it:** decorative layers with one position and scale for every width; fixed-resolution images or canvases shown full width.
- **Fix:** give decorative layers their own placement, scale and dimming for the narrow layout. Serve images sized for the physical pixels they cover (roughly 1x to 2x). Extend cropped art instead of moving the camera.
- **Check:** screenshot each decorative layer behind the longest paragraph in the narrowest and widest pose, and zoom images to 1:1 on the inner screen.
- **Applies to:** all

### W-16 Layout picked from `screen.width`, which reports the cover size on the inner screen
- **Went wrong:** In the Duo simulator, `screen.width` and `screen.height` read 466 x 678 (the cover) even while the page was showing on the 951 px inner screen, so code that picked a "phone layout" from `screen` kept the cramped layout on the big screen.
- **Spot it:** `screen.width`, `screen.height`, `screen.availWidth`, `device-width` media queries.
- **Fix:** lay out from the viewport (`innerWidth`, width media queries) or the element's own size (container queries, `ResizeObserver`).
- **Check:** on the inner screen in both orientations, the wide layout shows; on the cover, the compact one.
- **Applies to:** web / home-screen / wrapper

### W-17 Assuming Safari's side bar covers the page in cover landscape
- **Went wrong:** A reading taken while the phone was still turning showed an 84 px left safe area in one cover-landscape direction, which looked like the side bar covering the page. Settled, Safari reports 0 on every side: it shrinks the page to 594 px and keeps it clear of its side controls in both directions.
- **Spot it:** "fixes" that add large hard-coded left or right padding for the side bar on Safari pages.
- **Fix:** use `env(safe-area-inset-*)` (it is 0 here, so it costs nothing), never a hard-coded 84 px. Home-screen apps and native web views are different: they have no Safari chrome, so their side insets can be real.
- **Check:** `duo-shot` default poses include both cover-landscape directions and read the page only after it settles.
- **Applies to:** web / home-screen / wrapper
