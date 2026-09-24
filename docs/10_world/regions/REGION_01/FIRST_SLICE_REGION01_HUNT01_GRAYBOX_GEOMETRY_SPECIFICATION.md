# REGION_01 — Hunt-01 Graybox Geometry Specification

Status: SELECTED FIRST-SLICE GRAYBOX GEOMETRY SPECIFICATION / NO ENGINE GRAYBOX IMPLEMENTATION
Last reconciled: 2026-09-03

Technical owner: `docs/10_world/regions/REGION_01/`
Concrete primitive/volume registry: `FIRST_SLICE_HUNT01_GRAYBOX_GEOMETRY_REGISTRY.md`

## Purpose

Translate the already-recorded Hunt-01 coordinates into measurable primitive blockout geometry for only the first physical proof corridor:

`R01_S00 -> R01_S01 -> R01_S03 -> R01_EF02 -> escape stub toward R01_S05`.

Primary law:

**Graybox geometry must make the recorded hunt physically buildable without changing topology, inventing new Monster abilities, turning technical sector boundaries into visible walls, or promoting prototype measurements into runtime/phone truth.**

This specification owns:
- Hunt-01 route cross-sections and grade targets;
- River Ford shallow-water/mud/dry-bank blockout dimensions;
- S01->S03 route rise/visibility-break geometry;
- Feeding Meadow / EF02 terrain height bands;
- tactical-node marker and link-clearance geometry;
- physical cover primitive dimensions/tolerances;
- Monster Charge/pivot/body-force/escape clearance volumes;
- camera-transition clearance debug volumes;
- Hunt-01 streaming/grace debug proxies;
- geometry validation targets for later scene construction.

It does not own:
- final terrain meshes/materials;
- final Monster/Hunter collider dimensions;
- final attack range meters;
- final navigation/controller thresholds;
- final camera altitude/FOV;
- production streaming meter values;
- production scene/node hierarchy;
- runtime implementation;
- phone/performance verification.

Supporting authorities:
- `FIRST_SLICE_REGION01_TRACKING_TO_ENCOUNTER_GRAYBOX_INTEGRATION_CONTRACT.md`;
- `FIRST_SLICE_HUNT01_SPATIAL_LAYOUT_REGISTRY.md`;
- `REGION_TOPOLOGY.md`;
- `TRACKING_AND_ESCAPE.md`;
- `TERRAIN_ECOLOGY_MUTATION.md`;
- `ENCOUNTER_FOOTPRINTS.md`;
- `STREAMING_AND_PERFORMANCE.md`;
- `ACCEPTANCE_CHECKLIST.md`;
- `/docs/10_world/spatial/FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_CONTRACT.md`;
- `/docs/10_world/spatial/FIRST_SLICE_SPATIAL_COORDINATE_REGISTRY.md`;
- `/docs/30_content/monsters/MONSTER_01/ANATOMY_AND_DAMAGE.md`;
- `/docs/30_content/monsters/MONSTER_01/COMBAT_ATTACK_PACKET.md`;
- `/docs/20_gameplay/combat/FIRST_SLICE_TERRAIN_EFFECT_SET_CONTRACT.md`;
- `/docs/50_technical/persistence/FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_CONTRACT.md`.

---

# 1. Status language

`LOCKED/CURRENT`:
- `1 world unit = 1 meter`;
- world-axis convention;
- Region 01 canonical sector IDs/topology;
- Hunt/Monster/encounter/footprint stable IDs;
- Hunter Base 01 height `1.75 m`;
- same-persistent-Monster continuity law.

`PROTOTYPE BUILD TARGET`:
- route widths/grades;
- terrain-patch dimensions;
- bank/water/mud dimensions;
- observation/meadow height bands;
- evidence/cover/node/debug volumes;
- Monster-clearance volumes;
- streaming debug grace proxies.

`DEBUG ONLY`:
- evidence inspection/placement volumes;
- camera clearance columns/tubes;
- tactical-node marker cylinders;
- streaming/grace proxy boxes.

`OPEN`:
- production terrain sculpt;
- final collider dimensions;
- final navigation slope/step constants;
- final camera path;
- final streaming grace width;
- production-final coordinates after measured graybox evidence;
- target-phone performance.

