# Component recipes (read only the parts duo-scan flagged)

## tables
On 382 px nothing wide fits. Wrap the table in a box with `overflow-x: auto` so the table scrolls
and the page does not; keep the first column (what the row is) and the action column reachable
(sticky first column, or move actions into a row menu). Or reflow rows into cards below a width
that the table's real columns need. Never hide columns that hold the only way to do something.

## maps
Maps measure their box once. After a fold, call the library's resize method (Leaflet
`map.invalidateSize()`, Mapbox/MapLibre `map.resize()`, Google Maps re-center) from a
`ResizeObserver` on the map's container.

## canvas
A canvas keeps its pixel size when its box changes: re-size the backing store
(`canvas.width = box.width * devicePixelRatio`) and redraw on resize. Convert touch points with
the canvas's current `getBoundingClientRect()`, never cached numbers. PDF viewers: re-render the
page at the new width.

## overlays (dialogs, menus, popovers, sheets, toasts)
After a resize, open overlays must re-position or close cleanly. Check: the overlay fits 382 px
wide and 368 px tall, its close button is not under the side bar (home-screen apps and web views) or the home
indicator (34 px), and it is not centered on the fold line in book pose. Positioning libraries
(Floating UI, Radix, Headless UI) re-position on resize when their auto-update is on.

## iframes
CSS on the parent page cannot fix the layout inside a frame from another site. Size the frame to
its box (`width: 100%`, an aspect ratio or a container-based height), allow it to scroll, and
report anything wrong inside it as a limit, not as fixed.
