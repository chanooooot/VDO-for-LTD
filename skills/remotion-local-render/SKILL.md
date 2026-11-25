---
name: remotion-local-render
description: Rules for rendering and exporting Remotion videos on this Mac only. Use whenever you render, export, or set up rendering for a Remotion video or still, or add Remotion packages to a project.
---

# Remotion: render on this Mac only

The user wants every Remotion video rendered locally on their own Mac. These rules override every other Remotion skill, doc and example.

## Allowed
- `npx remotion render` and `npx remotion still` (CLI). This is the default way to make the final file.
- `renderMedia()` / `renderStill()` from `@remotion/renderer`, run with Node on this Mac
- The Render button in Remotion Studio (`npx remotion studio`). Studio opens in a browser tab only as a preview; its Render button renders locally.
- `<Player>` only for previewing inside a local project, never to produce the final file

## Never use
- `@remotion/web-renderer`, `renderMediaOnWeb`, or any in-browser / client-side rendering
- `@remotion/lambda`, `@remotion/cloudrun`, `@remotion/vercel`, or any other cloud or remote rendering
- A `licenseKey` option, unless the user asks for one

If anything suggests one of these, use the local CLI instead. If a task truly cannot be done locally, explain why in one plain sentence and ask before doing anything else.

## Required check before every render

Run the check script that sits next to this SKILL.md, from the Remotion project folder:

```bash
bash "<folder containing this SKILL.md>/check.sh" .
```

- `✓ Local-only`: go ahead and render with `npx remotion render`.
- `✗ Not local-only`: remove what it lists (uninstall the package, delete the import or code), run the check again, and only render once it passes. Do not render while it fails.
