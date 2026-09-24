# Unnamed Hunt RPG — NPC / Creature Behavior Pattern System

Status: DESIGN DECISION / NO IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

Define how NPCs, monsters and other autonomous actors behave without machine-learning, generative-AI or opaque decision systems.

## 1. Locked decision: no AI behavior system

The game will not use AI to decide ordinary NPC or monster behavior.

Autonomous actors use authored, inspectable behavior patterns made from:
- explicit states;
- schedules where appropriate;
- `IF / ELSE IF / ELSE` conditions;
- priorities;
- cooldowns;
- capability requirements;
- situation flags;
- deterministic or seeded variation only where useful;
- authored transitions between behavior phases.

The player should be able to learn behavior because it follows understandable patterns, while more important actors can still have many interacting conditions.

## 2. Core behavior flow

```text
AUTHORITATIVE WORLD / ENCOUNTER STATE
        ↓
READ ACTOR PATTERN STATE
        ↓
COLLECT CURRENT FACTS
        ↓
EVALUATE RULES IN DEFINED ORDER
        ↓
SELECT FIRST/HIGHEST VALID PATTERN
        ↓
CREATE NORMAL DOMAIN ACTION REQUEST
        ↓
VALIDATE THROUGH SAME GAME RULES
        ↓
RESOLVE → STATE / EVENTS
        ↓
UPDATE PATTERN MEMORY / COOLDOWNS / PHASE
```

A behavior controller does not directly subtract health, move through walls, bypass AP, ignore broken anatomy or create loot.

## 3. Behavior complexity tiers

Complexity is authored per actor type rather than giving every actor an expensive universal controller.

### Tier 0 — Static / reactive
Examples:
- shopkeeper counter interaction;
- stationary guard;
- simple ambient animal.

Typical logic:
- remain at anchor;
- play idle pattern;
- respond to direct interaction;
- react to one or two world flags.

### Tier 1 — Simple scheduled NPC
Examples:
- worker;
- merchant;
- villager;
- camp worker.

Typical inputs:
- time block;
- current location;
- weather severity;
- workplace open/closed;
- danger flag;
- player interaction.

### Tier 2 — Contextual NPC
Examples:
- hunter;
- guard captain;
- quest NPC;
- field researcher.

Adds:
- relationship/reputation flags;
- quest state;
- nearby danger;
- equipment state;
- recent event memory;
- alternate routes/activities;
- emergency priorities.

### Tier 3 — Hunt creature
Uses:
- species temperament;
- territory;
- alertness;
- range/bearing;
- player visibility/exposure;
- injuries;
- functional anatomy;
- stamina;
- statuses;
- escape routes;
- current phase;
- cooldowns;
- terrain opportunities.

### Tier 4 — Complex/boss creature
Adds authored layers such as:
- multiple combat phases;
- phase transition conditions;
- conditional pattern chains;
- temporary arena changes;
- remembered player tendencies through bounded encounter flags;
- attack-combo patterns;
- desperation logic;
- protection of a wounded side;
- terrain-specific reactions;
- enraged/exhausted/flee states.

Complexity comes from more explicit rules, not from an opaque intelligence model.

## 4. Rule structure

Conceptual `BehaviorRule`:
- stable rule ID;
- owning behavior profile;
- current-state requirement;
- conditions;
- priority;
- optional cooldown;
- optional minimum/maximum range;
- required capabilities;
- forbidden statuses;
- action request or state transition;
- optional next-pattern memory;
- optional seeded variation group;
- debug explanation key.

Example:

```text
IF state == WOUNDED
AND health_percent <= 25
AND escape_route_available
AND species_flee_threshold_reached
THEN request ESCAPE
PRIORITY 100
```

Another:

```text
IF player_bearing == REAR
AND capability(FUNCTIONAL_TAIL)
AND tail_sweep_cooldown == READY
THEN request ATTACK attack_tail_sweep
PRIORITY 70
```

If the tail is severed, the capability check fails automatically. The behavior file does not need a separate hard-coded exception in every attack rule.

## 5. Priority and deterministic choice

Preferred rule:
1. filter rules whose state/conditions/capabilities are valid;
2. sort by explicit priority;
3. apply authored tie policy;
4. submit the selected action through normal domain validation.

Tie policies may include:
- first-defined stable order;
- rotate through a pattern sequence;
- least-recently-used;
- seeded weighted selection within a specifically authored variation group.

Seeded variation is allowed for variety, but the same state + same seed must be reproducible for debugging.

## 6. Pattern state versus gameplay state

Behavior state is not allowed to duplicate gameplay truth.

Behavior may store bounded memory such as:
- current behavior phase;
- current routine activity;
- last selected pattern ID;
- cooldown counters;
- recently-used attack flags;
- alert target ID;
- short encounter memory flags;
- schedule block.

