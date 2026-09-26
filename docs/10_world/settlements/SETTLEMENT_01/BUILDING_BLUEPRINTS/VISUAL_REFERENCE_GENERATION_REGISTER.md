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
| Work Storage | SET01_BLD_WORK_STORAGE | REF_04_WORK_DISTRICT_SUPPORT_VISUAL_SPEC.md | SPEC_READY | generate storage/canopy reference sheet |
| Work Canopy | SET01_BLD_WORK_CANOPY | REF_04_WORK_DISTRICT_SUPPORT_VISUAL_SPEC.md | SPEC_READY | generate storage/canopy reference sheet |
| Hunter Watch | SET01_BLD_HUNTER_WATCH | REF_05_HUNTER_EXIT_SUPPORT_VISUAL_SPEC.md | SPEC_READY | generate hunter-exit reference sheet |
| Supply Cache | SET01_BLD_SUPPLY_CACHE | REF_05_HUNTER_EXIT_SUPPORT_VISUAL_SPEC.md | SPEC_READY | generate hunter-exit reference sheet |
| Market Stall Family | SET01_MARKET_STALL_A | REF_06_MARKET_STALL_FAMILY_VISUAL_SPEC.md | SPEC_READY | generate four compatible variants |
| Modular Wall/Gate Kit | SET01_WALL_* | REF_07_MODULAR_WALL_GATE_KIT_VISUAL_SPEC.md | SPEC_READY | generate modular wall/gate kit sheet |

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

All seven structural reference specifications are now `SPEC_READY`.

Generation/review order:

1. Community Hall
2. Residence Type A
3. South Gatehouse
4. Work Storage / Canopy
5. Hunter Watch / Supply Cache
6. Market variants
7. wall/gate modules

Next phase is actual reference-image generation/collection and review against the geometric blueprints.
