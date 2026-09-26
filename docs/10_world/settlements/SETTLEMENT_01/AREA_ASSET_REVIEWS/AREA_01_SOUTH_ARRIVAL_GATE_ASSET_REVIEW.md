# Area 01 Asset Extraction Review — South Arrival Gate

Status: TECHNICAL_REFERENCE_REVIEWED / MODEL-SHEET QUEUE READY  
Area ID: `SET01_A01_SOUTH_ARRIVAL_GATE`  
Reference ID: `REF_SET01_A01_SOUTH_ARRIVAL_GATE_R001`

Reference archive:
`/Pixel RPG/Settlement 01/Area References/AREA_01_SOUTH_ARRIVAL_GATE_R001.png`

## 1. Review result

The reference is useful for:
- strong central arrival corridor;
- paired security masses;
- visible registration/supply activity;
- banners/lantern landmark language;
- carts/travelers as arrival context;
- wayfinding/signage hierarchy;
- readable transition from outer arrival to internal settlement road.

It must **not** be copied literally.

The following reference features are rejected as settlement geometry authority:
- cliff-and-river perimeter;
- fortress-scale wall density;
- exact tower proportions;
- exact NPC crowd count;
- generated deer crest/logo;
- generated sign text;
- exact number of stalls/booths;
- exact road paving pattern.

## 2. Existing runtime assets that can be reused

### REUSE_CURRENT — direct

`game/assets/environment/starting_area/lantern_post_01.tscn`
- role: arrival lighting/landmark posts;
- collision: presentation/simple depending current owner;
- use 2–4 strategically, not every few meters.

`game/assets/environment/starting_area/signpost_01.tscn`
- role: wayfinding base;
- authored text/UI must replace generated image lettering.

`game/assets/environment/starting_area/fence_01.tscn`
- role: local boundary/queue edge;
- not the final settlement perimeter wall.

`game/assets/environment/starting_area/banner_post_01.tscn`
- role: gate identity/banner support;
- crest/art should be original Pixel RPG settlement identity.

`game/assets/environment/starting_area/service_clutter_01.tscn`
- role: compact supply/crate dressing;
- keep density controlled.

`game/assets/environment/starting_area/street_surface_details_01.tscn`
- role: arrival/main-spine surface detail.

### ADAPT_CURRENT

`game/assets/environment/starting_area/settlement_gate_01.tscn`
- use as visual/proportion reference;
- final South Gate needs the new 8 m opening contract and modular wall/gate connectors;
- do not inherit current gate placement as final geometry.

`game/assets/environment/starting_area/market_stall_01.tscn`
- can be adapted into one lightweight arrival supply/registration canopy;
- must not make Area 01 look like the market district.

`game/assets/environment/starting_area/concept_photo_sprites_011/concept_water_trough.png`
- possible presentation source for arrival water/logistics point;
- collision remains independent.

`game/assets/environment/starting_area/concept_photo_sprites_011/concept_signpost.png`
- presentation reference/overlay only where consistent;
- authored sign content remains separate.

`game/assets/environment/starting_area/concept_photo_sprites_011/concept_gate_banner_left.png`
and
`concept_gate_banner_right.png`
- may inform banner material/color treatment;
- final crest/sign content must use original authored identity.

## 3. New assets required

### NEW_REQUIRED — structural

#### A01-GATEHOUSE-W
Maps to:
`SET01_BLD_SOUTH_GATEHOUSE_W`

Need:
- real 8×7 m building;
- east/inward-facing usable doorway;
- simple guard/admin interior;
- segmented collision;
- roof visibility behavior;
- guard/service anchors.

Collision:
`COLLISION_BUILDING`

#### A01-WATCH-E
Maps to:
`SET01_BLD_SOUTH_WATCH_E`

Need:
- compact 6×6 m companion watch structure;
- stronger vertical silhouette than residence;
- ground-level usable/covered guard position;
- optional non-traversable upper watch silhouette first.

Collision:
`COLLISION_BUILDING` for base;
upper decorative watch pieces may be presentation-only.

#### A01-SOUTH-GATE-FRAME
Need:
- 8 m clear opening;
- left/right frame/post modules;
- open-state gate leaves;
- compatibility with modular perimeter wall.

Collision:
`GAMEPLAY_SPECIFIC`
because clear opening must be tested.

#### A01-WALL-CONNECTOR-L/R
Need:
- bridge from gatehouse/watch to perimeter wall kit;
- grid-compatible connector.

