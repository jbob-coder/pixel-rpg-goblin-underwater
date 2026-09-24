# First-Slice Settlement 01 Smith Service Interaction Contract

Status: SELECTED FIRST-SLICE PROTOTYPE DESIGN / NO SETTLEMENT SERVICE IMPLEMENTATION
Last reconciled: 2026-09-03

World/content owner: `docs/10_world/settlements/SETTLEMENT_01/`

## Purpose

Map the first recorded crafting proof into the actual walkable Settlement 01 so returning from a hunt leads through a short physical route to a usable Smith/Workshop instead of a disconnected global crafting menu.

Primary law:

**The settlement interaction gives the player physical access to crafting, but the settlement/UI never owns material consumption, recipe legality, or equipment mutation. Those remain authoritative domain transactions.**

This contract owns:
- Settlement 01 Smith/workshop physical service anchor;
- first-slice workbench interaction identity;
- return-from-hunt route target to the Smith;
- settlement-local service availability;
- open/close/preview/confirm/cancel interaction flow;
- compatible Field Poleblade target-selection boundary;
- settlement-side save/re-entry behavior;
- presentation/interaction trace requirements;
- future implementation tests.

It does not own:
- crafting material arithmetic;
- inventory quantities/provenance;
- equipment modifier math;
- Smith NPC personality/social systems;
- market prices/shop inventory;
- broad recipe catalog;
- production implementation.

Supporting authorities:
- `/FIRST_SETTLEMENT_BLUEPRINT.md`;
- `/GAME_EXPERIENCE_BIBLE.md`;
- `/SYSTEM_ARCHITECTURE_BLUEPRINT.md`;
- `/docs/20_gameplay/crafting/FIRST_SLICE_ONE_RECIPE_CRAFT_EQUIP_LINKAGE_CONTRACT.md`;
- `/docs/20_gameplay/inventory/FIRST_SLICE_INVENTORY_MATERIAL_OWNERSHIP_CONTRACT.md`;
- `/docs/20_gameplay/progression/PLAYER_PROGRESSION_AND_EQUIPMENT_SYSTEM.md`.

---

# 1. Physical service identity

Settlement:
`SETTLEMENT_01`

Local service ID:
`service_settlement01_smith_weapon_workbench`

Interaction anchor ID:
`interact_settlement01_smith_weapon_workbench`

Logical crafting-station capability:
`CRAFT_STATION_WEAPON_WORKBENCH`

Selected physical placement:
- Smith/Workshop in Settlement 01’s Craft / Processing Quarter;
- on the Hunter Service Loop;
- on or immediately adjacent to the main terrace/lower craft-transition route from the Hunter Gate;
- visually linked to furnace/chimney, weapon racks, material storage and the nearby processing-yard flow;
- reachable without crossing the residential or civic half of town.

The station is not a global menu entry. The player physically approaches the workbench or workshop interaction anchor.

---

# 2. Return-from-hunt route

The first-slice return path is:

```text
HUNTING REGION
-> FRONTIER CORRIDOR
-> HUNTER GATE
-> LOWER/CRAFT SERVICE ROUTE
-> PROCESSING-YARD EDGE
-> SMITH / WEAPON WORKBENCH
```

Prototype travel-quality target:

`HUNTER_GATE_RETURN_THRESHOLD -> SMITH_WORKBENCH <= 25 seconds normal walking`

This is a design/graybox target, not a runtime PASS claim.

The route should usually be readable through:
- chimney/smoke/warm forge light;
- metal/weapon-rack silhouette;
- processing carts/material racks;
- direct street/ramp connection from the gate-facing service area.

The player should not need to cross the full settlement after every hunt to use the first upgrade loop.

---

# 3. Service availability

Selected first-slice normal-state rule:

`SMITH_WEAPON_WORKBENCH_SERVICE = AVAILABLE_IN_NORMAL_SETTLEMENT_STATE`

The essential first-slice workbench does not require one specific Smith NPC to be standing at the forge.

NPC schedule may change:
- who is visually present;
- ambient animation/dialogue;
- presentation flavor;
- optional later social interaction.

NPC schedule may not silently remove the required first-slice crafting capability in normal settlement state.

If a future authored emergency explicitly disables the workshop, SettlementState must expose a deterministic service-unavailable reason such as:
- `SERVICE_DISABLED_EMERGENCY`;
- `SERVICE_DISABLED_STORY_STATE`;
- `SERVICE_DISABLED_DAMAGED_FACILITY`.

First-slice proof does not implement those exceptional states; it only preserves the ownership hook.

---

# 4. Interaction eligibility

