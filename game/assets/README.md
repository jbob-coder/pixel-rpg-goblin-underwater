# Production Stylized Asset Kit

Status: FIRST IMPLEMENTED VISUAL KIT / PRIMITIVE-MESH PRODUCTION PLACEHOLDERS / FIRST COMBAT TELEGRAPH ASSET ADDED
Last reconciled: 2026-09-04

Purpose: provide reusable grounded-stylized 3D presentation assets for the Android production project while approved final 3D exports are still unavailable.

Visual authority:
- `MODEL_ART_DIRECTION_AND_ASSET_STANDARD.md` — grounded stylized 3D / illustrated realism;
- Google Drive finished-game visual concept `1JSCDYW8A1JvW9Xht535uvcnRFbru44_U`;
- Hunter orthographic reference `1EjeitWONWZ2PHPbVkI-dvcVIoiL7bcfE`;
- Mudcrest Raker visual candidate `1yMLP6lcO4Us4uJO2CMNUCusiXlWpwI2m`.

The Drive `04_Approved_Exports/3D_Game_Ready` folder was empty when this kit was created. Therefore these files are intentionally lightweight reusable Godot scenes built from smooth primitive meshes and restrained materials. They are not claimed as final hero art.

Implemented runtime assets:
- `environment/stylized_pine.tscn`;
- `environment/stylized_rock_cluster.tscn`;
- `characters/hunter_visual.tscn`;
- `creatures/mudcrest_raker_visual.tscn`;
- `effects/mudcrest_head_sweep_telegraph.tscn`.

## Mudcrest Head Sweep telegraph

`effects/mudcrest_head_sweep_telegraph.tscn` is a lightweight, non-colliding presentation asset for `M01_HEAD_SWEEP_GORE`.

Runtime owner:
`game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_attack_runtime.gd`.

Behavior:
- instantiated only after a legal Head Sweep commits and its reaction window opens;
- positioned/oriented in the real same-location encounter around the Monster/Hunter relation;
- communicates the front sweep threat band visually;
- disappears after the hostile resolution handoff commits;
- has no collision body/shape and therefore cannot become hidden gameplay authority.

The visual telegraph supplements the authoritative runtime telegraph and legality checks. It does not define attack range, cover, hit quality or damage.

Rules:
- natural muted palette; no neon debug blocks in normal gameplay presentation;
- readable silhouette from aerial/first-person tactical context;
- non-pixel presentation;
- controlled material roughness and broad value groups instead of noisy textures;
- debug/clearance geometry must stay hidden from normal gameplay unless explicitly requested;
- gameplay telegraphs may be visible during their legitimate action window but must remain presentation-only unless separately authored as gameplay collision;
- later final model/effect exports may replace scene internals without changing gameplay identity/collision ownership.