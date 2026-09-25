# Pixel RPG Active Authority

Status: ACTIVE / MIGRATION-RECONCILED ON DOCUMENTATION BRANCH  
Last reconciled: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Documentation cleanup branch: `documentation`

Pixel RPG is the active project authority, and its player-facing exploration/presentation view is first-person.

The old repository `jbob-coder/Chatgptjuegolpcal@pixel-rpg` is migration/provenance history. It is not current implementation authority.

Archived, quarantined, superseded, unrelated, or historical material may be consulted only for provenance or where current source/tests prove a live technical dependency. It must not direct current camera, visual identity, sprite selection, world presentation, gameplay identity, build state, or implementation priorities merely because it exists.

Current authority order:

1. current explicit creator instruction;
2. live `jbob-coder/pixel-rpg-goblin-underwater@main` source;
3. exact implementation owner;
4. exact tests for that owner;
5. exact same-SHA build/device evidence;
6. current GitHub issue register;
7. current migration/stale-document audit;
8. narrow owner/package documentation that still matches source;
9. historical handoffs for provenance only.

Current first-person invariants to preserve unless a bounded current task explicitly changes them compatibly:

- direct active `Camera3D` first-person path;
- camera-relative movement and independent look;
- hidden third-person presentation body;
- explicit transient camera/touch ownership;
- current collision/state ownership boundaries;
- current targeting;
- Combat Bridge 002 no-attack domain bootstrap;
- deterministic combat/anatomy/status domain ownership;
- Android build/export pipeline.

Canonical first-person hands are already integrated in current source through:

`game/assets/characters/first_person/pixel_rpg_hunter_fp_hands_neutral_r001.png`

and:

`game/assets/characters/first_person_viewmodel_01.tscn`.

The ViewModel is presentation-only.

For image-derived presentation, approved Pixel RPG assets may replace visible procedural placeholders while invisible gameplay/collision support remains authoritative. Remove duplicated visible placeholders only after parity/integration verification.

Current repository navigation:

`docs/00_project/PIXEL_RPG_REPOSITORY_WHERE_IS_WHAT_MAP_2026-09-25.md`

Current master scan/reference:

`docs/00_project/PIXEL_RPG_REPOSITORY_SCAN_MASTER_REFERENCE_2026-09-25.md`

Known migration audit:

`docs/00_authority/PENDING_CORROBORATION_AUDIT_2026-09-24.md`

This file is an authority barrier, not a gameplay specification and not physical-device evidence.
