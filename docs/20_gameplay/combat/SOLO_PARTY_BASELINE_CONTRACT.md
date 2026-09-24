# Solo / Party Baseline Contract

Status: SELECTED FIRST-SLICE PROTOTYPE DESIGN / NO COMBAT IMPLEMENTATION
Last reconciled: 2026-09-03

Technical owner: `docs/20_gameplay/combat/`

## Purpose

Define the first-slice participation and control model for solo hunters and optional allied hunters without creating a second turn scheduler, shared resource pool, opaque companion AI, or party-required version of the hunt loop.

Primary rule:

**The game must remain fully playable solo. Optional companions join the same authoritative encounter, Initiative scheduler, action economy, terrain, status, anatomy and persistence rules as every other combat actor.**

This contract owns:
- first-slice solo-vs-party participation mode;
- prototype active hunting-party size;
- direct-control ownership;
- companion command authority;
- companion deterministic action-selection boundary;
- party participation in Initiative/RoundRoster;
- join/leave/incapacitation scheduling boundaries needed before implementation;
- party persistence/trace requirements;
- future implementation tests.

It does not own:
- defeat, death, revive, retreat or hunt-failure resolution;
- companion recruitment stories/relationships;
- final companion roster/content;
- reward/XP/harvest distribution;
- friendly-fire rules;
- multiplayer;
- final party size for expansion content;
- production implementation.

Supporting authorities:
- `ACTION_ECONOMY_CONTRACT.md`;
- `INITIATIVE_AND_TURN_ORDER_PROTOTYPE_CONTRACT.md`;
- `COMBAT_RESOLUTION_HIT_QUALITY_DEFENSE_CONTRACT.md`;
- `STAMINA_PROTOTYPE_SCALE_AND_RECOVERY_CONTRACT.md`;
- `FIRST_SLICE_STATUS_SET_PROTOTYPE_CONTRACT.md`;
- `FIRST_SLICE_TERRAIN_EFFECT_SET_CONTRACT.md`;
- `/BEHAVIOR_PATTERN_SYSTEM.md`;
- `/GAME_EXPERIENCE_BIBLE.md`;
- `/NEW_GAME_MASTER_PLAN.md`.

This contract is the more-specific current authority for the older `solo/party` open placeholder in `NEW_GAME_MASTER_PLAN.md` and the older `party/companion behavior until party design is decided` placeholder in `BEHAVIOR_PATTERN_SYSTEM.md`.

---

# 1. Selected first-slice mode

Selected:

`FIRST_SLICE_PARTY_MODE = SOLO_CAPABLE_WITH_OPTIONAL_COMPANIONS`

Meaning:
- no core hunt requires a companion;
- the first playable hunt loop must be completable with only the player hunter;
- companions may be added without switching to a different combat ruleset;
- difficulty/content may later recognize party size explicitly, but the first slice does not silently scale monster stats merely because another hunter is present;
- party-required encounters are not part of the first slice.

The tutorial/earliest proof hunt may be solo even when the party framework exists.

---

# 2. Prototype active party size

Selected first-slice cap:

`MAX_ACTIVE_HUNTERS_IN_PARTY = 3`

Composition:
- `1` player-controlled hunter;
- `0..2` optional companion hunters.

Why three:
- enough to prove meaningful ally positioning and scheduler participation;
- small enough for phone-readable turn order and first-person spatial awareness;
- limits pathing, collision, VFX, status and command complexity during the first implementation;
- does not lock future expansion to three forever.

This is a prototype cap, not a final world/lore maximum.

No fourth active hunter may be inserted into a first-slice encounter as a normal party member unless this contract is deliberately revised and retested.

---

# 3. Direct-control ownership

Selected:

`PLAYER_DIRECT_CONTROL = PLAYER_HUNTER_ONLY`

First slice does not use mid-combat body switching.

The player directly chooses for their own hunter:
- movement;
- attack/target part;
- defensive preparation;
- tools/items when available;
- inspect/analysis;
- explicit companion orders defined by this contract;
- end-turn decisions.

The player does **not** take over a companion's camera/body when that companion's Initiative slot begins.

A companion owns its own normal activation and submits legal domain actions through its deterministic behavior profile.

Reason:
first-person combat should preserve the identity and spatial continuity of the player's hunter instead of teleporting viewpoint/control between bodies every few seconds.

---

# 4. Independent actor resources

Every allied hunter is a separate combat actor.

Each owns independently:
- Health and body state;
- AP;
- RP;
- Stamina;
- statuses/tactical states;
- position/node/bearing/cover;
- InitiativeSnapshot;
- current RoundRoster slot;
- equipment/capabilities;
- behavior/command state if non-player-controlled.