The world interaction owner validates at least:
- current world location is `SETTLEMENT_01`;
- player Hunter is within the workbench interaction volume/range;
- service exists and is enabled;
- player is not in an active combat encounter;
- no incompatible modal interaction already owns input;
- workbench interaction anchor is currently active/loaded.

If valid, the world interaction emits a request to open the Smith service presentation.

No inventory/crafting mutation occurs from proximity alone.

---

# 5. Interaction prompt

Prototype prompt:

`USE WEAPON WORKBENCH`

The prompt is contextual and appears only when interaction eligibility is true.

The prompt may include a simple workbench icon, but the physical workshop should remain visually understandable without relying entirely on UI markers.

Opening the service:
- is free outside combat;
- does not spend AP/RP/Stamina;
- does not consume materials;
- does not reserve recipe inputs;
- does not apply equipment effects.

---

# 6. Service presentation scope

First-slice proof exposes exactly one crafting recipe:

`recipe_field_poleblade_raker_tendon_grip`

Working name:
**Raker-Tendon Grip**

The service UI displays at minimum:
- compatible target weapon instance;
- recipe name;
- required materials and quantities;
- minimum quality requirements;
- currently owned eligible amounts;
- selected refinement result;
- exact displayed gameplay effect: Placed Hew Stamina `18 -> 16` for the prototype target;
- explicit unavailable reason when requirements fail;
- Confirm;
- Cancel/Back.

No shop inventory, market price list, broad recipe tree or randomized crafting result appears in this first proof.

---

# 7. Mobile presentation rule

The Smith service is a deliberate overlay tied to the physical workbench.

Presentation target:
- landscape phone layout;
- large touch targets;
- recipe/material/effect information readable without tiny PC-style rows;
- the player can see enough workshop context to understand where the service is occurring when practical;
- function/readability outrank ornamental borders.

The UI may temporarily lock player locomotion while the service overlay is open.

Closing the overlay returns control to the same physical workbench location.

UI state is transient presentation state and does not become a second crafting/inventory authority.

---

# 8. Weapon-target selection

The craft must target a stable Field Poleblade weapon instance ID.

Eligibility:
- weapon instance is owned by the player;
- family = `WEAPON_FAMILY_FIELD_POLEBLADE`;
- compatible grip-refinement slot/state exists;
- `active_grip_refinement_id` is empty;
- weapon is accessible to the Smith service according to first-slice equipment ownership.

First-slice target-selection behavior:

### One eligible Poleblade
If exactly one eligible weapon instance exists:
- preselect it;
- display its stable player-facing identity;
- revalidate by stable instance ID on Confirm.

### Multiple eligible Poleblades
If multiple eligible instances exist:
- present a compact selection list;
- selection stores stable weapon instance ID, not list index;
- revalidate ownership/compatibility on Confirm.

### No eligible Poleblade
Recipe remains visible but cannot commit.
Return explicit reason:
`NO_COMPATIBLE_FIELD_POLEBLADE` or a more specific authoritative validation result.

---

# 9. Material-source boundary

Crafting at this first-slice Smith consumes only material already owned by:

`PLAYER_FIELD_INVENTORY`

The workbench does not directly spend from:
- carcass harvest sources;
- detached anatomy containers;
- `RECOVERY_BUNDLE`;
- companion inventory;
- hypothetical settlement storage.

Therefore the physical loop remains explicit:

`HARVEST -> RECOVERY_BUNDLE -> PLAYER_FIELD_INVENTORY -> SMITH CRAFT`.

If recovered material did not fit the field inventory and remains in a recovery bundle, the Smith recipe cannot pretend it is already available.

---

# 10. Preview is read-only

Selecting the recipe or weapon target creates a preview only.

Preview may calculate/display:
- eligible material amounts;
- exact quality requirements;
- projected material consumption;
- projected refinement ID;
- projected Placed Hew Stamina change.

Preview may not:
- decrement a stack;
- reserve a provenance lot;
- create a craft transaction;
- attach a refinement;
- emit ItemCrafted/UpgradeApplied as if committed.

Repeated opening/closing/selection therefore cannot mutate gameplay state.

---

# 11. Confirm boundary

Pressing Confirm submits one authoritative craft request containing at least:
- stable service ID;
- stable interaction/session ID;
- recipe ID;
- selected weapon instance ID;
- player/profile ID;
- deterministic craft transaction ID/sequence;
- current service/context reference.

The Crafting owner then performs the existing authoritative flow:
1. validate recipe;
2. validate workbench capability/context;
3. validate selected Poleblade/refinement state;
4. validate inventory/quality requirements;
5. deterministically select/reserve exact inputs;
6. atomically consume exact inputs and apply exactly one refinement;
7. emit authoritative result/events/trace.

