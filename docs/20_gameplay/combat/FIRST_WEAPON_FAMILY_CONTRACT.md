# First Weapon Family Contract — Field Poleblade

Status: SELECTED FIRST-SLICE WEAPON FAMILY DESIGN / NO COMBAT IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

Define exactly one first-slice weapon family that can instantiate the existing combat action-economy, hit-resolution, anatomy and progression contracts without creating a broad weapon roster or a universal best weapon.

Primary quality fix:

**the first weapon should prove the combat architecture while preserving meaningful tradeoffs, rather than being designed as a tool that is excellent at every damage type, range, defense and monster problem.**

Selected first-slice family:

- technical family ID: `WEAPON_FAMILY_FIELD_POLEBLADE`;
- working player-facing family name: **Field Poleblade**;
- form: two-handed long-hafted hunting weapon with a forward single-edged blade, reinforced spine/socket and thrust-capable point;
- primary identity: controlled cutting/severing at useful reach;
- secondary identity: thrusting/precision placement and defensive spacing;
- deliberately weak identity: heavy hard-structure smashing compared with a future dedicated impact weapon;
- no shield;
- no ranged projectile mode;
- no magical/crystal-powered behavior selected for the first slice.

`Field Poleblade` is a technical/design working name, not necessarily final setting terminology.

Supporting authorities:
- `ACTION_ECONOMY_CONTRACT.md`;
- `COMBAT_RESOLUTION_HIT_QUALITY_DEFENSE_CONTRACT.md`;
- `/STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`;
- `../progression/PLAYER_PROGRESSION_AND_EQUIPMENT_SYSTEM.md`;
- `/docs/30_content/monsters/MONSTER_01/ANATOMY_AND_DAMAGE.md`.

This document owns the first family identity and prototype technique contract. It does not own final damage arithmetic, final stamina scale, final animation timings or broad weapon progression.

---

# 1. Why this family is first

The first weapon should exercise several important systems at once without erasing specialization.

A two-handed poleblade can test:
- first-person reach and spacing;
- body-part targeting against a large creature;
- directional attack selection;
- cutting/sever logic;
- piercing/precision logic;
- limited guard/parry behavior;
- AP commitment bands;
- persistent Stamina pressure;
- terrain/close-space drawbacks;
- movement-to-attack tradeoffs;
- attack-control vs raw-damage separation;
- selected-part contact vs body fallback;
- hit-quality ceilings;
- Monster 01 tail/horn/leg/torso interactions.

It is not selected because it should be permanently superior.

Future weapon families should be able to beat it in specific roles such as:
- hard-structure breaking;
- close-range defense;
- rapid low-commitment attacks;
- ranged control;
- shielded survival;
- extreme mobility;
- dedicated piercing;
- specialist severing.

The first-slice family is a systems-validation tool and a viable hunting style, not the complete weapon design space.

---

# 2. Physical construction intent

Grounded construction direction:
- approximately human-scale two-handed haft;
- enough overall length to create visible spacing advantage without becoming an oversized fantasy polearm;
- forward blade large enough to support controlled cutting and chopping;
- point suitable for thrusting into exposed soft regions;
- reinforced socket/spine to survive contact with large prey;
- rear haft/butt suitable for emergency spacing/control but not treated as a dedicated warhammer head;
- hand spacing supports leverage and directional control;
- practical frontier materials consistent with the existing Hunter art direction.

Exact dimensions, mass, center of mass and materials remain `DCC_AND_BALANCE_OPEN` until the Hunter mannequin/animation/first-person camera can test them.

The weapon must not:
- clip constantly through the first-person camera;
- require impossible human leverage;
- be so long that every interior/forest encounter breaks;
- cover most of the screen while idle;
- visually read as an ornamental oversized fantasy blade.

---

# 3. Core mechanical identity

## Strengths

The Field Poleblade should be strong at:
- medium melee reach;
- controlled selected-part attacks;
- exposed-tail sever attempts;
- flank attacks;
- attacks against legs and other accessible anatomy;
- keeping some distance from bites/body mass;
- converting good positioning into `CLEAN` or `PRECISION` cutting contact;
- limited directional guard/parry against compatible attacks.

## Weaknesses