It should read, not duplicate:
- health;
- stamina;
- anatomy condition;
- inventory;
- world position;
- weather;
- player relationship;
- quest state;
- terrain;
- tactical range/bearing.

## 7. NPC schedule behavior

For civilian/hub NPCs, schedules should be deterministic and data-driven.

Potential schedule block fields:
- day category;
- start time;
- end time;
- default activity;
- target anchor/location;
- allowed interruptions;
- fallback location;
- weather override;
- danger override;
- quest/event override.

Example:

```text
IF danger_alarm == TRUE → shelter/assigned emergency role
ELSE IF storm_severity >= HEAVY → indoor fallback
ELSE IF current_time in WORK_BLOCK → workplace activity
ELSE IF current_time in MEAL_BLOCK → meal anchor
ELSE → home/leisure routine
```

## 8. Situation conditions

Reusable condition facts may include:
- time/day block;
- weather tag/intensity;
- region danger level;
- player distance;
- player reputation/relationship;
- quest/event flags;
- actor health percentage;
- stamina percentage;
- status present/absent;
- anatomy capability present/absent;
- target range band;
- target bearing;
- target cover;
- terrain tags;
- nearby ally/enemy count;
- escape route availability;
- recently-used action;
- cooldown ready/not ready;
- encounter phase;
- territory position;
- alertness.

Conditions should be composable and reusable instead of coded independently for each actor.

## 9. Monster pattern examples

### Territorial creature
- patrol territory;
- investigate fresh disturbance;
- warning display;
- attack if player crosses aggression threshold;
- chase only within territory/chase limit;
- return to territory after disengagement.

### Injured creature
- favor uninjured side;
- stop using disabled anatomy-dependent actions;
- increase defensive/reposition patterns;
- flee if condition and temperament allow;
- leave more tracking evidence if bleeding/injured.

### Ambush creature
- remain concealed while detection condition is false;
- prepare ambush if target enters valid zone;
- abort/reposition if discovered early;
- use normal combat pattern after ambush resolves.

## 10. NPC interaction patterns

Dialogue/interaction availability should also be condition-driven.

Examples:
- merchant greeting changes after first completed hunt;
- blacksmith offers recipe only when research/rank/material flag is met;
- researcher comments on a newly discovered anatomy fact;
- guard changes response during danger alarm;
- NPC moves to shelter during severe weather.

The dialogue system can select authored lines/branches from conditions. It does not generate dialogue dynamically unless the user later explicitly changes this rule.

## 11. Performance model

Not every actor evaluates every condition every frame.

Recommended update tiers:
- active combat actor: evaluate when a decision is needed, not continuously;
- nearby exploration NPC/monster: event-driven plus bounded periodic checks;
- distant loaded actor: low-frequency schedule/behavior updates;
- unloaded actor: coarse schedule/state advancement only if persistence requires it.

Use event triggers where possible:
- time block changed;
- weather changed;
- player entered range;
- damage received;
- status changed;
- anatomy capability changed;
- quest flag changed.

This reduces CPU cost and makes behavior easier to debug.

## 12. Admin / creator support

Behavior creator/debug tools should eventually show:
- current behavior profile;
- current phase/state;
- all candidate rules;
- each condition PASS/FAIL;
- rule priority;
- cooldown state;
- capability requirements;
- selected rule;
- submitted action;
- validation result;
- recent pattern history.

Creator controls:
- add/edit rule;
- edit priority;
- edit condition group;
- edit cooldown;
- edit phase transition;
- run one evaluation;
- simulate N turns/decision points;
- set test facts;
- export deterministic trace.

This is required so complex actors remain understandable rather than becoming unmaintainable nested condition code.

## 13. Validation requirements

Behavior validation should catch:
- duplicate rule IDs;
- nonexistent action references;
- nonexistent capability/status/terrain references;
- unreachable state/phase;
- transition to nonexistent state;
- contradictory always-false condition sets where detectable;
- invalid cooldowns;
- undefined priority/tie behavior;
- rule requiring an action illegal for the owning species/profile;
- loops that can issue actions without consuming time/resources where applicable.

## 14. Code organization principle

Do not implement every actor as one giant `if` script.

Preferred separation:
- behavior profile data;
- reusable condition evaluators;
- state/phase controller;
- rule evaluator;
- domain action request builder;
- trace/debug reporter.

Game rules remain in their owning domains. Behavior only decides what legal action to request.

## 15. Locked versus open

Locked:
- no AI-driven behavior;
- deterministic authored patterns/conditions;
- behavior uses normal domain actions;
- simple and complex actors use different authored complexity levels;
- behavior must be inspectable/debuggable;
- capability/anatomy/status/terrain facts can influence patterns;
- expensive continuous evaluation is avoided.

Open:
- exact number of pattern phases per first monster;
- final NPC daily schedule depth;
- whether seeded weighted variation is used broadly or sparingly;
- party/companion behavior until party design is decided.