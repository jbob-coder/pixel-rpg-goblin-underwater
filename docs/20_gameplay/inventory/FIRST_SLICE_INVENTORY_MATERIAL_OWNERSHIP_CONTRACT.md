# First-Slice Inventory Material Ownership Contract

Status: SELECTED FIRST-SLICE PROTOTYPE DESIGN / NO INVENTORY IMPLEMENTATION
Last reconciled: 2026-09-03

Technical owner: `docs/20_gameplay/inventory/`

## Purpose

Define how physically recovered Monster material acquires one authoritative owner after harvesting, how compatible material is stacked without losing provenance, how full-capacity rejection is handled without deletion, and how save/load prevents replay or duplication.

Primary law:

**A committed material quantity always has exactly one authoritative owner. Transfers move conserved quantity between owners; they never create, destroy or duplicate it.**

This contract owns:
- first-slice material inventory containers;
- material-stack identity;
- recovery-bundle ownership after harvest;
- inventory transfer transactions;
- capacity/full-inventory behavior;
- stack merge/split rules;
- quality/provenance representation;
- save/load transaction anti-replay;
- deterministic trace requirements;
- future implementation tests.

It does not own:
- harvest source capacity/yield;
- anatomy/damage;
- recipes/crafting output;
- equipment stats;
- broad item/consumable inventory;
- market value;
- companion reward splitting;
- production implementation.

Supporting authorities:
- `../harvest/FIRST_SLICE_HARVEST_CAPACITY_AND_CONDITION_CONTRACT.md`;
- `/MECHANICAL_SYSTEMS_GUIDE.md`;
- `/CONTENT_DATA_GUIDE.md`.

---

# 1. First-slice inventory owner

Selected primary material destination:

`PLAYER_FIELD_INVENTORY`

This is the player Hunter's field material container used by the first vertical slice.

It is not a shared party reward pool. Companion reward ownership/splitting remains deferred.

The contract is written with generic container IDs so later settlement storage, companion inventories or stash containers can reuse the transfer rules without changing conservation semantics.

---

# 2. Material container state

A runtime material container needs at least:
- stable `container_id`;
- `container_type`;
- owner actor/profile ID where applicable;
- `max_stack_entries`;
- ordered stack-entry references;
- transaction ledger/version;
- persistence scope.

First-slice container types:
- `PLAYER_FIELD_INVENTORY`;
- `RECOVERY_BUNDLE`.

Future containers such as settlement storage are outside this packet.

---

# 3. Prototype field-inventory capacity

Selected prototype targets:

`PLAYER_FIELD_INVENTORY_MAX_STACK_ENTRIES = 20`

`MATERIAL_STACK_MAX_QUANTITY = 99`

These are first-slice readability/testing targets, not permanent final-game limits.

Capacity is measured by stack entries in this packet. Final carried weight/encumbrance is deferred.

A full inventory never destroys harvested material.

---

# 4. Recovery bundle: mandatory post-harvest owner

The upstream harvest contract commits physical source depletion before inventory acceptance.

Therefore every successful harvest extraction that recovers quantity creates exactly one persistent material owner before any inventory transfer:

`RECOVERY_BUNDLE`.

Selected flow:

```text
HARVEST SOURCE DEPLETION COMMITS
-> MATERIAL TRANSFER RESULT EMITTED
-> CREATE/UPDATE RECOVERY_BUNDLE FOR THAT HARVEST TRANSACTION
-> BUNDLE OWNS RECOVERED QUANTITY
-> TRY TRANSFER BUNDLE -> PLAYER_FIELD_INVENTORY
-> ACCEPTED QUANTITY MOVES
-> UNACCEPTED QUANTITY REMAINS IN BUNDLE
```

Hard law:

**there is no state where committed recovered material exists only in UI text or an unowned transient value.**

---

# 5. Recovery-bundle identity

A first-slice bundle stores at least:
- stable `recovery_bundle_id`;
- source `harvest_transaction_id`;
- material ID;
- quantity currently owned;
- quality band;
- provenance lots;
- world/harvest-container location reference;
- terminal/empty state;
- persistence/version metadata.