The Smith UI does not duplicate this logic.

---

# 12. Cancel / Back behavior

Before authoritative commit:
- Cancel closes the current confirmation/overlay state;
- no material is consumed;
- no refinement is created;
- no craft transaction is marked successful;
- no inventory reservation persists from mere preview.

If Confirm already produced a committed domain transaction:
- UI cancellation cannot roll it back independently;
- closing animation/UI does not refund materials;
- reopening reads the committed weapon/inventory state.

This prevents presentation from becoming an unofficial undo system.

---

# 13. Failure and rejection

Authoritative craft rejection must return a deterministic reason such as:
- `SERVICE_UNAVAILABLE`;
- `INVALID_STATION_CONTEXT`;
- `NO_COMPATIBLE_FIELD_POLEBLADE`;
- `WEAPON_NO_LONGER_OWNED`;
- `GRIP_REFINEMENT_SLOT_OCCUPIED`;
- `INSUFFICIENT_TAIL_TENDON_HIGH`;
- `INSUFFICIENT_HIDE_STANDARD_PLUS`;
- `INVENTORY_STATE_CHANGED`;
- `TRANSACTION_CONFLICT`.

On any pre-commit rejection:
- materials remain unchanged;
- weapon remains unchanged;
- service stays usable unless the reason itself is service loss;
- UI refreshes from authoritative state.

No generic random craft-failure roll exists.

---

# 14. Service session identity

A transient Smith interaction session may use:

`smith_service_session:<player_id>:<service_id>:<session_sequence>`

Session identity exists to:
- correlate UI requests/traces;
- reject stale callbacks;
- avoid applying a Confirm from an already-closed/replaced session.

Session identity is not the craft transaction ID.

Closing/reopening the workbench creates a new presentation/service session but must not replay a previous craft transaction.

---

# 15. Save/load and re-entry

The open Smith overlay itself does not need to be restored after load in the first slice.

Selected behavior:
- save/load returns the player to authoritative Settlement 01 world state;
- Smith overlay starts closed after reload;
- player may physically interact again;
- inventory/material state comes from Inventory persistence;
- Poleblade refinement state comes from Equipment persistence;
- successful craft transaction ledger remains idempotent;
- service availability comes from SettlementState/current normal-state rules.

Hard cases:

### Save before Confirm
No material/refinement change exists.

### Save after authoritative commit but before craft animation/UI completion
Reload shows:
- materials already consumed exactly once;
- refinement already applied exactly once;
- no replay of the transaction;
- presentation reconstructs from authoritative state.

### Reload while standing at workbench
Player may interact again normally, but previous transaction ID/result cannot be re-consumed/reapplied.

---

# 16. Return-loop continuity

The first complete player-facing progression proof is:

```text
RETURN THROUGH HUNTER GATE
-> WALK SHORT SERVICE ROUTE
-> REACH PHYSICAL SMITH/WORKBENCH
-> OPEN WORKBENCH SERVICE
-> VIEW RAKER-TENDON GRIP REQUIREMENTS
-> SELECT/VERIFY FIELD POLEBLADE
-> CONFIRM AUTHORITATIVE CRAFT
-> MATERIALS CONSUMED ONCE
-> REFINEMENT APPLIED ONCE
-> CLOSE SERVICE
-> WALK/PREP FOR NEXT HUNT
```

The player remains in the same settlement world before and after the service interaction.

No teleport to a global abstract crafting scene is required for the first slice.

---

# 17. Visual/audio result boundary

After authoritative success, presentation may show:
- short workbench/forge animation;
- material placement/working VFX;
- equipment model/preview update;
- sound cue;
- confirmation panel.

These effects occur after or in response to authoritative success.

Animation cannot:
- consume extra material;
- create another refinement;
- decide quality;
- modify Stamina values itself;
- replay crafting because a callback fired twice.

---

# 18. SettlementState boundary

SettlementState may own:
- Smith service discovered/available flag;
- local service-disabled reason;
- local workshop/door state if relevant;
- interaction anchor active state;
- settlement emergency overrides later.

SettlementState does not own:
- inventory material stacks;
- recipe requirements;
- craft transaction ledger;
- Poleblade modifier math.

This keeps the Smith physical without turning SettlementState into a giant gameplay database.

---

# 19. Accessibility and usability

First-slice Smith service should support:
- large touch targets;
- readable material counts/quality labels;
- explicit unavailable reasons;
- no color-only eligibility communication;
- a clear final confirmation before consumption;
- simple Back/Cancel path;
- no hidden material auto-spend when merely browsing.

The one recipe should be understandable without nested category trees.

---

# 20. Performance boundary

