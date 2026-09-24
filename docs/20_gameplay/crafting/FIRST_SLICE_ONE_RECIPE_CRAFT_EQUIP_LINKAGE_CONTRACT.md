# First-Slice One-Recipe Craft / Equip Linkage Contract

Status: SELECTED FIRST-SLICE PROTOTYPE DESIGN / NO CRAFTING IMPLEMENTATION
Last reconciled: 2026-09-03

Technical owner: `docs/20_gameplay/crafting/`

## Purpose

Prove one complete deterministic progression loop from Monster 01 anatomy-preserving combat to harvested material, authoritative inventory ownership, one crafted Poleblade refinement, and a concrete reason to hunt again.

Primary law:

**A craft transaction consumes exact authoritative material quantities and applies exactly one authoritative refinement result. It is atomic, conserved, deterministic and idempotent.**

This contract owns:
- exactly one first-slice recipe;
- recipe material/quality requirements;
- deterministic input selection/reservation;
- craft transaction atomicity/anti-replay;
- first-slice refinement output identity;
- output application to a compatible Field Poleblade instance;
- one typed equipment effect;
- persistence/debug trace requirements;
- future implementation tests.

It does not own:
- broad recipe trees;
- market prices/currency;
- settlement NPC schedules;
- final crafting animation/UI;
- many equipment slots;
- additional weapon families;
- production implementation.

Supporting authorities:
- `../inventory/FIRST_SLICE_INVENTORY_MATERIAL_OWNERSHIP_CONTRACT.md`;
- `../harvest/FIRST_SLICE_HARVEST_CAPACITY_AND_CONDITION_CONTRACT.md`;
- `/docs/30_content/monsters/MONSTER_01/HARVEST_CAPACITY_PACKET.md`;
- `../combat/FIRST_WEAPON_FAMILY_CONTRACT.md`;
- `../combat/STAMINA_PROTOTYPE_SCALE_AND_RECOVERY_CONTRACT.md`;
- `../progression/PLAYER_PROGRESSION_AND_EQUIPMENT_SYSTEM.md`;
- `/CONTENT_DATA_GUIDE.md`;
- `/STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`.

---

# 1. Selected first recipe

Stable recipe ID:
`recipe_field_poleblade_raker_tendon_grip`

Working player-facing name:
**Raker-Tendon Grip**

Recipe category:
`WEAPON_REFINEMENT`

Compatible weapon family:
`WEAPON_FAMILY_FIELD_POLEBLADE`

Logical station/service requirement:
`CRAFT_STATION_WEAPON_WORKBENCH`

This logical station requirement is mapped into the physical Settlement 01 Smith/Workshop by the next bounded service-interaction contract.

No currency cost is used in the first-slice proof.

No knowledge/rank gate is required for the prototype test profile; later content may own discovery/unlock presentation.

---

# 2. Exact material requirements

The recipe consumes exactly:

| Material ID | Quantity | Minimum quality |
|---|---:|---|
| `material_m01_tail_tendon` | 2 | `HIGH` |
| `material_m01_hide` | 2 | `STANDARD` |

Quality ordering for recipe eligibility:
`HIGH > STANDARD > LOW > SCRAP`.

Rules:
- HIGH tendon requirement accepts HIGH only;
- STANDARD hide requirement accepts STANDARD or HIGH;
- when more than one eligible quality exists for a minimum-quality requirement, deterministic consumption prefers the lowest quality that satisfies the requirement, preserving higher-quality material when possible;
- different quality bands are never silently averaged.

Why these materials:
- high-quality distal-tail tendon strongly rewards a clean, controlled tail sever/preservation path;
- hide provides practical grip/binding material and makes the recipe consume more than one anatomy source;
- the physical source-to-output relationship remains understandable.

---

# 3. Output/refinement identity

Stable refinement ID:
`refinement_field_poleblade_raker_tendon_grip`

Runtime owner after successful craft:
**the selected compatible Field Poleblade weapon instance.**

