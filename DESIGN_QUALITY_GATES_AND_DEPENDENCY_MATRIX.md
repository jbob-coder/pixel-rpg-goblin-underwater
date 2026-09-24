# Unnamed Hunt RPG — Design Quality Gates and Cross-System Dependency Matrix

Status: ACTIVE DESIGN GOVERNANCE / NO IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

This document is the project-wide quality-control layer.

The project already has dedicated documents for world structure, combat, stats/effects, deterministic behavior, crystal life-force, mutation/ecology, performance, code, testing and creator tools. The remaining risk is **cross-system drift**: a new feature can look correct inside its own document while quietly breaking another system.

This guide exists to prevent that.

It defines:
- project-wide invariants;
- system ownership boundaries;
- dependency and impact rules;
- complexity budgets;
- feature-admission gates;
- documentation-state labels;
- change-impact analysis;
- anti-duplication rules;
- quality priorities;
- the order in which documentation should be expanded.

It does **not** replace the owning system documents. It tells us how they must remain compatible.

---

# 1. Primary quality fix

Every meaningful new mechanic must answer five questions before it becomes a design decision:

1. **What player decision does this create?**
2. **Which authoritative system owns it?**
3. **Which other systems does it affect?**
4. **What invariants/caps can it never violate?**
5. **How will we verify that it works and remains affordable on Android?**

If a proposed feature cannot answer these questions, it remains an idea rather than a project decision.

---

# 2. Documentation state labels

Every substantial design statement should use one of these meanings even when the label is not repeated on every sentence.

## LOCKED / CURRENT DECISION
Use when:
- explicitly decided by the user;
- selected as the current project architecture;
- should be treated as current authority unless deliberately changed.

Examples:
- no AI behavior system;
- deterministic authored patterns/conditions;
- crystal energy is creature life force;
- settlements are physically walkable;
- ordinary wilderness sectors should remain continuous when possible.

## SELECTED ARCHITECTURE
A preferred structural solution selected after alternatives were considered.

It can still be changed if implementation evidence disproves it, but future work should build around it until then.

Example:
- walkable settlement → major transition → continuous streamed hunting region.

## PROTOTYPE TARGET
A number/range/model selected for testing, not proven truth.

Examples:
- 1 world unit = 1 meter;
- first settlement around 180–320 m characteristic extent;
- 4–7 first-region sectors;
- 5–8 m first major monster length.

Prototype targets must never be reported as measured runtime limits.

## OPEN
Not decided. Future work may compare alternatives.

Examples:
- exact AP budget;
- exact crystal tiers;
- exact equipment slots;
- engine choice.

## FUTURE OPTION
Compatible with current architecture but intentionally deferred.

Examples:
- settlement siege events;
- broad hunting-pressure ecosystem evolution;
- very large cave/dungeon spaces.

## REJECTED / NOT PREFERRED
An option considered and currently excluded for a reason.

Examples:
- one giant always-loaded world;
- loading every wilderness sector separately;
- opaque AI decision system.

Rejected ideas can only return if new evidence addresses the original reason for rejection.

---

# 3. Project-wide quality hierarchy

When two goals conflict, protect in this order unless an owning document explicitly establishes a stronger local rule:

1. authoritative gameplay correctness;
2. player input/control responsiveness;
3. save/state integrity;
4. tactical readability and monster-anatomy readability;
5. clear cause-and-effect/explainability;
6. stable frame pacing and memory behavior;
7. hunt continuity and world coherence;
8. meaningful player choice;
9. content scalability/authoring efficiency;
10. audiovisual polish;
11. decorative density.

A prettier effect may never justify corrupting state, hiding telegraphs, destroying readability or destabilizing the phone build.

---

# 4. Global invariants

These are cross-system laws that future features must preserve.

## 4.1 Authority invariant

Gameplay truth is resolved in authoritative domain systems.

UI, animation, audio, particles, camera and models can represent outcomes but cannot secretly decide:
- damage;
- hit quality;
- break/sever/destroy;
- crystal-energy drain;
- mutation acquisition;
- status application;
- tactical position;
- harvest yield;
- inventory consumption;
- save progression.