Recommended deterministic identity:

`recovery_bundle_id = bundle:<harvest_transaction_id>:<material_id>:<quality_band>`

If one harvest transaction yields multiple material/quality combinations, each combination owns a separate bundle entry under the same transaction parent.

The exact serialization string may change; uniqueness and stability may not.

---

# 6. Material stack identity

Player-facing compatible stack key:

`MaterialStackKey = material_id + quality_band`

First-slice quality bands consumed from Harvest:
- `HIGH`;
- `STANDARD`;
- `LOW`;
- `SCRAP`.

Rules:
- same material + same quality may merge;
- same material + different quality may not merge;
- different materials may never merge;
- provenance does not have to create separate visible stacks;
- provenance is retained internally as lots.

This keeps the inventory readable while preserving physical history.

---

# 7. Material stack state

A stack entry stores at least:
- stable `stack_id`;
- material ID;
- quality band;
- current quantity;
- maximum stack quantity;
- ordered provenance-lot list;
- container ID;
- creation transaction ID;
- last mutation transaction ID.

Invariant:

```text
0 < stack.quantity <= MATERIAL_STACK_MAX_QUANTITY
```

Zero-quantity entries are removed or marked terminal according to implementation policy; they must not remain spendable.

---

# 8. Provenance lots

One visible material stack may contain several internal provenance lots.

Each lot stores at least:
- `provenance_lot_id`;
- quantity represented by the lot;
- source Monster instance ID;
- harvest source lineage ID;
- source harvest transaction ID;
- recovery bundle ID;
- material ID;
- quality band.

Optional future fields may include region/hunt/time metadata.

Hard invariant:

```text
sum(stack.provenance_lot.quantity) == stack.quantity
```

Merging stacks combines provenance lots; it does not rewrite them into a fictional common origin.

---

# 9. Transfer request

A material transfer request stores at least:
- stable `inventory_transfer_id`;
- source container ID;
- destination container ID;
- material ID;
- quality band;
- requested quantity;
- source stack/bundle reference;
- authoritative transaction sequence;
- caller/interaction source.

Validation occurs before destination mutation.

---

# 10. Transfer conservation law

For a committed transfer of quantity `Qaccepted`:

```text
source_before - source_after = Qaccepted

destination_after - destination_before = Qaccepted
```

Therefore:

```text
SOURCE_LOSS == DESTINATION_GAIN
```

No valid transfer may:
- decrease source by more than destination gained;
- increase destination without matching source reduction;
- duplicate provenance-lot quantity;
- spend already-transferred source quantity twice.

---

# 11. Deterministic destination-fill order

When transferring into `PLAYER_FIELD_INVENTORY`, use this deterministic order:

1. find existing compatible stacks with the same `MaterialStackKey`;
2. sort compatible stacks by stable `stack_id ASC`;
3. fill each toward `99` in that order;
4. if quantity remains and free stack entries exist, create new compatible stacks;
5. create new stack IDs from stable destination + transfer sequence data;
6. stop when all requested quantity is accepted or inventory has no remaining compatible capacity.

No random stack selection exists.

UI sorting may differ visually but cannot change authoritative fill order.

---

# 12. Partial acceptance

A transfer may be partially accepted.

Example:
- recovery bundle owns 8 units;
- one compatible inventory stack has 96/99;
- inventory has no free stack slot;
- destination accepts 3;
- source bundle remains with 5.

Result:

`PARTIAL_ACCEPT`.

Conservation:

```text
8 before = 3 moved + 5 still owned by bundle
```

The game must clearly show the remaining field material rather than implying all 8 entered inventory.

---

# 13. Full rejection

If destination can accept zero quantity:

`NO_CAPACITY`

or another explicit validation reason.

Rules:
- source quantity remains unchanged;
- destination remains unchanged;
- bundle remains persistent/collectable according to world rules;
- no harvest source capacity is restored;
- retry uses a new transfer request only if the original transfer was not committed, or reuses recorded result according to transaction-id rules below.

---

# 14. No rollback into anatomy

Once harvest source depletion committed and a recovery bundle owns the material, an inventory rejection does **not** put matter back into the Monster/carcass source.

