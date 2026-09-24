# First-Slice Harvest Capacity and Condition Contract

Status: SELECTED FIRST-SLICE PROTOTYPE DESIGN / NO HARVEST IMPLEMENTATION
Last reconciled: 2026-09-03

Technical owner: `docs/20_gameplay/harvest/`

## Purpose

Define one deterministic harvesting model where surviving anatomy determines what can physically be recovered, how much remains, what condition it is in, and how repeated extraction depletes the same source.

Primary rule:

**Yield is bounded by surviving anatomical capacity. Skill, tools and knowledge can improve recovery of what physically remains; they can never create additional matter or duplicate a unique body structure.**

This contract owns:
- harvest-source capacity units;
- surviving-capacity and condition mapping;
- clean sever/break/destruction consequences;
- carcass and detached-part harvest containers;
- extraction/recovery efficiency;
- source depletion;
- unique-source lineage/anti-duplication;
- deterministic trace/persistence requirements;
- future implementation tests.

It does not own:
- combat damage/break/sever resolution;
- Monster death/escape outcome;
- material inventory/storage;
- recipes/crafting;
- economy value;
- party reward sharing;
- final physical kilograms for a species whose final mass is still open.

Supporting authorities:
- `/MECHANICAL_SYSTEMS_GUIDE.md`;
- `/CONTENT_DATA_GUIDE.md`;
- `/STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`;
- `/docs/20_gameplay/combat/COMBAT_RESOLUTION_HIT_QUALITY_DEFENSE_CONTRACT.md`;
- `/docs/20_gameplay/combat/DEFEAT_RETREAT_BASELINE_CONTRACT.md`.

---

# 1. Harvest-source identity

A `HarvestSourceDefinition` links one physical anatomy source to one material output.

Minimum fields:
- stable `harvest_source_id`;
- source `part_id` or source-group ID;
- `material_id`;
- `capacity_type` = `DISCRETE` or `CONTINUOUS_UNITS`;
- `original_capacity_units`;
- preferred/required tool tags;
- minimum source condition;
- condition-to-preservation rules;
- knowledge requirement if any;
- extraction difficulty/time metadata later.

A runtime `HarvestSourceState` stores at least:
- source instance ID;
- owning monster instance ID;
- physical-container ID;
- lineage ID;
- original capacity;
- surviving capacity after combat damage;
- remaining unharvested capacity;
- current quality/condition band;
- extracted total;
- terminal/depleted flag.

---

# 2. Capacity units

First slice uses **material-specific harvest capacity units**, not kilograms.

Reason:
- Monster 01 final physical mass is still open;
- recipes/game balance need finite quantities now;
- an abstract capacity unit can later receive a physical weight without changing anti-duplication or depletion logic.

Rules:
- `original_capacity_units >= 0`;
- capacity is authored per physical source;
- capacity never increases because of player skill;
- capacity never increases on save/load/reacquisition;
- capacity cannot exceed the original source definition unless an explicit biological growth/recovery system later owns that change outside an active harvest event.

`DISCRETE` sources additionally enforce unique-count invariants.

---

# 3. Condition bands

Generic first-slice preservation bands:

| Band | Preservation multiplier | Meaning |
|---|---:|---|
| `PRISTINE` | `1.00` | source survived with negligible destructive loss |
| `GOOD` | `0.90` | ordinary wounds/surface damage; most material remains |
| `DAMAGED` | `0.70` | substantial break/wound/crush damage |
| `POOR` | `0.40` | heavily shattered/crushed/contaminated source |
| `RUINED` | `0.10` | only scraps/fragments remain recoverable |
| `DESTROYED` | `0.00` | no usable output of this material source remains |

The anatomy state alone does not automatically select the band. Combat/damage history and source-specific rules map the final physical state to a band.

Examples:
- a cleanly severed tail can remain `PRISTINE` or `GOOD` for tail-specific materials;
- a shattered horn may be `POOR` even though horn fragments physically exist;
- a broken dorsal plate can still be `DAMAGED` rather than disappearing;
- a destroyed organ/source is `DESTROYED` for intact-organ material.

---

# 4. Surviving capacity

At encounter/carcass harvest-state creation:

```text
surviving_capacity =
    floor(original_capacity_units * preservation_multiplier)
```

Clamp:

```text
0 <= surviving_capacity <= original_capacity_units
```

The calculation is performed once from authoritative final source condition for that harvest phase and stored.

Later extraction does not recalculate upward because a menu was reopened.

If later world decay/contamination exists, it may reduce surviving/remaining capacity through a separately owned rule; it may never increase it.

---

# 5. Clean sever rule

A legal clean sever is primarily a **preservation event**, not a bonus-matter event.

For a designated severable source:
- sever transfers the corresponding physical source from attached carcass lineage to a detached-part container;
- it does not clone capacity;
- clean cutting can preserve a better condition band than destructive crushing/tearing;
- any already-damaged material remains damaged after sever;
- source capacity before + after transfer is conserved.

Hard invariant:

```text
attached_remaining + detached_remaining + already_extracted
<= original_capacity
```

For Monster 01 the distal tail is the first proof source.

