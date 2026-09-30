# Player Avatar Foot Biomechanics v1

Date: 2026-09-26

## Purpose

This slice establishes the first production-facing joint contract for the future full-body Pixel RPG avatar. It is deliberately presentation-only and does not replace the current HunterVisual or first-person viewmodel.

## Functional rig

The game rig uses seven controlled pivots:

1. ankle — talocrural pitch for dorsiflexion / plantarflexion
2. subtalar — inversion / eversion
3. midfoot — limited arch compliance
4. MTP — metatarsophalangeal forefoot rocker
5. toe — distal toe curl / extension
6. big toe — separate hallux response
7. lesser toes — grouped 2–5 response

This is not a literal one-bone-per-anatomical-bone reconstruction. The human foot has 26 bones and many articulations; the runtime rig groups them into the minimum controls needed to preserve recognizable locomotion mechanics while staying inexpensive enough for Android.

## Biomechanics applied

The animation tracks use the three-rocker walking model:

- heel rocker: initial contact to foot-flat
- ankle rocker: tibia advances over a planted foot
- forefoot rocker: heel rises and the foot rotates around the metatarsophalangeal region into push-off

Walk uses an approximately 60% stance / 40% swing timing target. Midstance reaches approximately 8–10 degrees of ankle dorsiflexion. Toe-off reaches approximately 14 degrees of ankle plantarflexion. The MTP control reaches 40–50 degrees of dorsiflexion/extension during propulsion.

Run removes most heel-rocker emphasis, increases plantarflexion at push-off, increases MTP extension, and increases swing clearance.

Game crouch-walk is not intended as a medical reproduction of pathological crouch gait. It borrows the mechanically relevant observations: a lower posture tends to require more ankle dorsiflexion during loaded stance, shorter steps, longer controlled support, and reduced swing clearance. The authored animation therefore uses increased loaded dorsiflexion, shorter stride and a preserved forefoot rocker.

## Sources reviewed

- National Library of Medicine / StatPearls, *Anatomy, Bony Pelvis and Lower Limb: Arches of the Foot*
  https://www.ncbi.nlm.nih.gov/books/NBK587361/
- Brockett & Chapman, *Biomechanics of the ankle*
  https://pmc.ncbi.nlm.nih.gov/articles/PMC4994968/
- Wikstrom et al., *The Ankle-Joint Complex: A Kinesiologic Approach to Lateral Ankle Sprains*
  https://pmc.ncbi.nlm.nih.gov/articles/PMC6602390/
- Jastifer, *Contemporary Review: The Foot and Ankle in Long-Distance Running*
  https://pmc.ncbi.nlm.nih.gov/articles/PMC9520164/
- Holowka et al., *Torque–angle relationships of human toe flexor muscles highlight their capacity for propulsion in gait*
  https://pmc.ncbi.nlm.nih.gov/articles/PMC11744321/
- Bruening et al., *Kinetic coupling in distal foot joints during walking*
  https://pmc.ncbi.nlm.nih.gov/articles/PMC10367363/
- Böhm et al., *Effects of simulated crouch gait on foot kinematics and kinetics in healthy children*
  https://pubmed.ncbi.nlm.nih.gov/23473807/

## Runtime ownership

This rig owns only visual joint transforms and sampling of presentation poses.

It does not own:
- player physics
- collision
- locomotion speed
- input
- combat
- stamina
- damage
- persistence

Those remain with their existing owners.

## Next integration slice

After visual approval of the generated motion study:

1. build the full leg chain (hip, knee, ankle, foot)
2. create final pixel-style foot/boot mesh around this pivot topology
3. bind left and right feet to the full avatar skeleton
4. add synchronized walk/run/crouch cycles
5. validate first-person shadow / body visibility strategy
6. test on Android target hardware