## 4.2 Identity invariant

Persistent entities keep stable identity through transitions.

A hunted monster remains the same monster through:
`REGION → ENCOUNTER → ESCAPE/DEATH → HARVEST/WORLD RETURN`.

Do not replace the monster with a visually similar fresh instance when crossing sectors or modes.

## 4.3 Physical-resource invariant

No system creates physical material that does not have a valid source.

Examples:
- one tail cannot create several intact tails;
- destroyed anatomy cannot yield a pristine unique structure;
- crystal harvest cannot duplicate the creature's one physical core;
- harvesting efficiency can improve recovery but cannot create mass from nothing.

## 4.4 Crystal-life invariant

For crystal-bearing creatures:
- current usable crystal energy is life-force reserve;
- zero usable reserve resolves creature death;
- berserk consumes this same finite reserve;
- Tier/Rank/Quality/Element are not interchangeable with current energy;
- severed/broken anatomy is not magically restored by berserk unless an explicit future regeneration mechanic is separately approved.

## 4.5 Behavior-legality invariant

Deterministic NPC/creature behavior selects intentions only.

It must submit normal legal actions and cannot:
- teleport;
- ignore collision;
- ignore AP/stamina;
- use destroyed anatomy;
- bypass status restrictions;
- invent damage or loot.

## 4.6 Effect-pipeline invariant

Equipment, status, terrain, weather, posture, injury, crystal/mutation effects and action context use the common typed effect framework.

Do not create hidden one-off bonus math inside presentation or species scripts when the shared framework can represent the rule.

## 4.7 Action-economy invariant

AP and reaction count are high-leverage resources.

New equipment/attributes/statuses/mutations cannot create uncontrolled extra actions.

Any AP/reaction modification requires:
- explicit cap;
- explicit stack rule;
- clear source;
- trace output;
- dedicated balance tests.

## 4.8 Map-continuity invariant

Ordinary wilderness sector boundaries are technical streaming boundaries, not gameplay teleport boundaries.

Persistent monsters, tracks, injuries, ecology state and current hunt context must remain coherent across them.

## 4.9 Performance-bound invariant

Every scalable system must define:
- maximum active count or budget;
- update frequency/tier;
- cleanup/unload rule;
- debug instrumentation;
- isolation/degradation strategy where practical.

No unbounded particles, effects, statuses, behavior traces, decals, actors, sectors, logs, saves or mutation combinations.

## 4.10 Explainability invariant

Important mechanical results must be explainable.

Development builds should be able to answer questions such as:
- Why did this attack cost 3 AP?
- Why could the monster not use its charge?
- Why was this tail yield reduced?
- Why did this mutation appear?
- Why did this sector load/unload?
- Why did berserk activate?

If the project cannot explain a result, debugging and balancing will eventually become unreliable.

---

# 5. System dependency matrix

This matrix defines ownership and major dependencies.

| System | Owns | Reads from | Must not directly own |
|---|---|---|---|
| World/Region | location, sectors, region state, persistent actors | ecology, content, time/weather | damage, inventory math |
| Settlement | local NPC/service/runtime state | world flags, schedules, content | wilderness ecology simulation |
| Streaming | loaded/presented sector lifecycle | player position, sector graph, budgets | gameplay outcomes |
| Exploration | movement/tracking/gathering/encounter request | terrain, world, stats/effects | combat damage |
| Encounter | turns/AP/reactions/tactical position | terrain, stats, anatomy, statuses | rendering outcomes |
| Stats/Effects | derived values and contextual modifiers | equipment, status, terrain, mutation | inventory ownership |
| Anatomy | part integrity/state/capabilities | damage results, definitions | visual sever decisions |
| Damage | hit/protection/damage resolution | technique, stats/effects, anatomy | harvest award |
| Behavior | authored condition evaluation/action intent | authoritative actor/world facts | direct state mutation |
| Crystal | energy reserve/core condition | damage/status/behavior context | anatomy replacement |
| Mutation | mutation definitions/active traits | crystal/species/environment | arbitrary uncontrolled generation |
| Ecology | aggregate population/selection pressure | region, species, hunting pressure | every off-screen creature instance |
| Harvest | recoverable remaining material | anatomy, crystal, tool/skill | combat resolution |
| Inventory | item/material ownership | harvest/crafting outputs | damage calculation |
| Equipment | equipped definitions/loadout | inventory, effects | direct stat mutation outside effects service |
| Crafting | recipe validation/consumption/output | inventory/material definitions | free material creation |
| Knowledge | discovered information | observation/research/harvest | hidden omniscient truth exposure |
| Persistence | serialization/migration/recovery | authoritative state | gameplay decisions |
| Presentation | visual/audio/UI representation | snapshots/events | authoritative mutation |
| Admin/Creator | validated inspection/test authoring | all relevant schemas/state | secret bypass rules |