---

# 6. Break / shatter rule

Breaking does not automatically mean zero yield.

Source-specific mapping decides whether a break produces:
- intact recoverable component;
- lower-quality fragments of the same material;
- reduced capacity;
- unusable destruction.

A single physical horn cannot become multiple intact horns after breaking.

If a source uses continuous material units, fragments may still preserve some capacity while quality falls.

---

# 7. Carcass and detached-part containers

Harvest occurs from physical containers.

Minimum first-slice containers:
- `CARCASS_CONTAINER` — material still attached to the dead Monster body;
- `DETACHED_PART_CONTAINER` — severed/broken-off physical source objects that exist independently.

Each container has:
- stable container instance ID;
- owning Monster instance ID;
- source lineage IDs it currently owns;
- world/persistence reference;
- remaining source states.

When a source is detached:
1. remove/transfer that source lineage from the attached container;
2. create or update exactly one detached container for that physical source;
3. preserve remaining capacity and quality;
4. never leave the same capacity active in both places.

---

# 8. Recovery efficiency

A legal extraction computes a deterministic `recovery_efficiency` from explicit factors.

Prototype bounds:

```text
0.50 <= recovery_efficiency <= 1.00
```

Potential inputs:
- correct/incorrect tool category;
- Hunter harvest proficiency/technique;
- known versus poorly understood source;
- source condition/accessibility;
- explicit equipment effects.

No random harvest-roll layer is used in the first slice.

A poor tool may reduce efficiency or make a source illegal to extract. A superior tool/skill can approach `1.00`, never exceed it.

---

# 9. Extraction formula

For one committed harvest action/request:

```text
recoverable_now = floor(requested_capacity * recovery_efficiency)
recoverable_now = clamp(recoverable_now, 0, remaining_capacity)
```

Minimum useful deterministic rule:
- if `requested_capacity > 0`, source is legal, remaining capacity is positive and efficiency would floor to zero, return `1` unit only when at least one whole capacity unit physically remains;
- never return fractional capacity units in the first slice.

After successful extraction:

```text
remaining_capacity -= recoverable_now
extracted_total += recoverable_now
```

Then assert:

```text
remaining_capacity + extracted_total <= surviving_capacity
```

Inventory acceptance/stacking occurs after yield resolution and is owned by the next inventory contract.

---

# 10. Partial harvesting

A player may harvest only part of a source.

Example:
- source has 8 surviving units;
- player requests 3;
- recovery efficiency 0.90;
- yield = floor(3 * 0.90) = 2;
- only 2 units are removed from the source;
- 6 remain.

The system does not consume all 3 requested units when only 2 were successfully recovered unless a later extraction-waste mechanic explicitly owns that loss.

First slice therefore separates:
- **requested amount**;
- **successfully recovered amount**;
- **remaining physical capacity**.

---

# 11. Unique physical structures

Discrete unique structures require stable lineage IDs.

Examples:
- left horn;
- right horn;
- one special gland;
- one detached tail source.

Rules:
- one lineage cannot exist simultaneously as multiple intact rewards;
- changing container does not create another lineage;
- save/load cannot duplicate lineage;
- inventory transfer later stores provenance pointing to the physical source lineage;
- a continuous-material representation of a broken unique structure still cannot claim more total capacity than that structure originally contained.

---

# 12. Monster escape boundary

`MONSTER_ESCAPED` does not create a carcass.

The same living Monster retains:
- anatomy damage;
- missing/severed source state;
- already-created detached parts remaining in the world;
- any source-capacity losses already caused by damage.

The player may harvest a detached part that physically remains accessible even while the Monster escaped, if world/interaction rules allow it.

Reacquiring the Monster cannot respawn an already detached horn/tail or restore its harvest capacity.

---

# 13. Monster death boundary

`MONSTER_DEAD` or a completed Monster side of `MUTUAL_TERMINAL` allows carcass harvest state to be created from the final authoritative anatomy snapshot.

The carcass state reads:
- all attached body parts;
- final damage/break/sever/destroyed states;
- detached-source lineage already existing elsewhere;
- relevant Crystal/body state if later harvestable;
- source-specific condition mapping.

The defeat system does not award materials directly.

---

# 14. Mutual terminal boundary

`MUTUAL_TERMINAL` preserves carcass and detached-part state but does not auto-credit harvest to the player.

Whether the recovered party can later return to the carcass is a world/persistence question.

This avoids turning simultaneous defeat into free inventory rewards while still preserving physical consequences.

---

# 15. Quality

First slice stores a source quality band separately from quantity.

Recommended bands:
- `HIGH`;
- `STANDARD`;
- `LOW`;
- `SCRAP`.

Condition normally sets the maximum achievable quality:
- PRISTINE -> HIGH ceiling;
- GOOD -> HIGH/STANDARD;
- DAMAGED -> STANDARD/LOW;
- POOR -> LOW/SCRAP;
- RUINED -> SCRAP only;
- DESTROYED -> none.

Tools/skill may preserve/recover closer to that ceiling but cannot upgrade physically ruined material into pristine quality.

Exact recipe quality requirements are deferred.

---

# 16. Knowledge boundary

