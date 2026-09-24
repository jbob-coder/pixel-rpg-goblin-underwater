# Pixel RPG — Branch Recovery Handoff — 2026-09-16

Status: ACTIVE RECOVERY RECORDED / PIXEL RPG AUTHORITY RESTORED / STANDALONE SHOOTER REJECTED
Branch: `pixel-rpg`

## User decision

The user explicitly rejected continuing the separate Shooter game and instructed development to continue with the Pixel RPG.

Pixel RPG is therefore the active game/project direction.

## Recovery action

The existing `shooter-rpg` branch had moved beyond the user's earlier third-person pixel RPG pivot into a separate standalone first-person shooter with its own runtime/package/camera/movement direction.

That later Shooter state is not Pixel RPG authority.

To prevent accidental inheritance, `pixel-rpg` was recovered to commit:
`7ac7e84a6b0e8249ea8c869cf96171b834b2363c`

This is the last known branch point containing the intended third-person pixel monster-hunting RPG direction before the later standalone shooter rewrite.

New Pixel RPG authority was then added on top of that recovery point.

## Active authority

Primary visual/presentation authority:
`PIXEL_RPG_VISUAL_DIRECTION.md`

Active branch:
`pixel-rpg`

Current front doors:
- `EVOLVE_ALIGNMENT.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `DOCUMENTATION_INDEX.md`;
- `README.md`;
- `NEW_CHAT_CONTINUATION_PROMPT.md`;
- `VISUAL_REFERENCE_ASSETS.md`.

## Saved visual references

Google Drive:
- `Pixel RPG - Visual Reference ORIGINAL.png` — ID `1IcZDQAEPUVpSpvJsvaVZsLqAA0RJmaxp`;
- `Pixel RPG - Visual Reference.jpg` — ID `1NYHm1Y_CPQOb22ZQsF9e45T5uFV3Mh_b`.

These are visual direction references, not implementation evidence. Visible names/text are placeholders.

## Selected direction

- third-person behind-character player-visible camera;
- pixel-styled real 3D;
- Android landscape-first;
- left virtual stick movement;
- independent right-side camera/look;
- compact physical exploration rather than normal menu teleportation;
- same-world third-person monster combat;
- anatomy/body-part damage, break/sever and harvesting preserved;
- persistent NPC/world consequences;
- small, dense, expandable scope.

## Shooter separation

Do not import as Pixel RPG authority:
- standalone Shooter RPG first-person 115° HFOV contract;
- firearm-first game identity;
- shooter wall-jump progression;
- `shooter_game/` as active runtime root;
- `com.jbobcoder.shooterrpg` package identity;
- Shooter-specific Android artifact evidence.

A generic “shooter-style mobile control layout” can still describe left-stick + right-look ergonomics; it does not change Pixel RPG into a shooter.

## Preserved monster-hunting foundations

Potentially reusable where current source confirms compatibility:
- deterministic combat/action resolution;
- anatomy/body-part ownership;
- monster wound/status logic;
- break/sever/harvest rules;
- tracking/encounter continuity;
- stable IDs/data-driven content;
- Android/test infrastructure;
- regression/autorun verification tools.

Historical production evidence remains evidence only for its exact older source revision.

## Current verification boundary

`PIXEL_RPG_DIRECTION_RESTORED = YES`
`PIXEL_RPG_REFERENCE_IMAGE_SAVED = YES`
`PIXEL_RPG_THIRD_PERSON_PROTOTYPE_IMPLEMENTED = NO`
`PIXEL_RPG_ANDROID_BUILD_VERIFIED = NO`
`PIXEL_RPG_PHONE_RUNTIME_VERIFIED = NO`
`PIXEL_RPG_VISUAL_QUALITY_VERIFIED = NO`
`PIXEL_RPG_PERFORMANCE_VERIFIED = NO`

## Branch deletion limitation

The currently connected GitHub action set exposes branch creation/ref movement and file deletion but does not expose branch-ref deletion. Therefore the obsolete `shooter-rpg` ref cannot be truthfully marked deleted from this session.

It is non-authoritative and should be deleted through GitHub UI/CLI or another connector that exposes delete-ref capability.

## Exact next bounded piece

`PIXEL_RPG_THIRD_PERSON_VISUAL_PROTOTYPE_001`

First implementation slice:
1. inspect exact current `game/` player/presentation/HUD source;
2. preserve compatible gameplay/domain logic;
3. implement one small settlement gate/street;
4. implement one third-person controller;
5. left-stick movement + right-side camera/look;
6. one NPC interaction target;
7. one short physical route;
8. one monster/proxy;
9. coherent pixel presentation;
10. phone-safe HUD;
11. run the highest available static/headless/Android build gates;
12. keep phone/visual/performance acceptance separate until observed.