The Field Poleblade should be meaningfully weaker at:
- fighting with the monster already inside the weapon's comfortable working distance;
- cramped/narrow spaces;
- rapid repeated attacks;
- low-stamina play;
- powerful omnidirectional blocking;
- dedicated horn/plate smashing;
- defending against massive body charges by parry alone;
- attacks requiring extreme short-range maneuverability.

## Anti-universal-best law

The family must never gain, through normal refinement/mastery, simultaneous top-tier:
- sever;
- break;
- blunt stagger;
- piercing;
- block stability;
- parry;
- mobility;
- stamina efficiency;
- short-range safety;
- long-range safety.

Progression can improve proficiency while preserving the family tradeoff envelope.

---

# 4. Damage-channel identity

The family uses existing generic physical channels rather than inventing a weapon-specific damage system.

Primary:
- `CUTTING`.

Secondary:
- `PIERCING`.

Limited incidental/technique-specific:
- `BLUNT / IMPACT` from reinforced haft/spine/body-contact behavior where a technique explicitly supports it.

Important:
**limited impact capability does not make the Field Poleblade a dedicated structural-break weapon.**

Expected first-slice relationships:
- tail distal sever: favorable when legal exposure/contact and cutting thresholds are satisfied;
- soft exposed tissue: favorable with controlled cut/thrust;
- horn crest: can damage and contribute, but should be materially less efficient at hard-structure breaking than a future dedicated impact family;
- intact dorsal plate: can strike it but should not casually slice through heavy mineralized protection;
- broken/opened dorsal region: improved cutting/piercing opportunity because local protection/exposure changed;
- legs: useful controlled target due reach, but leg damage still obeys anatomy/integrity rules.

No attack bypasses local armor/anatomy because the weapon is sharp.

---

# 5. Reach and range contract

The Field Poleblade is a melee weapon with a defined comfortable working envelope.

First-slice conceptual range states:
- `TOO_CLOSE`;
- `WORKING_MELEE`;
- `EXTENDED_MELEE`;
- `OUT_OF_RANGE`.

## TOO_CLOSE

The monster/target is inside the effective leverage path.

Consequences can include:
- some full cuts illegal;
- reduced AttackControl for large swings;
- thrust or haft-spacing techniques remain more viable;
- repositioning becomes valuable.

The game should not visually show a full blade swing through the monster because a menu says the action is available.

## WORKING_MELEE

Preferred normal range.

Supports:
- standard cut;
- thrust;
- precision cut;
- guard/parry where bearing allows;
- committed cleave.

## EXTENDED_MELEE

Near maximum usable reach.

Supports suitable thrusts/long cuts but can:
- reduce control for some techniques;
- prevent short/haft techniques;
- make lateral target acquisition harder.

## OUT_OF_RANGE

Hard illegal for normal direct attacks.

Exact meter distances are `ANIMATION_AND_NODE_LAYOUT_OPEN` until the tactical-node and DCC prototypes exist.

---

# 6. Handling/control profile

The family should reward Finesse, Perception and correct spacing more than raw Might for contact placement.

Conceptual contribution direction:
- `Finesse` — major handling/controlled-cut/precision contribution;
- `Perception` — target acquisition/visibility/body-part reading contribution;
- `Might` — force/committed strike/break contribution where technique uses it;
- `Agility` — repositioning and defensive handling context, not direct generic damage;
- `Endurance` — sustained Stamina capacity/recovery;
- `Resolve` — maintaining control under pain/stagger/pressure where applicable.

No primary attribute automatically grants extra AP or extra normal reactions.

Weapon mastery should eventually improve:
- handling penalties;
- technique access;
- stamina efficiency within caps;
- precision requirements;
- defensive options;
without becoming a flat damage multiplier per rank.

---

# 7. First-slice technique packet

Keep the initial packet intentionally small.

Required first-slice techniques/actions:
1. `MEASURED_CUT`;
2. `DRIVING_THRUST`;
3. `PLACED_HEW`;
4. `COMMITTED_CLEAVE`;
5. `HAFT_CHECK`;
6. weapon-supported `GUARD`;
7. weapon-supported `PARRY` where legal.