---

# 2. Coordinate frame

All values use:
- space: `space_region_01`;
- meters;
- `+X East`;
- `+Y Up`;
- `-Z North`.

Existing Hunt-01 anchor coordinates remain authoritative unless a later measured correction is explicitly recorded.

Graybox route geometry may curve between anchors. It must not silently relocate stable evidence/Monster/node anchors to make construction easier.

---

# 3. Hunt-01 required-route centerline

Build the required proof route using this centerline order:

```text
anchor_r01_h01_depart_s00 (0,0,-45)
-> anchor_r01_h01_choice_s00 (0,0,-65)
-> EV01 (-24,0,-68)
-> canonical S00<->S01 route anchor (-45,-1,-82)
-> EV02 (-70,-2,-110)
-> Monster/wallow area near (-100,-4,-142)
-> anchor_r01_h01_choice_s01 (-72,-2,-153)
-> EV04 water exit (-78,-3,-168)
-> canonical S01<->S03 route anchor (-62,0,-188)
-> EV06 feeding remains (-59,4,-220)
-> EV07 (-67,4,-232)
-> observation (-72,5,-236)
-> N01 (-70,4,-238)
```

Straight/polyline planning length through these route-control points is approximately `279 m` before smoothing the final observation descent.

Selected build target after route curvature/smoothing:
`285–315 m` navigable required-route length from S00 departure to N01.

This remains inside the previous broader Hunt-01 `260–340 m` graybox target.

Do not lengthen the route with meaningless switchbacks merely to hit a number.

---

# 4. Required-route grade and step law

For the Hunt-01 proof corridor:
- normal required-route sustained grade target: `<= 15%`;
- short intentional transition target: `<= 18%`;
- no required vertical step/ledge above `0.25 m` until the eventual player-controller implementation proves a different safe threshold;
- normal required-route cross-slope target: `<= 8%`;
- no tiny ledge/platforming sequence is allowed.

These are graybox comfort targets, not final movement-controller constants.

The observation-to-N01 direct chord would drop about 1 m over only ~2.8 m horizontal distance and is therefore **not** the traversable surface.

Required solution:
- create a `6–7 m` curved/ramped approach between the observation shelf and N01;
- maintain `<=18%` grade;
- minimum clear walking width `3.5 m`;
- no permanent solid overhead/side obstruction that would invalidate the camera transition.

---

# 5. S00 departure and route-choice geometry

## `H01_GB_S00_DEPART_PAD`
Center:
`(0,0,-45)`.

Prototype footprint:
`18 m X × 14 m Z`.

Target:
- stable/mostly level ground;
- height variation inside pad `<=0.35 m`;
- clear player orientation toward the outer fork;
- no large-Monster combat inside the protected camp core.

## `H01_GB_S00_CHOICE_CLEARING`
Center:
`(0,0,-65)`.

Prototype footprint:
`24 × 20 m`.

Purpose:
- make the S01/S02 route decision readable without a permanent glowing waypoint;
- hold the first evidence/landmark interpretation space.

West/S01 branch mouth:
- `7 m` normal traversable surface;
- `9 m` permanent-solid-free large-body corridor through the historical Monster passage portion;
- widen to `10–12 m` at meaningful bends.

East/S02 branch mouth:
- minimum `6 m` clear hunter route for the first `20–30 m` visible branch;
- remains physically legal even though it is not the intended first-proof path.

The geometry must not close the S02 route simply because fresh evidence favors S01.

---

# 6. S00 -> S01 route corridor

Selected corridor from S00 fork through EV01 / canonical S00-S01 anchor / EV02 toward the River Ford:

Player walking surface:
`>= 7 m` clear where it is the primary route.

Historical Mudcrest Raker passage corridor where the current proof needs large-body travel:
`>= 9 m` permanent-solid-free width.

At turns/bends used by the Monster:
- target clear width `10–12 m`;
- avoid a hard 90-degree corner;
- prototype centerline bend radius target `>=10 m`.

Overhead permanent-solid clearance on Monster path:
`>=4.5 m`.

The Raker's current body target is ~6.6 m long / ~3.0 m shoulder-body height. Exact width/turn radius remains OPEN; these route dimensions are conservative environment targets only.

