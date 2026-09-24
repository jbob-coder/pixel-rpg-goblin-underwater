# Unnamed Hunt RPG — Game Experience Bible

Status: ACTIVE PLAYER-EXPERIENCE CONTRACT / SHOOTER-RPG PIXEL DIRECTION
Last reconciled: 2026-09-15
Branch: `shooter-rpg`

## Authority

This file is reconciled with `SHOOTER_RPG_VISUAL_DIRECTION.md`, which is the current visual/presentation authority.

When older documents still describe aerial exploration or mandatory first-person combat, those presentation assumptions are superseded on this branch.

## Purpose

Define how the game should feel from launch through settlement life, exploration, hunting, combat, harvesting, return, relationships and progression.

The objective is a game that feels physically explorable, visually distinctive, consequential and understandable on a phone without becoming an enormous open-world burden.

# 1. Experience statement

The player should feel like a hunter living inside a dangerous frontier world where settlements survive through cooperation, hunting, mining and control of energy-bearing crystals.

The game should combine:
- third-person physical exploration;
- readable pixel-styled presentation;
- large monsters that exist in the world rather than only in battle screens;
- body-part-focused combat;
- meaningful harvesting;
- NPC relationships and memory;
- time, schedules and aging;
- settlement/faction consequences;
- earned progression rather than runaway stat inflation.

The game should not feel like:
- a menu game with decorative travel buttons;
- a disconnected combat minigame;
- a giant empty open world;
- a stat treadmill where level alone trivializes monsters;
- a simulation spreadsheet the player must micromanage;
- smooth generic 3D with a cosmetic pixel filter pasted on top.

Core identity:

**a living third-person pixel hunting RPG with persistent consequences.**

# 2. Boot and introduction flow

Target flow:

`APP LAUNCH → TITLE → CONTINUE / NEW GAME / SETTINGS → FIRST SETTLEMENT → BASIC MOVEMENT/INTERACTION → FIRST TASK → LEAVE SETTLEMENT PHYSICALLY → TRACK/OBSERVE → FIRST ENCOUNTER → BODY-PART COMBAT → HARVEST → RETURN → CONSEQUENCE/UPGRADE`

The first session should teach the complete loop without exposing every system.

# 3. Camera language

## Core camera

The selected core presentation is third-person behind the character.

Goals:
- player character remains visible;
- forward terrain is readable;
- monsters can feel large;
- settlement streets and buildings feel physical;
- camera supports exploration and combat without a perspective swap;
- right-side mobile look input remains useful and responsive.

Exact camera distance, pitch, FOV, collision behavior and shoulder offset remain prototype-tunable.

## No mandatory perspective swap

The game should not normally transition from aerial exploration into first-person combat.

Combat happens in the same world and perspective family so terrain, approach direction, monster position and environmental context remain continuous.

# 4. Pixel visual identity

The selected visual target is pixel-styled third-person 3D.

Desired feeling:
- crisp readable pixels;
- strong silhouettes;
- warm practical settlement detail;
- lush but controlled wilderness;
- large readable monster forms;
- cohesive pixel UI;
- atmospheric depth without photoreal rendering cost.

The visual reference saved in Google Drive is the current composition/style anchor. It is a concept reference, not proof of implementation and not automatic canon for visible names/text.

# 5. World scale and traversal

The player physically walks through local world spaces.

Do not make ordinary exploration a sequence of location buttons.

Use world compression:
- connected routes;
- short but meaningful travel distances;
- landmarks;
- hunting signs;
- gatherables;
- NPCs/events;
- hazards;
- optional side paths;
- no large stretches of empty terrain merely to imply scale.

The world may be streamed in chunks/regions while appearing coherent to the player.

Fast travel, if added, is an earned convenience after discovery rather than a replacement for exploration.

# 6. Settlement experience

Settlements are playable social/survival spaces.

They should contain a small number of strong locations such as:
- smith/crafter;
- market/supply area;
- clinic/healer;
- hunter/contract authority;
- mining/licensing authority where relevant;
- homes/households;
- gate/watch structures;
- processing/harvest area.

NPCs should visibly use the space according to schedules and events.

A compact settlement with meaningful activity is preferred over a giant empty city.

# 7. Exploration experience

Exploration should involve:
- movement through the world;
- observing terrain;
- finding tracks/signs;
- hearing/seeing distant threats;
- discovering routes and resources;
- deciding whether to approach, avoid or investigate;
- encountering NPCs outside settlements;
- making choices that cost time.

The player should sometimes detect a monster long before combat through:
- tracks;
- damaged vegetation;
- carcasses;
- calls/sounds;
- crystal traces;
- territorial marks;
- NPC warnings;
- distant silhouettes.

# 8. Combat experience

Combat remains spatial and body-part focused in third person.

The player should be able to make decisions such as:
- move/reposition;
- attack selected anatomy;
- defend/block/react;
- dodge/evade where supported;
- use cover/terrain;
- use item/tool;
- observe/inspect;
- withdraw/escape.

The terrain used before combat should still matter during combat.

A rock, bridge, slope, ruin, tree line or narrow route can become tactical geometry.

Body-part targeting is contextual. Avoid permanently outlining every body part.

# 9. Monster presentation

Monsters are primary hero assets.

They should communicate:
- mass;
- locomotion;
- attack anatomy;
- injury state;
- ecological role;
- possible harvest structures;
- crystal/mutation influence when relevant.

Damage should remain visually persistent through the hunt.

Breaks/severs must match authoritative anatomy state.

