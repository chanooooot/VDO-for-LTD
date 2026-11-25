# VDO for LTD

A set of video-making skills for **Codex** and **Claude Code**, installed with one command.

| Skill | Source | What it does |
|---|---|---|
| ffmpeg-skill | [kajisho5/ffmpeg-skill](https://github.com/kajisho5/ffmpeg-skill) | Cut, trim, caption and convert video/audio with FFmpeg |
| Remotion skills | [remotion-dev/skills](https://github.com/remotion-dev/skills) | Make videos in React with Remotion |
| ponytail | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | Smallest-change coding mode |
| grill-me + grilling | [mattpocock/skills](https://github.com/mattpocock/skills) | Interviews you to sharpen a plan |
| video-kickoff | this repo | Before any video task, asks if you'd like a few planning questions first |

## Install

Needs Node.js 18+. The installer also makes sure `python3` is 3.10+ (macOS ships 3.9): it uses a newer Python if you have one, or installs one with Homebrew, then points `python3` at it through `~/.local/bin` and a PATH line in `~/.zshrc`.

**Option A: one script (simplest)**

```bash
git clone https://github.com/chanooooot/VDO-for-LTD.git
bash VDO-for-LTD/skills/vdo-for-ltd/install.sh
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