There is no shared party AP, RP or Stamina pool.

Baseline hunter economy remains owned by Action Economy:
- `4 AP` normal activation target;
- `1 RP` normal reaction target;
- persistent Stamina;
- one normal activation maximum per actor per round.

A companion does not spend the player's resources for its own actions, and the player's unused resources do not finance a companion turn.

---

# 5. Party participation in Initiative

All current encounter participants use the existing deterministic Initiative owner.

At encounter creation:
1. determine which persistent actors are accepted into the encounter;
2. player hunter receives one InitiativeSnapshot;
3. every accepted companion receives its own InitiativeSnapshot;
4. monsters receive their own snapshots;
5. all participants are sorted by the same comparator;
6. RoundRoster contains each eligible combatant exactly once.

Party affiliation does not create a special allied turn block.

Example legal order:

```text
Companion A
Monster 01
Player Hunter
Companion B
```

The game does not automatically group all allied turns together.

Hard invariant:

**one normal activation maximum per eligible actor per round.**

High party size, high Agility, player commands or companion behavior may not create duplicate normal slots.

---

# 6. First-slice companion behavior model

Companions use authored deterministic behavior patterns from `BEHAVIOR_PATTERN_SYSTEM.md`.

There is no runtime generative AI companion decision system.

Conceptual companion decision flow:

```text
COMPANION SLOT STARTS
→ read authoritative encounter facts
→ read current player-issued order, if any
→ collect legal movement/attack/defense/support candidates
→ filter through AP/RP/Stamina/equipment/status/terrain/cover legality
→ apply authored deterministic priorities
→ submit one legal domain action at a time
→ resolve through normal combat owners
→ continue while AP/resources/rules permit
→ end activation
```

Companion behavior cannot:
- move through blocked terrain;
- spend unavailable resources;
- invent an attack;
- ignore statuses;
- bypass Initiative;
- create extra normal activations;
- know hidden monster facts the party has not learned unless its own content explicitly owns such knowledge;
- reroll because animation or UI repeated.

---

# 7. First-slice player command system

Companions are autonomous within bounded player direction rather than fully uncontrolled or directly puppeted.

## 7.1 Pre-encounter directive

Before combat commitment, each companion may have one selected default directive stored in party state.

Setting/changing a directive during safe preparation does not spend combat AP because combat has not begun.

Default when none is explicitly selected:
`ORDER_STANDARD`.

## 7.2 Mid-combat command action

Selected player action:

`ISSUE_COMPANION_ORDER`

Prototype cost:
- `1 AP` from the **player hunter**;
- maximum `1` successful companion-order action per player normal activation;
- targets one current companion;
- no Stamina cost by default;
- does not spend the companion's AP;
- does not move the companion's Initiative slot;
- cannot be issued outside the player's own normal activation unless a later explicit reaction/communication rule exists.

The 1-AP cost makes tactical coordination compete with movement/attack/preparation instead of becoming free omnipotent micromanagement.

## 7.3 Minimal order set

### `ORDER_STANDARD`
Use the companion's normal authored combat profile.

### `ORDER_FOCUS_PART`
Parameters:
- current hostile target ID;
- known/legally targetable part/group ID.

Effect:
- increases authored priority for legal actions that pressure that target/part;
- does not guarantee contact;
- does not make an unknown, hidden, covered or impossible part targetable;
- if no legal focus action exists, companion falls back to normal legal behavior.

### `ORDER_HOLD_POSITION`
Effect:
- avoid voluntary tactical relocation from the current node unless remaining would make action resolution illegal or a separately authored emergency/survival rule overrides the preference;
- defensive reactions remain legal;
- does not grant Guard/Brace automatically;
- does not forbid forced displacement.

### `ORDER_CLOSE_DISTANCE`
Parameters:
- hostile target ID.

Effect:
- prioritizes legal movement/reposition toward a usable engagement range;
- obeys terrain, cover, hazards, body clearance and AP/Stamina;
- never teleports or guarantees an attack in the same activation.

The first slice deliberately avoids a large command wheel.

---

# 8. Order lifetime and validation

A companion has at most one current persistent combat directive in the first slice.

Order rules:
- a new valid order replaces the previous persistent order;
- orders persist until replaced, completed where the order defines completion, invalidated by actor/target removal, or encounter end;
- save/load preserves the current order and its parameters;
- an invalid parameter cannot create a partially applied order;
- presentation cannot change the authoritative order simply because a menu highlight changed;
- duplicate input cannot charge the same command twice after one authoritative commitment.