Smith service proof should avoid expensive decorative requirements.

Gameplay-critical:
- physical workbench/interactable;
- readable workshop landmark;
- service overlay;
- one weapon preview if budget allows.

Decorative particles, extra workers, high-cost fire/shadow effects and crowd density are lower priority than:
- input responsiveness;
- interaction reliability;
- readable UI;
- stable settlement frame pacing.

Target Galaxy A03s performance remains unverified until direct device testing.

---

# 21. Deterministic trace requirements

Development trace should include:
- interaction/session ID;
- Settlement ID;
- service/workbench ID;
- service availability result;
- player position/proximity validation result;
- selected recipe ID;
- selected weapon instance ID;
- displayed material eligibility snapshot/version;
- submitted craft transaction ID;
- authoritative craft result/rejection;
- resulting refinement ID when successful;
- UI open/close reason;
- save/reload reconciliation marker where relevant.

The same authoritative state + same committed request must produce the same result.

---

# 22. Explicitly deferred

Not selected here:
- shop buy/sell economy;
- crafting currency fees;
- Smith relationship/reputation;
- Smith dialogue tree;
- day/night shop-lock schedule;
- multiple crafting stations;
- armor crafting;
- many recipes;
- item repair/durability;
- settlement storage;
- companion crafting;
- asynchronous crafting timers;
- crafting minigame;
- production animation/art;
- production source implementation.

---

# 23. Required future implementation tests

Before this service can be runtime verified, test at least:
1. workbench interaction is unavailable outside its interaction range;
2. workbench interaction is available in normal Settlement 01 state;
3. one specific Smith NPC being absent does not remove normal first-slice service availability;
4. entering workbench opens no material mutation;
5. closing without Confirm consumes nothing;
6. previewing recipe repeatedly consumes nothing;
7. service exposes only `recipe_field_poleblade_raker_tendon_grip` in first proof;
8. exactly one eligible Poleblade is preselected deterministically;
9. multiple eligible Poleblades are selected by stable instance ID;
10. no eligible Poleblade produces explicit rejection and no mutation;
11. target weapon is revalidated on Confirm;
12. craft cannot consume directly from `RECOVERY_BUNDLE`;
13. insufficient HIGH tendon rejects without mutation;
14. insufficient STANDARD-or-better hide rejects without mutation;
15. successful Confirm consumes exactly 2 eligible tendon + 2 eligible hide once;
16. successful Confirm applies exactly one Raker-Tendon Grip refinement;
17. successful refinement changes Placed Hew prototype Stamina 18 -> 16 through typed equipment effect;
18. success does not change AP/damage/Initiative/Max Stamina or hit-quality ceiling;
19. double-tap Confirm cannot duplicate transaction;
20. stale callback from closed session cannot commit;
21. reopen after success shows refinement already applied;
22. reopening cannot spend inputs again;
23. save before Confirm preserves all inputs and empty refinement state;
24. save after commit/reload preserves exact consumed quantities and refinement once;
25. reload never replays prior craft transaction;
26. workbench overlay begins closed after first-slice reload;
27. service unavailable state rejects before crafting mutation;
28. UI animation interruption cannot produce partial authoritative craft;
29. return from workbench restores player control at same settlement location;
30. gate-to-workbench graybox travel time is measured and meets <=25-second design target or records failure;
31. Smith/workbench is readable from service-route landmarks without mandatory floating waypoint spam;
32. interaction remains usable with touch targets/readability appropriate to landscape phone;
33. no settlement/NPC/UI subsystem directly decrements inventory;
34. no settlement/NPC/UI subsystem directly writes the refinement;
35. presentation event replay cannot duplicate materials/equipment effects;
36. trace contains enough IDs/state versions to reproduce the service/craft result.

These are future runtime/graybox tests. This document itself is design-recorded only.

---

# 24. Acceptance

Design baseline is complete when:
- [x] physical workbench/service identity selected;
- [x] Settlement 01 placement selected;
- [x] gate-return route target selected;
- [x] normal service availability separated from one NPC schedule;
- [x] interaction eligibility selected;
- [x] one-recipe presentation scope selected;
- [x] stable weapon target selection/revalidation selected;
- [x] preview/confirm/cancel ownership selected;
- [x] inventory/crafting/equipment owners preserved;
- [x] save/re-entry behavior selected;
- [x] future interaction/runtime tests recorded;
- [x] broad shop/social/economy scope deferred.

Verification state:

`FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_RECORDED = YES`
`SETTLEMENT_SMITH_RUNTIME_IMPLEMENTED = NO`
`SETTLEMENT_SMITH_RUNTIME_VERIFIED = NO`.