First-slice weapon-instance field concept:
`active_grip_refinement_id`.

First-slice invariant:
- at most one active grip refinement on one Field Poleblade instance;
- this recipe requires the grip-refinement position to be empty;
- replacement/removal/respec behavior is deferred rather than silently destroying an existing refinement.

The refinement is not represented as a second free-standing material stack after successful application.

---

# 4. Selected equipment effect

Effect ID:
`effect_field_poleblade_raker_tendon_grip_placed_hew_stamina`

Effect operation:
`COST_MODIFIER`

Target:
`POLEBLADE_PLACED_HEW` Stamina cost.

Prototype modifier:
`FLAT -2 Stamina`.

Existing first-slice base:
`POLEBLADE_PLACED_HEW = 18 Stamina`.

With only this refinement active:
`18 -> 16 Stamina` before other legal modifiers/caps.

The existing ordinary positive-cost floor from the Stamina contract remains authoritative.

## Explicit non-effects

This refinement does NOT:
- reduce Placed Hew AP cost;
- increase damage;
- increase hit-quality ceiling;
- guarantee selected-part contact;
- increase sever thresholds/contribution directly;
- increase Initiative;
- grant extra RP/turns;
- improve Guard/Block/Parry;
- increase Max Stamina;
- alter other Poleblade techniques.

Reason:
the first upgrade should improve handling efficiency while preserving the Field Poleblade's existing tactical envelope.

---

# 5. Why the effect matters

Placed Hew is the first-slice precision selected-part technique and costs 3 AP / 18 Stamina.

Reducing it to 16 Stamina:
- modestly improves repeated anatomy-focused play;
- leaves more reserve for later Dodge/Parry/Brace decisions;
- does not permit extra AP actions;
- does not remove the need for good exposure/bearing/range;
- does not convert the weapon into a raw-damage upgrade.

The player therefore feels a practical consequence from preserving and harvesting the exact Monster anatomy used in the recipe.

---

# 6. Recipe input ownership

Inputs must come from authoritative inventory material stacks owned by `PLAYER_FIELD_INVENTORY`.

A `RECOVERY_BUNDLE` is not consumed directly by this recipe in the first-slice proof. The material must first complete the existing inventory transfer boundary.

This keeps the chain explicit:

`HARVEST SOURCE -> RECOVERY_BUNDLE -> PLAYER_FIELD_INVENTORY -> CRAFT RESERVATION -> REFINEMENT`.

No crafting UI may invent temporary material counts outside this chain.

---

# 7. Deterministic ingredient selection

For each recipe requirement:
1. filter stacks by exact material ID;
2. filter by eligible quality;
3. prefer the lowest quality that still satisfies the requirement;
4. within that quality, consume stacks in deterministic stable stack order;
5. within a stack, consume provenance lots in their stable recorded order;
6. stop exactly at the required quantity.

This makes the same inventory state produce the same input selection.

The player-facing UI may later allow explicit lot/source selection, but the first-slice default remains deterministic.

---

# 8. Craft reservation

Before any material is consumed, create an authoritative reservation containing at least:
- `craft_transaction_id`;
- recipe ID;
- target weapon instance ID;
- required station/service tag;
- exact selected stack IDs;
- exact selected provenance-lot quantities;
- pre-commit inventory version;
- target weapon pre-commit refinement state.

Reservation validation must confirm:
- recipe exists;
- station/service context is legal;
- target weapon is Field Poleblade-compatible;
- grip-refinement position is empty;
- required materials/quality exist;
- selected quantities still exist at commit time;
- transaction ID has not already committed.

Reservation itself does not consume material.

---

# 9. Atomic craft commit

Selected commit boundary:

```text
VALIDATE RESERVATION
-> BEGIN CRAFT TRANSACTION
-> CONSUME EXACT RESERVED MATERIAL LOTS
-> APPLY refinement_field_poleblade_raker_tendon_grip TO TARGET WEAPON
-> REGISTER EFFECT SOURCE ON WEAPON/EQUIPMENT STATE
-> RECORD CRAFT TRANSACTION RESULT
-> COMMIT INVENTORY + WEAPON STATE TOGETHER
-> EMIT PRESENTATION EVENT
```

Hard law:

**the authoritative saved state may not expose a completed material consumption without the refinement, or the refinement without matching material consumption.**

Implementation may use a transaction journal, write-ahead record, domain command log or equivalent mechanism; exact storage mechanism is open.

---

# 10. Conservation

Successful craft consumes exactly four material units total:
- 2 tendon;
- 2 hide.

For each consumed material stack/provenance lot:
`SOURCE_LOSS == CRAFT_CONSUMPTION`.

No material is returned as change because quantities are integer units and exact.

Crafting cannot:
- consume five when the recipe requires four;
- consume material from a recovery bundle and inventory simultaneously;
- duplicate provenance;
- produce the refinement without consumption;
- consume materials twice on callback/reload replay.

---

# 11. Failure/rejection behavior

Reject before mutation for:
- missing recipe;
- wrong weapon family;
- occupied grip refinement;
- missing/invalid station context;
- insufficient tendon quantity;
- tendon below HIGH quality;
- insufficient hide quantity at STANDARD-or-better quality;
- stale reservation/inventory version;
- target weapon changed/removed;
- duplicate/conflicting transaction ID.

A normal validation failure spends/consumes nothing.

If an implementation-level interruption occurs after transaction start, recovery must resolve the journal to one legal terminal state:
- full commit exactly once; or
- rollback/no commit.

No partial loss state is acceptable.

---

# 12. Craft transaction idempotence

A stable `craft_transaction_id` is mandatory.

If the same already-committed transaction ID is submitted again:
- return/read back the recorded result;
- do not consume another 2 tendon/2 hide;
- do not apply a second copy of the refinement;
- do not create another effect source.

If the same ID is reused with conflicting payload, reject as transaction conflict.

UI double-tap, animation callback duplication and save/load resume must not bypass this rule.

---

# 13. Save/load persistence

Persist at least:
- craft transaction ledger/result;
- recipe ID;
- target weapon instance ID;
- consumed source stack/provenance references;
- refinement ID on target weapon;
- effect source ID;
- inventory post-commit quantities/version.

Reload must not:
- refund ingredients automatically;
- reapply the refinement twice;
- replay effect registration;
- lose the refinement while keeping ingredients consumed;
- restore consumed provenance lots.

---

# 14. Equipment/effect ownership

The refinement definition owns its configured effect reference.

The equipped/owned weapon instance owns whether that refinement is active.

The shared effect/modifier pipeline calculates the actual Stamina cost.

No crafting menu, animation, icon or item-description text directly edits Stamina values.

Debug trace should be able to explain:
`BASE 18 -> RAKER_TENDON_GRIP -2 -> FINAL 16` before other legal sources.

---

# 15. Relationship to hunt quality

The recipe intentionally consumes high-quality tendon because Monster 01's harvest packet says clean distal-tail sever can preserve tendon at PRISTINE/GOOD source condition, producing a HIGH quality ceiling when extraction is strong.

A crushed/ruined tail may still yield scraps, but those scraps do not satisfy this first recipe.

Therefore:
- combat choice changes source condition;
- source condition changes harvest quality;
- harvest quality changes recipe eligibility;
- recipe changes future tactical efficiency.

This is the intended closed-loop proof.

---

# 16. Reason to hunt again

The crafted refinement is not the end state.

The next hunt lets the player test whether the 2-Stamina Placed-Hew reduction:
- helps preserve defensive reserve;
- enables more deliberate anatomy-targeting attempts over a long encounter;
- improves the player's ability to pursue a clean sever/break strategy;
- creates a noticeable but bounded equipment progression difference.

The game loop becomes:

