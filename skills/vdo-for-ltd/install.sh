#!/usr/bin/env bash
# Installs the VDO for LTD skill set globally for Codex and Claude Code.
# Each step runs even if an earlier one fails; a summary prints at the end.
set -u

# Space-separated agent names, e.g. VDO_AGENTS="codex" or "codex claude-code cursor"
read -r -a AGENTS <<< "${VDO_AGENTS:-codex claude-code}"
failed=()

step() {
  local name="$1"; shift
  echo ""
  echo "==> $name"
  echo "    $*"
  if "$@"; then echo "    ✓ $name"; else echo "    ✗ $name failed"; failed+=("$name"); fi
}

command -v npx >/dev/null || { echo "npx not found. Install Node.js 18+ first: https://nodejs.org"; exit 1; }

# 0. This bundle's own skills (vdo-for-ltd installer + video-kickoff)
step "vdo-for-ltd" npx -y skills add chanooooot/VDO-for-LTD --skill '*' -g -a "${AGENTS[@]}" -y

# 1. FFmpeg skill: installs the skill, installs FFmpeg if missing, then runs its doctor check
step "ffmpeg-skill" npx -y ffmpeg-skill setup

# 2. Remotion skills (videos in React)
step "remotion" npx -y skills add remotion-dev/skills --skill '*' -g -a "${AGENTS[@]}" -y

# 3. Ponytail (smallest-change coding mode)
step "ponytail" npx -y skills add DietrichGebert/ponytail --skill '*' -g -a "${AGENTS[@]}" -y

# 4. grill-me + grilling from Matt Pocock (grill-me calls grilling, so both are needed)
step "grill-me" npx -y skills add mattpocock/skills --skill grill-me --skill grilling -g -a "${AGENTS[@]}" -y

echo ""
if [ ${#failed[@]} -eq 0 ]; then
  echo "All done. Restart Codex / Claude Code so they load the new skills."
else
  echo "Finished with failures: ${failed[*]}"
  exit 1
fi