Expected vertical profile on the recorded polyline is gentle:
- EV01 -> canonical anchor: ~4% grade;
- canonical anchor -> EV02: ~3%;
- EV02 -> wallow: ~5%.

Required build target for this section:
`<=10%` sustained centerline grade unless a later measured correction is recorded.

Brush/reeds may visually narrow the corridor while their collision still preserves required passage.

---

# 7. S01 River Ford / wallow micro-zone

The first proof does not graybox all of EF01 as combat space. It builds only the tracking/wallow geometry required for Hunt-01.

## `H01_GB_S01_FORD_BASIN`
Planning center:
`(-90,-3.3,-145)`.

Prototype envelope:
`58 × 54 m` X×Z.

Vertical working band:
approximately `Y -4.6 .. -1.5 m`.

This envelope may overlap broader existing EF01 planning geometry but does not redefine EF01's encounter contract.

## `H01_GB_S01_SHALLOW_WATER_MAIN`
Center:
`(-92,-4,-149)`.

Prototype visible/traversable water envelope:
`34 × 18 m`.

Prototype orientation:
roughly `20–30°` from the east-west axis as needed to fit the recorded approach/exit anchors.

Required-route water depth:
`0.15–0.55 m`.

Off-route visible shallow edge may reach approximately `0.65 m`, but first-slice Hunt-01 never requires swimming.

No random slip/fall is created by this geometry.

## `H01_GB_S01_WALLOW_MUD`
Center:
`(-100,-4,-142)`.

Prototype mud/wallow footprint:
`16 × 12 m`.

Prototype maximum local depression below surrounding bank:
`0.35–0.45 m`.

The fresh wallow evidence anchor lies inside this patch.

## `H01_GB_S01_EXIT_MUD`
Center:
`(-79,-3,-165)`.

Prototype mud patch:
`20 × 12 m`.

Purpose:
- support fresh water-exit track evidence;
- transition from shallow-water/mud context into the S01->S03 route.

## Dry-bank working shelves

Required approach/exit banks should provide at least:
- `8 m` usable dry/firm width at the main route shoulders where Hunt-01 needs inspection/repositioning;
- sustained traversable bank slope target `<=12°`;
- short local traversable bank slope `<=15°`;
- steeper `25–35°` decorative/non-route erosion faces are allowed only outside the required path.

No required bank edge may create an unavoidable >0.25 m vertical step.

## Reeds / brush

Reed/brush bands may be `3–6 m` deep around water margins.

They are visibility/presentation context unless a real trunk/root/rock collider exists. Do not convert the entire reed band into invisible solid cover.

---

# 8. Hunt-01 evidence placement volumes

These volumes are **DEBUG/authoring placement bounds only**, not gameplay detection radii.

- `EV01_OUTER_PRINTS`: route strip ~`8 × 3 m` around `(-24,0,-68)`;
- `EV02_BANK_REEDS`: disturbed-bank strip ~`10 × 4 m` around `(-70,-2,-110)`;
- `EV03_FRESH_WALLOW`: evidence volume ~`14 × 10 × 2 m` around `(-100,-4,-140)` / wallow patch;
- `EV04_WATER_EXIT`: track strip ~`10 × 4 m` around `(-78,-3,-168)`;
- `EV05_OLD_ROOT_SCRAPE`: local inspection box ~`4 × 2 × 2.5 m` around `(-35,-1,-145)`;
- `EV06_FEEDING_REMAINS`: disturbed feeding patch ~`8 × 6 m` around `(-59,4,-220)`;
- `EV07_FLATTENED_GRASS_AUDIO`: grass/disturbance patch ~`10 × 8 m` around `(-67,4,-232)`.

The final render footprint of each clue may be smaller than its authoring volume.

Coordinates remain developer truth only; no player GPS is implied.

---

# 9. S01 -> S03 ascent corridor

Required route:
water exit `(-78,-3,-168)`
-> canonical S01/S03 route anchor `(-62,0,-188)`
-> feeding-edge approach `(-59,4,-220)`.

Recorded straight 3D length through these points is about `58 m`.

Vertical rise:
about `7 m`.

