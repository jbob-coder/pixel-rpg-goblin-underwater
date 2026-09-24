# MONSTER_01 — Anatomy and Damage Contract

Status: SELECTED FIRST-SLICE ANATOMY / NUMERIC THRESHOLDS OPEN
Last reconciled: 2026-09-02

## Purpose

Define the Mudcrest Raker's gameplay-relevant anatomy so visual modeling, targeting, damage, capability loss, severing and harvesting all describe the same physical creature.

Global anatomy rules remain in the root mechanical/content authorities.

## Anatomy hierarchy

Conceptual physical hierarchy:

```text
BODY / TORSO
├── HEAD / NECK
│   └── HORN-CREST GROUP
│       ├── HORN_L
│       └── HORN_R
├── FORELEG_L
├── FORELEG_R
├── HINDLEG_L
├── HINDLEG_R
├── DORSAL_PLATE_GROUP
└── TAIL
    ├── TAIL_BASE
    └── TAIL_DISTAL
```

The internal crystal core is located deep in the forward torso/sternal cavity behind the forequarter mass. It is not a default externally targetable part in the first slice unless later explicitly approved.

## Player-facing target groups

The UI should expose a bounded set of meaningful choices.

Recommended first-slice target groups:
1. `HEAD`
2. `HORN_CREST`
3. `FORELEG_L`
4. `FORELEG_R`
5. `HINDLEG_L`
6. `HINDLEG_R`
7. `DORSAL_PLATES`
8. `TAIL`

General torso hits remain valid when the player does not select a specialized region or when an attack naturally lands there.

The internal implementation may track HORN_L/HORN_R and tail subparts separately even when the UI groups them.

## Head

Role:
- sensory orientation;
- bite/head-sweep capability;
- horn mount;
- strong but not invulnerable skull protection.

Damage consequences candidates:
- heavy head injury may reduce perception/accuracy or increase stagger susceptibility;
- direct head damage does not automatically break horns unless attack geometry/material rules support it.

## Horn crest

Physical form:
- two large mineral/keratin horn structures extending forward/outward from the reinforced skull/crest;
- large enough to read from aerial view;
- individual horns have separate internal states.

States:
- intact;
- cracked/wounded;
- broken.

Not normally severed like a fleshy tail; treated as breakable hard structures.

Capability effects:
- both intact: full charge/gore capability;
- one broken: strongest symmetrical charge/gore version weakened or disabled; altered attack variants remain possible;
- both broken: horn-dependent attacks removed; head/body ram may remain.

Harvest effect:
- intact/cleanly broken horn material quality/quantity differs from pulverized/destructively damaged horn.

## Forelegs

Purpose:
- carry front-heavy mass;
- stabilize charge;
- digging/rooting;
- braking/turning.

Each foreleg tracks separately.

Damage consequences:
- wounded: movement/charge efficiency penalty candidate;
- heavily damaged/broken: major charge restrictions, poorer turning/stability, more vulnerable stagger;
- destroyed/severed limb is not a normal first-monster mechanic unless later explicitly approved; limb severing is not required for the first slice.

Presentation:
- changed gait;
- reduced planting strength;
- guarded stance;
- visibly reduced charge confidence.

## Hindlegs

Purpose:
- propulsion;
- retreat/sprint;
- body rotation during tail attacks.

Damage consequences:
- reduced movement/repositioning;
- poorer escape speed;
- possible reduction to tail-sweep setup if rotation/pivot is impaired.

Do not make all four legs identical stat bags; front and rear function differently.

## Dorsal plates

Physical form:
- several large mineralized armor plates over shoulder/dorsal line;
- grouped visually into a few large readable forms, not dozens of tiny spikes.

Gameplay states:
- intact;
- cracked;
- broken/opened.

Purpose:
- armor/protection;
- silhouette identity;
- possible mutation expression surface;
- harvest material source.

