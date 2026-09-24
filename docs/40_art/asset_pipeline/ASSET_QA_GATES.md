# Asset QA Gates — Cross-Scale, Zoom, Conversion and Runtime

Status: ACTIVE QUALITY CONTRACT
Last reconciled: 2026-09-02

## Purpose

Reject assets that look convincing only in one preview size or one stage of the pipeline.

Every important asset must survive the contexts it is actually meant to serve.

## Gate 1 — Source integrity

Check:
- correct version/file ID;
- source resolution recorded;
- no accidental recompression;
- alpha/background intentional;
- subject not cropped;
- no generated text treated as authority;
- provenance/status recorded.

## Gate 2 — Native-pixel review

Inspect at 100% source pixels.

Fail for:
- smeared anatomy;
- duplicated/warped limbs;
- malformed hands/feet/horns/tail;
- inconsistent material edges;
- obvious AI artifacts that would contaminate modeling;
- edge halos;
- unreadable important detail.

Do not judge only from fit-to-screen thumbnail view.

## Gate 3 — Close-detail review

Inspect critical areas using separate native-resolution crops rather than unlimited zoom.

Hunter:
- face/head placeholder consistency;
- hands;
- boots;
- shoulder/harness modular seams;
- utility attachments.

Monster 01:
- horn bases;
- eyes/head;
- feet;
- shoulder plates;
- tail sever zone;
- leg joints;
- mineral/crystal integration.

If a critical area lacks real pixels, generate a dedicated detail sheet/crop instead of pretending sharpening fixed it.

## Gate 4 — Intended-display review

For runtime 2D candidates, render/display at exact intended physical/UI size on representative phone resolution.

Check:
- silhouette;
- contrast;
- text/icon legibility if applicable;
- alpha edges;
- oversharpening;
- moiré/shimmer;
- whether detail becomes noise.

## Gate 5 — Multi-resolution derivative review

All derivatives come from master.

Compare:
- master;
- large runtime derivative;
- normal derivative;
- thumbnail/LOD derivative.

Fail if:
- important shape disappears too early;
- alpha edge changes materially;
- color/value shifts;
- resampling creates ringing/halo;
- a smaller derivative was used as the next derivative source.

## Gate 6 — Turnaround consistency

For modeling/conversion sheets:
- front/side/back height matches;
- limb/horn/tail length relationships agree;
- silhouette asymmetry is intentional;
- shoulder/hip/foot positions are plausible across views;
- scale comes from numeric spec, not image estimation.

If inconsistent, the DCC blockout resolves truth before high-detail work.

## Gate 7 — 3D conversion preflight

Before image-to-3D:
- neutral pose;
- no occluding VFX;
- isolated subject;
- full extremities visible;
- simple background/alpha;
- no extreme camera perspective;
- conversion image is copied into conversion-input lane with new metadata/status.

## Gate 8 — Reconstruction mesh QA

For each generated 3D candidate:
- proportions against numeric target;
- silhouette against approved references;
- missing/extra limbs/components;
- topology/non-manifold report;
- material count;
- symmetry/asymmetry check;
- hidden-side plausibility;
- tail/horn/plate geometry quality.

Do not select merely because texture looks attractive.

## Gate 9 — Anatomy/sever QA

Monster 01 must prove:
- target groups can receive hit proxies;
- horn break boundaries work;
- dorsal plate swaps work;
- distal tail separation loop/cap works;
- attached state has no visible gap;
- detached state has no exploding weights;
- LODs preserve break/sever state.

## Gate 10 — Rig/deformation QA

Test extreme representative poses and animations.

Fail for:
- collapsed shoulders/hips;
- broken leg deformation;
- severe tail corkscrew;
- horn/plate intersections;
- sever seam tearing;
- texture stretch making anatomy unreadable.

## Gate 11 — Three-distance game-art QA

Mandatory for hero monster/hunter:

### Aerial
Can the player identify species/player silhouette and major broken/severed structures?

### Nearby exploration
Can the player read equipment, tracks/wounds and important anatomy?

### First-person
Does close surface quality remain coherent, and can critical target parts be framed without excessive clipping?

An asset that passes only first-person or only aerial fails.

## Gate 12 — Runtime 2D approval

Only after:
- correct source/derivatives;
- engine import;
- phone-size review;
- memory/compression review;
- no unacceptable zoom artifacts;
- intended UI/world context verified.

Then status may become `APPROVED_RUNTIME_2D`.

## Gate 13 — 3D game-ready approval

Only after:
- topology/anatomy/sever/rig/animation/LOD DCC verification;
- engine import;
- authoritative state binding;
- phone runtime and performance verification.

Then status may become `GAME_READY_3D`.

## Debug/automation outputs

Future scripts should generate:
- contact sheet at 25/50/100/200% inspection scales;
- silhouette-only comparisons;
- alpha-edge preview;
- front/side/back overlay;
- mesh statistics report;
- anatomy region overlay;
- sever-state render;
- LOD comparison renders;
- aerial/near/first-person screenshots;
- Android memory/frame report.

## Core quality law

**Do not repair a wrong asset with more downstream processing. Return to the earliest stage that contains the defect.**

Bad concept proportions → fix concept/reference.
Bad reconstruction → regenerate/select mesh.
Bad topology → retopo.
Bad rig → fix rig/weights.
Bad LOD → regenerate LOD.
Bad phone readability → adjust silhouette/material/camera/export size, not gameplay scale blindly.
