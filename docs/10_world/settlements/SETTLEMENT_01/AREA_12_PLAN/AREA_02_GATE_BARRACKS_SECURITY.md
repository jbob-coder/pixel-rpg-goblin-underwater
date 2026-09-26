# Area 02 — Gate Barracks & Security

Status: FINAL_REFERENCE_GENERATED / SPATIAL_CHECK_PASS / CREATOR REVIEW PENDING
Parent section: `SET01_S01`  
Area ID: `SET01_A02_GATE_BARRACKS_SECURITY`

## 1. Purpose

Area 02 is the working security zone immediately inside/alongside the South Arrival Gate.

It is not another gate image.

It should communicate:
- guards live/work here;
- patrols originate here;
- duty equipment is stored here;
- visitors have crossed the public threshold and entered the protected settlement;
- security exists without making the settlement feel like a military fortress.

## 2. Relationship to Area 01

Area 01:
- gate opening;
- greeting/arrival;
- visitor flow.

Area 02:
- guard operations;
- barracks/duty yard;
- equipment;
- patrol staging;
- secondary security anchors.

Area 02 should sit beside the arrival route, not block it.

## 3. Planned composition

Preferred image viewpoint:
- high 3/4 pixel-art game view;
- one contained security yard;
- no full-settlement overview;
- Area 02 only.

Core elements:
- compact guard barracks/duty building;
- open security yard;
- equipment rack;
- shield/spear/training rack;
- duty notice board;
- small covered briefing area;
- 2 watch/guard posts maximum;
- bench/rest point;
- lanterns;
- fence/wall edge;
- visible but unobstructed main-road edge.

## 4. Building target

Primary barracks/duty building:
- provisional footprint: about 8×6 m;
- one story;
- compact pitched roof;
- real doorway;
- small guard room/interior;
- no giant dormitory.

Internal functions:
- duty desk;
- equipment storage;
- guard rest/briefing nook.

## 5. Yard target

Open yard:
- about 10×10 m usable visual zone;
- center remains mostly clear;
- equipment around perimeter;
- one training target optional;
- no large combat arena.

## 6. Props

Required visual categories:
- weapon/equipment rack;
- duty board;
- crates/supply chest;
- bench;
- lantern;
- shield/spear display;
- patrol gear.

Optional:
- simple training dummy/target;
- water barrel;
- small awning.

Avoid:
- torture devices;
- dungeon/cells as dominant theme;
- oversized military siege gear;
- dozens of weapons.

## 7. NPC density

Reference image:
- 4–7 guard figures maximum;
- 1–2 active duty positions;
- 1 briefing/rest cluster.

Runtime target can be lower.

No hero character should dominate the image.

## 8. Visual language

Match Area 01:
- deliberate pixel art;
- timber + stone base;
- blue/neutral settlement security accents if retained;
- warm lanterns;
- compact readable silhouettes.

But Area 02 should feel more utilitarian and less ceremonial than the gate.

## 9. Navigation

Keep:
- clear 4.5–5 m circulation route along the security zone;
- no rack/bench blocking the main road;
- obvious building entrance;
- open sightline toward Area 01 and Area 03.

## 10. Collision intent

Future:
- barracks uses segmented building collision;
- equipment racks use simple collision only if large enough;
- small props presentation-only;
- fence/wall separate modular collision.

## 11. Anchors

Planned:
- `A02_GuardDutyAnchor`
- `A02_PatrolStartAnchor`
- `A02_BriefingAnchor`
- `A02_EquipmentUseAnchor`
- `A02_GuardIdleAnchor_01`
- `A02_GuardIdleAnchor_02`
- `A02_RoadConnector_A01`
- `A02_RoadConnector_A03`

## 12. Image-generation brief

Generate **only Area 02**.

Prompt intent:
Original pixel-art RPG settlement security yard immediately inside a civilian settlement gate. Compact guard barracks, open patrol yard, equipment racks, duty board, shield/spear storage, briefing canopy, benches, lanterns, modest wall/watch elements, 4–7 guards, clear road edge. Practical frontier security, not a fortress, not a giant military camp. High 3/4 game-map view, crisp deliberate pixel art, readable object separation, compact mobile-game density, no full settlement, no collage, no blueprint panels, no large text labels, original IP.

## 13. Acceptance checklist