This is enough to test the architecture. Do not create a twenty-technique tree in the first slice.

---

# 8. Measured Cut

Technical technique ID:
`POLEBLADE_MEASURED_CUT`.

Prototype role:
standard controlled melee attack.

Prototype economy:
- AP: `2`;
- Stamina: moderate, exact amount open;
- normal reaction window: yes when defender/action rules permit.

Damage identity:
- primary `CUTTING`;
- minor incidental impact only if later damage profile needs it.

Range:
- `WORKING_MELEE` preferred;
- some `EXTENDED_MELEE` variants possible at a control penalty;
- poor/illegal in `TOO_CLOSE` depending geometry.

Targeting:
- selected target group allowed;
- fallback policy: `ALLOW_BODY_FALLBACK`.

Hit-quality ceiling:
- normally `CLEAN`;
- does not reach `PRECISION` by default merely from a lucky margin.

Purpose:
provide a reliable 2-AP attack that leaves room for movement/brace/other action decisions.

Expected tradeoff:
reasonable control and sever contribution, but less selected-part certainty than the dedicated precision technique.

---

# 9. Driving Thrust

Technical technique ID:
`POLEBLADE_DRIVING_THRUST`.

Prototype role:
linear controlled piercing attack with good reach.

Prototype economy:
- AP: `2`;
- Stamina: moderate-low to moderate, exact amount open.

Damage identity:
- primary `PIERCING`;
- low cutting contribution if blade geometry supports it, not universal.

Range:
- strong at `WORKING_MELEE` and suitable `EXTENDED_MELEE`;
- can remain usable closer than a large committed cleave, within animation evidence.

Targeting:
- selected part allowed;
- fallback policy: `ALLOW_BODY_FALLBACK` for normal thrust;
- exact protected-part penalties use exposure/local protection.

Hit-quality ceiling:
- `CLEAN` normally.

Strengths:
- controlled line;
- useful against exposed soft targets;
- good positional reach.

Weaknesses:
- poor wide-area contact;
- poor hard-plate smashing;
- line can be defeated strongly by directional cover or displacement.

---

# 10. Placed Hew

Technical technique ID:
`POLEBLADE_PLACED_HEW`.

Prototype role:
dedicated selected-part precision cut.

Prototype economy:
- AP: `3`;
- Stamina: moderate-high;
- intended to compete directly with `Aim + standard attack` style decisions.

Damage identity:
- primary `CUTTING`;
- technique prioritizes placement rather than maximum force.

Targeting:
- requires explicit selected target part/group;
- fallback policy: `REQUIRE_SELECTED_PART`;
- if selected-part acquisition fails, do not automatically convert the attack into full normal torso damage.

Hit-quality ceiling:
- `PRECISION` allowed.

Expected strengths:
- tail distal sever setup;
- exposed limb/soft-region targeting;
- opened dorsal-region targeting;
- controlled contact where harvest preservation matters.

Expected weaknesses:
- higher AP commitment;
- stronger exposure/visibility requirements;
- no free body fallback;
- can waste substantial opportunity if used from a bad angle.

This technique is the clearest first-slice proof that anatomy targeting is a real decision rather than a cosmetic crosshair choice.

---

# 11. Committed Cleave

Technical technique ID:
`POLEBLADE_COMMITTED_CLEAVE`.

Prototype role:
full-turn, high-force cutting strike.

Prototype economy:
- AP: `4`;
- Stamina: high;
- represents full normal turn commitment.

Damage identity:
- dominant `CUTTING`;
- stronger structural/impact delivery than the family's lighter techniques due leverage, but still not a dedicated blunt-break tool.

Targeting:
- selected part may be declared when legal;
- fallback policy: `ALLOW_BODY_FALLBACK` by default;
- technique may impose stricter exposure/arc requirements.

Hit-quality ceiling:
- `CLEAN` by default;
- `PRECISION` not normally allowed because this technique prioritizes force over surgical placement.

Expected strengths:
- strong delivered damage/structural contribution;
- strong sever contribution on sufficiently exposed legal sever zone;
- useful when monster is committed/staggered/exposed.