Reason:
physical extraction already happened.

The material now exists as the recovery bundle until moved elsewhere or later lost by an explicit future world rule.

This prevents harvest-capacity duplication through reject/retry loops.

---

# 15. Stack creation

New stack creation is legal only when:
- destination has a free stack entry;
- material/quality is valid;
- accepted quantity is positive;
- no compatible existing stack can absorb that same quantity first under deterministic fill order.

New stack quantity:

```text
new_stack_quantity = min(remaining_transfer_quantity, 99)
```

Repeat only while free stack entries and transfer quantity remain.

---

# 16. Stack merge

Explicit or automatic merge is allowed only for identical `MaterialStackKey`.

Merge operation:
- moves quantity from source stack into destination stack up to max 99;
- moves the matching provenance lots/lot portions;
- decreases/removes source stack accordingly;
- does not alter quality;
- does not average quality;
- does not erase source Monster/lineage information.

Merging is a transfer transaction and obeys the same conservation/anti-replay rules.

---

# 17. Stack split

Splitting quantity `Q` from a stack:
- requires `0 < Q < source.quantity`;
- requires a valid destination/new stack capacity;
- moves exactly `Q` quantity;
- moves provenance lot segments using deterministic lot order;
- preserves total quantity and quality.

Selected deterministic provenance split order:

`provenance_lot_id ASC`.

A lot may be divided into two lot segments if the split boundary lands inside it, but the summed quantity and original provenance identity must remain traceable.

---

# 18. Quality law

Quality is not averaged when stacks merge.

Therefore:
- `HIGH` + `HIGH` may merge;
- `HIGH` + `STANDARD` may not merge;
- `LOW` + `SCRAP` may not merge.

A future crafting recipe may consume mixed quality intentionally, but it must consume distinct stacks/lots explicitly.

Inventory cannot upgrade or downgrade quality merely to make stacking easier.

---

# 19. Provenance and crafting boundary

The next crafting contract may need provenance only for:
- audit/debug;
- special source requirements if later approved;
- anti-duplication;
- research/knowledge consequences.

Normal first-slice recipes should primarily query:
- material ID;
- quantity;
- minimum quality.

They should not require one inventory row per Monster kill unless a specific unique material mechanic later requires it.

---

# 20. Transaction state machine

Selected inventory transfer states:
- `REQUESTED`;
- `VALIDATED`;
- `COMMITTED`;
- `REJECTED`.

`COMMITTED` includes both full and partial accepted quantity.

One committed transfer result stores:
- requested quantity;
- accepted quantity;
- remaining source quantity;
- created/modified destination stack IDs;
- moved provenance-lot quantities;
- final reason/status.

---

# 21. Transaction anti-replay

`inventory_transfer_id` is stable and idempotent.

If a request with an already committed ID is received again:
- do not mutate source/destination again;
- return/read the recorded committed result.

If a request with an already rejected terminal ID is received again with unchanged request identity:
- return the recorded rejection;
- do not create a second transfer.

A genuinely new retry after state changed receives a new transfer ID.

Save/load/UI reopen cannot convert one transaction into two.

---

# 22. Harvest -> inventory atomic ownership boundary

Required sequence:

```text
HARVEST TX resolves recovered quantity
-> HARVEST source depletion commits
-> RECOVERY_BUNDLE becomes authoritative owner
-> INVENTORY TRANSFER request created
-> validate inventory capacity/compatibility
-> move accepted quantity bundle -> inventory
-> retain rejected remainder in bundle
-> commit transfer ledger
-> presentation displays recorded result
```

At every completed step, quantity has exactly one owner.

---

# 23. Save/load persistence

Persist at least:
- container IDs/types/owners;
- stack IDs/material/quality/quantity;
- provenance lots;
- recovery bundles and world references;
- transfer ledger IDs/results;
- stack-entry capacity values/version;
- last mutation transaction IDs.

Reload may not:
- recreate already emptied recovery bundles;
- duplicate a committed transfer;
- restore source quantity after destination accepted it;
- drop bundle remainder because inventory was full;
- merge different quality bands;
- erase provenance quantity;
- create a stack beyond max quantity/capacity.

