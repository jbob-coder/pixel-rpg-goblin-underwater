> **SUPERSEDED DUPLICATE PLAN — 2026-09-26**
>
> This earlier Area 03 planning draft is retained for provenance only. Current Area 03 authority is `AREA_03_CARAVAN_VISITOR_STAGING.md`, which contains the accepted R001 reference, asset-review/model-sheet links, and F001 position-locked reference. Do not use this duplicate file as current status or naming authority.

# Area 03 — Caravan Yard / Visitor Staging

Status: PLAN_READY / REFERENCE GENERATION NEXT  
Parent section: `SET01_S01`  
Area ID: `SET01_A03_CARAVAN_YARD_VISITOR_STAGING`

## 1. Purpose

Area 03 handles temporary arrival logistics after the player/travelers pass through the South Gate.

It should communicate:
- carts stop here;
- visitors unload and orient themselves;
- goods wait briefly before moving deeper into town;
- travelers can water/rest animals;
- the main route stays clear.

This is not a farm district and not a market district.

## 2. Relationship to adjacent areas

Area 01:
- formal gate/arrival threshold.

Area 02:
- security operations.

Area 03:
- carts, visitors, unloading, short-term staging.

Area 04:
- main route continuing toward the settlement center.

## 3. Planned composition

Preferred scene:
- compact open yard beside the main road;
- 2–3 carts maximum;
- hitching posts;
- covered supply awning;
- water trough;
- crate/load staging;
- wayfinding sign;
- small visitor bench/rest corner;
- clear connector toward Area 04.

## 4. Spatial intent

Provisional usable yard:
- approximately 16×14 m visual zone.

Clear road-side circulation:
- preserve at least 5 m visual/functional lane along the settlement route.

The center of the yard should remain open enough for cart turning/staging.

## 5. Props

Required:
- 2–3 carts;
- hitching posts;
- water trough;
- crates/sacks;
- covered supply awning;
- sign/wayfinding post;
- bench/rest point;
- lantern.

Optional:
- handcart;
- travel bundles;
- small feed bin;
- one notice board.

Avoid:
- crop fields;
- permanent market stalls;
- giant warehouse;
- crowded livestock pen.

## 6. NPC density

Reference image:
- 3–6 visitor/worker figures;
- 1 cart handler;
- 1–2 travelers;
- optional guard at road edge.

Runtime target may be lower.

## 7. Visual language

Match Areas 01–02:
- deliberate low-resolution pixel art;
- timber;
- stone;
- packed earth;
- blue/neutral settlement accents;
- warm lanterns.

Area 03 should feel less formal and more logistical than Area 01.

## 8. Navigation

Required visual connectors:
- `A03_RoadConnector_A01`
- `A03_RoadConnector_A02`
- `A03_RoadConnector_A04`

The road edge must remain obvious and unobstructed.

## 9. Collision intent

Future:
- carts: simple collision;
- trough: simple collision;
- hitching posts: collision only if needed;
- crates: mostly presentation unless large;
- awning posts: simple collision;
- small bundles: presentation-only.

## 10. Anchors

Planned:
- `A03_CartStandAnchor_01`
- `A03_CartStandAnchor_02`
- `A03_UnloadAnchor`
- `A03_WaterAnchor`
- `A03_VisitorIdleAnchor_01`
- `A03_VisitorIdleAnchor_02`
- `A03_WayfindingAnchor`
- `A03_RoadConnector_A04`

## 11. Image-generation brief

Generate **only Area 03**.

Prompt intent:
Original deliberate pixel-art RPG caravan yard immediately inside a settlement. Compact open packed-earth staging yard beside a clear road, two or three wooden carts, hitching posts, water trough, crates and travel bundles, small covered supply awning, wayfinding sign, bench, warm lanterns, 3–6 traveler/worker figures. No farms, no giant market, no full settlement overview. High 3/4 game-map view, crisp low-resolution pixels, compact mobile-game density, readable object separation, original IP.

## 12. Acceptance checklist

Approve only if:
- Area 03 only;
- no full settlement overview;
- road edge clearly visible;
- 2–3 carts maximum;
- yard remains open;
- logistics/visitor function immediately readable;
- genuine pixel-art treatment;
- prop density controlled.