Expected weaknesses:
- consumes all 4 AP;
- high Stamina;
- bad at `TOO_CLOSE`;
- larger telegraph/commitment;
- poor follow-up flexibility;
- vulnerable if used without regard for remaining RP/Stamina/position.

Do not let high force automatically guarantee a sever or horn break.

---

# 12. Haft Check

Technical technique ID:
`POLEBLADE_HAFT_CHECK`.

Prototype role:
short-range emergency spacing/control action, not a primary damage source.

Prototype economy:
- AP: `2` candidate;
- Stamina: low-moderate.

Damage identity:
- low `BLUNT / IMPACT`;
- intentionally low damage ceiling.

Range:
- `TOO_CLOSE` / short `WORKING_MELEE`.

Targeting:
- general body/large exposed target preference;
- not a precision sever technique.

Hit-quality ceiling:
- `SOLID` or `CLEAN` only if later balance warrants; no `PRECISION`.

Purpose:
- prove that the long weapon is not helpless inside its preferred range;
- create bounded emergency control/stagger contribution;
- give the player a reason not to require every close-range problem to be solved by a free reposition.

Important restriction:
**Haft Check must not make the weapon competitive with a dedicated hammer/impact family at horn/plate breaking.**

---

# 13. Guard support

The Field Poleblade can support a two-handed haft/blade guard, but it is not a shield weapon.

Guard characteristics:
- directional;
- moderate guard stability;
- consumes Stamina when absorbing force;
- may require AP to prepare according to the Action Economy Contract;
- can reduce/redirect suitable bites, swipes, smaller impacts and weapon-like strikes;
- poor against massive body charges unless combined with strong Brace/terrain/support conditions;
- does not create full-body omnidirectional protection.

Guard weaknesses should remain visible:
- side/rear attacks can bypass directional coverage;
- extreme force can produce `BLOCK_BROKEN`;
- low Stamina degrades viability;
- guarding may restrict movement/attack options depending later prototype.

The weapon cannot be balanced as if it provides shield-level protection for free.

---

# 14. Parry support

Parry is supported, but narrowly.

Likely compatible incoming categories:
- readable head swipe;
- limb swipe;
- tail strike where geometry/timing permit;
- bite/head-line attack where deflection is physically plausible;
- smaller weapon-like creature appendage strikes later.

Likely incompatible or highly restricted:
- full-body charge from a multi-ton monster;
- ground shockwave;
- area eruption;
- falling body mass;
- attack from outside guard bearing;
- attack already inside an impossible leverage angle.

A clean parry can:
- deflect contact;
- improve monster off-balance/stagger context where attack/profile supports it;
- create a bounded vulnerability state.

It does not automatically grant a free counter-turn.

---

# 15. Relationship to Dodge and Brace

The weapon does not replace generic defensive choices.

## Dodge

Still important when:
- charge/body mass cannot be safely guarded;
- angle is poor;
- Stamina/guard stability is insufficient;
- the player wants repositioning rather than force absorption.

## Brace

Strong synergy with the poleblade's two-handed leverage:
- improves stability;
- can strengthen guard outcomes;
- helps resist displacement;
- may support future set-against-charge mechanics if separately designed.

But Brace does not convert an impossible parry into a legal one.

---

# 16. Monster 01 anatomy interaction

The first weapon must interact coherently with the Mudcrest Raker rather than being designed in isolation.

## HEAD

Viable target.

Expected:
- standard cut/thrust possible depending exposure;
- protection/skull still matters;
- head damage does not automatically break horns.

## HORN_CREST

Viable but unfavorable specialization.

Expected:
- can contribute to horn integrity damage;
- committed impact/contact can matter;
- dedicated future impact weapon should be more efficient;
- cutting efficiency against dense mineralized horn is limited by local protection/material rules.

## FORELEG_L / FORELEG_R

Strong tactical target opportunity due weapon reach.

Expected:
- controlled cuts/thrusts can contribute to injury;
- damaging front legs can impair charge/stability according to Monster 01 authority;
- no automatic limb severing.

## HINDLEG_L / HINDLEG_R

Viable flank target.

Expected:
- controlled cut/thrust;
- can impair retreat/reposition when integrity thresholds are reached;
- positioning matters.

## DORSAL_PLATES

Poor target while intact for cutting specialization.

