# VDO for LTD

One skill that installs a set of video-making skills for Claude Code.

| Skill | Source | What it does |
|---|---|---|
| ffmpeg-skill | [kajisho5/ffmpeg-skill](https://github.com/kajisho5/ffmpeg-skill) | Cut, trim, caption and convert video/audio with FFmpeg |
| Remotion skills | [remotion-dev/skills](https://github.com/remotion-dev/skills) | Make videos in React with Remotion |
| ponytail | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | Smallest-change coding mode |
| grill-me + grilling | [mattpocock/skills](https://github.com/mattpocock/skills) | Interviews you to sharpen a plan |

## Install

Needs Node.js 18+ and Python 3.10+.

**Option A: through Claude Code**

```bash
npx skills add chanooooot/VDO-for-LTD -g -a claude-code -y
```

Restart Claude Code, then type `/vdo-for-ltd`. Claude checks your machine and installs everything.

**Option B: run the script yourself**

```bash
git clone https://github.com/chanooooot/VDO-for-LTD.git
bash VDO-for-LTD/skills/vdo-for-ltd/install.sh
```

Every skill installs globally into `~/.claude/skills`. To target another agent, set `VDO_AGENT`, for example `VDO_AGENT=cursor`.

## Update

Run `/vdo-for-ltd` again, or re-run `install.sh`.

## Credits

All bundled skills belong to their authors. This repo only installs them from their original repositories.