Prototype route target:
- central hunter walking surface `>=6 m`;
- Monster-capable permanent-solid-free corridor `>=9 m` where the same Raker path is required;
- bend widening to `10–11 m` around the canonical route anchor;
- permanent-solid overhead clearance `>=4.5 m`;
- sustained route grade target `<=14%`;
- short transition maximum `<=16%`;
- no mandatory step >0.25 m.

The current anchor-derived grades (~12%) fit this target without a platforming section.

---

# 10. S01 -> S03 visibility breaks

The player must not see the Feeding Meadow Monster from the River Ford merely because coordinates are known.

Use two prototype graybox visibility structures.

## `H01_GB_VIS01_BANK_RISE`
Planning center:
`(-68,1,-190)`.

Approx cross-route footprint:
`22 m wide × 8 m deep`.

Relief:
`~2.0–2.5 m` above the lower route side.

Purpose:
- break long River-Ford-to-Meadow sightline;
- preserve a physically readable rising trail rather than a hidden loading wall.

Required Monster route opening through/around the rise:
`>=9 m`.

## `H01_GB_VIS02_MEADOW_EDGE_SCREEN`
Planning center:
`(-62,4,-222)`.

Approx visual mass envelope:
`28 × 10 m`.

Visual height band:
`~2.5–4 m` using brush/tree/terrain forms.

Maintain a `>=9 m` Monster-capable route opening.

This is not one giant invisible collider. Solid collision belongs only to deliberately authored trunk/root/rock primitives.

---

# 11. S03 Feeding Meadow / EF02 base terrain

Existing footprint:
- center `(-45,4,-250)`;
- envelope `76 × 60 m`.

## `H01_GB_EF02_MEADOW_FLOOR`
Prototype working terrain patch:
`70 × 54 m` centered near the existing EF02 center.

Primary playable height band:
`Y 3.5 .. 5.5 m`.

Open-center target:
approximately `48 × 34 m` with local relief generally `<=0.4 m` between tactical-node pads unless a High-Ground node explicitly uses a higher lip.

The footprint has no invisible combat wall.

## West approach / brush belt

Prototype west-edge brush/soft-cover belt:
`10–14 m` deep.

Purpose:
- preserve the observation approach;
- provide partial visual concealment;
- avoid placing solid cover across the initial Charge lane.

## Feeding-site disturbance

Around Monster pre-contact feed position near `(-20,4,-258)`:
prototype disturbed-grass/feeding patch `14 × 12 m`.

This patch is evidence/activity presentation, not a damage/terrain buff zone.

---

# 12. Observation shelf and N01 descent

## `H01_GB_OBSERVATION_SHELF_W`
Center:
`(-72,5,-236)`.

Prototype usable shelf:
`16 × 12 m`.

Height variation:
`<=0.4 m` inside the primary standing/observation portion.

The shelf must support a Monster silhouette read at ~56 m without exposing the entire Region graph.

## N01 descent

Observation anchor -> N01 direct coordinate separation is only ~3 m while dropping 1 m.

Do not use a straight steep cut.

Build a `6–7 m` curved/ramped path inside the west-edge geometry:
- walking width `>=3.5 m`;
- grade `<=18%`;
- no step >0.25 m;
- maintain camera-clearance volume from section 18.

The player arrives at exact N01 coordinate `(-70,4,-238)`.

---

# 13. Tactical-node graybox marker standard

The ten node coordinates remain in `FIRST_SLICE_HUNT01_SPATIAL_LAYOUT_REGISTRY.md`.

For graybox/debug authoring only, place at each node:
- visible marker disc/cylinder `2.0 m` diameter;
- marker height/thickness `0.20–0.25 m`;
- local standable-pad target `>=5 m` diameter where terrain/cover geometry allows;
- no permanent overhead obstruction below `3 m` inside the immediate Hunter standing pad.

For each recorded legal node link:
- target hunter movement corridor width `>=3.5 m`;
- preserve the recorded link unless measured geometry proves it invalid;
- do not create new links solely because two nodes are visually close;
- no mandatory jump/climb in first-slice link geometry.

Node-marker size is not the player collision radius.

---

# 14. Physical cover geometry

## `R01_EF02_COV01_BOULDER_W`
Existing anchor/center:
`(-61,4.8,-253)`.