---

# 24. Container and world continuity

A non-empty recovery bundle remains a persistent world/material owner until an explicit later world rule removes it.

First slice does not define decay/despawn.

Therefore region unload/reload must restore:
- bundle identity;
- quantity;
- quality;
- provenance;
- world location/parent harvest container reference.

The same bundle cannot exist twice after reload.

---

# 25. UI boundary

Inventory UI may:
- display aggregated material stacks;
- display quantity/quality;
- optionally expose provenance/history detail;
- request transfer/merge/split;
- explain full capacity.

UI may not:
- increment quantity locally;
- delete bundle remainder;
- merge different qualities;
- replay harvest/transfer;
- create a stack without an authoritative transaction.

---

# 26. Trace requirements

Minimum development trace for every material transfer:
- inventory transfer ID;
- upstream harvest transaction ID where applicable;
- source/destination container IDs;
- source bundle/stack ID;
- material ID;
- quality band;
- requested quantity;
- source quantity before/after;
- compatible-stack capacities before;
- free destination stack slots before;
- accepted quantity;
- created/modified stack IDs;
- provenance lots moved;
- unaccepted quantity;
- result code;
- conservation assertion result.

Same state + same transaction ID must return the same recorded result.

---

# 27. Explicitly deferred

Not selected here:
- inventory weight/encumbrance;
- broad weapon/armor/consumable inventory behavior;
- settlement stash size;
- item durability;
- market/sale value;
- party loot division;
- material spoilage/decay;
- drop/destruction mechanics;
- recipe consumption;
- crafting UI;
- final inventory slot count beyond prototype tuning;
- production implementation.

---

# 28. Future implementation tests

Before runtime verification, test at least:
1. harvest result creates exactly one recovery bundle owner before inventory transfer;
2. bundle quantity equals recovered material quantity;
3. transfer never creates/destroys quantity;
4. source loss equals destination gain;
5. same material + same quality merges;
6. different quality does not merge;
7. different material does not merge;
8. existing compatible stacks fill in stable stack-ID order;
9. stack quantity never exceeds 99;
10. new stack creation stops at 20 field-inventory entries;
11. full inventory returns zero accepted and leaves bundle unchanged;
12. partial capacity accepts only available amount;
13. partial transfer leaves exact remainder in bundle;
14. no rejection restores Monster harvest source capacity;
15. emptied bundle cannot be collected twice;
16. provenance-lot quantities sum to visible stack quantity;
17. merge preserves provenance lots;
18. split preserves total quantity/provenance;
19. split lot segmentation is deterministic;
20. committed transfer ID cannot replay after save/load;
21. rejected terminal ID cannot mutate on repeated read;
22. new retry after capacity changes requires new transfer ID;
23. region reload restores non-empty recovery bundle once;
24. region reload does not recreate emptied bundle;
25. save/load preserves inventory stacks exactly;
26. UI reopen does not mutate quantity;
27. quality is never averaged/upgraded by inventory;
28. total quantity across bundle + inventory equals upstream committed recovered quantity minus any later explicit consumer transaction;
29. inventory transfer trace reproduces conservation math;
30. crafting cannot consume material before the next crafting owner commits a consumer transaction.

These are future domain/runtime tests. This contract itself is design-recorded only.

---

# 29. Acceptance

Design baseline is complete when:
- [x] one authoritative owner law selected;
- [x] player field material container selected;
- [x] prototype 20-entry/99-quantity capacity selected;
- [x] recovery-bundle fallback selected;
- [x] material + quality stack key selected;
- [x] internal provenance lots selected;
- [x] deterministic merge/split selected;
- [x] partial/full rejection behavior selected;
- [x] transaction idempotency selected;
- [x] save/load/world continuity recorded;
- [x] future tests recorded;
- [x] crafting/economy kept outside scope.

`FIRST_SLICE_INVENTORY_MATERIAL_OWNERSHIP_RECORDED = YES`
`INVENTORY_RUNTIME_IMPLEMENTED = NO`
`INVENTORY_RUNTIME_VERIFIED = NO`
