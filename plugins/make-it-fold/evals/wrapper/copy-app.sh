#!/bin/bash
# Copies the practice wrapper app into the eval's empty workspace (never the answer key).
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
cp -R "$here/../../practice/wrapper/." .
printf 'workspace: %s\nplugin practice dir: %s\n' "$(pwd)" "$here/../../practice/wrapper" > .scaffold-info
