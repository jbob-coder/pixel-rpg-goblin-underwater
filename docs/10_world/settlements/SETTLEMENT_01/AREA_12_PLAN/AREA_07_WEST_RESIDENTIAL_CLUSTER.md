# Area 07 — West Residential Cluster

Status: FINAL_REFERENCE_GENERATED / SPATIAL_CHECK_PASS / CREATOR REVIEW PENDING
Parent section: `SET01_S03`  
Area ID: `SET01_A07_WEST_RESIDENTIAL_CLUSTER`

## Purpose

Area 07 is the quieter local-living district west of the civic core.

It supports:
- two primary residence plots;
- small yards;
- resident daily-life anchors;
- low-density props;
- local path connection to Community Hall and the north/south settlement routes.

## Core buildings

Initial:
- Residence W01
- Residence W02

Both derive from Residence Type A:
- 7×5.5 m footprint
- east-facing real doorway
- simple one-room + private/rest zone interior

## Visual composition

Standalone pixel-art residential cluster only.

Show:
- two compact houses;
- separated yards;
- local lane;
- woodpile / small storage;
- one bench;
- 2–3 lanterns;
- low fence segments;
- one small shared green/tree pocket;
- sparse residents.

Do not show:
- market stalls;
- smith equipment;
- civic hall dominating frame;
- dense urban street.

## Yard language

House W01:
- woodpile
- bench/stool
- small fence/yard marker

House W02:
- storage chest/crates
- optional garden/laundry-style low-cost prop
- lantern

Keep both yards visually distinct while sharing the same residence family.

## Circulation

West frontage lane remains clear.

Target:
- 4.5 m frontage lane
- no yard prop intrudes into primary lane

Small footpath from each house to the frontage lane.

## NPC density

Reference:
- 3–6 resident figures maximum.

Runtime can be lower.

## Anchors

Planned:
- `A07_ResidenceW01Entrance`
- `A07_ResidenceW02Entrance`
- `A07_ResidentIdle_01..04`
- `A07_YardAnchor_W01`
- `A07_YardAnchor_W02`
- `A07_Connector_A06`
- `A07_Connector_North`
- `A07_Connector_South`

## Collision

- houses use segmented collision with real doorway;
- yard fences use modular simple collision only if player-blocking is intentional;
- small props mostly presentation-only.

## Image brief

Generate only Area 07.

Desired view:
- high 3/4 deliberate pixel art;
- two compact residences;
- readable lane and yards;
- quiet local-life character;
- no full settlement or infographic.

## Acceptance checklist

Approve only if:
- clearly residential;
- two houses share a family but are not identical;
- lane remains open;
- yard prop density controlled;
- no market/work-district visual language;
- genuine pixel art.


## Accepted reference artifact

Reference ID:
`REF_SET01_A07_WEST_RESIDENTIAL_CLUSTER_R001`

Accepted pixel-art artifact:
- source file: `AREA_07_WEST_RESIDENTIAL_CLUSTER_R001.png`
- dimensions: 1152×768
- bytes: 8,015
- SHA-256: `7795764a2b82c184dfde27f5f4979fc267564b559ebbd278d89d03ec4e1971d6`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Area References/AREA_07_WEST_RESIDENTIAL_CLUSTER_R001.png`
- Library file ID: `libfile_9482f1206518819194a4b7f6f73d9c1f`
- backing file ID: `file_00000000834081f69078fd6432500e8d`

Disposition:
- accepted as current Area 07 pixel-art reference;
- residence family geometry remains building-blueprint authority.


## Technical asset review / model sheets

Technical asset review:
`../AREA_ASSET_REVIEWS/AREA_07_WEST_RESIDENTIAL_CLUSTER_ASSET_REVIEW.md`

Model-sheet package:
`../MODEL_SHEETS/AREA_07/`

Final-reference placement authority:
`FINAL_AREA_REFERENCE_SPATIAL_LOCK_2026-09-26.md`

Current state:
- R001 concept reference preserved;
- technical asset review complete;
- primary model-sheet contracts ready;
- final position-locked reference still requires regeneration;
- runtime implementation not started;
- device visual verification not started.


## Final position-locked reference F001

Reference ID:
`FINAL_REF_SET01_A07_F001`

Artifact:
- filename: `AREA_07_WEST_RESIDENTIAL_CLUSTER_F001_LOCKED.png`
- dimensions: 660×1092
- bytes: 7,385
- SHA-256: `6aa89680506dd155375b3a60037da16162864550af0cd1923495dc8f79b4583d`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Final Area References/AREA_07_WEST_RESIDENTIAL_CLUSTER_F001_LOCKED.png`
- Library file ID: `libfile_86d731ea32fc8191b399bc2ee082d36c`
- backing file ID: `file_000000008cac81f682cafebc716e8225`

Spatial validation:
- north = image top;
- full relation frame uses X -30..-14 / Z -14..+14;
- W02 remains at center -24.5,-10;
- Community Hall remains at center -24.5,0 between the residences;
- W01 remains at center -24.5,+10;
- all three east-facing approaches connect toward the fixed West Frontage Lane;
- no residential building was moved into the Hall parcel or road lane.

Disposition:
`SPATIAL_CHECK_PASS`

Creator visual approval:
`PENDING`

Runtime implementation:
`NOT STARTED`