`ORDER_FOCUS_PART` automatically loses its specific target parameter if that target/part becomes terminally unavailable; the companion then falls back to `ORDER_STANDARD` unless a later explicit order is issued.

---

# 9. Companion reaction ownership

The player does not receive a manual reaction prompt every time a companion is attacked in the first slice.

Reason:
with up to two companions, routing every ally RP window to the player would create interruption spam and undermine first-person continuity.

Companion reactions are selected deterministically by the companion's authored defensive policy using:
- legal reaction types;
- RP;
- Stamina;
- bearing;
- equipment;
- status;
- terrain/destination space;
- current order where relevant;
- incoming attack telegraph facts available to that companion.

The selected reaction still resolves through Action Economy/Combat Resolution.

A companion cannot execute two normal reactions in one window merely because several are legal.

---

# 10. Encounter-entry / exploration continuity

Party members are persistent world actors, not combat-only summons.

For a companion to begin in an encounter, the encounter-creation owner must accept that actor from the current world/party state.

First-slice laws:
- no companion teleports into the battle merely because it is listed in the party roster;
- encounter creation captures each participating companion's real position/context;
- an out-of-context or physically absent party member is not silently spawned beside the player;
- exact world-distance/participation thresholds remain an encounter-implementation value, not selected here;
- aerial exploration and first-person combat refer to the same actor instances.

---

# 11. Mid-encounter join rule

Normal first-slice party membership is chosen before encounter creation.

There is no normal mid-combat recruit/swap command.

If a scripted/world rule nevertheless accepts an allied actor after the current RoundRoster is finalized, the existing Initiative late-entry law applies:
- create InitiativeSnapshot at authoritative entry;
- `first_eligible_round = current_round + 1`;
- no normal activation in the already-finalized current round;
- include exactly once in the next round if still eligible.

This prevents an arriving companion from gaining a surprise extra turn.

---

# 12. Leave / removal boundary

This contract does not define retreat or defeat outcomes.

Scheduler boundary only:
- a companion terminally removed from the encounter is removed from future rosters;
- a pending current-round slot becomes `REMOVED`;
- an already-consumed slot is not replaced;
- no AP/RP/Stamina refresh occurs because the actor left;
- no automatic replacement companion enters the same slot.

Whether voluntary withdrawal is allowed, what happens to the hunt, and how escape succeeds belong to `DEFEAT_RETREAT_BASELINE_CONTRACT` or later owners.

---

# 13. Incapacitation boundary

This contract does not define downed/death/revive mechanics.

It consumes Initiative's generic rule:
- if a companion reaches its slot and is temporarily ineligible to start a normal activation, mark `SKIPPED_INELIGIBLE`;
- that actor cannot be reinserted later in the same round;
- if later eligible for the next round, it can participate once according to the scheduler;
- if terminally removed, use `REMOVED` instead.

The player does not automatically take control of a companion if the player hunter becomes incapacitated. That outcome belongs to the next failure/retreat contract.

---

# 14. Positioning and collision ownership

Party members remain separate physical/tactical actors.

They do not:
- occupy one shared tactical node unless the future spatial owner explicitly allows co-occupancy for that node/size;
- phase through each other because they are allies;
- ignore Narrow/cover/terrain clearance;
- inherit the player's cover because they are in the same party.

Exact ally collision/formation spacing is an implementation/encounter-layout dependency and must preserve the current spatial authority.

---

# 15. Targeting / knowledge boundary

Companion orders do not create knowledge.

A player can only issue `ORDER_FOCUS_PART` for a part/group that the command UI is legally allowed to reference under the current knowledge/visibility rules.

Companion content may have its own authored knowledge if later defined, but that knowledge must be explicit and traceable.

No companion silently reveals unknown anatomy through perfect hidden targeting.

---

# 16. Camera / presentation boundary

During companion activations:
- authoritative world state remains live;
- player stays anchored to the player hunter's first-person body/camera ownership;
- camera may present readable companion/monster action through bounded look/tracking presentation if later approved;
- presentation never moves the player hunter tactically;
- presentation never chooses the companion action;
- companion animation does not advance its Initiative slot by itself.

The turn-order UI may show player, companion and monster slots with stable actor identity.

---

# 17. Save/reload continuity

Future persistence must save enough party state to resume without turn/resource duplication.

Minimum relevant state:
- party membership/order;
- which hunters are accepted into current encounter;
- stable combatant instance IDs;
- per-actor InitiativeSnapshots;
- current RoundRoster and slot states;
- current actor resources/status/position;
- companion current directive + parameters;
- companion behavior state required for deterministic continuation;
- current action/commit sequence IDs as owned elsewhere.

