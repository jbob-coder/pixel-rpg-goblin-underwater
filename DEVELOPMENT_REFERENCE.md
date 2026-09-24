# Unnamed Hunt RPG — Development Reference

Status: PLANNING CONTRACT / NO SOURCE IMPLEMENTED
Last reconciled: 2026-09-02

## Purpose
Define how future source should be organized, changed, tested, and documented once implementation is authorized.

## Fundamental code rule

Gameplay truth belongs in authoritative domain systems, not presentation code.

Expected direction:

```text
Player/AI Input
    ↓
Action Request
    ↓
Domain Validation
    ↓
Resolver
    ↓
Authoritative State + Domain Events
    ↓
Save / Replay / Debug Record
    ↓
Presentation / Animation / Audio / UI
```

## Ownership map

### Exploration domain
Owns:
- region/player position;
- traversal legality;
- roaming monster state;
- tracking/gathering/interactables;
- encounter initiation context.

### Encounter/combat domain
Owns:
- initiative/turn index;
- AP/stamina/reactions;
- tactical nodes/range/bearing;
- cover state;
- attack legality and resolution;
- body-part state;
- statuses;
- monster action selection inputs;
- victory/escape/failure.

### Anatomy/damage domain
Owns:
- part definitions;
- structural integrity;
- wounds;
- break/sever/destroy transitions;
- functional anatomy tags;
- attack dependencies;
- harvest-condition consequences.

### Harvest domain
Owns:
- anatomical resource capacities;
- remaining usable mass/condition;
- tool/skill/method modifiers;
- extracted quantity/quality;
- carcass/severed-part depletion.

### Inventory/crafting domain
Owns:
- material stacks;
- items/equipment;
- recipes;
- crafting costs/results;
- upgrade state.

### Progression/research domain
Owns:
- bestiary knowledge;
- mastery/perks/rank once defined;
- unlock conditions.

### Persistence
Owns:
- schema/version;
- serialization;
- repair/migration;
- save integrity;
- deterministic continuation information when required.

### Presentation
Owns only representation/input surfaces:
- aerial exploration camera/renderer;
- first-person encounter camera/renderer;
- animation;
- VFX/audio;
- HUD/action selection;
- targeting visualization;
- transitions.

Presentation must not directly grant loot, subtract authoritative integrity, teleport persistent state, or decide hit outcomes.

## Data-driven content

Prefer definitions for:
- species;
- body parts;
- attacks;
- behavior profiles;
- weapons/techniques;
- materials;
- harvest sources;
- items;
- recipes;
- regions;
- cover/environment definitions;
- quests/contracts later.

Every persistent content entity uses a stable ID.

## Testing expectations

Domain tests should cover at minimum:
- deterministic action resolution;
- illegal-action rejection;
- turn/AP invariants;
- cover/range legality;
- body-part damage state transitions;
- break/sever/destroy behavior;
- anatomy-dependent attack disable/changes;
- harvest capacity invariants;
- impossible duplicate unique-part prevention;
- crafting material consumption;
- save round-trip/repair once persistence exists.

Integration tests should later cover:
- exploration → encounter transfer;
- combat outcome → harvest;
- harvest → inventory → crafting;
- save/reload across each mode.

Target-device validation must separately verify:
- launch;
- landscape/touch;
- aerial renderer;
- combat renderer;
- transition stability;
- suspend/resume;
- frame pacing/memory/thermal behavior.

## Change discipline

For every behavior change:
1. identify owner;
2. define acceptance criteria;
3. make smallest coherent change;
4. add/update tests;
5. run relevant tests;
6. inspect regressions;
7. update affected docs;
8. save/commit;
9. read back actual saved state.

Do not combine unrelated systems for speed.

## Save discipline

The new game starts a new schema lineage.

Before adding/changing persistent fields:
- determine defaults;
- determine invariants;
- define repair/migration;
- determine compatibility expectations;
- add fixtures/tests;
- increment schema when the persistence contract materially changes.

Never inherit WorldLife save schema simply because the repository is reused.

## Performance discipline

Profile the target Android device early.

Track:
- launch time;
- scene/region transition time;
- combat transition time;
- frame time/fps;
- memory;
- thermal behavior;
- APK size;
- number of active monsters/props/effects/materials.

Do not increase visual/content density without evidence that the device budget remains healthy.

## Future creator/debug tooling

Build only after core data/commands exist:
- state inspector;
- encounter preset loader;
- creature/anatomy validator;
- body-part condition editor;
- attack validator;
- harvest calculator;
- deterministic replay/log viewer;
- item/material/recipe inspector;
- save inspector;
- stable ID checker;
- performance overlay.

Creator UI must sit on validated domain/content APIs rather than transient UI state.

## Current implementation gate

No engine/source layout is authoritative yet because engine selection remains open and implementation is explicitly paused for discussion.
