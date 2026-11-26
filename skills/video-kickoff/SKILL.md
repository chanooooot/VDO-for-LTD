---
name: video-kickoff
description: Offers a short planning interview before video work, and sets the working rules for every video task. Use whenever the user asks to make, create, edit, cut, caption, animate or render a video or clip, with HyperFrames, FFmpeg or anything else.
---

# Video kickoff

The user may not know what "grilling" means. Never use that word with them.

## Before doing any video work

If the request is already detailed (length, look, content, output format all clear), skip the question below and start working. The working rules at the end still apply.

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

When the interview is done, sum up the plan in a short list and confirm it. Then propose storyboards (below).

## If they choose 2

Pick sensible defaults and state them in one short line. Then propose storyboards (below).

## Storyboards: two options before building

For any new video or animation, before writing any code or rendering, offer two different storyboards and let the user pick. Skip this only for simple edits of existing clips (trim, cut, convert, resize, add captions or music to one clip).

- Make the two options really different (for example calm and clean vs. bold and fast), not small variations.
- Text only: no images, no renders, no code yet.
- Keep each option short: a one-line style summary, then one row per scene.

Format:

> **Option A: Clean & calm** (15 s, 9:16, soft piano)
> | # | Time | What you see | Text on screen |
> |---|---|---|---|
> | 1 | 0–3 s | Logo fades in on white | — |
> | 2 | 3–9 s | Product photo slides in | "Fresh every morning" |
> | 3 | 9–15 s | Shop address and opening hours | "Open 7am–6pm" |
>
> **Option B: Bold & fast** (15 s, 9:16, upbeat drums)
> | … same format … |
>
> Which one do you like: A, B, or a mix (for example "B, but with A's music")?

Wait for the answer. If they want changes, update only the chosen storyboard and show it again. Build the video only after they say it's good.

## Working rules (every video task)

Tools:
- For animated videos use HyperFrames (not Remotion) and follow the `hyperframes-local-render` skill: everything stays on this Mac.
- For editing existing clips use ffmpeg-skill.

Keep the work lean without lowering quality. These override other skills:
- **Frames:** after a render, look at one frame per scene, and at least 3 (start, middle, end). Look at more only while fixing something visual or when the user reports a problem.
- **Iterating:** while adjusting, show changes in the live preview (`npx hyperframes preview`) instead of rendering. Render the final file once, at `delivery` quality, when the user is happy.
- **Command output:** send long logs and JSON to a file (`> render.log 2>&1`) and read only the last lines, or the error. Never paste a whole log into the chat.
- **Replies:** short and plain. Say what changed, not the whole plan again.
- **New videos:** when a video is finished, add one short line suggesting a new chat for the next video. Never insist. The project folder stays, so a new chat can continue from it.