Prototype solid blockout:
- X size `5.0 m`;
- Z size `4.0 m`;
- height `3.0 m`;
- rough yaw target `15–25°` from world axes to avoid a perfect rectangular wall silhouette;
- partial ground embedding `~0.5–0.8 m` acceptable.

Placement tolerance before validation:
- center X/Z `±0.75 m`;
- vertical `±0.25 m`;
- each horizontal dimension `±0.5 m`.

Hard requirements:
- must physically intercept Monster->N02 line when the Hunter is behind it;
- must not block the full central footprint;
- must remain outside the initial Charge-lane clear volume;
- current plan leaves roughly >5 m lateral gap from the Charge-lane edge, which must be preserved in graybox.

## `R01_EF02_COV02_SCARRED_TREE_NW`
Existing base anchor:
`(-61,4,-270)`.

Prototype solid blockout:
- trunk cylinder diameter `1.4 m`;
- graybox trunk height `8 m` minimum for sightline testing;
- root-base footprint `4 × 3 m`;
- exposed solid root height up to `1.2 m`.

Placement tolerance:
`±0.5 m` X/Z before validation.

Hard requirements:
- trunk/root geometry must intercept appropriate Monster->N03/NW lines;
- must not seal N03<->N06 route;
- surrounding Brush remains non-solid visibility context unless separate solid roots/trunks are authored.

---

# 15. Monster initial placement / clearance

Mudcrest Raker body target:
~6.6 m long / ~3.0 m shoulder-body height.

Exact width/collider/turn radius remains OPEN.

Initial anchor:
`R01_EF02_MA01 = (-18,4,-252)`.

## `R01_EF02_MA01_PIVOT_CLEARANCE`
Debug clearance cylinder:
- radius `8 m`;
- vertical permanent-solid clear height `4.5 m` above local ground.

No permanent solid boulder/tree/root may enter this cylinder at proof start.

Soft grass/brush may exist.

Purpose:
- prevent initial spawn intersection;
- allow large-body rotation;
- support later Tail Sweep/pivot testing.

This is not final Tail Sweep reach.

## Local body-force zone

Around MA01 preserve at least `12 m` of open forward/side travel in the primary local body-force directions.

For authoring/debug, show a `24 × 24 m` local reference square centered on MA01; this is not a gameplay hitbox.

---

# 16. Charge-lane volume

`R01_EF02_CHARGE_LANE_W`:

Centerline:
`(-18,4,-252)` -> approximately `(-65,4,-242)`.

Length:
~`48 m`.

Permanent-solid-free width:
`>=9 m`.

Permanent-solid vertical clearance:
`>=4.5 m` above terrain.

Inside the lane:
- stable/rough grass geometry may exist;
- non-solid brush may exist only if it does not destroy telegraph readability;
- permanent boulder/tree/root collision is forbidden at proof start.

The lane is an **environment clearance test volume**, not `M01_HORN_CHARGE` final range.

The boulder/tree become tactically useful because the Hunter can move out of the initial lane and use their real geometry, not because the lane contains invisible safe zones.

---

# 17. Monster escape / S05 staging corridor

Selected escape starts at:
`R01_EF02_MX01_TO_S05 = (-8,4,-258)`.

Then uses:
- canonical S03<->S05 anchor `(23,0,-255)`;
- deeper route evidence `(35,0,-260)`;
- same-Monster staging `(58,-3,-268)`.

Prototype required corridor:
- permanent-solid-free width `>=9 m` where the same Raker must pass;
- bend width `10–12 m` where needed;
- overhead permanent-solid clearance `>=4.5 m`;
- sustained grade target `<=15%`;
- no mandatory step >0.25 m.

Anchor-derived grade checks:
- escape boundary -> canonical S03/S05 anchor: ~12.8%;
- canonical anchor -> deeper evidence: ~0%;
- deeper evidence -> S05 staging: ~12.3%.

These fit the prototype slope target without a teleport or vertical cliff.

Only the Hunt-01 escape/staging stub is specified here; this does not graybox the whole S05 sector.

---

# 18. Camera-transition clearance debug volumes

Final camera altitude/FOV/interpolation remain OPEN.

