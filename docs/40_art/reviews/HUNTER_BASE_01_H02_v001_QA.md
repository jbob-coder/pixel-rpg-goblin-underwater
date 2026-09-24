# Hunter Base 01 — H02 Turnaround + Scale v001 QA

Status: REVIEWED / REVISION REQUIRED
Decision: `REVISE`
Last reconciled: 2026-09-02

## Asset identity

Stable asset ID: `HUNTER01-H02-REF-001`
File: `HUNTER_BASE_01_H02_TURNAROUND_SCALE_v001_DRAFT_REFERENCE.png`
Drive file ID: `1U9vm0y7YSSGnEiPYO8C7M8QAq43FyibV`
Class: `REFERENCE_MASTER` for this generated revision.
Owning hunter design: `docs/30_content/hunters/HUNTER_BASE_01/README.md`.

Related inspection derivative:
- `HUNTER01-H02-UPSCALEREF-001`
- `HUNTER_BASE_01_H02_TURNAROUND_SCALE_v001_DRAFT_UPSCALED_REFERENCE.png`
- Drive file ID: `1hcxXoOH6xsy-CXh2EoyhnjgIH_etizOc`

## Intended role

This sheet was intended to become a clean modeling/turnaround reference for Hunter Base 01 and, if it passed conversion preflight, a possible source for a later dedicated image-to-3D input.

It does **not** pass that role in v001.

## Evidence inspected

- full 3200 × 1800 composed H02 sheet;
- native/detail crop of front/side/back figure group;
- upscaled reference derivative;
- current Hunter Base 01 design authority;
- `ASSET_QA_GATES.md`;
- `RASTER_RESOLUTION_AND_ZOOM_QUALITY.md`.

## What v001 gets right

Preserve these directions in v002 unless a later user decision changes them:
- grounded frontier hunter tone;
- believable adult human overall proportion rather than chibi/heroic caricature;
- readable shoulder/boot/utility silhouette from a distance;
- layered clothing/armor concept rather than a single body suit;
- roughly coherent front/side/back overall height;
- practical dark leather/cloth/metal material family;
- no extreme ornamental fantasy silhouette;
- 1.75 m remains the authoritative prototype height from Markdown, not from generated text.

The visual direction is therefore worth revising rather than discarding.

# QA gate results

## Gate 1 — Source integrity
Result: `PASS WITH LIMITATIONS`.

Verified:
- exact Drive file identity exists;
- source file is preserved;
- the upscale is recorded as a derivative rather than silently replacing the source.

Limitations:
- the visible turnaround figures originate from a lower-detail generated panel embedded inside the larger composed sheet;
- generated labels inside the art are not reliable technical annotation.

## Gate 2 — Native-pixel review
Result: `FAIL FOR MODELING DETAIL`.

Observed:
- face/eyes/beard are soft and partly artifact-like;
- hands lack enough real source detail for finger/glove/gauntlet modeling;
- boot closures and lower-leg armor are too blurred to resolve consistently;
- small straps, buckles, seam lines and plate boundaries merge into painterly noise;
- surface detail does not justify the apparent 3200 × 1800 canvas size because the figure art itself contains far fewer useful pixels.

Conclusion:
large canvas dimensions do not equal adequate subject detail.

## Gate 3 — Close-detail review
Result: `FAIL`.

Critical areas requiring dedicated clean reference in v002 or later detail sheets:
- hands/glove shape;
- boot construction;
- shoulder/harness attachment;
- belt/pouch attachment;
- neck/collar layering;
- knee/shin transition.

The upscaled derivative makes these areas larger but does not recover authoritative missing structure.

## Gate 4 — Intended-display review
Result: `NOT APPLICABLE FOR RUNTIME APPROVAL`.

This is a modeling reference, not a runtime 2D asset.

At thumbnail/normal viewing size, the silhouette reads acceptably, which is useful directional evidence only.

## Gate 5 — Multi-resolution derivative review
Result: `PASS AS REFERENCE-ONLY LINEAGE`.

The upscale remains traceable to v001.

It must remain `DISCUSSION_ONLY`; it is not a new master and is not a valid conversion input simply because it contains more pixels.

## Gate 6 — Turnaround consistency
Result: `FAIL`.

