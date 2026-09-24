# REGION_01 — Terrain, Ecology and Mutation Pressure

Status: SELECTED REGIONAL APPLICATION / PROTOTYPE TARGETS / NO IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

Define how Region 01's physical terrain affects hunting and how the region expresses the existing mutation/crystal ecosystem without inventing a second ecology system.

Global authority remains `/CRYSTAL_MUTATION_ECOSYSTEM_SYSTEM.md` and `/STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`.

## Quality rule

A biome should not be a visual skin.

Every major terrain family included in the region should contribute at least one meaningful consequence to:
- traversal/footing;
- tracking;
- visibility/cover;
- encounter tactics;
- habitat selection;
- mutation/ecological pressure.

Avoid adding terrain tags that have no visible or mechanical distinction.

## Regional environmental identity

Working identity:
**temperate river-root basin transitioning from controlled frontier edge into older, denser crystal-influenced deep territory.**

Large visual forms:
- river/tributary;
- saturated mud banks;
- mature root-heavy forest;
- open feeding meadow;
- rocky rise/outcrops;
- lower deepwood basin;
- mineral/crystal-bearing fault near deepest territory.

The region should feel coherent: these features belong to one watershed/terrain system rather than seven unrelated biomes stitched together.

## Terrain definition usage

Region documents should reference reusable terrain definitions later, for example:
- `terrain_dry_ground`;
- `terrain_mud`;
- `terrain_shallow_water`;
- `terrain_rooted_forest_floor`;
- `terrain_open_grass`;
- `terrain_rock_slope`.

Exact stable IDs remain subject to the content-definition pass.

Region 01 specifies where/why terrain appears. Generic modifier math remains in the shared stats/effect system.

## Sector terrain roles

### R01_S00 — Trailhead / Field Camp
Pressure:
- low wilderness pressure;
- mostly stable footing;
- controlled human disturbance.

Ecology:
- fewer large predators inside protected camp footprint;
- ambient signs show wilderness starts immediately beyond it.

Mutation pressure:
- baseline/low relative to deep sectors.

### R01_S01 — River Ford / Mud Flats
Terrain:
- shallow water;
- mud;
- reed/riverbank edges;
- limited dry stones/logs.

Mechanical applications:
- mud can increase movement/footing cost through shared effects;
- water/mud improves some track visibility while destroying/obscuring other evidence;
- crossing choices create tactical route decisions.

Ecology:
- drinking/watering site;
- prey/predator crossing point;
- high traffic produces overlapping evidence.

Mutation pressure candidates:
- water/wetland adaptation favored;
- mud-footing/adapted limbs plausible;
- exact elemental association remains OPEN until element roster is locked.

### R01_S02 — Rootwood Thicket
Terrain:
- dry/soft forest floor;
- massive roots;
- brush;
- trunks/rocks as cover;
- constrained sight lines.

Mechanical applications:
- visibility/concealment changes;
- route width can restrict large moves;
- root/brush geometry can create cover/line-of-sight differences.

Ecology:
- rubbing/scratching/travel corridor;
- smaller creatures can use denser subroutes not valid for the first large monster.

Mutation pressure candidates:
- sensory adaptations;
- maneuverability/armor tradeoffs;
- camouflage is a future option only if it creates readable gameplay rather than invisible unfairness.

### R01_S03 — Feeding Meadow
Terrain:
- open grass;
- sparse trees/rocks;
- relatively level ground;
- soft edge cover.

Mechanical applications:
- easier long-range observation;
- less concealment across center;
- more room for charge/large attack patterns;
- approach direction matters.

Ecology:
- primary feeding site candidate;
- prey activity/feeding remains;
- open area increases predator/prey visibility.

Mutation pressure:
- no special high elemental pressure by default;
- selection may favor speed, sensory range or open-ground behavior over specialized elemental mutation.

### R01_S04 — Rocky Rise
Terrain:
- stone;
- slopes;
- ledges/shelves kept compatible with mobile traversal;
- wind/exposed vegetation.

