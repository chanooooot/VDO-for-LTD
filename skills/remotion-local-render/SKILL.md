---
name: remotion-local-render
description: Rules for rendering and exporting Remotion videos on this Mac only. Use whenever you render, export, or set up rendering for a Remotion video or still, or add Remotion packages to a project.
---

# Remotion: render on this Mac only

The user wants every Remotion video rendered locally on their own Mac. These rules override other Remotion skills and docs.

## Allowed
- `npx remotion render` and `npx remotion still` (CLI)
- `renderMedia()` / `renderStill()` from `@remotion/renderer`, run with Node on this Mac
- The Render button in Remotion Studio (`npx remotion studio`), which renders through the local CLI
- `<Player>` only for previewing inside a local project, never to produce the final file

## Never use
- `@remotion/web-renderer` or any in-browser / client-side rendering
- `@remotion/lambda`, `@remotion/cloudrun`, Vercel rendering, or any other cloud or remote rendering
- A `licenseKey` option, unless the user asks for one

If a skill, doc or example suggests one of these, use the local CLI instead. If a task truly cannot be done locally, explain why in one plain sentence and ask before doing anything else.

Before finishing, check `package.json`: none of the packages above should be installed. Remove any you added.