Expected:
- weapon can strike plates but is inefficient compared with dedicated structural-break equipment;
- broken/opened plate region becomes more favorable for selected-part attacks;
- no global armor bypass.

## TAIL

Primary first-slice sever demonstration target.

Expected:
- `PLACED_HEW` is the strongest controlled sever-oriented first technique;
- `COMMITTED_CLEAVE` offers force but less surgical certainty;
- legal distal sever boundary remains mandatory;
- sever requires suitable accumulated integrity/sever conditions;
- proximal/base tail cannot be arbitrarily severed because the player selected it.

The family should make the tail-sever system achievable without making it automatic.

---

# 17. AP economy integration

The family must preserve the selected 4 AP structure.

Example legal turn patterns:

```text
MOVE 1
+ MEASURED_CUT 2
+ BRACE 1
= 4 AP
```

```text
AIM/FOCUS 1
+ PLACED_HEW 3
= 4 AP
```

```text
DRIVING_THRUST 2
+ DRIVING_THRUST or MEASURED_CUT 2
= 4 AP
```

The two-attack turn is possible but should be limited by Stamina, range, target state and monster response rather than becoming universally optimal.

```text
COMMITTED_CLEAVE 4
= full normal turn commitment
```

No normal weapon upgrade increases `MAX_AP` merely because it is a better poleblade.

---

# 18. Stamina integration

Exact numeric Stamina costs remain open until the Stamina Prototype Scale/Recovery packet.

Relative intended ordering:

From lower to higher exertion, approximately:
- guard maintenance/light reaction depending force;
- `DRIVING_THRUST`;
- `MEASURED_CUT`;
- `HAFT_CHECK` or similar depending implementation;
- `PLACED_HEW`;
- `COMMITTED_CLEAVE`;
- strong Block/Parry consequences can additionally cost Stamina based on incoming force.

The weapon should feel sustainable when used deliberately, but repeated:
- cleave;
- precision hew;
- block;
- dodge;
without recovery must create multi-turn exertion pressure.

Stamina efficiency upgrades cannot reduce meaningful costs to zero.

---

# 19. Hit-quality ceilings and technique identity

Technique ceilings prevent every attack from becoming equivalent after enough stats.

Prototype ceilings:

| Technique | Maximum intended hit quality |
|---|---|
| Measured Cut | CLEAN |
| Driving Thrust | CLEAN |
| Placed Hew | PRECISION |
| Committed Cleave | CLEAN |
| Haft Check | SOLID/CLEAN balance-open |

`PRECISION` remains special because it requires the technique and target conditions to support it.

A high AttackControl score cannot turn every ordinary swing into a Precision strike if the technique ceiling is `CLEAN`.

---

# 20. Body-fallback policy

The combat-resolution contract distinguishes selected-part contact from general body contact.

Selected first family policies:
- `MEASURED_CUT` → `ALLOW_BODY_FALLBACK`;
- `DRIVING_THRUST` → `ALLOW_BODY_FALLBACK`;
- `PLACED_HEW` → `REQUIRE_SELECTED_PART`;
- `COMMITTED_CLEAVE` → `ALLOW_BODY_FALLBACK`;
- `HAFT_CHECK` → general/large-target action; not designed as surgical targeting.

This creates a real reason to choose between reliability and precision.

---

# 21. Movement and terrain relationship

The long two-handed weapon should care about physical context.

Potential modifiers later:
- `NARROW` terrain can restrict wide cuts/cleaves;
- dense brush can reduce some swing arcs while thrusts remain useful;
- mud can increase reposition/Stamina burden;
- unstable footing can lower control on high-commitment cuts;
- high ground/angle can expose or obscure specific parts;
- walls/large roots/rocks can affect attack path where encounter geometry models them.

Important:
terrain constraints should be authored/readable, not random animation clipping penalties.

Do not implement a generic hidden `-20% damage in forest` rule.

---

# 22. First-person presentation requirements

Because combat presentation is first-person, the weapon must remain readable and usable on the Galaxy A03s target without consuming excessive screen space or animation cost.

