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

# ---- Python 3.10+ as `python3` (ffmpeg-skill and the agents only call `python3`) ----
py_ok() { "$1" -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 10) else 1)' 2>/dev/null; }

find_python() {
  local c
  for c in python3.14 python3.13 python3.12 python3.11 python3.10; do
    command -v "$c" >/dev/null && py_ok "$c" && { command -v "$c"; return 0; }
  done
  for c in /opt/homebrew/bin/python3.1[0-9] /usr/local/bin/python3.1[0-9] \
           /opt/homebrew/bin/python3 /usr/local/bin/python3 \
           /Library/Frameworks/Python.framework/Versions/3.1[0-9]/bin/python3; do
    [ -x "$c" ] && py_ok "$c" && { echo "$c"; return 0; }
  done
  return 1
}

ensure_python() {
  echo ""
  echo "==> Python 3.10+"
  if command -v python3 >/dev/null && py_ok python3; then
    echo "    ✓ python3 is $(python3 --version 2>&1)"; return 0
  fi

  local py
  py="$(find_python)"
  if [ -z "$py" ] && [ "$(uname)" = "Darwin" ] && command -v brew >/dev/null; then
    echo "    python3 is older than 3.10. Installing Python with Homebrew:"
    echo "    brew install python@3.13"
    brew install python@3.13 && py="$(find_python)"
  fi
  if [ -z "$py" ]; then
    echo "    ✗ No Python 3.10+ found. Install it from https://www.python.org/downloads/ and run this script again."
    return 1
  fi

  # Point `python3` at the new Python via ~/.local/bin, placed first on PATH.
  mkdir -p "$HOME/.local/bin"
  ln -sf "$py" "$HOME/.local/bin/python3"
  export PATH="$HOME/.local/bin:$PATH"
  local line='export PATH="$HOME/.local/bin:$PATH"  # added by VDO for LTD (python3 >= 3.10)'
  local rc
  for rc in "$HOME/.zshrc" "$HOME/.bash_profile"; do
    [ "$rc" = "$HOME/.bash_profile" ] && [ ! -f "$rc" ] && continue
    grep -qs "added by VDO for LTD" "$rc" || printf '\n%s\n' "$line" >> "$rc"
  done
  echo "    ✓ python3 now points to $py ($(python3 --version 2>&1))"
  echo "      (symlink in ~/.local/bin, PATH line added to ~/.zshrc)"
}

ensure_python || failed+=("python")

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
