# How the plugin learns

Three notebooks, read at the start of every job and written at the end:

1. **The plugin's traps** (`traps/*.md`): lessons every user gets. They change when the plugin updates.
2. **This computer's notebook** (`duo-notes show`): lessons from Duo jobs done on this computer,
   across all apps. It survives plugin updates.
3. **The app's own notes** (`duo/notes.md` in the app): how to run it, its sandbox, its screens,
   what was decided for it.

## At the end of every job
Ask: did something bite that none of the three warned about? Did Apple's live page disagree with a
recipe? Did a layout choice work well enough to reuse? If yes to any, save it straight away, without
asking, one entry per lesson:

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/duo-notes add --title "<one line>" --went-wrong "<what happened>" \
  --spot "<what gives it away in code or pictures>" --fix "<what worked>" \
  --check "<a check a person or script can run>" --applies "<web / native / iPad / Expo / all>"
```

Write it generically: no app names, people, companies, addresses, keys or private paths. If
nothing new was learned, add nothing.

App-specific facts (ports, launch flags, the screen list, decisions) go in the app's `duo/notes.md`.

## Sharing a lesson with everyone
After saving, offer once: "Want me to send this lesson to the plugin's maintainers so every user
gets it?" Only on a yes, open an issue at `github.com/theJoshLucas/make-it-fold/issues` with the
entry (`duo-notes show --last`), written generically. Sending is publishing: always ask.

If this computer has the plugin's source repo checked out (the person maintains the plugin), offer
instead to add the entry to `plugins/make-it-fold/skills/make-it-fold/traps/` in the trap format
(`### <ID> <title>` and the same five fields) and, if it fits, to plant the same bug in the
matching practice app so the exam checks it from then on.
