# Unnamed Hunt RPG — Discussion Checklist

Status: OPEN / MUST BE DISCUSSED BEFORE IMPLEMENTATION
Last reconciled: 2026-09-02

This file records decisions that must not be invented silently.

## Decisions now recorded

Current decisions unless the user changes them:
- exploration uses elevated angled dimensional overview;
- Paper-Mario-like comparison is only for readability/camera philosophy, not paper/craft art;
- visual identity: **an illustrated hunting world brought to life**;
- tone target: grounded stylized wilderness/frontier monster-hunting fantasy;
- current aerial camera target roughly 40–50° downward;
- player/major monsters preferably stylized 3D;
- selective 2D/billboard/impostor detail allowed for Android efficiency;
- combat transitions into the same physical encounter context;
- anatomy damage visibly persists;
- practical hunter-field-document UI;
- environment communicates tracking/navigation before excessive HUD markers;
- **no AI behavior system**;
- NPCs/creatures use deterministic authored schedules/patterns/conditions with priorities, cooldowns and phases;
- simple actors use simple patterns; important monsters can use layered authored conditions;
- current six-role attribute direction: Might, Finesse, Agility, Endurance, Perception, Resolve;
- attributes are bounded; current internal scale recommendation is 1–100 while practical values remain open;
- equipment/status/terrain/weather/posture/action context use one shared modifier/effect pipeline;
- modifier stacking/caps/floors are explicit;
- AP/reaction scaling is tightly restricted;
- contextual hit quality is preferred over a generic hidden critical-hit system;
- terrain can mechanically affect movement, footing, visibility, tracking and tactical legality;
- development builds require stat/modifier and behavior-rule traces;
- crystal-bearing creatures contain an internal life crystal;
- crystal energy is an authoritative life-force reserve;
- zero usable crystal energy means creature death;
- desperate creatures can burn their own life-force reserve to enter berserk/overdrive according to deterministic conditions;
- crystal Tier, Rank, Quality and Element are separate intrinsic properties;
- current Energy Reserve and structural Condition are separate from Tier/Rank/Quality/Element;
- mutation is a core ecological system and is data-driven rather than arbitrary random stat inflation;
- mutations can alter anatomy, stats/effects, capabilities, elemental behavior, terrain adaptation, authored behavior patterns and harvest;
- mutation combinations are bounded through prerequisites, incompatibilities and support/load limits;
- off-screen ecology uses region/species aggregate state rather than full per-creature simulation.

Detailed authorities:
- `VISUAL_WORLD_BEHAVIOR_BIBLE.md`
- `STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`
- `BEHAVIOR_PATTERN_SYSTEM.md`
- `CRYSTAL_MUTATION_ECOSYSTEM_SYSTEM.md`

## Identity / setting
- Final game name.
- Exact world setting/history.
- Technology/magic level.
- Why crystal-bearing life exists.
- Why creatures are hunted.
- Player role/background.
- Exact maturity level.
- Story importance versus systems-driven hunting.

## Crystal life-force
- Exact number/names of crystal tiers.
- Exact rank scale inside each tier.
- Quality internal scale and player-facing bands/names.
- Element roster.
- Whether secondary/hybrid elements exist.
- How crystal energy normally recovers: metabolism, rest, habitat exposure, diet, or combination.
- Whether every non-human creature has a crystal or only specific life forms.
- Whether humans have crystals.
- Exact maximum-energy relationships to tier/rank/quality.
- Whether severe body injuries create continuous core drain and how strongly.
- Whether direct crystal targeting is possible.
- What anatomy must be broken/exposed before core targeting if it exists.
- Exact crystal structural states: intact/strained/cracked/fractured/etc.
- Consequences of core fracture besides reserve loss.
- Whether a dead crystal can ever be recharged/reused or remains permanently inert as a life source.
- Human social/economic/religious consequences of harvesting life crystals.

## Berserk / desperation
- Exact trigger conditions.
- Whether each species has its own desperation policy.
- Activation energy cost.
- Ongoing per-turn/per-action drain.
- Whether elemental attacks drain additional reserve.
- Exact stat/action/pattern benefits.
- Whether berserk reduces defense/control or only adds offense.
- Whether berserk can be voluntarily ended.
- Whether some species use short overdrive bursts instead of one continuous mode.
- Whether some final phases are irreversible once activated.
- Visual/audio tell requirements.
- Whether waiting behind cover while the creature burns life force is an intended common strategy or only works against specific species.

## Mutation system
- Biological/lore mechanism that causes mutation.
- Whether mutation happens during one life, across generations, or both.
- Whether traits can be inherited.
- Mutation categories used in the first release.
- Exact support/load budget model.
- Relationship between Tier/Rank/Quality and mutation capacity/stability.
- Whether mutation can alter crystal element.
- Whether mutation can add new anatomy parts or only modify existing ones.
- Whether regeneration mutations exist and how tightly they are constrained.
- Mutation rarity/selection rules.
- How visible mutations are before combat.
- Bestiary/research rules for identifying mutation traits.
- How mutation changes crystal/anatomy harvest value.