When a new feature appears to require two systems to own the same truth, stop and resolve ownership before implementation.

---

# 6. Cross-system impact classes

Before accepting a feature, classify its impact.

## Class A — Local
Touches one owner with little/no persisted or performance consequence.

Example:
- changing the icon used for a known status.

## Class B — Shared-mechanic
Touches several gameplay systems but stays inside one session/mode.

Example:
- a terrain effect that modifies movement and targeting.

Requires integration tests.

## Class C — Persistent
Changes save-visible or cross-mode state.

Example:
- a mutation that changes anatomy and persists after monster escape.

Requires save/reload and transition tests.

## Class D — Structural/performance
Changes streaming, scene lifetime, actor count, update frequency, large assets or platform behavior.

Example:
- expanding settlement NPC density or keeping more neighboring wilderness sectors loaded.

Requires target-device profiling.

## Class E — Foundational
Changes a project-wide invariant, authority boundary, save identity or core data model.

Example:
- changing crystal energy from life-force reserve into an optional mana pool.

Requires explicit design reconciliation before any code work.

---

# 7. Feature admission gate

A proposed mechanic should not move from IDEA to CURRENT DESIGN until it passes this checklist.

## Player value
- Does it create a meaningful decision, information problem, risk/reward or world consequence?
- Is it visible/understandable enough for the player to use intentionally?
- Does it improve the hunt loop rather than merely add another number?

## Ownership
- Which system is authoritative owner?
- Which systems read it?
- Which systems are forbidden from mutating it?

## Interaction
- What happens with anatomy?
- What happens with crystal energy?
- What happens with mutations?
- What happens with equipment/status/terrain?
- What happens when a monster flees?
- What happens across save/reload?

Not every feature must affect every system. The point is to check deliberately.

## Complexity
- Does this duplicate an existing mechanic?
- Can it use the shared effect/capability/condition systems?
- Does it require a new subsystem or only new content data?
- Can a content author understand it without custom code?

## Performance
- Maximum active count?
- Evaluation frequency?
- Memory cost?
- Presentation cost?
- What degrades first on weaker devices?

## Verification
- What unit test proves the rule?
- What integration fixture proves interaction?
- Does it need target-phone verification?
- What trace/debug output explains it?

If several answers are unknown, keep the feature OPEN instead of prematurely locking it.

---

# 8. Complexity budget

The game's depth should come from interactions between a limited number of strong systems, not from hundreds of independent micro-systems.

## 8.1 Reuse before invention

Before adding a new mechanic, first ask whether it can be expressed using:
- attributes;
- typed effects;
- statuses;
- terrain tags;
- capabilities;
- anatomy state;
- crystal state;
- mutation traits;
- behavior conditions;
- knowledge/research state.

If yes, prefer composition over a new subsystem.

## 8.2 New subsystem threshold

Create a new subsystem only if the mechanic has:
- its own authoritative state;
- its own lifecycle;
- several consumers;
- persistence or validation requirements;
- behavior that cannot be represented clearly through existing primitives.

## 8.3 Content-combination cap

Mutation/status/equipment combinations can explode combinatorially.

Therefore:
- every category gets caps;
- incompatible combinations are explicit;
- content validators reject illegal combinations;
- first vertical slice uses deliberately small sets;
- broad content expansion happens only after combination tests exist.

