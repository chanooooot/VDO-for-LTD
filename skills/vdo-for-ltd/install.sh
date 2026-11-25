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

# ---- Helpers ----
# Put DIR first on PATH now and in future shells (once per marker).
add_to_path() {
  local dir="$1" marker="$2" rc
  export PATH="$dir:$PATH"
  local line="export PATH=\"$3:\$PATH\"  # added by VDO for LTD ($marker)"
  # .zprofile: login shells (how agents usually run commands); .zshrc: interactive terminals
  for rc in "$HOME/.zprofile" "$HOME/.zshrc" "$HOME/.bash_profile"; do
    [ "$rc" = "$HOME/.bash_profile" ] && [ ! -f "$rc" ] && continue
    grep -qsF "added by VDO for LTD ($marker)" "$rc" || printf '\n%s\n' "$line" >> "$rc"
  done
}

# pixi installs FFmpeg/Python into ~/.pixi from conda-forge: no Homebrew, no password.
PIXI_BIN="$HOME/.pixi/bin"
pixi_install() {
  if [ ! -x "$PIXI_BIN/pixi" ]; then
    echo "    Installing pixi (no password needed) into ~/.pixi"
    curl -fsSL https://pixi.sh/install.sh | PIXI_NO_PATH_UPDATE=1 bash >/dev/null || return 1
  fi
  echo "    pixi global install $*"
  "$PIXI_BIN/pixi" global install "$@" || return 1
  add_to_path "$PIXI_BIN" "pixi" '$HOME/.pixi/bin'
}

have_brew() { [ "$(uname)" = "Darwin" ] && command -v brew >/dev/null; }

# ---- Python 3.10+ as `python3` (ffmpeg-skill and the agents only call `python3`) ----
py_ok() { "$1" -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 10) else 1)' 2>/dev/null; }

find_python() {
  local c
  for c in python3.14 python3.13 python3.12 python3.11 python3.10; do
    command -v "$c" >/dev/null && py_ok "$c" && { command -v "$c"; return 0; }
  done
  for c in /opt/homebrew/bin/python3.1[0-9] /usr/local/bin/python3.1[0-9] \
           /opt/homebrew/bin/python3 /usr/local/bin/python3 \
           /Library/Frameworks/Python.framework/Versions/3.1[0-9]/bin/python3 \
           "$PIXI_BIN"/python3.1[0-9]; do
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
  if [ -z "$py" ]; then
    echo "    python3 is older than 3.10. Installing a newer Python."
    if have_brew; then
      echo "    brew install python@3.13"
      brew install python@3.13
    else
      pixi_install python=3.13
    fi
    py="$(find_python)"
  fi
  if [ -z "$py" ]; then
    echo "    ✗ Could not install Python 3.10+. Install it from https://www.python.org/downloads/ and run this script again."
    return 1
  fi

  # Point `python3` at the new Python via ~/.local/bin, placed first on PATH.
  mkdir -p "$HOME/.local/bin"
  ln -sf "$py" "$HOME/.local/bin/python3"
  add_to_path "$HOME/.local/bin" "python3 >= 3.10" '$HOME/.local/bin'
  echo "    ✓ python3 now points to $py ($(python3 --version 2>&1))"
}

# ---- FFmpeg: with Homebrew, ffmpeg-skill installs ffmpeg-full itself; without it, use pixi ----
ensure_ffmpeg() {
  echo ""
  echo "==> FFmpeg"
  if command -v ffmpeg >/dev/null && command -v ffprobe >/dev/null; then
    echo "    ✓ found $(command -v ffmpeg)"; return 0
  fi
  if have_brew || [ "$(uname)" != "Darwin" ]; then
    echo "    ffmpeg-skill setup will install it"; return 0
  fi
  pixi_install ffmpeg && command -v ffmpeg >/dev/null && echo "    ✓ installed $(command -v ffmpeg)"
}

ensure_python || failed+=("python")
ensure_ffmpeg || failed+=("ffmpeg")

# 0. This bundle's own skills (vdo-for-ltd installer + video-kickoff)
step "vdo-for-ltd" npx -y skills add chanooooot/VDO-for-LTD --skill '*' -g -a "${AGENTS[@]}" -y

# 1. FFmpeg skill: installs the skill, installs FFmpeg if missing, then runs its doctor check.
# The no-Homebrew FFmpeg (pixi/conda-forge) lacks only vid.stab (stabilisation): accept that.
ffmpeg_skill() {
  npx -y ffmpeg-skill setup
  local rc=$?
  # Homebrew's ffmpeg-full is keg-only: setup only puts it on PATH for itself, so persist it.
  if ! command -v ffmpeg >/dev/null && have_brew; then
    local keg; keg="$(brew --prefix ffmpeg-full 2>/dev/null)"
    [ -x "$keg/bin/ffmpeg" ] && add_to_path "$keg/bin" "ffmpeg-full" "$keg/bin" && echo "    added $keg/bin to PATH"
  fi
  [ $rc -eq 0 ] && return 0
  local missing
  missing="$(npx -y ffmpeg-skill doctor 2>&1 | sed -n 's/^missing required: //p')"
  [ -n "$missing" ] || return 1
  echo "$missing" | tr ',' '\n' | sed 's/^ *//' | grep -qv '^filter:vidstab' && return 1
  echo "    note: everything works except video stabilisation (this FFmpeg build has no vid.stab)."
}
step "ffmpeg-skill" ffmpeg_skill

# 2. Remotion skills (videos in React). Skip remotion-saas: it is for web apps and steers
#    towards browser/cloud rendering; this bundle renders on the local Mac only.
REMOTION_SKILLS=(remotion-best-practices remotion-captions remotion-create remotion-docs
  remotion-elements remotion-interactivity remotion-license remotion-maps remotion-markup
  remotion-multimedia remotion-render remotion-studio remotion-upgrade)
step "remotion" npx -y skills add remotion-dev/skills --skill "${REMOTION_SKILLS[@]}" -g -a "${AGENTS[@]}" -y
# Remove remotion-saas if an earlier install added it (ignore "not installed").
npx -y skills remove remotion-saas -g -a "${AGENTS[@]}" -y >/dev/null 2>&1 || true

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
