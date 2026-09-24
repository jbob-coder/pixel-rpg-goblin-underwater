# Pixel RPG Repository Authority

Status: ACTIVE
Effective date: 2026-09-24

## Canonical development location

- Repository: `jbob-coder/pixel-rpg-goblin-underwater`
- Canonical branch: `main`
- Engine: Godot 4.7.2
- Presentation: first-person

This repository and branch are the active source of truth for continued Pixel RPG development.

## Migration provenance

The current repository was populated from the historical Pixel RPG source branch at source snapshot `b2021e043db88fac31beacfdca843c310e68bbee`, then continued with additional commits in this repository. The historical source repository remains provenance only; it is not an active write target and must not be treated as current authority.

The migration automation was temporary and must not be reintroduced as a recurring `main` workflow. A migration process that uses destructive synchronization such as `rsync --delete` against a moving historical source is prohibited for normal development because it can overwrite repository-only work.

## Authority rules

1. Fetch current `main` HEAD from this repository before changing anything.
2. Current source/tests/build evidence and current Pixel RPG authority docs outrank historical handoffs and repository history.
3. Historical assets/docs may be retained for provenance, but they do not govern current presentation, camera, controls, gameplay identity, or priorities.
4. First-person is authoritative.
5. CI success is not physical-device verification.
6. Never weaken a legitimate test or provenance check merely to make CI green.
7. Build-affecting changes must record source SHA and test/build evidence.

## Branch compatibility

A `pixel-rpg` compatibility branch may exist, but `main` is canonical. It must not diverge into a second authority line. If it is retained, keep it aligned intentionally and never instruct new work to begin there by default.
