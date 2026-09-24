# REGION_01 — Tracking, Monster Movement and Escape

Status: SELECTED HUNT FLOW / PROTOTYPE TARGETS / NO IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

Make tracking a physical information problem and make monster escape part of the hunt rather than an encounter reset.

The region provides evidence locations/routes. The generic deterministic behavior system owns rule evaluation. The creature/region state owns persistent identity/location/injuries.

## Tracking quality rule

Tracking should answer:
- **where did it likely go?**
- **how recently?**
- **what was it doing?**
- **is it injured/stressed?**
- **what terrain/habitat does it prefer?**

Tracking should not automatically answer:
- exact current coordinates;
- exact hidden crystal values;
- exact mutation data the player has not learned;
- guaranteed next behavior.

## Evidence classes

### Direction evidence
Useful primarily for route choice:
- footprints;
- displaced mud/water;
- broken grass/brush;
- branch damage;
- scrape trails;
- large-body passage signs.

### Activity evidence
Explains what the monster was doing:
- feeding remains;
- drinking site disturbance;
- rubbing/scratching marks;
- resting impressions;
- territorial marks;
- nesting material.

### Injury evidence
Generated after relevant wounds:
- blood;
- altered footprint/gait pattern;
- drag marks;
- broken armor/horn fragments only when physically plausible;
- damaged vegetation from unstable movement.

Injury evidence must reflect authoritative monster state. A non-bleeding wound cannot create unlimited blood trails merely for player convenience.

### Element/mutation evidence
Only when supported by actual monster traits and player knowledge:
- scorched/frozen/wet/mineralized vegetation;
- unusual residue;
- altered tracks;
- damaged material matching a known elemental behavior.

Do not use generic glowing footprints for every creature.

### Audio evidence
- calls;
- branch/rock disturbance;
- heavy movement;
- feeding sounds;
- water disturbance;
- combat aftermath.

Audio can indicate rough direction/near-far relationship without giving perfect map coordinates.

## Evidence confidence

Recommended player-facing concept:
- `FRESH / STRONG`;
- `RECENT / USEFUL`;
- `OLD / WEAK`;
- `AMBIGUOUS`.

Exact numerical time-to-decay values remain OPEN.

Perception/knowledge/tools may improve interpretation but do not fabricate evidence.

## Region-specific evidence strengths

### R01_S01 River Ford
Strong:
- mud footprints;
- water disturbance;
- bank damage.
Weak/problematic:
- tracks can disappear after entering water;
- rain/flooding may degrade evidence if later adopted.

### R01_S02 Rootwood Thicket
Strong:
- scratches;
- snapped branches;
- disturbed roots/leaf litter;
- sound.
Weak:
- direct long-range visual observation.

### R01_S03 Feeding Meadow
Strong:
- feeding remains;
- flattened grass;
- open-distance observation;
- clear movement direction at edges.

### R01_S04 Rocky Rise
Strong:
- visual observation;
- calls;
- scrape/claw marks on stone where species supports them.
Weak:
- clean footprints on hard rock.

### R01_S05 Deepwood Basin
Mixed evidence:
- many signs may overlap;
- injury evidence becomes valuable;
- behavioral knowledge helps distinguish routes.

### R01_S06 Nesting Shelf
Strong:
- repeated territory/nesting signs;
- recent resting/feeding/defensive evidence;
- accumulated species-specific clues.

Knowing where a nest is does not mean the monster is always present there.

## Pre-combat movement pattern concept

The first monster design will later select legal authored rules against this geography.

Region exposes facts such as:
- current sector;
- hunger/thirst/rest need if used;
- known feeding/watering/nest anchors;
- player/noise proximity;
- injury severity;
- crystal reserve band;
- time/weather where relevant;
- legal adjacent sectors;
- blocked/dangerous paths.

Example only:

```text
IF heavily injured AND retreat legal
  prefer R01_S06 or R01_S05
ELSE IF thirsty AND river route legal
  prefer R01_S01
ELSE IF feeding cycle active
  prefer R01_S03
ELSE
  follow authored territory route
```

This is deterministic authored behavior, not AI.

## Encounter escape contract

If a large monster successfully escapes combat:
1. encounter ends with authoritative outcome `MONSTER_ESCAPED`;
2. same monster instance remains alive;
3. anatomy injuries remain;
4. broken/severed parts remain;
5. crystal energy/condition remains;
6. persistent statuses remain according to status rules;
7. behavior phase/escape intent is recorded;
8. a legal retreat destination/route is selected through deterministic behavior rules;
9. region state updates monster location/movement;
10. new physical evidence can be produced along the route;
11. player returns to aerial exploration at the real encounter location;
12. hunt continues.

Never replace the escaping monster with a new full-health copy in another sector.

## Retreat geography

Preferred deep retreat hierarchy:
- outer injury: move toward cover/concealment in `R01_S02` or `R01_S05` depending position;
- serious injury: prefer `R01_S05` or `R01_S06` when legal/species-appropriate;
- critical crystal reserve: defensive/escape/berserk rules can alter destination/action but must use legal routes;
- blocked route: evaluate another legal adjacency rather than teleporting.

Exact rules belong to the monster's behavior packet.

## Player pursuit decisions

After escape the player may need to choose:
- immediate pursuit while evidence is fresh;
- slower pursuit to recover stamina/resources;
- route interception using known territory habits;
- return to camp if risk is too high;
- abandon/retreat from hunt under final contract rules.

This makes knowledge and terrain matter after combat, not only before it.

## Track generation cap

Tracking evidence is scalable and must be bounded.

Do not spawn a permanent physical footprint object every step forever.

Future implementation should use bounded strategies such as:
- pooled decals/instances;
- evidence clusters/segments;
- logical track records with nearby presentation;
- age/importance cleanup;
- stronger persistence for unique hunt evidence than ambient wildlife evidence.

Exact cap requires device profiling.

## Reacquisition quality gate

A monster escape is bad design if the player loses it only because the game silently moved it.

After escape, at least one reasonable information path should exist unless the design intentionally allows a complete loss:
- visible retreat direction;
- fresh injury trail;
- known territory route;
- strong nearby evidence;
- audible cue;
- research knowledge suggesting likely destination.

The player can still make the wrong inference. The game should not hide all causal evidence arbitrarily.

## Admin/Creator trace requirements

Development view should eventually show:
- monster instance ID;
- current/previous sector;
- selected destination;
- legal neighbors;
- evaluated retreat rules and reasons;
- evidence clusters generated;
- evidence age/confidence;
- player knowledge filter;
- persistent injuries/crystal state.

This trace is developer-facing, not normal player UI.

## Acceptance cases

Future tests/prototypes must cover:
- monster crosses S01→S03 without identity reset;
- monster escapes combat and retreats to another sector;
- tail/horn damage persists after escape;
- injury evidence is produced only when valid;
- player can reacquire through at least one supported clue chain;
- save/reload during an active pursuit preserves monster/evidence state according to final save policy;
- no duplicate monster appears at old and new sectors.
