#!/bin/bash
# Copies the already-fixed Setlist app into the eval's empty workspace. The fixed copy lives
# outside the plugin (in the source repo's dev/answers/) so exam sessions can't read it.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
src="$here/../../../../dev/answers/web/fixed"
[ -d "$src" ] || { echo "run this exam from the make-it-fold source repo (needs dev/answers/)" >&2; exit 1; }
cp -R "$src/." .
