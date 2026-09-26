# Area 09 Asset Extraction Review — Smithy & Craft Quarter

Status: TECHNICAL_REFERENCE_REVIEWED / MODEL-SHEET QUEUE READY  
Area ID: `SET01_A09_SMITHY_CRAFT_QUARTER`  
Reference ID: `REF_SET01_A09_SMITHY_CRAFT_QUARTER_R001`

## Spatial lock

Final frame:
- X +20.5..+30
- Z -5..+5

Fixed Smith:
- center +24.5,0
- footprint X +21.2..+27.8 / Z -3.2..+3.2
- west-facing frontage toward East Frontage Lane.

The R001 composition is concept-only.

The image label itself incorrectly reads `AREA08`; that is rejected metadata/art and must not appear in any final Area 09 reference.

## Review result

Useful:
- one dominant smith building;
- exterior forge/fire identity;
- anvil;
- worktable;
- equipment rack;
- ore/wood/material piles;
- compact customer waiting pocket;
- sparse workers/customers.

Reject as literal authority:
- exact object positions;
- detached forge placement if it conflicts with current smith;
- exact worker count;
- wrong area label;
- any building geometry that replaces the implemented enterable smith.

## Existing runtime authority

Current enterable smith remains primary implementation reference:
`world_pack_004_enterable_smith.gd`

Already exists:
- real doorway;
- interior;
- forge;
- anvil;
- bench;
- tool rack;
- EntranceAnchor;
- UseAnchor;
- roof handling.

## Reuse current/planned assets

### REUSE_CURRENT
- smith forge detail
- smith anvil detail
- smith bench detail
- smith frontage detail
- lantern_post_01
- service_clutter_01

### REUSE_PLANNED
- `SET01_PROP_EQUIPMENT_RACK_A`
- `SET01_PROP_SERVICE_TABLE_A`
- shared crate family
- bench family

## New/adapted assets

### Smith exterior work-apron deployment
No new building.

Need a controlled placement contract for:
- anvil;
- worktable;
- equipment rack;
- material bins;
- customer waiting position;
- lanterns.

### Material pile variants
- ore pile
- firewood pile

Prefer low-cost reusable props.

### Forge VFX presentation
Existing forge visual may later receive controlled glow/smoke/particle treatment.

No damage/gameplay implied.

## Collision

| Asset | Collision |
|---|---|
| Smith | BUILDING |
| Anvil | SIMPLE |
| Worktable | SIMPLE |
| Rack frame | SIMPLE |
| Display gear | NONE |
| Ore/firewood piles | NONE/SIMPLE |
| Forge visual/VFX | NONE |
| Lantern | NONE/SIMPLE |

## Model-sheet queue

1. Smith Frontage Deployment
2. Smith Material Pile Family
3. Forge Presentation/VFX Contract
4. Smith Customer/Worker Anchor Layout

## Review state

Technical review: `PASS`  
Spatial placement: `LOCKED`  
Runtime smith authority: `EXISTS`  
Model extraction: `READY`
