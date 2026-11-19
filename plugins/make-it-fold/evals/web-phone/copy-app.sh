#!/bin/bash
# Copies the phone-first practice web app into the eval's empty workspace (never the answer key).
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
cp -R "$here/../../practice/web-phone/." .
printf 'workspace: %s\nplugin practice dir: %s\n' "$(pwd)" "$here/../../practice/web-phone" > .scaffold-info