Unknown anatomy does not stop matter from existing.

Knowledge may affect:
- whether the UI identifies the material/source correctly;
- whether the Hunter knows a preferred extraction method;
- recovery efficiency;
- quality preservation;
- displayed estimated remaining capacity.

Perception/knowledge cannot make hidden source capacity exceed physical truth.

---

# 17. Tool boundary

Harvest tools are explicit capability/efficiency inputs.

A tool may:
- permit extraction;
- reduce waste;
- improve recovery efficiency within `<=1.00`;
- preserve quality;
- reduce extraction time later.

A tool may not:
- multiply source capacity;
- restore destroyed material;
- turn one horn into two;
- harvest from a source that no longer physically exists.

---

# 18. Persistence and save/load

Save state must preserve at least:
- Monster instance ID;
- harvest container IDs;
- source instance + lineage IDs;
- original/surviving/remaining/extracted capacities;
- condition and quality bands;
- detached/attached ownership;
- depletion flag;
- extraction transaction sequence IDs.

Reload may not:
- reroll source condition;
- restore depleted capacity;
- clone detached sources;
- duplicate a committed extraction transaction;
- create a new carcass for the same dead Monster;
- reset already-harvested material because the region reloaded.

---

# 19. Transaction boundary

A harvest extraction should use an authoritative transaction sequence:

```text
SELECT SOURCE / REQUEST AMOUNT
-> VALIDATE SOURCE + TOOL + KNOWLEDGE REQUIREMENTS
-> SNAPSHOT REMAINING CAPACITY
-> CALCULATE RECOVERY EFFICIENCY
-> CALCULATE YIELD
-> COMMIT SOURCE DEPLETION
-> EMIT MATERIAL-TRANSFER RESULT
-> INVENTORY OWNER ACCEPTS/REJECTS/STORES RESULT
-> TRACE TRANSACTION
```

UI cannot grant material before source depletion commits.

If later inventory capacity can reject transfer, the inventory contract must define whether material remains in a temporary extraction container or the transaction is prevented before depletion. Harvest will not silently delete or duplicate matter.

---

# 20. Trace requirements

Development trace should include:
- harvest transaction ID;
- Monster instance ID;
- container ID;
- source/lineage ID;
- material ID;
- original/surviving/remaining-before capacity;
- source condition + preservation multiplier;
- requested capacity;
- tool/knowledge/skill factors;
- final recovery efficiency;
- recovered quantity;
- remaining-after quantity;
- quality result;
- destination transfer request ID;
- rejection/failure reason if any.

Same authoritative state/input must produce same result.

---

# 21. Explicitly deferred

Not selected here:
- inventory carry limits;
- material stack-size rules;
- crafting recipes;
- sale prices/economy;
- party reward ownership/splitting;
- carcass decay timers;
- field-processing minigames;
- exact extraction animation duration;
- permanent Hunter harvest-skill progression curve;
- final kilograms/real mass calibration;
- broad material catalog.

---

# 22. Required future implementation tests

Before harvest can be runtime verified, test at least:
1. surviving capacity never exceeds original capacity;
2. DESTROYED source yields zero;
3. PRISTINE multiplier preserves full capacity;
4. condition mapping is deterministic;
5. clean sever transfers rather than duplicates source capacity;
6. attached + detached + extracted never exceed original lineage capacity;
7. partial extraction reduces only recovered quantity;
8. repeated extraction eventually reaches zero and then rejects further yield;
9. recovery efficiency never exceeds 1.00;
10. skill/tool improvement never creates capacity;
11. wrong/missing required tool rejects or applies exact authored penalty;
12. unique left horn cannot produce two intact left-horn lineages;
13. save/load preserves remaining capacity;
14. save/load cannot replay a committed extraction;
15. Monster escape does not create a carcass;
16. reacquisition does not regrow severed harvest sources;
17. dead Monster creates exactly one carcass state;
18. mutual-terminal does not auto-credit harvest;
19. detached part remains harvestable independently when world rules allow;
20. quantity and quality are tracked separately;
21. poor condition caps quality;
22. UI reopen does not recalculate source upward;
23. no harvest RNG is sampled;
24. trace reproduces all capacity/efficiency/yield math;
25. inventory handoff cannot grant material before depletion commit;
26. source lineage remains stable through container/world reload;
27. two material sources on one body part deplete independently while sharing the same physical part state;
28. total material from one source never exceeds its surviving capacity.

These are future domain/runtime tests. This document itself is design-recorded only.

---

# 23. Acceptance

Design baseline is complete when:
- [x] finite source capacity selected;
- [x] material-specific capacity units selected;
- [x] condition/preservation bands selected;
- [x] sever transfer/anti-duplication law selected;
- [x] break/shatter behavior bounded;
- [x] carcass/detached containers defined;
- [x] deterministic recovery efficiency selected;
- [x] partial extraction/depletion selected;
- [x] quality separated from quantity;
- [x] Monster escape/death/mutual-terminal boundaries linked;
- [x] save/load/transaction/trace requirements recorded;
- [x] future tests recorded;
- [x] inventory/crafting/economy kept outside scope.
