# Pixel RPG First-Person Canonical Presentation Assets

This directory is the active first-person presentation source for Pixel RPG.

`pixel_rpg_hunter_fp_hands_neutral_r001.png` is the exact canonical 640x360 RGBA hands PNG promoted from the approved source. Its SHA-256 is recorded in `CANONICAL_HANDS_SOURCE.sha256`.

The active viewmodel references that PNG directly. A derived SVG, recreated forearm/hand mesh, or other placeholder is not allowed to replace it as the canonical hands presentation.

The hands layer is presentation-only. It owns no physics, collision, input, targeting, combat, persistence, or durable state.

See `CANONICAL_HANDS_RUNTIME_RULE.md` for the runtime lock.