Collision:
`COLLISION_SIMPLE`.

### NEW_REQUIRED — props

#### A01-CART-A
Compact traveler cargo cart.

Need:
- one reusable base;
- 2–3 loadout variants through cargo props.

Collision:
`COLLISION_SIMPLE`.

#### A01-REGISTRATION-DESK
Can reuse stall/table modules, but needs a distinct admin/arrival presentation.

Collision:
simple counter only.

#### A01-WAYFINDING-BOARD
Need:
- post/frame model;
- text content rendered/authored separately;
- no generated text baked into final texture.

Collision:
usually none/simple post.

#### A01-ARRIVAL-SUPPLY-RACK
Small supply/crate display.

Collision:
none or simple depending size.

#### A01-GATE-BRAZIER
Optional.
Existing lantern posts are preferred first for cost/reuse.

Create only if open-flame brazier improves gate silhouette enough to justify another asset.

## 4. NPC/character asset needs

Current Gate Warden can inform:
- guard palette;
- settlement security visual language.

Still needed later:
- civilian traveler visual variants;
- settlement guard variants;
- clerk/registration presentation.

Do not extract exact generated people from the image.

NPC state remains outside visual assets.

## 5. Original settlement crest

The white deer-head emblem in the reference is generated visual language only.

Decision:
`REJECT_FROM_REFERENCE AS FINAL CREST`.

Need later:
- original Settlement 01 crest/symbol;
- simple enough for pixel banners and signs;
- not copied from another game/faction/logo;
- usable in 16–64 px contexts.

Until then:
- banners may use neutral color blocks or placeholder geometric mark.

## 6. Area 01 model-sheet queue

Priority 1:
1. South Gatehouse W
2. South Watch E
3. 8 m South Gate frame/open leaves
4. wall/gate connector modules

Priority 2:
5. cargo cart family
6. wayfinding board
7. registration desk
8. arrival supply rack

Priority 3:
9. optional brazier
10. original crest/banner art

## 7. First-person readability requirements

From 10–25 m:
- gate opening must be visually obvious;
- inward road continuation must be visible;
- gatehouse vs watch structure must read as separate masses;
- wayfinding should be recognizable as a sign even if text is not readable at distance;
- carts/props must not visually close the gate corridor.

At doorway distance:
- gatehouse entrance must clearly read as usable;
- registration interaction surface must be visible;
- clutter must not obscure guard/NPC interaction anchors.

## 8. Collision decisions

| Asset | Collision class |
|---|---|
| Gatehouse | BUILDING |
| Watch base | BUILDING |
| Watch upper silhouette | NONE unless traversable |
| Gate frame/posts | GAMEPLAY_SPECIFIC |
| Gate leaves | GAMEPLAY_SPECIFIC if stateful |
| Wall connectors | SIMPLE |
| Cart | SIMPLE |
| Sign board | NONE/SIMPLE post |
| Banner cloth | NONE |
| Lantern | NONE/SIMPLE |
| Small crates/sacks | NONE by default |
| Large supply rack | SIMPLE |
| Registration counter | SIMPLE |

## 9. Density reduction from reference

The reference is visually rich but too dense to copy directly for target mobile runtime.

Runtime target:
- 1 main gatehouse;
- 1 companion watch;
- 1 registration/admin point;
- 1 supply point;
- 1–2 carts visible at a time;
- 2–4 lantern/banner landmarks;
- low static crowd density.

Crowd/background activity should come from NPC scheduling rather than permanently placing many decorative characters.

## 10. Runtime migration relationship

Current assets map as follows:

current `settlement_gate_01.tscn`
→ reference/prototype input for final South Gate, not direct final contract.

current gate collision proxies
→ architecture lesson: collision separate from gate visual.

current signpost/lantern/fence/banner/service clutter
→ reusable Area 01 dressing modules.

current first-person world
→ remains unchanged until section/building migration issues implement this area.

## 11. Review state

Technical reference review:
`PASS`

Model extraction readiness:
`READY`

Creator final visual approval:
`NOT SEPARATELY RECORDED`

Runtime implementation:
`NOT STARTED`

Device visual verification:
`NOT STARTED`

## 12. Next action

Create model sheets/contracts for the four structural priority assets:
- Gatehouse W;
- Watch E;
- Gate frame;
- wall connector pair.

Then advance to Area 02 asset extraction review.