Later prototype requirements:
- idle pose does not obscure central target anatomy;
- weapon head position is readable without dominating the screen;
- attack telegraphs preserve monster readability;
- target-part highlighting remains visible around the weapon;
- wide swings avoid nauseating camera motion;
- camera is not driven by weapon animation in a way that changes authoritative aim/contact;
- high-commitment attack animation must not hide incoming reaction information;
- camera/weapon clipping must be measured in narrow terrain.

Presentation never changes the domain-selected target/contact/hit quality.

---

# 23. Animation requirements later

Minimum future animation coverage:
- neutral/ready;
- walking/turning with weapon;
- Measured Cut;
- Driving Thrust;
- Placed Hew;
- Committed Cleave;
- Haft Check;
- Guard;
- Block outcomes;
- Parry outcomes;
- Brace;
- hit/stagger interruption states;
- transitions that preserve first-person readability.

Do not create final animation assets until actual Hunter DCC/rig and combat implementation gates allow it.

Animation frames are presentation of an already-authoritative action timeline; they do not decide damage/contact.

---

# 24. Equipment/progression relationship

The first family supports the selected hybrid progression model.

Future variants/refinement may improve:
- handling;
- material durability/structure if durability is adopted;
- Stamina efficiency within caps;
- edge retention if later useful;
- controlled sever efficiency;
- technique compatibility;
- burden/weight optimization;
- terrain specialization.

They may not gradually erase the family's weaknesses.

Examples of healthy future specialization:
- lighter poleblade → improved handling/mobility, lower force/guard stability;
- reinforced poleblade → stronger guard/structural contact, higher burden/Stamina;
- fine-edge poleblade → better controlled cutting/sever, worse abuse against hard structures.

Do not create these actual variants in this bounded pass.

---

# 25. Mastery relationship

First-slice mastery should demonstrate familiarity rather than raw level scaling.

Possible later mastery effects:
- lower handling penalty at extended reach;
- reduced recovery penalty after a committed cut;
- improved legal parry categories;
- better Stamina efficiency within floor;
- access to one advanced technique;
- improved ability to maintain selected-part control under movement.

Mastery must not:
- add extra normal turns;
- raise AP cap routinely;
- turn every technique into PRECISION;
- make hard cover/anatomy legality disappear;
- convert the family into a top blunt weapon.

---

# 26. Data-definition requirements

Future data-driven family definition should include stable fields equivalent to:
- family ID;
- display/localization key;
- handedness;
- reach profile;
- handling profile;
- damage-channel capabilities;
- break/sever efficiency profile;
- guard capability;
- parry capability/categories;
- burden/mass class;
- mastery family ID;
- compatible technique IDs;
- presentation/rig attachment references;
- content validation tags.

Technique definitions should include:
- technique ID;
- family requirement;
- AP cost;
- Stamina cost;
- range states;
- allowed target policy;
- body-fallback policy;
- damage-channel profile;
- AttackControl contributors;
- hit-quality ceiling;
- reaction-window/allowed defense categories;
- guard/parry interaction;
- commitment/recovery tags;
- terrain restrictions;
- break/sever modifiers;
- status payload where relevant;
- animation/presentation reference IDs later.

Definitions own design values. Runtime state stores current equipment/mastery/condition, not duplicated definition values.

---

# 27. Validation invariants

Future content validation must reject or flag:
- weapon with no stable family ID;
- technique referencing nonexistent family;
- technique AP cost outside action-economy limits without explicit exception;
- technique with contradictory range policy;
- `PRECISION` ceiling without selected-part support;
- `REQUIRE_SELECTED_PART` technique with no legal target rule;
- family claiming parry capability against all incoming attack categories;
- zero-Stamina high-force technique after modifiers unless explicitly exceptional;
- refinement that changes family identity without becoming a distinct variant;
- weapon definition giving top break + sever + guard + mobility without explicit cost/risk;
- attack capable of severing anatomy outside legal sever boundaries;
- UI-only weapon bonuses not present in authoritative data.

---

# 28. Debug/Admin requirements

Future combat/admin inspector should show for the equipped Field Poleblade:
- family ID;
- exact weapon/item ID;
- mastery state;
- current handling modifiers;
- reach state to target;
- legal techniques;
- rejected techniques + reason;
- AP/Stamina costs before/after modifiers;
- damage-channel profile;
- selected target;
- body-fallback policy;
- hit-quality ceiling;
- break/sever efficiency;
- guard/parry eligibility;
- terrain/footing restrictions;
- complete resolution trace after use.

