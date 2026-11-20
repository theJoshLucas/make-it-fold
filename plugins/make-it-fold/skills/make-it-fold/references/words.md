# Words: Apple's names for the Duo, and what people mean by theirs

The plugin speaks Apple's words (from Apple's design guide, its developer overview, Xcode's Device Hub
and the `UIHinge` status names; `duo-docs` fetches the first two on every job). Use them in reports,
plans and questions. Read the person's words through the table at the bottom.

## The glass and the app
- **Display**: the glass. There are two: the **outer display** (the small one, used closed) and the
  **inner display** (the big one that folds).
- **Screen**: a page of the app (a tab, a pushed page, a sheet, a form). "Every screen on both
  displays" is the job.
- **Portrait / landscape**: which way the display is turned.

## Fold states and poses
- Fold states (formal: Xcode's Device Hub buttons and `UIHinge.Status`): **closed**, **partially
  open**, **open** (`fullyOpen`).
- Apple's six poses (the captions on Apple's pose drawing), with the plugin's picture names:

| Apple's pose | Display, orientation | Plugin pose |
|---|---|---|
| closed | outer, portrait (or landscape) | `outer-portrait`, `outer-landscape`, `outer-landscape-flipped` |
| tent ("folded like a tent") | outer, landscape, partially open, standing on its edges | `tent` |
| open wide ("open in a wide layout") | inner, landscape | `inner-landscape` |
| book ("partially folded like a book") | inner, landscape, partially open | `book` |
| open tall ("open in a tall layout") | inner, portrait | `inner-portrait` |
| laptop ("folded like a laptop") | inner, portrait, partially open | `laptop` |

`outer-landscape-flipped` is the outer display turned the other way round; Apple has no name for it.

## Parts of the display
- **The fold** (Apple also says "folding region"): the strip of the inner display over the **hinge**.
  It is a **division** (a reserved region that splits content) only while the phone is partially open.
- **Reserved regions**: areas content must keep clear of. **Occlusions** cover content (the outer
  camera, always; the inner camera, only while it is on); **divisions** split it (the fold).
- **Vertical bar** (Apple: "controls on the side", the "vertical axis"; API names `UIVerticalBarEdge`,
  `toolbarVerticalEdge`): where iOS stacks the Dynamic Island, status bar, toolbar and tab bar down one
  side. On the outer display and on the inner display in landscape; the inner display in portrait keeps
  horizontal bars at the top and bottom.
- **Overflow menu**: the system "…" menu toolbar items move into when they do not fit.
- **Visibility priority**: which toolbar items overflow last.

## Layout words
- **Split view** (`NavigationSplitView`, `UISplitViewController`): one app showing two or three panes
  (a **sidebar** or list on the leading side, the detail beside it). Collapses to one pane on the
  outer display.
- **Split View multitasking**: two different apps sharing the inner display. Each puts its bars along
  its own outer edge.
- **Arrangement view** (`ArrangementView`, `UIArrangementViewController`): two views, **primary** and
  **secondary**, in a **split arrangement** (side by side, or stacked) or an **overlay arrangement** (one
  over the other; partially open, they move to each side of the fold).
- **Leading / trailing**: left / right in a left-to-right language. The vertical bar stays on the
  same hardware side in right-to-left languages.
- **Compact / regular width**: the size classes. The outer display is compact width; the inner
  display is regular width and regular height.
- **An additional level of hierarchy**: Apple's phrase for what the inner display adds, such as the
  list beside the open item.

## Reading the person's words
| They say | They mean |
|---|---|
| cover, cover screen, front screen, small screen | outer display |
| big screen, main screen, unfolded screen | inner display |
| upright / sideways | portrait / landscape |
| half-open, half-folded, bent | partially open (ask which pose if it matters: book, laptop or tent) |
| crease | the fold |
| side rail, side bar, side strip, the buttons on the side | vertical bar |
| sidebar | usually Apple's: the list pane on the leading side of a split view. If they clearly mean the strip of buttons, it is the vertical bar: check before acting on it |
| split screen, two apps at once | Split View multitasking |
| screen (meaning the glass) | display; ask if it is unclear whether they mean the glass or a page of the app |
| no pose named | every pose |
