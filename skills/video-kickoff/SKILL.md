---
name: video-kickoff
description: Offers a short planning interview before starting any video work. Use when the user asks to make, create, edit, cut, caption, animate or render a video or clip, with Remotion, FFmpeg or anything else, and has not already given a detailed plan.
---

# Video kickoff

The user may not know what "grilling" means. Never use that word with them.

## Before doing any video work

If the request is already detailed (length, look, content, output format all clear), skip this skill and start working.

Otherwise ask, in plain words, exactly this one question and wait for the answer before doing anything else:

> Before I start, would you like me to ask you a few questions about the video, like what it's for, how long it should be and how it should look? It takes a couple of minutes and the result will be much closer to what you want.
> 1. Yes, ask me questions first
> 2. No, just start, and I'll fix things after

If you have a tool for asking the user multiple-choice questions, use it. Otherwise ask in a normal message and stop your turn there.

## If they choose 1

Follow the `grilling` skill. Load it the way your agent loads skills (for example the Skill tool, or by reading its SKILL.md). While it runs:
- Use simple, everyday words. No jargon.
- Always give your recommended answer, so they can just say "ok".
- Cover: purpose and audience, length, aspect ratio (16:9, 9:16, 1:1), source footage or assets, text and captions, music and audio, style, output format.

If the grilling skill is not installed, run the same interview yourself, a few questions at a time.

When the interview is done, sum up the plan in a short list, confirm it, then build the video.

For Remotion videos, always follow the `remotion-local-render` skill: render on this Mac only.

## If they choose 2

Start right away using sensible defaults, and state the defaults you picked in one short line.
