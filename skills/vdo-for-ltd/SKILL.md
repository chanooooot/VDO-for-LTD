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

## Steps

1. Tell the user what will be installed (the table above), and that the installer may also:
   - install FFmpeg (Homebrew, winget or apt) if it is missing, which can take a few minutes;
   - make sure `python3` is version 3.10+ (ffmpeg-skill needs it). If `python3` is older but a newer Python exists, it links `~/.local/bin/python3` to it and adds `~/.local/bin` to PATH in `~/.zshrc`. On a Mac with no newer Python, it runs `brew install python@3.13` first.

   Ask them to confirm and wait for the answer.
2. Check `node --version` (needs 18+). If Node is missing, tell them to install it from https://nodejs.org and stop.
3. Run `install.sh` from the same folder as this SKILL.md:
   ```bash
   bash "<folder containing this SKILL.md>/install.sh"
   ```
   It downloads packages and writes to `~/.agents/skills` and `~/.claude/skills`, so it needs network access and permission to write outside the project. If your sandbox blocks that, ask the user to approve it. Allow at least 10 minutes.
4. Report which steps passed and which failed, using the summary at the end of the output. For a failure, show the relevant error lines and suggest the fix.
5. Tell the user to restart Codex or Claude Code, then just describe the video they want. The agent will offer to ask them a few planning questions first.

To update later, run the same installer again.