Geometry must nevertheless reserve space for the existing aerial->first-person continuity requirement.

## `H01_GB_CAM_N01_DESCENT_CLEAR`
Centered in X/Z on N01 `(-70,-238)`.

Debug clear cylinder:
- radius `4 m`;
- vertical range from local ground `Y 4 m` to approximately `Y 16 m`.

No permanent trunk/boulder/overhang may penetrate the core cylinder.

Soft foliage may visually cross only if it can be reduced/culled without changing collision/gameplay.

## `H01_GB_CAM_N01_SIGHT_TUBE`
Debug sight tube from Hunter eye reference near N01 toward the visible Monster upper-body silhouette.

Prototype radius:
`1.5 m`.

Hard requirement:
no `FULL_COVER` permanent object may block this initial sight tube at encounter creation.

This is not a target-lock or aim-assist volume.

## Tactical-node head clearance

Every N01–N10 immediate standing pad should preserve at least:
- `3 m` vertical solid clearance above local player ground;
- enough local lateral space for first-person camera rotation without embedding in a nearby primitive at spawn.

---

# 19. Streaming/grace-zone debug proxies

Exact runtime grace-zone width remains engine/device dependent.

For later implementation/debug visualization only, create these **prototype proxy bands**:

### `H01_GB_STREAM_S00_S01_PROXY`
Center:
canonical S00/S01 route anchor `(-45,-1,-82)`.

Debug volume:
approximately `20 m` along route × `18 m` lateral × `8 m` vertical.

### `H01_GB_STREAM_S01_S03_PROXY`
Center:
canonical S01/S03 route anchor `(-62,0,-188)`.

Debug volume:
approximately `24 × 18 × 10 m`.

### `H01_GB_STREAM_S03_S05_PROXY`
Center:
canonical S03/S05 escape route anchor `(23,0,-255)`.

Debug volume:
approximately `24 × 18 × 10 m`.

These volumes:
- are not visible player barriers;
- do not define final sector polygons;
- do not select final preload/unload meter thresholds;
- exist so future scene/streaming tests have a shared marker for crossing/hysteresis instrumentation.

---

# 20. Terrain tag application in this geometry pass

Use existing terrain definitions only.

S00/S00->S01 required route:
primarily `STABLE_GROUND`, with visual brush context outside the clear corridor.

S01:
- shallow traversable water -> `SHALLOW_WATER`;
- wallow/exit mud -> `MUD`;
- dry bank -> `STABLE_GROUND` or `ROUGH_GROUND` as actual primitive surface warrants.

S01->S03:
mostly `STABLE_GROUND` / `ROUGH_GROUND`, with Brush context around visibility screens.

EF02:
current node registry remains `STABLE_GROUND` / `ROUGH_GROUND` plus `BRUSH` / limited `HIGH_GROUND` context.

No new terrain formula is created by the graybox.

---

# 21. Build-order recommendation

When an engine graybox is later authorized, construct this proof in the following order:

1. meter/axis debug grid;
2. S00 departure/choice clearing;
3. S00->S01 route centerline + width/grade shell;
4. S01 ford basin ground profile;
5. water/mud/dry-bank patches;
6. S01->S03 route rise + visibility breaks;
7. S03/EF02 meadow base floor;
8. N01–N10 node markers and legal-link corridor markers;
9. COV01/COV02 primitive collision placeholders;
10. MA01 + pivot/body-force/Charge debug volumes;
11. escape/S03->S05 staging stub;
12. camera-clearance volumes;
13. streaming/grace debug proxies;
14. evidence placement volumes;
15. validation pass before art/detail.

Do not begin final foliage/material/detail work before the primitive geometry passes its measurements.

---

# 22. Geometry validation checklist

Future engine graybox must test at minimum:

## Coordinate integrity
- all stable Hunt-01 anchors are within `<=1 m` of recorded target unless a deliberate revision is documented;
- N01–N10 remain inside EF02 planning envelope;
- Monster initial/escape/staging IDs and coordinates do not change through camera/streaming transitions.

## Route length
- required S00 departure -> N01 navigable route measures about `285–315 m` after smoothing;
- broader acceptance remains inside prior `260–340 m` target unless a measured design correction is approved.