Reload may not:
- duplicate companion turn-start recovery/AP/RP refresh;
- reroll Initiative;
- issue the same order twice;
- create a missing/extra companion slot;
- move an absent companion into the encounter;
- reset companion directive without an explicit owner.

---

# 18. Debug / trace contract

Development trace for party behavior should include:
- party member IDs;
- player-controlled actor ID;
- current party cap/membership;
- encounter participant acceptance/rejection reason;
- InitiativeSnapshot + round slot for each member;
- current companion directive;
- directive parameter IDs;
- considered companion behavior rules;
- each rule PASS/FAIL reason;
- selected action request;
- validation result;
- reaction decision reason;
- order commitment/AP charge;
- late-entry/removal/skip reason;
- duplicate-turn/order invariant violations.

The same authoritative state and seed must reproduce companion choices when no explicit deterministic input changed.

---

# 19. Explicitly deferred from this contract

Not selected here:
- named companion roster;
- recruitment requirements;
- loyalty/relationship systems;
- companion story quests;
- revive/downed/death handling;
- hunt failure after player incapacitation;
- voluntary party retreat success rules;
- reward/loot/material/XP division;
- friendly-fire policy;
- combo/team attacks;
- formation editor;
- direct companion body switching;
- four-plus active hunters;
- multiplayer/co-op;
- companion-specific classes/builds;
- final difficulty scaling by party size.

These do not block the baseline scheduler/control contract unless an implementation gate genuinely consumes them.

---

# 20. Required future implementation tests

Before this system can be called runtime verified, test at least:

1. solo encounter with only player hunter builds exactly one allied Initiative slot;
2. two-hunter party builds exactly two allied slots;
3. three-hunter party builds exactly three allied slots;
4. fourth party hunter is rejected by first-slice active-party cap;
5. every actor receives at most one normal activation per round;
6. party affiliation does not force allied turns to be consecutive;
7. each hunter owns independent AP/RP/Stamina;
8. player resource change does not mutate companion resources;
9. companion resource change does not mutate player resources;
10. player cannot directly body-switch/control a companion activation;
11. companion action selection is deterministic for identical state/seed/order;
12. companion behavior cannot submit an illegal action successfully;
13. `ISSUE_COMPANION_ORDER` costs player 1 AP once;
14. second successful command in the same player activation is rejected;
15. command does not consume companion AP;
16. invalid command parameter does not spend/apply partially;
17. duplicate input cannot double-charge the same command commit;
18. `ORDER_FOCUS_PART` never makes an illegal/hidden part targetable;
19. invalidated focus target falls back safely;
20. `ORDER_HOLD_POSITION` does not prevent forced displacement;
21. `ORDER_CLOSE_DISTANCE` obeys terrain/clearance/AP/Stamina;
22. companion defensive reaction consumes its own RP/Stamina only;
23. companion chooses at most one normal reaction per reaction window;
24. companion reaction does not create a normal activation;
25. absent world companion does not teleport into encounter;
26. late entrant receives no current-round activation;
27. late entrant appears exactly once next round;
28. pending terminally removed companion slot becomes `REMOVED`;
29. temporarily ineligible companion becomes `SKIPPED_INELIGIBLE` and does not reinsert that round;
30. save/reload preserves party membership and stable IDs;
31. save/reload preserves current companion directive;
32. save/reload preserves consumed RoundRoster slots;
33. reload does not duplicate turn-start AP/RP/Stamina hooks;
34. camera/UI cannot choose companion action or advance schedule;
35. solo completion path does not require companion-only action;
36. same authoritative inputs reproduce party scheduler/behavior trace.

These are future implementation/runtime tests; this design document itself does not satisfy them.

---

# 21. First-slice acceptance

Design-recorded when:
- [x] solo-vs-party mode selected;
- [x] prototype party cap selected;
- [x] direct-control owner selected;
- [x] independent actor resources explicit;
- [x] scheduler participation explicit;
- [x] deterministic companion behavior boundary explicit;
- [x] bounded command action and minimal order set selected;
- [x] companion reaction ownership selected;
- [x] encounter-entry continuity explicit;
- [x] late-entry/removal/incapacitation scheduler boundaries explicit;
- [x] camera/presentation boundary explicit;
- [x] persistence/trace requirements recorded;
- [x] defeat/retreat kept outside scope;
- [x] future implementation tests recorded.

`SOLO_PARTY_BASELINE_RECORDED = YES`
`PARTY_RUNTIME_IMPLEMENTED = NO`
`PARTY_RUNTIME_VERIFIED = NO`

## Exact next dependency

`DEFEAT_RETREAT_BASELINE_CONTRACT`
