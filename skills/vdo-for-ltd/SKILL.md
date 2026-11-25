---
name: vdo-for-ltd
description: Installs the VDO for LTD video-making skill set (ffmpeg-skill, Remotion skills, ponytail, grill-me). Use when the user says "vdo for ltd", "install video skills", "set up video skills", or asks to install or update this bundle.
disable-model-invocation: true
---

# VDO for LTD: skill set installer

This bundle installs four skill sets for making videos:

| Skill | Source | What it does |
|---|---|---|
| ffmpeg-skill | kajisho5/ffmpeg-skill | Cut, trim, caption and convert video/audio with FFmpeg |
| Remotion skills | remotion-dev/skills | Make videos in React with Remotion |
| ponytail | DietrichGebert/ponytail | Smallest-change coding mode, keeps generated code lean |
| grill-me + grilling | mattpocock/skills | Interviews you to sharpen a video plan before building |

## Steps

1. Tell the user what will be installed (the table above). Mention that `ffmpeg-skill setup` may install FFmpeg itself through Homebrew, winget or apt if it is missing, which can take a few minutes. Ask them to confirm.
2. Check prerequisites: `node --version` (needs 18+) and `python3 --version` (ffmpeg-skill needs 3.10+). If either is missing, tell them how to install it and stop.
3. Run the installer that sits next to this file:
   ```bash
   bash "<this skill's directory>/install.sh"
   ```
   Use a timeout of at least 10 minutes.
4. Report which steps passed and which failed, using the summary at the end of the output. For a failure, show the relevant error lines and suggest the fix.
5. Tell the user to restart Claude Code, then try `/grill-me` to plan a video, or ask for a Remotion or FFmpeg task.

To update later, run the same installer again.
