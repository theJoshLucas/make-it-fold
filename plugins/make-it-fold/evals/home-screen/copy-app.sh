#!/bin/bash
# Copies the practice home-screen app into the eval's empty workspace (never the answer key).
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
cp -R "$here/../../practice/home-screen/." .
printf 'workspace: %s\nplugin practice dir: %s\n' "$(pwd)" "$here/../../practice/home-screen" > .scaffold-info
