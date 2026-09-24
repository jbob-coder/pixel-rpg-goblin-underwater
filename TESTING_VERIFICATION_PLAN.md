# Unnamed Hunt RPG — Testing and Verification Plan

Status: PLANNING CONTRACT / NO TEST SUITE IMPLEMENTED
Last reconciled: 2026-09-02

## Purpose

Define how correctness, performance, save safety and Android runtime behavior will be verified as the game is built.

## 1. Verification vocabulary

Use exact gates:
- DESIGNED;
- IMPLEMENTED;
- STATIC_VERIFIED;
- CONTENT_VALIDATED;
- UNIT_TESTED;
- INTEGRATION_TESTED;
- COMPILED;
- APK_BUILD_VERIFIED;
- PHONE_RUNTIME_VERIFIED;
- VISUAL_QUALITY_VERIFIED;
- PERFORMANCE_VERIFIED.

Never promote one gate into another.

## 2. Test layers

### Domain unit tests
Verify pure gameplay rules.

Examples:
- primary/derived stat calculation;
- modifier order/stacking/caps;
- AP/stamina costs;
- illegal-action rejection;
- terrain/status/equipment interactions;
- target exposure;
- hit-quality boundaries;
- break/sever transitions;
- capability removal;
- harvest capacity;
- inventory/equipment/crafting consumption;
- knowledge visibility;
- deterministic behavior-rule filtering/selection.

### Content validation
Verify definitions/references.

### Integration tests
Verify subsystem handoffs.

Critical chains:
- equipment/status/terrain → action calculation;
- exploration → encounter;
- encounter → monster escape/world;
- encounter → kill/harvest;
- harvest → inventory;
- inventory → crafting/equipment;
- save/reload across each state.

### Replay/regression fixtures
Save representative encounter states/seeds/actions/rule traces so bugs can be reproduced.

### Runtime/device tests
Verify touch, camera, rendering, lifecycle and performance.

## 3. Core invariants

Tests must protect at least:
- state cannot reference missing stable IDs;
- attributes/derived values stay inside legal bounds;
- AP/stamina cannot spend below legal bounds;
- AP/reaction scaling cannot bypass configured hard limits;
- duplicate equipment/status sources obey declared stack policies;
- movement/action costs obey minimum/maximum floors;
- status resistance cannot exceed ordinary cap unless explicit immunity exists;
- terrain effects come from authoritative terrain context, not presentation;
- severed part cannot remain functionally attached;
- destroyed unique part cannot yield intact duplicate structure;
- harvest cannot exceed capacity;
- autonomous actor cannot request attack whose capability is disabled;
- behavior rules cannot bypass normal domain legality;
- tactical occupancy/adjacency remains valid;
- world monster and combat monster remain the same runtime lineage;
- encounter conclusion cannot award harvest twice;
- crafting cannot create output without consuming required materials;
- UI/admin cannot mutate authoritative state outside approved command paths.

## 4. Determinism tests

For systems using seeded RNG:
- same initial state + definitions + seed + actions → same authoritative result;
- same behavior facts/profile/seed/tie policy → same selected pattern where seeded variation is used;
- replay fixtures remain stable unless intentional rules change updates them;
- randomness never violates physical/capacity invariants.

## 5. Stats/effects test matrix

Test:
- each primary attribute contribution independently;
- derived-stat cache invalidation after equipment/status change;
- `FLAT` modifier;
- additive percentage;
- multiplicative percentage where allowed;
- capability grant/removal;
- resistance;
- cost modifier;
- threshold modifier;
- `STACK`;
- `UNIQUE_SOURCE`;
- `HIGHEST_ONLY`;
- `LOWEST_ONLY`;
- `REFRESH_DURATION`;
- capped intensity stacking;
- replacement policy;
- hard cap/floor;
- calculation trace equals actual result;
- no recalculation when authoritative inputs did not change.

Combination fixtures are required. Testing every modifier in isolation is insufficient.

## 6. Terrain/weather test matrix

Representative cases:
- stable ground baseline;
- mud movement burden;
- armor + mud combination;
- shallow water;
- brush concealment/targeting;
- high-ground visibility/exposure;
- narrow-node restrictions;
- ice/rough footing with Agility mitigation;
- actor capability bypass/reduction such as `MUD_RESISTANT`;
- rain changing wet/mud/track context;
- fog range penalty;
- weather disabled/nonmechanical case produces no hidden bonus.

## 7. Status test matrix

- apply/remove;
- duration countdown;
- refresh duration;
- stack intensity to cap;
- resistance application;
- cure/removal;
- timing at turn start/end;
- on-hit/on-move hook where used;
- persistence across save/reload according to policy;
- interaction with equipment/terrain;
- removal of status correctly invalidates derived values.

## 8. Save tests

