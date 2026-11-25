---
name: vdo-for-ltd
description: Installs or updates the VDO for LTD video-making skill set (ffmpeg-skill, Remotion skills, ponytail, grill-me). Use only when the user explicitly asks to install, set up or update this bundle or the video skills.
disable-model-invocation: true
---

# VDO for LTD: skill set installer

Works in Codex and Claude Code. Installs these skill sets globally for both agents:

| Skill | Source | What it does |
|---|---|---|
| ffmpeg-skill | kajisho5/ffmpeg-skill | Cut, trim, caption and convert video/audio with FFmpeg |
| Remotion skills | remotion-dev/skills | Make videos in React with Remotion |
| ponytail | DietrichGebert/ponytail | Smallest-change coding mode, keeps generated code lean |
| grill-me + grilling | mattpocock/skills | Interviews you to sharpen a video plan before building |
| video-kickoff | this repo | Asks "want me to interview you first?" before any video task |
| remotion-local-render | this repo | Renders Remotion videos on this Mac only: no browser or cloud rendering |

## Steps

1. Tell the user, in plain friendly words, what will be installed (the table above), and that the installer may also set up FFmpeg and a newer Python if they are missing. No password is needed: without Homebrew it uses pixi, installed into `~/.pixi`. It adds a few PATH lines to `~/.zprofile` and `~/.zshrc`. Ask them to confirm and wait for the answer.
2. Check `node --version` (needs 18+). If Node is missing, tell them to install it from https://nodejs.org and stop.
3. Run `install.sh` from the same folder as this SKILL.md:
   ```bash
   bash "<folder containing this SKILL.md>/install.sh"
   ```
   It downloads packages and writes to `~/.agents/skills` and `~/.claude/skills`, so it needs network access and permission to write outside the project. If your sandbox blocks that, ask the user to approve it. Allow at least 10 minutes.
4. Read the summary at the end of the output and tell the user the result in one plain sentence. Do not show raw error output unless they ask.
   - "everything works except video stabilisation" counts as success. Do not try to fix it or mention it unless they later ask to stabilise shaky footage.
   - "No Python 3.10+" / "Could not install Python 3.10+": ask them to install Python from https://www.python.org/downloads/ (big yellow Download button, double-click the file), then run the installer again.
   - Anything else: fix it yourself if you can and run the installer again. Only ask the user when you truly need them.
5. Tell the user to restart Codex or Claude Code, then just describe the video they want. The agent will offer to ask them a few planning questions first.

To update later, run the same installer again.
