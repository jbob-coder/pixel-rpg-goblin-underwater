# Layer 06 — NPCs, Services and Activity

Status: PROVISIONAL NPC/SERVICE BLUEPRINT

## Core law

NPC presentation does not own durable NPC state.

Use stable NPC IDs and lightweight schedule/activity state. No expensive generative AI is required.

## S01 South Gate / Arrival

Planned roles:
- Arrival Guard
- optional second gate/watch guard
- logistics/porter presentation

Service/activity:
- arrival orientation
- settlement rules/help
- visitor state hooks
- gate status

Anchors:
- guard idle
- gate watch
- visitor conversation
- cart/logistics activity

## S02 Central Plaza / Market

Planned roles:
- 2–4 market vendors
- rotating local NPC visitors
- optional civic/notice-board keeper

Services:
- general goods future
- food/basic supplies future
- notices/bounties
- social/local information

NPC activity should create life without crowding the central movement cross.

## S03 West Residential

Required local-life foundation:
- Community Hall keeper/local coordinator
- 2–4 resident identities
- optional rotating visitor

Community Hall anchors:
- keeper desk/work
- central conversation
- event gathering
- idle/social seats

Residence anchors:
- resident home
- doorway/yard
- private/rest state
- local route connection

Unloaded sections use abstract state, not continuously simulated full NPC physics.

## S04 East Work District

Planned roles:
- Smith
- helper/apprentice optional
- storage/work handler optional

Services:
- smith interaction
- future crafting
- equipment/material processing
- storage/loadout future

Smith building only exposes service anchors.
Crafting/economy mutation must live in domain/service owners.

## S05 North Hunter Exit

Planned roles:
- Gate Warden / Hunter Warden
- watch/hunter support NPC optional

Services:
- hunt departure
- route warnings
- bounty/target information
- return/re-entry context
- future emergency supply interaction

Current Gate Warden presentation is the natural source/reference for the future S05 warden role.

## Schedule model

Use simple authored states such as:
- HOME
- WALK_TO_WORK
- WORK
- PLAZA
- MEAL/REST
- RETURN_HOME
- NIGHT_REST
- SPECIAL_EVENT

Do not require full pathfinding/simulation while a section is unloaded.

## Stable NPC state

Durable future NPC owner may hold:
- stable NPC ID
- relationship/reputation
- role
- current abstract section
- schedule state
- injury/status
- event flags
- availability

Presentation may hold:
- visible transform
- animation
- current visual prompt

## Population target

First implementation should remain small and readable.

Provisional visible active NPC target:
- S01: 1–3
- S02: 4–8
- S03: 3–6
- S04: 2–4
- S05: 1–3

These are planning ranges, not performance guarantees.

Device testing decides final density.
