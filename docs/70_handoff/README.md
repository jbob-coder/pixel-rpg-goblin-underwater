# 70_handoff — Historical Continuity Records

Status: HISTORICAL / NON-AUTHORITATIVE UNLESS CURRENT BOOTSTRAP EXPLICITLY NAMES A SPECIFIC HANDOFF
Last reconciled: 2026-09-24
Branch: `pixel-rpg`

## Authority barrier

This directory preserves historical implementation, migration, verification, and continuation records. Files here do **not** become current Pixel RPG design, camera, visual, sprite, gameplay, or runtime authority merely because they exist in this directory or were once build-verified.

Current work must begin from:
1. `/START_HERE_NEW_CHAT.md`;
2. `/docs/00_authority/PIXEL_RPG_ACTIVE_AUTHORITY.md`;
3. current explicit creator instruction;
4. current `pixel-rpg` source/tests/build/device evidence;
5. the current root alignment/handoff documents named by the bootstrap.

A historical handoff may be read only when the current bootstrap or the bounded task explicitly requires that specific record for provenance, compatibility, or verification. If a historical handoff conflicts with current first-person Pixel RPG authority, the current authority wins.

## What belongs here

- bounded-piece handoffs;
- migration plans/readbacks;
- package status snapshots;
- supersession records;
- source/build/runtime verification summaries;
- historical camera/presentation checkpoints;
- exact evidence needed to reconstruct what a past revision actually did.

## Preservation rule

Historical evidence remains traceable and must not be rewritten to pretend an old build implemented a newer design. Old third-person or other superseded presentation evidence may remain here as factual history, but it is never current presentation authority.

Reusable technical history is allowed only when current Pixel RPG source/tests demonstrate a live dependency. In that case it is a technical legacy dependency, not design authority.

## Verification language

Keep these states separate:

`source/readback ≠ Godot parse ≠ headless/runtime gate ≠ APK build ≠ phone install ≠ phone runtime ≠ visual acceptance ≠ sustained performance`

No file in this directory may silently change mechanics or override an owning current authority.