Mechanical applications:
- elevation/cover/visibility;
- hard ground reduces footprint quality;
- chokepoints can make large attacks more or less viable.

Ecology:
- observation/rest route for terrain-capable species;
- local mineral deposits possible without implying life-crystal abundance.

Mutation pressure candidates:
- footing/climbing/stability;
- mineral/armor adaptation if future element/ecology supports it.

### R01_S05 — Deepwood Basin
Terrain:
- denser forest;
- lower ground;
- moisture pockets;
- boulder/root barriers;
- converging paths.

Mechanical applications:
- mixed cover and restricted long sight lines;
- route choice/reacquisition more important;
- combination terrain can produce more complex effect context.

Ecology:
- major retreat/transit territory;
- greater predator pressure;
- older undisturbed habitat.

Mutation pressure:
- elevated relative to outer sectors;
- region aggregates can weight more developed/terrain-specialized traits here without spawning full off-screen individuals.

### R01_S06 — Nesting Shelf / Crystal Fault
Terrain:
- elevated/stone nest shelf;
- deeper fault/mineral formation;
- limited but meaningful approach routes;
- defensive geometry.

Ecology:
- nest/rest/territorial core;
- strongest local signs of dominant large creature;
- rare resource/habitat interactions possible later.

Mutation pressure:
- highest local crystal/elemental pressure candidate inside Region 01;
- exact elements, intensity and mutation weights remain OPEN;
- higher pressure does not automatically mean every spawned creature is stronger in every stat.

## Regional aggregate ecology

Off-screen ecology should use aggregate records such as:
- species abundance bands;
- predator/prey balance;
- preferred sectors/habitat tags;
- mutation-family weights;
- crystal Tier/Rank distribution bands;
- quality distribution bands;
- elemental pressure profile;
- hunting pressure;
- weather/seasonal modifiers if later adopted.

Do not simulate complete anatomy/behavior for thousands of off-screen creatures.

## First-slice ecology scope

Keep bounded:
- one primary large hunt species;
- only enough ambient/prey ecology to make its feeding/watering/travel behavior plausible;
- a small set of regional terrain pressures;
- 2–4 meaningful mutation traits for the primary species as already recommended globally;
- one clearly readable terrain-linked adaptation candidate.

Do not build a full food-web simulator before the hunt loop works.

## Mutation placement rule

A region can influence mutation probability/eligibility, but it cannot silently grant arbitrary mutations every time an actor crosses a sector boundary.

Mutation acquisition/development must occur at explicit lifecycle boundaries defined by the global system.

Sector pressure is an input/context, not an instant random buff zone.

## Hunting pressure

Future option:
Repeated hunting can alter population/trait distributions over longer time scales.

If adopted, use bounded aggregate changes such as:
- abundance change;
- behavior/route pressure;
- trait-weight shift;
- age/rank distribution shift.

Do not dynamically rewrite every creature every minute.

This remains FUTURE/OPEN for the first slice.

## Environmental storytelling

Show ecology physically:
- repeated drinking tracks at river;
- broken grass/feeding remains in meadow;
- scrape/rub marks in root forest;
- territory damage in deepwood;
- nesting material/carcass remnants/marks near deepest territory.

The player should be able to infer habitat use before reading exact database values.

## Admin/Creator overlays required later

- terrain tag overlay;
- movement/footing modifier source trace;
- habitat/territory overlay;
- aggregate species abundance;
- mutation-family pressure heatmap;
- elemental-pressure heatmap;
- persistent monster location;
- evidence anchors;
- active/background/off-screen ecology tier.

## Acceptance gate

Before expansion, verify conceptually/graybox that:
- every sector has distinct terrain/hunt function;
- terrain rules reuse shared effect definitions;
- habitat routes explain monster movement;
- mutation pressure increases coherently rather than by arbitrary invisible level zones;
- deep territory feels more dangerous through ecology/terrain/monster state, not just larger numeric damage;
- off-screen ecology can remain aggregate without breaking the active hunt.
