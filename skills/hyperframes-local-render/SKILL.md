---
name: hyperframes-local-render
description: Rules for making HyperFrames videos on this Mac only, with no uploads and no usage tracking. Use whenever you create, preview, render or export a HyperFrames video, run any `hyperframes` command, or get media for a video.
---

# HyperFrames: this Mac only, nothing sent out

The user wants every video made and rendered on their own Mac, with nothing uploaded and no usage tracking. These rules override the `hyperframes`, `hyperframes-cli`, `media-use` and every other skill, doc or example.

## Always
- Run every `hyperframes` command with tracking off:
  ```bash
  HYPERFRAMES_NO_TELEMETRY=1 DO_NOT_TRACK=1 npx hyperframes <command>
  ```
- Render locally: `npx hyperframes render --quality looks -o out.mp4` (`draft` while iterating, `delivery` for the final file).
- Preview locally: `npx hyperframes preview`. It opens a browser tab on this Mac only.
- Get media with free local tools only (local files, FFmpeg, local speech-to-text, built-in registry blocks).

## Never
- `cloud`, `lambda`, `cloudrun` (remote rendering)
- `share`, `publish` (they upload the video)
- `auth` / logging in to HeyGen, or any HeyGen API, avatar, voice or generated-video service
- `feedback`, `events`, `telemetry enable` (usage reports)

If a skill or doc says to do one of these, skip it. If a task truly cannot be done locally, explain why in one plain sentence and ask before doing anything else.

## Check before every render

```bash
HYPERFRAMES_NO_TELEMETRY=1 npx hyperframes telemetry status
```

It must say telemetry is disabled. If not, run `npx hyperframes telemetry disable`, then render.