## Grade / steps
- normal sustained required-route grade <=15%;
- short transition <=18%;
- no required step >0.25 m;
- observation->N01 uses the curved/ramped solution rather than the steep direct chord.

## Width / Monster fit
- hunter primary corridors meet specified widths;
- Raker historical/active corridors preserve >=9 m permanent-solid width where required;
- Monster-route overhead clear >=4.5 m;
- no hard 90° bend traps the large proxy;
- proxy can traverse S00->S01, S01->S03 and escape stub without clipping permanent solids.

## River Ford
- required crossing depth remains 0.15–0.55 m;
- no swimming required;
- mud/water/dry-bank surfaces remain spatially distinct;
- wallow and water-exit evidence fit the physical patches.

## Visibility / tracking
- River Ford does not expose the feeding Monster directly;
- visibility breaks preserve route readability;
- observation shelf reveals the Monster silhouette without revealing the complete Region;
- evidence anchors can be physically presented without GPS UI.

## EF02 tactical layout
- all ten nodes have usable local pads;
- every recorded legal link has >=3.5 m hunter corridor and no accidental barrier;
- no unrecorded invisible wall seals the footprint;
- terrain tags correspond to real surface/context.

## Cover
- boulder intercepts intended MA01->N02 line;
- scarred tree/root intercepts intended NW line;
- neither cover primitive blocks every central route;
- physical cover and Brush remain distinguishable.

## Monster attack-space support
- initial Charge lane remains >=48 m class / >=9 m clear width;
- pivot radius 8 m remains permanent-solid-free;
- local body-force directions preserve ~12 m open travel;
- environment does not make every normal Monster attack simultaneously illegal.

## Camera
- N01 descent clearance has no permanent solid intrusion;
- initial Monster silhouette is readable through the sight tube;
- tactical-node immediate camera space does not begin embedded in cover.

## Escape / reacquisition
- Monster can physically leave EF02 toward S05 through the 9 m corridor;
- no teleport or inaccessible cliff exists on the required stub;
- player pursuit remains physically connected to the same route/evidence anchors.

## Streaming proxies
- debug grace volumes cross the same physical route without creating collision or visible boundaries;
- future instrumentation can detect entry/exit without using them as gameplay authority.

## No-softlock
- both S00 branch mouths remain usable;
- required Hunt-01 path has no accidental dead end;
- player can retreat back toward S00 from the pre-engagement route;
- tactical links and Monster escape do not depend on one destructible/decorative object being absent.

---

# 23. Future automated/static validation targets

When build data exists, add checks that can read a machine-facing primitive manifest/scene export and verify:
1. stable geometry IDs are unique;
2. coordinates use `space_region_01`;
3. route widths meet minima;
4. route grade samples meet limits;
5. water depth sample band is bounded;
6. tactical nodes remain within EF02;
7. link distances remain within recorded topology or an approved revision;
8. boulder/tree do not intersect initial Charge volume;
9. MA01 pivot volume is clear;
10. escape corridor is connected;
11. camera-clearance volume has no permanent-solid overlap;
12. streaming proxy volumes have no gameplay collision;
13. evidence placement volumes do not create duplicate evidence IDs;
14. wrong-route S02 mouth remains physically open;
15. no world geometry claims phone/performance PASS merely because the dimensions validate.

---

# 24. Verification boundary

This pass is a geometry **specification**.

It does not create engine terrain, navigation, collision or runtime scenes.

`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_GEOMETRY_SPECIFICATION_RECORDED = YES`
`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_GEOMETRY_REGISTRY_RECORDED = YES`
`REGION01_HUNT01_GRAYBOX_IMPLEMENTED = NO`
`REGION01_HUNT01_RUNTIME_VERIFIED = NO`
`REGION01_HUNT01_PHONE_VERIFIED = NO`
`WORLD_SPATIAL_RUNTIME_VERIFIED = NO`.

---

# 25. Exact downstream dependency

If the production domain gate remains blocked after this pass, the next smallest build-enabling artifact is:

`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_BUILD_MANIFEST_AND_VALIDATION_SPECIFICATION`

That pass should map these geometry IDs into an engine-neutral build manifest/scene hierarchy and explicit validation-data/test ownership without creating final art or claiming production runtime implementation.
