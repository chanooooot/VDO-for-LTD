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
# Add LINE to every shell profile once (identified by MARKER).
# .zprofile: login shells (how agents usually run commands); .zshrc: interactive terminals
add_profile_line() {
  local marker="$1" line="$2  # added by VDO for LTD ($1)" rc
  for rc in "$HOME/.zprofile" "$HOME/.zshrc" "$HOME/.bash_profile"; do
    [ "$rc" = "$HOME/.bash_profile" ] && [ ! -f "$rc" ] && continue
    grep -qsF "added by VDO for LTD ($marker)" "$rc" || printf '\n%s\n' "$line" >> "$rc"
  done
}

# Put DIR first on PATH now and in future shells.
add_to_path() {
  export PATH="$1:$PATH"
  add_profile_line "$2" "export PATH=\"$3:\$PATH\""
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
    # Our link from an earlier run: make sure every shell profile has the PATH line.
    [ -L "$HOME/.local/bin/python3" ] && add_to_path "$HOME/.local/bin" "python3 >= 3.10" '$HOME/.local/bin'
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
    # Installed by pixi in an earlier run: make sure every shell profile has the PATH line.
    case "$(command -v ffmpeg)" in "$PIXI_BIN"/*) add_to_path "$PIXI_BIN" "pixi" '$HOME/.pixi/bin' ;; esac
    echo "    ✓ found $(command -v ffmpeg)"; return 0
  fi
  if have_brew || [ "$(uname)" != "Darwin" ]; then
    echo "    ffmpeg-skill setup will install it"; return 0
  fi
  pixi_install ffmpeg && command -v ffmpeg >/dev/null && echo "    ✓ installed $(command -v ffmpeg)"
}

# ---- Node.js 22+ (HyperFrames needs it); without Homebrew, use pixi ----
node_major() { node -p 'process.versions.node.split(".")[0]' 2>/dev/null || echo 0; }
ensure_node() {
  echo ""
  echo "==> Node.js 22+"
  if [ "$(node_major)" -ge 22 ]; then
    case "$(command -v node)" in "$PIXI_BIN"/*) add_to_path "$PIXI_BIN" "pixi" '$HOME/.pixi/bin' ;; esac
    echo "    ✓ node $(node --version)"; return 0
  fi
  echo "    node $(node --version 2>/dev/null) is older than 22. Installing Node.js 22."
  if have_brew; then
    brew install node@22 && add_to_path "$(brew --prefix node@22)/bin" "node@22" "$(brew --prefix node@22)/bin"
  else
    pixi_install nodejs=22
  fi
  [ "$(node_major)" -ge 22 ] && echo "    ✓ node $(node --version)"
}

# ---- No usage tracking from HyperFrames (and other tools that honour DO_NOT_TRACK) ----
export HYPERFRAMES_NO_TELEMETRY=1 DO_NOT_TRACK=1
add_profile_line "no telemetry" "export HYPERFRAMES_NO_TELEMETRY=1 DO_NOT_TRACK=1"

ensure_node || failed+=("node")
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

# Remove skills this bundle no longer uses. The skills CLI leaves the shared ~/.agents copy
# (Codex) and its lock entry behind, so delete those directly.
remove_skill() {
  local name="$1"
  local claude="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/$name"
  [ -e "$HOME/.agents/skills/$name" ] || [ -e "$claude" ] || [ -L "$claude" ] || return 0
  npx -y skills remove "$name" -g -a "${AGENTS[@]}" -y >/dev/null 2>&1 || true
  rm -rf "$HOME/.agents/skills/$name" "$claude"
  local lock="$HOME/.agents/.skill-lock.json"
  [ -f "$lock" ] && python3 - "$lock" "$name" <<'PY'
import json, sys
path, name = sys.argv[1], sys.argv[2]
try:
    data = json.load(open(path))
except Exception:
    sys.exit(0)
skills = data.get("skills")
if isinstance(skills, dict) and skills.pop(name, None) is not None:
    json.dump(data, open(path, "w"), indent=2)
PY
  echo "    removed old skill: $name"
}
# Remotion was replaced by HyperFrames (no licence risk).
for old in remotion-best-practices remotion-captions remotion-create remotion-docs remotion-elements \
           remotion-interactivity remotion-license remotion-maps remotion-markup remotion-multimedia \
           remotion-render remotion-saas remotion-studio remotion-upgrade remotion-local-render; do
  remove_skill "$old"
done

# 2. HyperFrames core skills (HTML -> MP4, Apache-2.0)
HF_SKILLS=(hyperframes hyperframes-cli hyperframes-registry media-use reverse-any-video style-sampling)
step "hyperframes" npx -y skills add heygen-com/hyperframes --skill "${HF_SKILLS[@]}" -g -a "${AGENTS[@]}" -y
npx -y hyperframes telemetry disable >/dev/null 2>&1 || true

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