## Ecosystem
- Which region ecological pressures are simulated.
- Population aggregate update cadence.
- How much predator/prey interaction is simulated.
- Whether elemental saturation changes over time.
- Whether hunting pressure can make some mutations more common.
- Whether overhunting can reduce/temporarily remove a species from a region.
- Migration rules.
- Breeding/repopulation depth.
- Whether high-tier/high-rank individuals affect regional ecology differently.
- How persistent ecosystem changes are across the campaign.
- Whether player actions can intentionally manipulate ecology to hunt desired mutations.

## Exploration
- Exact camera projection after prototype comparison.
- Fixed/discrete/tightly limited camera rotation.
- Exact 3D vs 2.5D asset mix.
- Region size/streaming.
- Android movement controls.
- Tracking depth.
- Gathering depth.
- Stealth/approach mechanics.
- Camps/hubs/towns.
- Weather/day-night relevance.

## Stats / attributes
- Exact starting attribute baseline/distribution.
- Whether player allocates starting points.
- Whether attributes grow directly, mostly through gear/mastery, or both.
- Exact practical soft range and hard cap.
- Health derivation.
- Stamina derivation/recovery.
- Initiative formula.
- Tracking/inspection formulas.
- Whether Resolve uses fear/panic mechanics or only stagger/composure.
- How strongly attributes influence attacks relative to weapon/technique/context.

## Action economy
- AP model final value/costs.
- Reaction resource final rules.
- Turn order/initiative model.
- Minimum movement/AP/stamina cost floors.
- Whether rare equipment/perks can alter AP and by how much.

## Equipment
- Initial weapon families.
- Melee/ranged balance.
- Equipment slots.
- Armor coverage model.
- Armor burden/weight model.
- Ammunition/reload.
- Sharpness/durability only if decision value justifies it.
- Traps/bait/lures.
- Hunting tools.
- Whether accessories/charms exist and how many.
- Upgrade branching depth.
- Whether harvested crystals power/sock/catalyze equipment, or serve another purpose.

## Status effects
- Exact first-slice status list.
- Bleeding severity/timing.
- Exhaustion model.
- Stagger vs Off-Balance distinction.
- Poison/toxin depth if setting supports it.
- Heat/cold depth.
- Psychological effects: use or omit.
- Buff duration/intensity philosophy.
- Cure/item interaction.
- Persistence between encounters.

## Terrain / weather
- Exact first terrain tags.
- Exact movement cost impact.
- Mud/water depth.
- High-ground benefits.
- Brush/concealment rules.
- Ice/rough-footing rules.
- Hazard system depth.
- Rain/fog/wind mechanical relevance.
- Heat/cold region strain.
- Elemental terrain saturation effects.
- Whether terrain can be changed/destroyed during battle.

## Combat
- Party/companions or solo baseline.
- Exact nodes/lanes/range-band model.
- Cover depth/destructibility.
- Dodge/block/parry formulas.
- Telegraph/reaction timing.
- Retreat/failure rules.
- Monster escape/continuation.
- Exact hit-quality bands/formula.
- Resistance/protection channels.
- Whether any controlled randomness remains in hit resolution and how much.

## Deterministic NPC / creature patterns
- Complexity of first monster profile.
- Number of phases for first monster.
- Berserk pattern position/priority.
- Crystal-energy conservation/flee rules by species.
- Mutation-specific pattern additions.
- Whether seeded variation is used broadly or only in tie groups.
- NPC daily schedule depth.
- Emergency/weather overrides.
- How much bounded short-term memory important monsters may keep.
- Pack/group pattern depth if later used.
- Boss pattern complexity cap/readability rule.

## Anatomy / damage
- Number of targetable parts.
- Layer complexity: hide/armor/bone/tissue vs simpler model.
- Break/sever thresholds.
- Whether sever requires cutting-specific damage.
- Overkill/destruction.
- Internal organs targetable vs harvest-only.
- Crystal/core placement/protection within anatomy.
- Persistent scars/injury for escaped creatures.
- Exact gore intensity.

## Harvesting
- Automatic vs interactive harvesting.
- Harvest time/tool choices.
- Quality tiers vs continuous score for normal materials.
- Crystal extraction method and tool requirements.
- How core Condition changes harvest value.
- Whether berserk overdraw damages crystal Condition or only drains Energy.
- Carry capacity.
- Spoilage/decomposition.
- Rare-material logic tied to anatomy/mutations/crystal.
- Selling/trading.

## Crafting / progression
- Equipment-driven progression vs direct character levels.
- Skill/perk trees.
- Weapon mastery.
- Hunter rank/reputation.
- Bestiary/research progression.
- Recipe complexity.
- Upgrade trees.
- Economy/merchants.
- Exact place of crystals in human crafting/technology.

## Player failure
- Death vs incapacitation.
- Material loss.
- Contract failure.
- Save/checkpoint rules.
- Permadeath currently assumed NO unless requested.

## Technology
- Engine choice.
- Target Android device/version.
- Minimum Android.
- 30/60 FPS target.
- Landscape orientation current direction YES.
- Controller support.
- Offline vs online features.
- Multiplayer currently assumed OUT unless requested.

## Content / scope
- First region theme.
- First monster.
- First crystal element/tier/rank/quality test range.
- First mutation set.
- First berserk/desperation behavior.
- First weapon/equipment set.
- First craftable upgrade.
- First terrain/status set.
- Long-term region/monster count.
- Story/campaign structure.

## Stop rule

Do not create gameplay source until the user explicitly says the design discussion is complete enough to begin implementation.