Approve only if:
- image shows Area 02 only;
- clearly different function from Area 01;
- main circulation remains visible;
- barracks is compact;
- yard is readable;
- prop density controlled;
- security theme is clear without fortress scale;
- pixel art is genuine/readable rather than painterly.


## Generation attempt record

Multiple 2026-09-25 image-generation attempts drifted back into whole-settlement / twelve-area overview infographics instead of producing the required standalone Area 02 scene.

Disposition:
- **REJECTED AS AREA-02 REFERENCE**
- do not archive/promote those overview images as Area 02;
- keep this specification authoritative;
- retry only with a generation path that can honor a single-area scene reliably.

No rejected overview image is considered `REFERENCE_GENERATED` for Area 02.


## Accepted visual reference

Reference ID:
`REF_SET01_A02_GATE_BARRACKS_SECURITY_R001`

Persisted archive:
- Library path: `/Pixel RPG/Settlement 01/Area References/AREA_02_GATE_BARRACKS_SECURITY_R001.png`
- Library file ID: `libfile_d23b6419e71481919403009dfe6d009b`
- backing file ID: `file_00000000c57081f68bfdfda82dbeb839`
- MIME: `image/png`

Image properties:
- dimensions: 1152×768
- source construction canvas: 384×256
- nearest-neighbor scale: 3×
- bytes: 9,014
- SHA-256: `b62d64add0f57be79696a2e0347fbc21dbe4aebd04bfe1115ca23e95700c9600`

This accepted reference is deliberate low-resolution pixel art constructed from the Area 02 specification.

## Reference interpretation

Keep:
- compact guard barracks;
- open patrol/security yard;
- equipment racks;
- duty board;
- briefing canopy;
- benches;
- lanterns;
- modest guard count;
- visible clear road edge.

Refine before runtime:
- align final barracks footprint to exact settlement parcel once Area 02 runtime bounds are authored;
- keep guard count performance-bounded;
- collision remains independent;
- authored signage replaces placeholder label/text;
- preserve the main-road clearance.

Earlier full-settlement infographic outputs are explicitly rejected and are not part of Area 02 asset authority.


## Canonical R001 archive

The canonical R001 archive is the unsuffixed Library file recorded above:
- path: `/Pixel RPG/Settlement 01/Area References/AREA_02_GATE_BARRACKS_SECURITY_R001.png`
- Library file ID: `libfile_d23b6419e71481919403009dfe6d009b`
- backing file ID: `file_00000000c57081f68bfdfda82dbeb839`

Accidental duplicate-safe copies `(1)` and `(2)` were removed from the Library on 2026-09-26. They were byte-identical duplicates and carried no independent authority.

## Asset extraction and model sheets

Technical asset review:
`../AREA_ASSET_REVIEWS/AREA_02_GATE_BARRACKS_SECURITY_ASSET_REVIEW.md`

Model-sheet package:
`../MODEL_SHEETS/AREA_02/`

Current state:
- reference generated and archived;
- technical reference review passed;
- primary model-sheet contracts ready;
- runtime implementation not started;
- device visual verification not started.


## Final-reference placement authority

`FINAL_AREA_REFERENCE_SPATIAL_LOCK_2026-09-26.md`

The archived R001 image remains a concept/asset reference.

A later final reference must be regenerated against the locked coordinates, orientation, neighbor edges, streets and building parcels before runtime placement is approved.


## Final position-locked reference F001

Reference ID:
`FINAL_REF_SET01_A02_F001`

Artifact:
- filename: `AREA_02_GATE_BARRACKS_SECURITY_F001_LOCKED.png`
- dimensions: 840×714
- bytes: 6,302
- SHA-256: `f10d6c21623e29d16322fad5e093cf4361eb0fc1e96b5eda5886f5b47b6374e8`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Final Area References/AREA_02_GATE_BARRACKS_SECURITY_F001_LOCKED.png`
- Library file ID: `libfile_bcd1f43499908191a798027f74ca176e`
- backing file ID: `file_000000009c0c81f6916cfc1e566a6d00`

Spatial validation:
- north = image top;
- frame uses X -30..-12 / Z +14..+29;
- Barracks locked to center -20,+23;
- Barracks footprint fixed at 7×6 m;
- bounds X -23.5..-16.5 / Z +20..+26;
- east-side circulation lane remains open;
- northbound connection remains readable;
- yard equipment stays outside the primary connector.

Disposition:
`SPATIAL_CHECK_PASS`

Creator visual approval:
`PENDING`

Runtime implementation:
`NOT STARTED`
