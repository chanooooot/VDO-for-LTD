#!/usr/bin/env bash
# Fails if a Remotion project could render in the browser or the cloud.
# Usage: bash check.sh [project-dir]   (default: current folder)
dir="${1:-.}"
bad='@remotion/web-renderer|@remotion/lambda|@remotion/lambda-client|@remotion/cloudrun|@remotion/vercel|renderMediaOnWeb|renderStillOnWeb|renderMediaOnLambda|renderStillOnLambda|renderMediaOnCloudrun|renderStillOnCloudrun'
[ -f "$dir/package.json" ] || { echo "check: no package.json in $dir"; exit 2; }
hits="$(grep -rnE "$bad" "$dir" \
  --include=package.json --include='*.ts' --include='*.tsx' --include='*.js' --include='*.jsx' --include='*.mjs' --include='*.cjs' \
  --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=out --exclude-dir=build 2>/dev/null)"
for p in web-renderer lambda lambda-client cloudrun vercel; do
  [ -d "$dir/node_modules/@remotion/$p" ] && hits="$hits"$'\n'"node_modules/@remotion/$p is installed"
done
hits="$(echo "$hits" | sed '/^$/d')"
if [ -n "$hits" ]; then
  echo "✗ Not local-only. Remove these before rendering:"
  echo "$hits"
  exit 1
fi
echo "✓ Local-only: no browser or cloud rendering in $dir"