## 8.4 Choice-density rule

Avoid adding options that are mathematically different but tactically identical.

Example of weak variety:
- sword A +5 damage;
- sword B +7 damage;
- sword C +9 damage.

Prefer choices that change behavior:
- better severing but worse armor break;
- better mud stability but heavier burden;
- stronger guard but higher stamina cost;
- mutation that improves water movement but increases heat strain.

---

# 9. Anti-duplication rules

Do not create separate versions of the same concept under different names unless the distinction is mechanically necessary.

Examples to watch:
- Endurance vs Resolve;
- wound vs status;
- crystal Rank vs Tier;
- mutation Quality vs crystal Quality;
- armor protection vs resistance;
- region sector vs encounter footprint;
- behavior phase vs combat phase;
- knowledge discovery vs Perception attribute.

When two concepts overlap, document the boundary explicitly before adding more content.

---

# 10. Player-facing clarity gate

A system is too opaque if the player cannot reasonably infer or learn its important consequences.

Use three information layers:

## Immediate
Things the player must know now:
- attack telegraph;
- AP/stamina cost;
- critical status;
- target accessibility;
- cover/terrain state.

## Learnable
Information gained through hunting/research:
- monster habits;
- mutation tendencies;
- anatomy weaknesses;
- crystal/element knowledge;
- territory patterns.

## Hidden/internal
Information normally reserved for developer tools:
- exact RNG seed;
- cache invalidation;
- streaming reference counts;
- exact rule-evaluation traces.

Do not expose developer complexity directly as player UI clutter.

---

# 11. Quality gate for world/map additions

Any new settlement/region/sector must define:
- gameplay purpose;
- visual identity;
- traversal structure;
- landmarks;
- safety/danger class;
- required runtime systems;
- streaming neighbors;
- persistent state;
- monster/ecology role where applicable;
- encounter-capable footprints;
- performance budget;
- unload behavior;
- map/discovery representation.

A region is not complete because terrain art exists.

A settlement is not complete because buildings exist.

---

# 12. Quality gate for a new monster

Before a monster can become production content it should eventually define:
- species identity/ecological role;
- crystal profile;
- mutation possibilities;
- anatomy graph;
- functional capabilities;
- attack set;
- deterministic behavior profile;
- terrain preferences/adaptations;
- tracking evidence;
- escape/retreat behavior;
- berserk conditions if used;
- harvest sources;
- visual readability;
- audio telegraphs;
- content validation;
- performance budget;
- test fixtures.

Do not solve missing design by putting unique logic directly into one monster script.

---

# 13. Quality gate for new equipment

Every equipment item/family should define:
- role;
- tradeoff;
- technique/capability effects;
- burden/cost where used;
- target anatomy interactions;
- terrain/status interactions where meaningful;
- crafting/material source;
- progression position;
- stacking rules;
- visual silhouette/readability;
- first-person presentation cost;
- test cases.

If an upgrade only raises every number with no choice, reconsider whether it adds useful gameplay.

---

# 14. Quality gate for status/terrain/mutation effects

Every effect should define:
- stable ID;
- owner/source;
- target stat/capability/rule;
- operation;
- conditions;
- stack group/policy;
- duration/lifetime;
- cap/floor;
- visibility/feedback;
- save persistence policy;
- removal/cleanup rule;
- trace explanation;
- combination tests.

Avoid effects whose only definition is prose such as "makes the hunter much faster."

---

# 15. Documentation architecture quality rules

The documentation itself must remain maintainable.

## 15.1 One owner per topic

Each durable topic gets one primary authority.

Other docs summarize and link rather than copying large duplicated rule sets.

## 15.2 Specific beats general

If a general document and a newer dedicated authority overlap, the dedicated authority owns the detail unless an explicit reconciliation says otherwise.

## 15.3 Decisions and candidates stay distinct

Do not silently convert:
- examples;
- recommendations;
- prototype numbers;
- future options
into locked requirements.

## 15.4 Current-state docs remain small enough to resume from

