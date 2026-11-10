# Answer key: practice/web (Setlist)

Planted Duo bugs. The practice folder never contains this file, so the agent under test can't
read it. Graders in `case.yaml` check each one.

| # | Bug | Where | What fixed looks like |
|---|---|---|---|
| W1 | Full-height shell built on `100vh` hides content behind Safari's bars | `style.css` `.shell` | `100dvh` / `100svh` (or flow height), no bare `100vh` |
| W2 | Viewport tag blocks zoom and lacks `viewport-fit=cover` (insets read as 0) | `index.html` | `viewport-fit=cover`; no `user-scalable=no` / `maximum-scale=1` |
| W3 | Bottom save bar ignores safe areas (34 px home indicator on the inner screen) | `style.css` `.save-bar` | `env(safe-area-inset-bottom)` plus left and right insets on the bar (side padding on the page shell is optional: Safari reports 0 there) |
| W4 | Song table is a fixed 760 px wide: sideways page scroll on the 382 px cover | `style.css` `.song-table` | table scrolls inside its own box (`overflow-x: auto` wrapper) or reflows; no fixed 760 px |
| W5 | Inputs at 14 px make Safari zoom when tapped | `style.css` `.editor input` | inputs at 16 px or more |
| W6 | Layout picked by `screen.width`, which reports the cover size even on the inner screen | `app.js` `applyLayout` | width of the space the content actually has (the content region's own width or a container query; `innerWidth` only where nothing sits beside the content) |
| W7 | Sidebar hidden by an orientation query, so inner portrait (669 px) loses it | `style.css` `@media (orientation: portrait)` | width-based rule instead of orientation |
| W8 | Editor rebuilt on every resize: a fold erases half-typed text | `app.js` `applyLayout` / `renderEditor` | resize no longer rebuilds the form, typed text survives a fold |
| W9 | Delete buttons only appear on hover: invisible on touch | `style.css` `.del` | visible on touch (`@media (hover: none)` or always shown) |

A correct run also: reports per tier (desktop browser / Duo simulator / needs the phone),
does not redesign the app, and does not invent bugs outside this list.