When broken:
- underlying hide/tissue becomes more vulnerable in the relevant region;
- plate-derived harvest may lose pristine quality but broken fragments may still be recoverable depending on damage type;
- no magical permanent global defense reduction unless the exposed region actually matters to the incoming attack.

## Tail

Physical form:
- muscular tail used for balance and wide defensive sweep;
- distal section carries a mineralized ridge/weight that strengthens sweep impact.

Internal segmentation:
- `TAIL_BASE` — thick attachment and major locomotor musculature;
- `TAIL_DISTAL` — legal sever/recovery section for the first slice.

First-slice sever rule:
- sever occurs in a defined distal boundary, not arbitrarily at any triangle;
- the base remains attached and receives a sealed/wound-cap representation;
- detached distal tail becomes a physical harvest source;
- tail-sweep capability is disabled or replaced by a much weaker stump/body-turn action.

Severed state must persist through escape/region transitions/save state according to global rules.

## Torso / general body

The torso is the largest damage area and contains the crystal core deep inside.

Protection varies:
- front/shoulder: heavier hide/plate influence;
- flank: moderate protection;
- lower/inner flex areas: softer but harder to access depending position.

The torso should not become a universal 'best damage spot' that makes anatomy targeting pointless.

## Crystal core location

Technical modeling location:
- deep forward torso/sternal cavity behind major forequarter bone/muscle;
- protected by body mass and not visually exposed in baseline form.

Important rule:
**the anatomy sheet may show the core location for technical planning, but the player-facing game does not automatically reveal or allow direct core targeting.**

Future direct-core mechanics remain OPEN.

## Damage-state visual stack

Use layered representation:

### Intact
Normal hide/plate/horn/tail.

### Wounded
- localized wound material/decal;
- swelling/blood/mud disturbance;
- posture/animation change where significant.

### Broken horn
- intact horn mesh replaced/hidden appropriately;
- broken stump mesh/cap;
- optional detached fragment if gameplay requires it.

### Broken dorsal plate
- cracked/broken plate representation;
- exposed underlayer;
- fragment state as required.

### Severed tail
- attached distal tail removed;
- stump wound cap;
- detached tail object/source;
- changed silhouette immediately visible.

### Leg impairment
Prefer deformation/pose/gait/animation changes; do not require grotesque limb separation.

## Damage type relationships

Global damage rules own actual formulas, but visual/mechanical intent is:
- blunt/impact is effective at structural horn/plate breaking;
- controlled cutting can support tail sever when thresholds/exposure permit;
- piercing may exploit exposed soft regions more than armored plate;
- destructive overkill can reduce harvest quality.

Do not hard-code these relationships directly into the mesh or animation.

## Required model topology checks

Before high-detail approval:
- horn bases have clean breakable attachment zones;
- dorsal plate pieces can swap/break without tearing unrelated torso topology;
- distal tail has a clean sever loop/cap plan;
- leg loops deform under stride/crouch/turn;
- shoulder mass deforms without collapsing during charge;
- jaw/neck move without intersecting horns excessively;
- anatomy hit proxies can be placed independently from render topology.

## Required anatomy sheet visual

`MONSTER_01_M03_ANATOMY_v001.png` should show:
- side or 3/4 neutral monster;
- eight player-facing target groups separated clearly;
- horn internal L/R distinction if visible;
- tail distal sever boundary;
- dorsal plate group;
- technical crystal-core marker in a separate cutaway/inset if possible;
- no reliance on generated text labels for stable IDs.

Authoritative IDs remain in this Markdown.

## First-slice acceptance

The first monster model does not advance to final detailing until a graybox proves:
- all eight target groups are readable enough;
- horn break is technically possible;
- tail sever is technically possible;
- leg injury can be presented;
- dorsal plate break can expose underlying surface;
- first-person camera can frame each critical region;
- aerial silhouette still shows horn/tail/plate state changes where reasonably visible.
