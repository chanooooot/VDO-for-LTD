# VDO for LTD

A set of video-making skills for **Codex** and **Claude Code**, installed with one command.

**Easiest way:** paste this into Codex or Claude Code:

> Install this for me: https://github.com/chanooooot/VDO-for-LTD

## Instructions for AI agents installing this

If a user asked you to install this repo, follow these steps exactly. The user may not be technical: use plain, friendly words, no jargon, and never ask them to edit files or type commands.

1. **Do not** install it by copying a skill folder (for example with a skill-installer). That skips most of the bundle. Run the installer script below instead.
2. Run this one command (it needs network access and writes outside the project, so request approval if your sandbox asks, and allow at least 10 minutes):
   ```bash
   bash -c "$(curl -fsSL https://raw.githubusercontent.com/chanooooot/VDO-for-LTD/main/skills/vdo-for-ltd/install.sh)"
   ```
   If the user needs to click "Approve" or "Allow", tell them in one short sentence what to click and why.
3. Read the summary at the end of the output.
   - "All done": tell the user it worked, and that they should quit and reopen the app. After that they can just describe the video they want.
   - "npx not found": the user needs Node.js. Tell them: "Please open https://nodejs.org, download the LTS version, and double-click it to install, like any other app. Tell me when it's done." Then run step 2 again.
   - "No Python 3.10+ found": tell them: "Please open https://www.python.org/downloads/, click the big yellow Download button, and double-click the file to install. Tell me when it's done." Then run step 2 again.
   - ffmpeg-skill failed because FFmpeg is missing and there is no Homebrew: install FFmpeg yourself if you can do it without asking for a password, otherwise explain in one sentence and give the simplest option for their system.
   - Anything else: fix it yourself if you can, then run step 2 again. Only ask the user when you truly need them.
4. Never show the user raw error output unless they ask. Summarise in one sentence.

## What it installs

| Skill | Source | What it does |
|---|---|---|
| ffmpeg-skill | [kajisho5/ffmpeg-skill](https://github.com/kajisho5/ffmpeg-skill) | Cut, trim, caption and convert video/audio with FFmpeg |
| Remotion skills | [remotion-dev/skills](https://github.com/remotion-dev/skills) | Make videos in React with Remotion |
| ponytail | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | Smallest-change coding mode |
| grill-me + grilling | [mattpocock/skills](https://github.com/mattpocock/skills) | Interviews you to sharpen a plan |
| video-kickoff | this repo | Before any video task, asks if you'd like a few planning questions first |

## Manual install

Needs Node.js 18+. The installer also makes sure `python3` is 3.10+ (macOS ships 3.9): it uses a newer Python if you have one, or installs one with Homebrew, then points `python3` at it through `~/.local/bin` and a PATH line in `~/.zshrc`.

**Option A: one command in Terminal**

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/chanooooot/VDO-for-LTD/main/skills/vdo-for-ltd/install.sh)"
```

This installs this repo's skills plus all the skills above, for both Codex (`~/.agents/skills`) and Claude Code (`~/.claude/skills`).

**Option B: through your agent**

```bash
npx skills add chanooooot/VDO-for-LTD --skill '*' -g -a codex claude-code -y
```

Restart your agent, then ask it to run the installer:
- Codex: type `$vdo-for-ltd`, or pick it from `/skills`
- Claude Code: type `/vdo-for-ltd`

The agent checks your machine and installs everything else.

To install for other agents, set `VDO_AGENTS`, for example `VDO_AGENTS="codex cursor" bash install.sh`.

## Using it

Just describe the video you want. The agent asks whether you'd like it to interview you about the details first. Pick "yes" if you're not sure exactly what you want.

## Update

Re-run `install.sh`, or the installer skill.

## Credits

All bundled skills belong to their authors. This repo only installs them from their original repositories.
