# Area 03 Asset Extraction Review — Caravan Yard / Visitor Staging

Status: TECHNICAL_REFERENCE_REVIEWED / MODEL-SHEET QUEUE READY  
Area ID: `SET01_A03_CARAVAN_VISITOR_STAGING`  
Reference ID: `REF_SET01_A03_CARAVAN_VISITOR_STAGING_R001`

## 1. Review result

The reference successfully communicates a temporary arrival/logistics zone rather than a market.

Useful concepts:
- three compact carts/wagons;
- one covered storage/loading shelter;
- hitching rail;
- water trough;
- benches;
- crates/barrels;
- wayfinding sign;
- sparse traveler/workers;
- open central maneuvering space.

Reject as literal authority:
- exact cart positions;
- exact traveler count;
- exact wall/post count;
- exact bench/sign sizes;
- exact earth-color palette;
- any generated spacing not derived from the settlement blueprint.

## 2. Reuse current runtime assets

### REUSE_CURRENT

`lantern_post_01.tscn`
- perimeter/road-edge lighting.

`signpost_01.tscn`
- wayfinding base.

`service_clutter_01.tscn`
- crate/sack/supply dressing.

`concept_photo_sprites_011/concept_water_trough.png`
- presentation source for water point.

`fence_01.tscn`
- can support lightweight local boundary/hitching language if visually compatible.

### ADAPT_CURRENT

`market_stall_01.tscn`
- structural reference for the covered storage/loading shelter;
- remove market-vendor identity;
- use as logistics canopy/storage awning instead.

## 3. New asset families required

### A03-CARGO-CART-FAMILY

One reusable cart chassis with visual load variants:
- covered traveler wagon;
- open cargo cart;
- supply cart.

Collision:
`SIMPLE`

Do not build three unrelated cart meshes.

### A03-HITCHING-RAIL

Target:
- simple timber rail/post family;
- modular 2–4 m segment.

Collision:
`SIMPLE` only if substantial.

### A03-LOGISTICS-AWNING

Target:
- roughly 6×5 m open shelter;
- 4 posts;
- simple pitched or lean-to roof;
- cargo/sack sockets;
- no enclosed building collision.

May share construction language with Area 02 briefing canopy and Area 10 work canopy while using different dressing.

### A03-CHECKIN-TABLE / CLERK-POINT

Small arrival/logistics service point.

Prefer:
- shared counter/table family;
- not a new full building.

### A03-BENCH-FAMILY

Should become shared generic settlement bench rather than Area-03-only.

### A03-CRATE/BARREL FAMILY

Should become shared reusable prop family.

## 4. Prop reuse strategy

Shared families should serve later areas:

Cargo cart:
- Area 01 arrival
- Area 03 staging
- Area 10 loading/work yard

Bench:
- Area 03
- Area 05 plaza
- Area 06 civic core
- Area 07 residential
- Area 11 hunter staging

Crate/barrel:
- nearly all service/logistics areas

Wayfinding sign:
- Area 01
- Area 03
- Area 04
- Area 12

Water trough:
- Area 01/03 only unless later justified.

## 5. NPC relationship

Reference supports 3–6 traveler/work figures.

Recommended runtime:
- 1–3 visible travelers/workers;
- carts/props carry most of the area identity;
- additional arrivals may be schedule/event driven.

No durable NPC identity should be created solely because a decorative reference person exists.

## 6. Collision table

| Asset | Collision class |
|---|---|
| Cargo cart | SIMPLE |
| Covered wagon canvas | NONE |
| Hitching rail | SIMPLE |
| Logistics awning posts | SIMPLE |
| Awning roof | NONE |
| Clerk/check-in table | SIMPLE |
| Water trough | SIMPLE |
| Wayfinding sign | NONE/SIMPLE post |
| Bench | SIMPLE |
| Small crates/sacks | NONE |
| Large crate/barrel | SIMPLE |
| Lantern | NONE/SIMPLE |

## 7. Model-sheet queue

Priority:
1. Cargo Cart Family
2. Logistics Awning / Shelter
3. Hitching Rail + Water Point
4. Shared Bench / Crate / Barrel logistics prop family

Wayfinding and lantern can reuse current/runtime families first.

## 8. First-person readability

From the main connector:
- carts should communicate staging immediately;
- central route must stay open;
- awning should read as temporary loading/supply, not a shop;
- wayfinding sign must be recognizable without relying on tiny text.

At close range:
- cart collision must be predictable;
- player must be able to walk around every parked cart;
- hitching rail must not create narrow dead-end traps.

## 9. Density rule

Preferred first runtime pass:
- 1–2 carts active/visible;
- 1 awning;
- 1 water point;
- 1 bench;
- limited crates/barrels;
- 1–3 NPCs.

Do not reproduce the reference as a permanently crowded yard.

## 10. Review state

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
