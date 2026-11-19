# Scenario file, safe test data, test logins, publishing

## duo/scenario.json (one per app, kept in the app's repo)
Write it once, on the first Duo job, and reuse it. Short is fine.
```json
{
  "backend": "local-sandbox",
  "start": "npm run dev",
  "url": "http://localhost:5173",
  "paths": ["/", "/new"],
  "steps": {
    "/new": [
      {"name": "form half filled"},
      {"type": ["#title", "Half-typed note"]},
      {"pose": "cover-portrait"},
      {"expect_value": ["#title", "Half-typed note"]},
      {"pose": "inner-landscape"},
      {"expect_visible": "button[type=submit]"}
    ]
  }
}
```
Steps: `type` [selector, text], `tap` selector, `pose` name (folds, and takes a picture), `wait`
seconds, `expect_visible` selector (on screen and not covered), `expect_value` [selector, text],
`expect_text` text, and `name` text: it names the state the following pictures show ("item open",
"new-entry form"), and each named state gets its own block in the design scorecard. Reach every
state a person can see (an open item, each form, a menu) and name it, on the cover and unfolded.
Keep app-specific notes for the next job in `duo/notes.md`.

## native screens (so every screen is photographed, not just the first)
`duo-shot native` relaunches the app once per screen and shoots it in every pose:
```json
{
  "backend": "local-sandbox",
  "screens": [
    {"name": "home"},
    {"name": "settings", "args": ["-screen", "settings"]},
    {"name": "new-entry", "env": {"APP_OPEN": "new-entry"}, "wait": 2},
    {"name": "item", "url": "myapp://item/1"},
    {"name": "menu", "taps": [[420, 60]]}
  ]
}
```
Each screen may use `args` (launch arguments), `env` (environment values the app reads at launch),
`url` (a link the app opens), `taps` (points to tap, in the first pose, after launch) and `wait`
(seconds to settle, default 3). Most apps need a small debug-only switch to open a screen directly
with made-up data: add one (never in release builds) and write it in `duo/notes.md`. Include every
sheet, form and menu: they are where a stretched layout shows most.
With many screens add `--order pose`: it folds once and then starts every screen in that pose, which is many
times faster when a fold is slow (trap T-18). It cannot be used with `taps`, and it does not show a fold in the
middle of a task: do one run in the default order on a single screen for that.

## backend (required): never test against live data
- `local-sandbox`: a throwaway local database with made-up data. Writes allowed.
- `read-only`: only pages that never write, with analytics switched off (load from localhost,
  or use the app's own test or bot marker). Many apps record analytics on page load: check.
- `mocked`: the app's API calls are answered by fake data.
Payments, messages, emails and paid AI calls are always mocked or skipped. If none of these is
possible, stop and report "needs a sandbox first".

## sandbox recipe (apps with a database)
1. Find how the app gets its database (often `DATABASE_URL`). Never reuse a deployed one.
2. Create a local one (`createdb duo_sandbox_<app>` for Postgres; a temp file for SQLite).
3. Create the tables with the app's own tool (`npm run db:push`, `prisma db push`, migrations).
4. Add `duo/seed.*` with a few rows of obviously fake data, and run it.
5. Start the app with the local database. Write these steps into `duo/notes.md`.

## test-only login (apps behind a sign-in)
Add a sign-in shortcut that works only when BOTH the request comes from localhost AND a dev-only
setting is on (for example `DUO_TEST_LOGIN=1`), and only against the sandbox database. Add a check
that fails the build or start-up if that setting is on outside development. Never commit a real
password or token. If the sign-in is a hosted service you cannot bypass locally, check the login
screen by script and list the signed-in screens as a manual check.

## publishing
Pushed is not live. Find how this app actually goes live (a deploy command, a hosting dashboard,
an App Store build) and write that exact step in the report. Ask before doing it, every time.