`HUNT CLEANLY -> RECOVER QUALITY MATERIAL -> CRAFT REFINEMENT -> EQUIP/APPLY -> HUNT AGAIN WITH A NEW TACTICAL EDGE`.

---

# 17. Logical settlement-service boundary

The recipe requires `CRAFT_STATION_WEAPON_WORKBENCH` but this contract does not define the physical interaction flow.

Current Settlement 01 authority already contains:
- a Smith/Workshop;
- a compact Hunter Service Loop;
- return-from-hunt processing/crafting adjacency.

The next bounded contract maps this logical requirement to a physical walkable service interaction without building broad commerce/economy.

---

# 18. Trace requirements

A development craft trace must include at least:
- craft transaction ID;
- recipe ID;
- station/service tag;
- target weapon instance ID;
- pre-existing refinement state;
- each material requirement;
- selected stack IDs;
- selected quality bands;
- consumed provenance lots + quantities;
- inventory version before/after;
- refinement ID applied;
- effect source ID;
- resulting Placed-Hew cost trace;
- rejection/rollback reason where applicable.

Same authoritative state and command must produce the same result.

---

# 19. Explicitly deferred

Not selected here:
- recipe unlock narrative;
- recipe research tree;
- multiple refinement sockets;
- refinement removal/replacement;
- crafting timers/minigames;
- currency/service fees;
- randomized craft quality;
- item rarity colors;
- weapon durability;
- many recipes;
- broad armor crafting;
- market/selling;
- companion crafting ownership;
- production source/UI/animation.

---

# 20. Required future implementation tests

Before this linkage can be runtime verified, test at least:
1. recipe ID resolves uniquely;
2. only Field Poleblade-compatible target is accepted;
3. occupied grip refinement rejects without mutation;
4. missing workbench/service context rejects without mutation;
5. exactly 2 HIGH tendon required;
6. STANDARD tendon cannot satisfy HIGH requirement;
7. exactly 2 STANDARD-or-better hide required;
8. STANDARD hide is preferred before HIGH hide;
9. deterministic stack order is stable;
10. provenance-lot selection is deterministic;
11. insufficient quantity rejects without consuming anything;
12. stale reservation rejects without consuming anything;
13. successful craft consumes exactly 2 tendon + 2 hide;
14. source inventory quantity decreases exactly by consumed quantity;
15. consumed provenance quantity is removed exactly once;
16. refinement is applied exactly once to target weapon;
17. duplicate craft transaction ID does not consume again;
18. conflicting payload under same transaction ID rejects;
19. save/load preserves committed refinement;
20. save/load preserves consumed inventory quantities;
21. reload does not reapply effect source;
22. Placed Hew base 18 becomes 16 with only this refinement;
23. modifier does not change Placed Hew AP;
24. modifier does not change damage/hit-quality/sever thresholds;
25. modifier does not change other Poleblade techniques;
26. ordinary Stamina cost floor remains enforced;
27. craft presentation callback cannot trigger a second commit;
28. atomic interruption recovery never leaves ingredients consumed without refinement;
29. atomic interruption recovery never grants refinement without ingredients consumed;
30. trace reproduces ingredient selection, commit and final effect calculation.

These are future runtime/domain tests. This document is design-recorded only.

---

# 21. Acceptance

Design baseline is complete when:
- [x] exactly one recipe selected;
- [x] exact material IDs/quantities/qualities selected;
- [x] exact refinement/effect IDs selected;
- [x] one bounded effect selected;
- [x] deterministic ingredient selection selected;
- [x] atomic craft transaction selected;
- [x] inventory/provenance conservation linked;
- [x] save/load/idempotence requirements recorded;
- [x] future tests recorded;
- [x] broad crafting/economy kept outside scope.

`FIRST_SLICE_ONE_RECIPE_CRAFT_EQUIP_LINKAGE_RECORDED = YES`
`CRAFTING_RUNTIME_IMPLEMENTED = NO`
`CRAFTING_RUNTIME_VERIFIED = NO`
