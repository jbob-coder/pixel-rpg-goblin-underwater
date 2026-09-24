# REGION_01 — Region Topology and Sector Roles

Status: SELECTED TOPOLOGY / PROTOTYPE TARGETS / NO IMPLEMENTATION
Last reconciled: 2026-09-02

## Quality objective

The region must create hunting decisions through geography rather than through arbitrary menu choices or a linear corridor.

A useful sector changes at least one of:
- route choice;
- visibility;
- tracking reliability;
- footing/terrain;
- monster behavior opportunity;
- encounter tactics;
- danger/retreat pressure;
- ecological information.

If two sectors provide effectively the same decisions, merge/rework them rather than increasing map size for its own sake.

## Canonical sector graph

```text
R01_S00: Trailhead / Field Camp
  ↔ R01_S01 River Ford
  ↔ R01_S02 Rootwood Thicket

R01_S01: River Ford / Mud Flats
  ↔ R01_S00
  ↔ R01_S02
  ↔ R01_S03 Feeding Meadow

R01_S02: Rootwood Thicket
  ↔ R01_S00
  ↔ R01_S01
  ↔ R01_S03
  ↔ R01_S05 Deepwood Basin

R01_S03: Feeding Meadow
  ↔ R01_S01
  ↔ R01_S02
  ↔ R01_S04 Rocky Rise
  ↔ R01_S05

R01_S04: Rocky Rise
  ↔ R01_S03
  ↔ R01_S05
  ↔ R01_S06 Nesting Shelf

R01_S05: Deepwood Basin
  ↔ R01_S02
  ↔ R01_S03
  ↔ R01_S04
  ↔ R01_S06

R01_S06: Nesting Shelf / Crystal Fault
  ↔ R01_S04
  ↔ R01_S05
```

## Topology quality rules

### Loop rule
Middle hunting terrain should provide route loops. The player should often be able to:
- approach an area from a second direction;
- bypass one hazard at additional distance/risk;
- reacquire a fleeing monster without returning through the exact path just traveled.

### Exit redundancy rule
Except for deliberate safe/deep-edge spaces, a normal middle sector should usually have at least two useful exits.

`R01_S00` and `R01_S06` are allowed to behave more like edge anchors because one is the civilization edge and one is deepest territory. Even those have two region connections in the current topology.

### No hidden teleport rule
Sector links are physical routes such as:
- trail;
- ford;
- root tunnel/opening;
- ridge path;
- slope;
- stream corridor;
- narrow pass.

Crossing a technical streaming boundary never teleports actor/world state.

### Sightline rule
No ordinary viewpoint should expose the complete graph.

Use terrain to permit **partial prediction**:
- from Rocky Rise, the player may see the meadow and portions of the deep basin;
- from the camp, the player may see distant ridge/nest silhouettes but not their routes;
- from the meadow, tree/ridge masses hide deep paths;
- from Rootwood, local visibility is constrained.

### Landmark rule
Every sector receives at least one memorable physical landmark that remains recognizable without HUD text.

## Sector specifications

### R01_S00 — Frontier Trailhead / Field Camp

Purpose:
- settle the player after the hunter-gate transition;
- establish wilderness scale/direction;
- provide safe orientation and camp anchor;
- let the player choose initial outer route.

Landmark candidates:
- fortified supply shelter;
- old split tree/trail marker;
- visible river sound/downhill cue;
- distant rocky-rise silhouette.

Terrain:
- compact cleared ground;
- trail forks;
- sparse cover;
- safe/controlled fire or shelter.

Combat:
- ordinary large-monster combat should not normally initiate directly inside the protected camp footprint;
- outskirts may still support encounters if the player draws danger toward the edge under future rules.

### R01_S01 — River Ford / Mud Flats

Purpose:
- make terrain mechanically obvious early;
- create high-quality tracking evidence;
- teach crossing-point reasoning;
- create a strong local combat footprint.

