# Apple's docs: always read live

Apple changes these pages. Fetch the one or two a job needs, at the time of the job. Apple serves
its documentation as Markdown: add `.md` to a `developer.apple.com/documentation/...` URL. If a
fetch fails, say so in the report; never fill the gap from memory.

| Problem | Page |
|---|---|
| Overview: everything Apple wants for the Duo | https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo.md |
| Apple's three-step checklist | https://developer.apple.com/iphone-duo/prepare/ |
| Design rules (poses, columns, reserved regions) | https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo |
| The vertical bar (which edge, how to read it) | https://developer.apple.com/documentation/uikit/uiverticalbaredge.md |
| Camera and fold areas content must avoid | https://developer.apple.com/documentation/uikit/uiviewreservedregion.md |
| Hinge angle and status (optional features) | https://developer.apple.com/documentation/uikit/uihinge.md and https://developer.apple.com/documentation/uikit/uihingeinteraction.md |
| Two-pane layouts that adapt (split / overlay) | https://developer.apple.com/documentation/uikit/uiarrangementviewcontroller.md |
| `UIRequiresFullScreen` going away | https://developer.apple.com/documentation/technotes/tn3192-migrating-your-app-from-the-deprecated-uirequiresfullscreen-key.md |
| Launch screen required (ITMS-90870) | https://developer.apple.com/documentation/technotes/tn3208-preparing-your-apps-launch-screen-to-meet-app-store-requirements.md |
| App Store screenshot sizes | https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/ |
| Safari on the Duo (sizes, feature flags) | https://webkit.org/blog/ (search "Safari 27.1") |
| Duo tech talks (videos with transcripts) | https://developer.apple.com/videos/ (search "iPhone Duo") |

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
