# Teaching the plugin a new trap

At the end of a job, ask: did something bite that the traps did not warn about, and did it cost
real time? If not, add nothing.

If yes, draft one entry in the same shape as the trap files:
```
### <next ID> <one-line title>
- **Went wrong:** what happened
- **Spot it:** what in the code or the screenshots gives it away
- **Fix:** the smallest fix that worked
- **Check:** a concrete check a person or script can run
- **Applies to:** web / home-screen / wrapper / native / iPad / Expo / all
```
Write it generically: no app names, people, companies, addresses, keys or private paths. The
plugin is public.

Then:
- If this computer has the plugin's source repo checked out (the person maintains the plugin),
  offer to add the entry to `plugins/make-it-fold/skills/make-it-fold/traps/` and, if it fits,
  plant the same bug in the matching practice app so the exam checks it from then on.
- Otherwise, save the draft in the app's `duo/notes.md` and offer to open an issue on the
  plugin's GitHub repo with it.