`START_HERE_NEW_CHAT.md` and `PROJECT_HANDOFF.md` should summarize current authority rather than duplicate every detailed design document.

## 15.5 Source-adjacent docs wait for source

Do not invent class names, file paths, exact APIs or measured performance records before implementation exists.

## 15.6 Reconciliation after major decisions

When a foundational design changes:
1. update owning document;
2. identify dependent docs through this dependency matrix;
3. update conflicting summaries;
4. update discussion checklist;
5. update handoff/status;
6. read back saved files;
7. record what remains open.

---

# 16. Documentation expansion order

Do not try to finish every possible document now.

Expand in bounded pieces.

## Piece A — Cross-system quality governance
**Current piece.**

Create this document and integrate it into the documentation index/handoff.

Goal:
prevent future design drift before more detailed content is added.

## Piece B — First settlement blueprint
Next recommended documentation piece.

Define:
- settlement geography;
- defensive logic;
- approximate meter-scale layout;
- districts/services;
- NPC-density zones;
- walkable interiors;
- hunter gate/transition corridor;
- camera occlusion/readability;
- streaming/culling partitions;
- first-pass building kit.

Do not design every future settlement.

## Piece C — First hunting-region blueprint
Define one region only:
- 4–7 sectors;
- sector connections;
- elevation/water/terrain;
- ecology/mutation pressure;
- first monster territory;
- camps;
- tracks;
- encounter footprints;
- streaming graph;
- sight-line management;
- performance expectations.

## Piece D — First monster complete design packet
Create one monster as the proof content for:
- crystal;
- mutation;
- anatomy;
- deterministic behavior;
- terrain interaction;
- berserk;
- harvest.

## Piece E — Player progression/equipment packet
Only after the first monster and region provide something concrete to balance against.

## Piece F — Exact combat economy packet
Lock AP/stamina/reaction numbers only when first weapon/monster/terrain cases exist.

## Piece G — Technical engine mapping
Only after engine/device probe.

Translate design authorities into actual folders/classes/scenes/resources/tests.

---

# 17. Change-impact workflow

When a new idea is proposed:

```text
IDEA
↓
identify owner
↓
classify impact A–E
↓
list dependencies
↓
check global invariants
↓
check complexity/performance budget
↓
mark LOCKED / PROTOTYPE / OPEN / FUTURE / REJECTED
↓
update owning doc
↓
update dependent summaries only
↓
read back
```

This is intentionally slower than dumping ideas into many documents, because it keeps the project coherent.

---

# 18. Current known high-risk interaction zones

These deserve extra scrutiny as the design expands.

## AP / action economy
Small numerical changes have disproportionately large tactical effects.

## Mutation × anatomy
Structural mutations can invalidate assumptions in targeting, animation, harvest and behavior.

## Crystal × damage × berserk
Core damage, energy drain and death must not create contradictory death conditions.

## Equipment × status × terrain
Modifier stacking can become opaque or exploitable.

## Monster escape × streaming
Persistent monsters must survive sector unload/reload without duplication or state loss.

## Settlement interiors × aerial camera
Roofs/walls/occlusion must remain readable without making architecture physically oversized.

## Ecology × persistence
Aggregate ecology must not contradict persistent named/hunted monster instances.

## Creator tools × authority
Admin convenience must not become a second hidden implementation path.

---

# 19. First quality metrics to track once implementation exists

Do not measure everything immediately. Start with high-value signals:
- frame time / FPS stability;
- peak memory around settlement↔wilderness transition;
- sector load/unload time;
- active actor count by simulation tier;
- behavior evaluations per second;
- derived-stat recalculation count;
- active modifier/status count;
- domain-action resolution time;
- save size/write time;
- monster persistent-state correctness across transitions;
- touch input latency/comfort;
- first-person targeting readability.

Later profiling can become more detailed only when evidence justifies it.

---

# 20. Current decision

The project will use this quality-governance layer before expanding more detailed content.

The next recommended bounded documentation piece is **the first settlement blueprint**, because the world architecture and scale/streaming model now exist but the actual first settlement has not yet been converted into a coherent meter-scale production design.

No gameplay implementation is authorized by this document.