Once persistence begins:
- round-trip current save;
- missing optional fields defaulted according to policy;
- invalid references rejected/repaired according to policy;
- migration fixtures for every released schema;
- attributes/equipment/status round-trip;
- behavior phase/cooldown persistence only where designed;
- active encounter save/reload;
- escaped injured monster save/reload;
- harvested capacity save/reload;
- app background/resume.

## 9. Combat test matrix

Representative cases:
- valid/invalid range;
- valid/invalid bearing;
- terrain movement cost;
- cover interaction;
- target hidden/exposed;
- hit/miss/hit-quality bands;
- armor/resistance interaction;
- break exactly at threshold;
- sever exactly at threshold;
- overkill/destroy;
- capability removal;
- reaction resource used once;
- status application/removal;
- monster flee condition;
- player escape.

## 10. Harvest test matrix

- intact part;
- wounded part;
- broken attached part;
- clean sever;
- destroyed part;
- burned/crushed/shattered condition where supported;
- correct/wrong tool;
- different skill/method;
- unique discrete part;
- continuous resource like hide/meat;
- repeated extraction cannot exceed remaining capacity.

## 11. Deterministic behavior-pattern tests

Detailed authority: `BEHAVIOR_PATTERN_SYSTEM.md`.

Test:
- only rules with passing conditions considered;
- explicit priority order;
- tie policy;
- anatomy-disabled attack rule fails capability check;
- flee rule activates at configured condition;
- range/bearing/cover/terrain affects only rules that declare those conditions;
- cooldown suppresses rule correctly;
- phase transition occurs exactly when condition is met;
- NPC schedule override for danger/weather works;
- seeded variation reproduces with fixed seed;
- behavior requests normal action and receives normal rejection when illegal;
- no infinite zero-cost decision loop;
- trace records why every candidate passed/failed.

There are no AI scoring tests because the design does not use an AI decision system.

## 12. Performance tests

Use fixed benchmark scenes:
- empty/minimal region baseline;
- representative exploration density;
- worst supported nearby-actor density;
- first-person combat with intended VFX/wounds/statuses;
- complex behavior-profile decision case;
- large-but-legal modifier/status case;
- transition stress loop;
- long-session memory/thermal test;
- save/load stress case.

Record device, build SHA/version, settings and content version.

## 13. Android runtime checklist

- install/update;
- cold launch;
- title/menu;
- new game/load;
- landscape orientation;
- touch movement;
- aerial camera;
- terrain feedback;
- region transition;
- encounter transition;
- combat actions;
- equipment/status effect visibility;
- target selection;
- break/sever visuals;
- harvest;
- crafting/equipment;
- save/reload;
- suspend/resume;
- screen lock/unlock;
- audio focus/interruption;
- low-memory/reload behavior where practical;
- no ANR/crash;
- performance/thermal check.

## 14. Visual quality tests

Check on real phone:
- hunter readable from aerial camera;
- monster silhouette readable;
- tracks/navigation clues visible;
- terrain/cover/hazards understandable;
- 2D/3D layers cohesive;
- first-person monster anatomy targetable;
- broken/severed state matches domain state;
- status/terrain feedback does not clutter combat;
- combat UI does not cover critical anatomy;
- text/touch targets usable;
- camera transition spatially coherent.

## 15. Audio tests

- telegraph sounds audible under music;
- impact materials differentiated when intended;
- terrain footsteps match surface where implemented;
- no runaway overlapping voices;
- music state transitions correct;
- suspend/resume/audio focus stable;
- mute/volume settings work.

## 16. Admin/tool tests

Admin commands/tools must test:
- dev gating;
- validation;
- invariant preservation;
- readback after mutation;
- test-save isolation;
- stat/modifier trace correctness;
- status/terrain overrides;
- behavior-rule trace correctness;
- creator definition validation;
- deterministic replay capture/load.

## 17. Bug severity

- BLOCKER: cannot launch/play/save or corrupts core data.
- CRITICAL: severe progression/save/combat correctness failure.
- HIGH: major mechanic/visual/input failure with no reasonable workaround.
- MEDIUM: significant defect but core loop remains usable.
- LOW: polish/minor visual/text issue.

Fix highest-severity root cause first.

## 18. Release gate principle

A build intended for playtesting must not be described as verified unless relevant checks actually ran.

Document source commit, content version, build result, test results, APK checksum/signature where used, target device, runtime observations and known issues.

## 19. First vertical-slice acceptance gate

The slice is successful only if:
- player can launch on target phone;
- explore one region with meaningful terrain effects;
- identify/approach monster;
- transition coherently to combat;
- reposition/use cover/terrain;
- attributes/equipment/statuses modify actions through the shared pipeline;
- modifier traces match actual outcomes in development;
- target anatomy;
- break and sever at least one defined part;
- deterministic monster behavior changes when anatomy/status/context changes;
- finish/exit encounter;
- harvest condition affects yield;
- craft/equip one upgrade with visible mechanical consequence;
- save/reload preserves relevant state;
- no blocker/critical defects remain;
- performance meets selected target or documented fallback.