Landmarks:
- shallow ford;
- fallen trunk/stone shelf;
- eroded bank;
- reeds/mud basin.

Route character:
- open enough to read tracks;
- water limits some paths;
- multiple crossing opportunities should exist, but not every bank is equally traversable.

### R01_S02 — Rootwood Thicket

Purpose:
- contrast the river with obscured sight lines;
- emphasize scratches, broken branches and sound;
- create alternate route into deep territory;
- provide cover/concealment concepts.

Landmarks:
- giant exposed root formation;
- split-trunk corridor;
- shallow hollow/cave-like root arch.

Route character:
- branching but not labyrinthine;
- silhouettes/landmarks prevent player confusion;
- large monster routes require sufficient physical clearance.

### R01_S03 — Feeding Meadow

Purpose:
- create exposed open hunting terrain;
- support long observation before engagement;
- provide feeding remains/evidence;
- connect multiple outer/deep routes.

Landmarks:
- grazing/feeding clearing;
- scarred central tree/stone;
- meadow edge facing the rocky rise.

Route character:
- multiple exits visible only locally;
- open center is fast but exposed;
- edges provide concealment/cover at longer path length.

### R01_S04 — Rocky Rise

Purpose:
- introduce elevation and observation;
- give the player partial information about adjoining areas;
- support rock cover and ranged/line-of-sight tactics;
- provide one route toward deepest territory.

Landmarks:
- broken stone spine;
- overlook shelf;
- narrow pass toward nest territory.

Route character:
- climbing is bounded/readable;
- avoid tiny ledge platforming inconsistent with tactical/mobile controls;
- elevation matters without turning this into a platformer.

### R01_S05 — Deepwood Basin

Purpose:
- major route convergence and retreat territory;
- higher danger/mutation pressure;
- dense enough to hide monster movement but not erase tracking;
- bridge outer hunt and nest territory.

Landmarks:
- basin depression;
- massive root/boulder landmark;
- damaged vegetation corridor;
- possible elemental/crystal environmental signs.

Route character:
- multiple exits preserve hunt continuation;
- geometry should support circling/reacquisition rather than one choke.

### R01_S06 — Nesting Shelf / Crystal Fault

Purpose:
- deepest territory/retreat destination;
- visually communicate stronger crystal/ecological pressure;
- support nest/rest/defensive monster behavior;
- provide one of the most tactically consequential encounter locations.

Landmarks:
- elevated/stone nesting shelf;
- natural fault/crystal-bearing geology;
- dominant den structure;
- two escape/arrival routes from S04/S05.

Important restriction:
Crystal geology does not automatically mean exposed harvestable life crystals everywhere. Creature-core crystal rules remain separate from environmental mineral/crystal features.

## Route pacing

Do not set final seconds until player movement speed is implemented.

Prototype spatial rule:
- sectors should contain meaningful traversal, not a single screen;
- direct route across a normal sector should be short enough to avoid empty travel;
- tracking/exploration should lengthen traversal because the player is reading evidence/choosing routes, not because the sector is physically enormous.

## Navigation clarity

Use three navigation layers:
1. **macro landmark** — ridge, giant root, river sound, nest shelf;
2. **route landmark** — forked tree, ford, rock arch, broken log;
3. **local evidence** — footprint, scratch, blood, feeding remains.

If the player needs a permanent glowing waypoint to know which of two adjacent routes is a river versus ridge path, the environment composition is insufficient.

## Graybox requirements

Before final art:
- block all seven sectors using simple terrain/volumes;
- connect every canonical adjacency physically;
- verify no accidental dead-end/softlock;
- walk every route in both directions;
- verify a large monster proxy can traverse its intended routes;
- test camera occlusion/sight lines;
- mark potential encounter footprints;
- mark sector technical boundaries separately from visible geographic transitions;
- measure route lengths and worst-case streaming transitions.

Final terrain art must not change connectivity without updating this document/package state.
