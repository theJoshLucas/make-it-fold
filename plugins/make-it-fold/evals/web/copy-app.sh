#!/bin/bash
# Copies the practice web app into the eval's empty workspace (never the answer key).
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
cp -R "$here/../../practice/web/." .
printf 'workspace: %s\nplugin practice dir: %s\n' "$(pwd)" "$here/../../practice/web" > .scaffold-info
