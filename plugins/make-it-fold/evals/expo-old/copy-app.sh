#!/bin/bash
# Copies the practice expo-old app into the eval's empty workspace (never the answer key).
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
cp -R "$here/../../practice/expo-old/." .
printf 'workspace: %s\nplugin practice dir: %s\n' "$(pwd)" "$here/../../practice/expo-old" > .scaffold-info