A developer should be able to answer:
**why was Placed Hew illegal or why did it hit torso instead of tail?**
without inspecting animation code.

---

# 29. Required tests later

When combat implementation is authorized, tests should cover at minimum:

## Action economy
- Measured Cut consumes 2 AP;
- Driving Thrust consumes 2 AP;
- Placed Hew consumes 3 AP;
- Committed Cleave consumes 4 AP;
- no technique creates extra AP/turns;
- insufficient AP rejects before commitment.

## Targeting
- Measured Cut can fall back to body contact when allowed;
- Placed Hew cannot silently become full torso damage when tail acquisition fails;
- inaccessible target part is rejected or downgraded exactly according to technique policy;
- sever cannot occur outside legal distal tail boundary.

## Hit quality
- technique ceiling is respected;
- standard cut cannot become PRECISION if its ceiling is CLEAN;
- Placed Hew can reach PRECISION only when selected-part contact and control conditions are satisfied.

## Range
- OUT_OF_RANGE rejects;
- TOO_CLOSE restricts appropriate swing techniques;
- thrust remains available only according to defined geometry/range policy.

## Defense
- parry rejects incompatible body charge;
- directional guard does not protect rear/illegal bearing;
- block/guard consumes appropriate Stamina/guard consequences;
- clean parry does not create recursive free turn.

## Anatomy
- tail sever interaction preserves Monster 01 state/harvest invariant;
- horn break is possible but less efficient than future dedicated impact baseline once comparison exists;
- intact dorsal plate protection is respected;
- broken plate exposure changes local interaction only.

## Determinism
- identical seed/context reproduces same attack result;
- UI/animation replay does not reroll;
- save/reload cannot duplicate committed/resolved action.

---

# 30. First-slice acceptance criteria

This weapon family design is sufficient to enter later implementation only when the combat gate and prior implementation gates allow it.

The first playable Field Poleblade prototype should eventually prove:
- the 4 AP economy produces at least three meaningfully different turn choices;
- reach matters;
- TOO_CLOSE matters;
- standard vs precision vs heavy attack choices feel mechanically distinct;
- tail sever targeting is achievable but not automatic;
- hard-structure break is possible but visibly not the family's specialty;
- guard/parry are useful but cannot neutralize every Monster 01 attack;
- repeated high-commitment actions create Stamina pressure;
- first-person weapon presentation does not hide the monster anatomy;
- movement/terrain affects technique selection;
- all outcomes remain explainable through the combat trace.

If the prototype shows the Field Poleblade is the best answer to every Monster 01 situation, the family has failed its quality gate and must be narrowed rather than buffing every future weapon to compete.

---

# 31. Current selected/open state

Selected:
- first family: `WEAPON_FAMILY_FIELD_POLEBLADE`;
- working name: Field Poleblade;
- two-handed long-hafted blade;
- primary cutting/sever identity;
- secondary piercing/control identity;
- limited impact capability;
- medium melee reach advantage;
- directional guard;
- restricted parry;
- six-action/defense first packet as described above;
- explicit technique hit-quality ceilings and fallback policies.

Prototype/open:
- exact weapon dimensions/mass;
- exact Stamina numbers;
- exact damage values;
- exact AttackControl coefficients;
- exact break/sever numerical efficiencies;
- exact reach distances;
- exact animation timing;
- exact mastery thresholds;
- exact material/construction variant;
- final setting-facing family name.

Rejected for this first family:
- universal best weapon identity;
- shield-level defense;
- dedicated top-tier blunt break performance;
- routine ranged projectile mode;
- free omnidirectional parry;
- random critical-hit mechanic;
- AP-cap growth through weapon refinement;
- automatic sever on a successful tail hit.

`FIRST_WEAPON_FAMILY_CONTRACT = RECORDED`
`FIRST_WEAPON_FAMILY = FIELD_POLEBLADE`
`COMBAT_IMPLEMENTATION = STILL_BLOCKED_BY_READINESS_GATES`
