#!/usr/bin/env bash
# Installs the VDO for LTD skill set globally for Claude Code.
# Each step runs even if an earlier one fails; a summary prints at the end.
set -u

AGENT="${VDO_AGENT:-claude-code}"
failed=()

step() {
  local name="$1"; shift
  echo ""
  echo "==> $name"
  echo "    $*"
  if "$@"; then echo "    ✓ $name"; else echo "    ✗ $name failed"; failed+=("$name"); fi
}

command -v npx >/dev/null || { echo "npx not found. Install Node.js 18+ first: https://nodejs.org"; exit 1; }

# 1. FFmpeg skill: installs the skill, installs FFmpeg if missing, then runs its doctor check
step "ffmpeg-skill" npx -y ffmpeg-skill setup

# 2. Remotion skills (videos in React)
step "remotion" npx -y skills add remotion-dev/skills --skill '*' -g -a "$AGENT" -y

# 3. Ponytail (smallest-change coding mode)
step "ponytail" npx -y skills add DietrichGebert/ponytail --skill '*' -g -a "$AGENT" -y

# 4. grill-me + grilling from Matt Pocock (grill-me calls grilling, so both are needed)
step "grill-me" npx -y skills add mattpocock/skills --skill grill-me --skill grilling -g -a "$AGENT" -y

echo ""
if [ ${#failed[@]} -eq 0 ]; then
  echo "All done. Restart Claude Code so it loads the new skills."
else
  echo "Finished with failures: ${failed[*]}"
  exit 1
fi