Observed cross-view problems:
- only front, one side, and back are presented cleanly; the required 3/4 confirmation view is absent;
- shoulder/upper-arm plate shapes do not match precisely between front, side, and back;
- chest/harness strap routing changes across views;
- lower coat/skirt panels and belt/pouch placement shift across views;
- shin/knee/boot details are not sufficiently consistent;
- arm/hand resting position differs enough to complicate exact overlay/blockout;
- the views are illustrative rather than strict orthographic/turntable-consistent projections;
- generated facial/hair identity is stronger than desired for a reusable base whose final protagonist identity remains OPEN.

These contradictions make direct image-to-3D use unsafe.

## Gate 7 — 3D conversion preflight
Result: `FAIL`.

Reasons:
- no clean isolated four-view set;
- no reliable 3/4 confirmation;
- view consistency insufficient;
- generated source detail insufficient in hands/boots/gear seams;
- current styling carries too much view-specific armor information;
- current sheet includes presentation layout rather than clean task-specific conversion inputs.

Do not copy H02 v001 or its upscale into `03_3D_Conversion_Inputs/Hunter`.

## Gate 11 — Three-distance art suitability
Result: `PARTIAL / DIRECTIONAL ONLY`.

Aerial/medium silhouette:
- broadly readable;
- boots, shoulders and layered lower garment survive reduction reasonably well.

Close/first-person:
- current source does not contain enough trustworthy detail for final close use.

# Design reconciliation

Hunter Base 01 is intended as a reusable practical frontier-human production base, not the final story identity.

The v001 reference trends too heavily toward a finished armored male ranger/warrior identity:
- pronounced beard/hair identity;
- substantial metal chest/arm/leg coverage;
- strong fixed ornamental strap/plate solution.

For v002, reduce premature identity lock and move the neutral base closer to:
- layered cloth/leather foundation;
- limited protective plate on gameplay-relevant areas;
- removable/modular shoulder/forearm/shin protection;
- simple neutral head/hair placeholder or less identity-specific face;
- cleaner attachment boundaries for equipment variants.

This does not prohibit a later reinforced armor loadout. It prevents the reusable base turnaround from accidentally becoming the reinforced loadout by default.

# v002 exact revision request

Create a new master rather than editing/upscaling v001 into authority.

Required v002 views:
1. front orthographic-like neutral view;
2. left side orthographic-like neutral view;
3. back orthographic-like neutral view;
4. right side if generation budget permits;
5. clean 3/4 front confirmation view on a separate panel or sheet.

Required pose:
- neutral modeling stance;
- feet parallel/consistent;
- arms slightly separated from torso so armpit/gear topology is visible;
- hands relaxed and unobstructed;
- no weapon held;
- no cape/large dangling object covering body seams.

Required visual construction:
- same shoulder width, limb length, hand size, boot height and waist position in every view;
- same harness path and pouch count/placement;
- same collar/shoulder protection in every view;
- clear modular boundaries between base clothing and removable protection;
- less metal coverage than v001 for the neutral base;
- no generated numeric labels touching the figure;
- plain neutral background or transparent isolated figures;
- no dramatic lighting or perspective;
- no final weapon design;
- no strong story-specific facial identity.

Required resolution behavior:
- generate the figure views as the primary image, not as small elements inside a giant infographic;
- reserve enough native pixels that hands, boots, harness seams and shoulder attachments can be inspected without relying on AI upscale invention;
- if one generation cannot provide adequate details, create separate hand/boot/harness detail references rather than pretending one image can solve every scale.

# Decision

Primary decision: `REVISE`.

Current review state:
`REVIEWED_WITH_ISSUES`.

Permitted use for v001:
- `DISCUSSION_ONLY`.

Not permitted:
- `MODELING_REFERENCE_OK` — NO for technical modeling decisions;
- `DETAIL_REFERENCE_OK` — NO;
- `CONVERSION_TEST_OK` — NO;
- `RUNTIME_2D_TEST_OK` — NO.

Directional ideas may be reused when creating v002, but v001 must not be treated as the technical turnaround authority.

Upscaled derivative disposition:
- retain for provenance/inspection;
- `DISCUSSION_ONLY`;
- never use to infer new anatomy or exact gear construction.

# Next bounded action

Generate **Hunter H02 v002 only** from the revision requirements above, then perform the same QA gates before reviewing H04 or Monster 01.

Do not generate the whole remaining sheet queue in the same step.