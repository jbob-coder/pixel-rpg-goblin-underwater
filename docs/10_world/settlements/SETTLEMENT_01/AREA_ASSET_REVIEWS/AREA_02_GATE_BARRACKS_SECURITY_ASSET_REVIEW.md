# Area 02 Asset Extraction Review — Gate Barracks & Security

Status: TECHNICAL_REFERENCE_REVIEWED / MODEL-SHEET QUEUE READY  
Area ID: `SET01_A02_GATE_BARRACKS_SECURITY`  
Reference ID: `REF_SET01_A02_GATE_BARRACKS_SECURITY_R001`

## 1. Review result

The reference is useful for:
- one compact barracks/duty building;
- open central security yard;
- one briefing canopy;
- dedicated equipment racks;
- a simple duty board;
- low-density crates/bench clutter;
- one simple training target;
- guard presence without fortress scale.

The reference correctly separates security function from Area 01 arrival function.

Rejected as literal runtime authority:
- exact fence/post count;
- exact guard positions/count;
- exact weapon count;
- exact signboard proportions;
- exact brown yard dimensions;
- any implied wall/compound dimensions.

## 2. Reuse current runtime assets

### REUSE_CURRENT

`lantern_post_01.tscn`
- use for 2–3 security-yard landmarks.

`service_clutter_01.tscn`
- can supply limited crate/supply dressing.

`fence_01.tscn`
- suitable for local yard boundary treatment;
- not perimeter-wall authority.

### ADAPT_CURRENT

`market_stall_01.tscn`
- structural reference for a small open briefing canopy;
- final canopy should use its own work/security identity rather than market dressing.

`signpost_01.tscn`
- may provide post/material language;
- duty board should become its own readable civic/security board.

Existing settlement wood/metal material families:
- reuse for barracks, racks, bench, canopy.

## 3. New structural assets required

### A02-BARRACKS-DUTY-BUILDING

Target:
- compact 8×6 m family;
- one real doorway;
- one duty/admin room;
- equipment/storage nook;
- simple interior.

Collision:
`COLLISION_BUILDING`.

### A02-BRIEFING-CANOPY

Target:
- roughly 6×4 m open-sided canopy;
- 4 posts;
- roof;
- briefing table/bench sockets;
- at least two open walk-through sides.

Collision:
- posts and substantial table only;
- no invisible wall volume.

## 4. New prop families required

### A02-EQUIPMENT-RACK-A

Shared rack frame supporting:
- spear/polearm variant;
- shield variant;
- mixed patrol-gear variant.

Collision:
`COLLISION_SIMPLE` only on rack body.

Displayed weapons/shields:
`PRESENTATION_ONLY` unless gameplay later makes them interactable.

### A02-DUTY-BOARD

Purpose:
- shift/patrol/security information.

Final text:
- authored separately;
- not baked from generated reference text.

Collision:
NONE/SIMPLE post.

### A02-TRAINING-TARGET

Purpose:
- lightweight security-yard activity.

Collision:
SIMPLE if substantial.

Do not create a combat training system from this prop by default.

### A02-SECURITY-BENCH

Can likely use a future generic bench family shared with plaza/residential areas.

### A02-SUPPLY-CRATE-SET

Prefer shared crate family rather than Area-02-specific models.

## 5. NPC/guard relationship

Reference supports:
- 4–7 visible guards in concept art.

Recommended runtime baseline:
- 1–3 visible active guards;
- extra guard activity represented through schedule/section state.

Potential stable roles:
- Duty Guard
- Patrol Guard
- Briefing/Watch Guard

Do not turn decorative reference figures into separate durable NPCs automatically.

## 6. Yard layout rule

Keep central security yard mostly open.

Permanent objects should stay near edges:
- barracks west;
- canopy central/north;
- racks east;
- board/bench south/edge;
- crates near building/rack zones.

The road-side edge must remain readable and unobstructed.

## 7. Collision table

| Asset | Collision class |
|---|---|
| Barracks | BUILDING |
| Briefing canopy posts | SIMPLE |
| Briefing table | SIMPLE |
| Equipment rack frame | SIMPLE |
| Displayed weapons | NONE |
| Shields | NONE |
| Duty board | NONE/SIMPLE |
| Training target | SIMPLE |
| Bench | SIMPLE |
| Small crates | NONE by default |
| Large crates | SIMPLE |
| Lantern | NONE/SIMPLE |

## 8. Model-sheet queue

Priority:
1. Barracks/Duty Building
2. Briefing Canopy
3. Equipment Rack Family
4. Duty Board / Training Target shared prop sheet

Shared generic later:
- bench
- crate family
- lantern

## 9. First-person readability

From road edge:
- barracks doorway should read as usable;
- open yard must remain visible;
- canopy should read as a meeting point, not a market stall;
- equipment racks should identify security use without becoming visual clutter.

At interaction distance:
- duty board and equipment-use points should be obvious;
- racks should not create narrow collision traps.

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