# 10. NPC / SIM experience

NPCs should feel persistent without requiring generative AI.

Important characters may remember meaningful events and react later.

Relationships should affect:
- dialogue;
- willingness to help;
- information shared;
- access to services/resources;
- future scenes;
- faction/settlement consequences;
- companionship/rivalry;
- long-term family/community outcomes.

Most relationship numbers stay hidden. The player experiences changed behavior rather than visible `+5 friendship` popups.

NPCs may have relationships with each other, not only with the player.

# 11. Time, schedules and aging

Time is part of gameplay.

Actions consume believable time:
- walking;
- conversation;
- gathering;
- harvesting;
- crafting;
- hunting;
- resting;
- travel.

Time affects:
- NPC schedules;
- monster activity;
- daylight;
- availability of services;
- events/contracts;
- long-term aging.

Over sufficiently long campaigns, NPCs may age, form households, have children, inherit roles, retire or die. This should create continuity and legacy without requiring every citizen to be simulated every frame.

# 12. Crystal / mining / settlement survival experience

Energy-bearing crystals/diamonds connect world systems.

They may come from:
- mines/veins;
- rare formations;
- selected monsters/ecologies.

Their importance can drive:
- mining licenses;
- protected territory;
- settlement power/energy;
- factions and survivor groups;
- economy;
- difficult moral/resource decisions.

The resource should create world tension, not exist only as another crafting currency.

# 13. Diamond Watch experience

The Diamond Watch can function as a recurring recognizable interface object across projects while each game retains its own lore.

Potential functions:
- time/date;
- map;
- contracts;
- hunter journal/bestiary;
- discovered places;
- notes;
- mining licenses;
- faction notices;
- selected relationship/settlement information.

It should reduce HUD clutter by housing deeper information outside the normal exploration view.

# 14. Progression experience

Progression must feel earned.

Power comes from multiple layers:
- level;
- attributes;
- mastery;
- equipment;
- monster knowledge;
- harvesting/crafting expertise;
- relationships/access;
- tactical options.

Level should increase capability without making early bosses meaningless.

A normal racial/species cap may exist. Human level 20 remains a provisional design anchor only. Beyond-cap growth can require rare materials, conditions and uncertain breakthrough attempts.

Failed breakthroughs should still produce some form of adaptation/learning/partial progress rather than deleting major progress.

# 15. Story and consequences

The story should use difficult choices with real benefits and costs.

Possible consequence targets:
- save a person versus secure critical settlement resources;
- protect a settlement versus pursue a rare monster/material;
- obey or violate mining restrictions;
- support one group and damage trust with another;
- preserve a dangerous creature/ecosystem versus exploit it;
- spend scarce time helping an NPC versus pursuing a contract.

Consequences may be immediate or delayed.

The strongest outcomes should be shown through world changes, character behavior, availability, loss, survival, inheritance and future opportunities rather than only text summaries.

# 16. Exploration HUD

Normal exploration HUD should remain compact.

Preferred layout family:
- upper-left: health/stamina/essential player state;
- upper-right: mini-map/compass/time access;
- collapsible objective panel;
- lower-left: bounded quick items;
- lower-right: contextual touch actions;
- world-space markers only when relevant.

The generated reference image is composition inspiration, not a requirement to permanently display every element shown there.

# 17. Combat HUD

Combat UI can expand contextually without hiding the monster.

Possible information:
- current target anatomy;
- health/stamina/action resources;
- reaction availability;
- range/position;
- known monster condition;
- telegraphed threat;
- contextual action choices.

Avoid giant fixed panels and permanent target overlays.

# 18. UI usability rules

- landscape-first;
- safe-area aware;
- anchors/containers rather than hard-coded fixed coordinates;
- readable on supported Android aspect ratios;
- large touch targets;
- no control/sprite overlap;
- no critical action hidden beneath phone cutouts/rounded corners;
- pixel styling must not make text hard to read;
- scalable UI/text options planned from the beginning.

# 19. Music and audio

Music should follow state rather than run at maximum intensity continuously.

Useful states:
- title;
- settlement;
- wilderness exploration;
- nearby threat;
- combat;
- critical danger;
- victory/resolution;
- harvest/return.

Gameplay-critical sounds outrank decorative ambience:
1. monster attack telegraphs;
2. player danger/status cues;
3. impacts/material feedback;
4. monster movement/calls;
5. tracking interactions;
6. environment;
7. decorative ambience.

# 20. First-session target

The first session should communicate:
1. the player lives in a functioning settlement;
2. movement/camera feel good on a phone;
3. the world is physically explorable;
4. NPCs are persistent people, not menu entries;
5. monsters leave readable evidence;
6. combat happens in the same spatial world;
7. anatomy targeting changes monster capability;
8. damage changes harvest results;
9. the player returns to a settlement that reacts;
10. progression gives a reason to hunt again.

# 21. First visual prototype acceptance questions

Before calling the new direction successful:
- Does the third-person camera feel good on a phone?
- Does the pixel style look intentional rather than filtered/blurry?
- Can the player move and look simultaneously without control conflict?
- Does the HUD stay inside safe areas and avoid sprite overlap?
- Is the character readable against the environment?
- Can NPCs/interactables be recognized without excessive floating markers?
- Does one monster feel large and readable in the same camera?
- Can body-part targeting work without switching to first person?
- Does the settlement feel alive despite small scope?
- Does the game launch and run reliably on the target Android device?

Current status of this player-facing direction: `DESIGNED`, not yet `VISUAL_QUALITY_VERIFIED`.
