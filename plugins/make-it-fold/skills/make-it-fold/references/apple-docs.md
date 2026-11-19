# Apple's docs: fetched fresh on every run

`${CLAUDE_PLUGIN_ROOT}/scripts/duo-docs` downloads Apple's current Duo pages at the start of every
job and keeps a copy on this computer. It prints one line per page:

- **READ**: Apple's overview and Apple's design rules. Read both on every job, from the path shown
  (`duo-docs path overview`, `duo-docs path design`). The line also says if Apple changed them.
- **changed**: a topic page Apple has edited since this plugin's recipes were written, or since your
  last job. Read it if the job touches that topic.
- **same**: unchanged since the recipes were written. Read it only when the job needs that topic.
- **offline**: Apple could not be reached. A saved copy is used and its date is shown; with no
  copy, say in the report "Apple's live pages could not be reached" and never fill the gap from memory.

It also lists **links that are new** on Apple's two main Duo pages since the last run: pages Apple
has added. Open any that touch this job (add `.md` to a `developer.apple.com/documentation/...`
address to get plain text).

If a live page disagrees with a recipe or with `design.md`, Apple wins: follow Apple, name the
stale recipe in the report, and save the lesson with `duo-notes add`.

| Name | What it is for |
|---|---|
| `overview` (every job) | Everything Apple wants for the Duo: resizing, bars, arrangement views, reserved regions |
| `design` (every job) | The design rules: two screens, poses, the side rail, reserved regions, split and arrangement views |
| `arrangement-swiftui`, `arrangement-uikit` | Two views that re-arrange around the fold |
| `reserved-region` | Camera and fold areas content must avoid |
| `vertical-bar` | Which edge the rail is on, and how to read it |
| `sheet-placement` | Putting a sheet on one side of the inner screen |
| `hinge` | Hinge angle and status (optional features) |
| `fullscreen-key` | `UIRequiresFullScreen` going away |
| `launch-screen` | Launch screen required (ITMS-90870) |

Not fetched automatically (open when needed): Apple's three-step checklist
(https://developer.apple.com/iphone-duo/prepare/), App Store screenshot sizes
(https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/),
Safari on the Duo (https://webkit.org/blog/, search "Safari 27.1"), and the Duo tech talks
(https://developer.apple.com/videos/, search "iPhone Duo").

## Apple's own agent skills (native apps)
Xcode 27.1+ ships Apple-written skills, including `app-resizability` ("get my app ready for
iPhone Duo"). Find the person's current copy:

```bash
P="$(xcrun agent plugin path --plugin-format claude 2>/dev/null)/skills/app-resizability"
[ -d "$P" ] || { C="${XDG_CACHE_HOME:-$HOME/.cache}/make-it-fold/xcode-skills"; xcrun agent skills export "$C" && P="$C/app-resizability"; }
echo "$P"
```

Read its `SKILL.md`, then only the `references/*-task.md` files for patterns `duo-scan` found.
Its six files are about 19,500 words: never read them all.
