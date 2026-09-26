# Settlement 01 — Visual Reference Generation Register

Status: ACTIVE REFERENCE-PRODUCTION TRACKER  
Created: 2026-09-25

This register tracks the visual-reference → blueprint → model/runtime progression.

## State vocabulary

- SPEC_PENDING
- SPEC_READY
- REFERENCE_GENERATED
- REFERENCE_REVIEWED
- MODEL_SHEET_READY
- GRAYBOX_READY
- RUNTIME_VISUAL_IMPLEMENTED
- DEVICE_VISUAL_VERIFIED

A later state does not erase earlier source/reference provenance.

## Current register

| Asset | Stable/Family ID | Visual spec | Current state | Next action |
|---|---|---|---|---|
| Community Hall | SET01_BLD_COMMUNITY_HALL | REF_01_COMMUNITY_HALL_VISUAL_SPEC.md | SPEC_READY | generate/reference front-side-top-interior sheet |
| Residence Type A | SET01_BLD_RESIDENCE_A | REF_02_RESIDENCE_TYPE_A_VISUAL_SPEC.md | SPEC_READY | generate two compatible facade variants |
| South Gatehouse | SET01_BLD_SOUTH_GATEHOUSE_W | REF_03_SOUTH_GATEHOUSE_VISUAL_SPEC.md | SPEC_READY | generate whole arrival-complex sheet |
| Work Storage | SET01_BLD_WORK_STORAGE | not yet authored | SPEC_PENDING | create visual spec |
| Work Canopy | SET01_BLD_WORK_CANOPY | not yet authored | SPEC_PENDING | create visual spec |
| Hunter Watch | SET01_BLD_HUNTER_WATCH | not yet authored | SPEC_PENDING | create visual spec |
| Supply Cache | SET01_BLD_SUPPLY_CACHE | not yet authored | SPEC_PENDING | create visual spec |
| Market Stall Family | SET01_MARKET_STALL_A | not yet authored | SPEC_PENDING | create shared variant spec |
| Modular Wall/Gate Kit | SET01_WALL_* | not yet authored | SPEC_PENDING | create modular construction spec |

## Promotion rule

A generated image is not enough to mark MODEL_SHEET_READY.

Before promotion:
1. compare image to geometric blueprint;
2. mark observed/inferred/game-design elements;
3. reject dimensions that conflict with the building contract;
4. identify reusable modules;
5. identify art-only details;
6. define collision separately;
7. confirm original-IP compliance.

## Storage rule

When an approved reference image is stored in the repository later, record:
- filename/path;
- source/generation date;
- source prompt/reference;
- dimensions;
- checksum;
- owning building ID;
- approval state.

## Current priority

1. Community Hall
2. Residence Type A
3. South Gatehouse
4. Work Storage / Canopy
5. Hunter Watch / Supply Cache
6. Market variants
7. wall/gate modules
