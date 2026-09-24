# Pixel RPG — New Chat Continuation Prompt

Use this launcher in a new ChatGPT conversation when continuing the project. The live repository and `START_HERE_NEW_CHAT.md` remain authoritative.

---

@GitHub

You are continuing active development of my Android monster-hunting RPG.

Repository: `jbob-coder/Chatgptjuegolpcal`
Active branch: `pixel-rpg`
Active game: `Pixel RPG`

WorldLife is abandoned. The later standalone first-person Shooter RPG is also not authoritative for Pixel RPG.

## FIRST ACTION — MANDATORY

Before coding, generating assets, changing balance or architecture:
1. fetch live HEAD of `pixel-rpg`;
2. read `EVOLVE_ALIGNMENT.md`;
3. read `PROJECT_HANDOFF.md`;
4. read `START_HERE_NEW_CHAT.md` completely;
5. read `DOCUMENTATION_INDEX.md`;
6. read `PIXEL_RPG_VISUAL_DIRECTION.md`;
7. read `GAME_EXPERIENCE_BIBLE.md`;
8. read `NEW_GAME_ARCHITECTURE_VISUAL_BIBLE.md`;
9. read root `README.md`;
10. read the newest relevant Pixel RPG handoff under `docs/70_handoff/`;
11. read `game/README.md` and exact owning source/tests/workflows for the bounded piece;
12. re-fetch HEAD and restart reconstruction if it changed materially.

## AUTHORITY ORDER

1. current explicit user instruction;
2. current source/tests/build/device evidence;
3. `PIXEL_RPG_VISUAL_DIRECTION.md` for current presentation;
4. `EVOLVE_ALIGNMENT.md` / `PROJECT_HANDOFF.md` and narrow owners;
5. package/local docs;
6. older handoffs/chat/memory.

Do not rewrite historical evidence to pretend older builds already used the Pixel RPG presentation.

## SELECTED DIRECTION

- third-person behind-character gameplay;
- pixel-styled real 3D world/UI;
- landscape Android-first;
- left-stick movement;
- independent right-side camera/look;
- physical compact exploration;
- same-world third-person monster combat;
- body-part targeting/break/sever/harvest;
- persistent NPC/world consequences;
- deep, coherent, expandable scope rather than a massive open world.

Do not import the standalone Shooter RPG first-person 115° camera, firearm-first identity, wall-jump progression, `shooter_game/` runtime or shooter package/build assumptions.

## VISUAL REFERENCES

Google Drive:
- `Pixel RPG - Visual Reference ORIGINAL.png` — `1IcZDQAEPUVpSpvJsvaVZsLqAA0RJmaxp`;
- `Pixel RPG - Visual Reference.jpg` — `1NYHm1Y_CPQOb22ZQsF9e45T5uFV3Mh_b`.

Visible concept names/text are placeholders unless current authority says otherwise.

## EXPECTED NEXT BOUNDED PIECE

Unless live EVOLVE has changed:
`PIXEL_RPG_THIRD_PERSON_VISUAL_PROTOTYPE_001`.

Prototype:
- one small settlement gate/street;
- one third-person player controller;
- left-stick move + right-side look;
- one NPC interaction;
- one short route outside town;
- one monster/proxy;
- coherent pixel treatment;
- safe-area HUD;
- static/headless/build verification where available.

Do not rewrite the entire project before this slice is accepted.

## VERIFICATION DISCIPLINE

Keep separate: DESIGNED, IMPLEMENTED, STATIC_VERIFIED, HEADLESS_VERIFIED, ANDROID_BUILD_VERIFIED, PHONE_RUNTIME_VERIFIED, VISUAL_QUALITY_VERIFIED, PERFORMANCE_VERIFIED.

Never claim phone, visual-quality or performance verification from CI/build success alone.

## REQUIRED PRE-START REPORT

Report live HEAD, last actually verified source baseline, objective, verified state, exact next bounded piece, owning files, tests/gates, blockers, open questions, expected changes, protected behavior and contradictions. If continuation was already requested and no genuine blocker exists, proceed after reconstruction without asking again.
