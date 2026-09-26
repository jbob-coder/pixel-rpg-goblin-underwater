# Player Avatar Foot Rig 001 — Research and Animation Contract

Date: 2026-09-26  
Branch: `feature/avatar-foot-rig-001`  
Production authority at branch point: `main@d43bdacb63cead6ae4f6c28b7be3d6e92eeab201`

## Purpose

Create an isolated, game-ready foot articulation contract before the full-body avatar mesh is authored.

This is not a medical simulation. It is a locomotion rig abstraction intended to preserve the major visual functions of the human foot while remaining practical for a stylized pixel-3D Android character.

## Research findings applied

1. The ankle complex is not a single rigid hinge. Talocrural motion primarily contributes dorsiflexion/plantarflexion, while subtalar motion contributes inversion/eversion and combined pronation/supination.
2. Walking stance is commonly described with three sequential rockers:
   - heel rocker,
   - ankle rocker,
   - forefoot rocker.
3. The forefoot rocker uses the metatarsophalangeal region as a pivot during push-off.
4. First-MTP / hallux dorsiflexion increases in late stance; one multi-segment study reported hallux dorsiflexion peaking around 40 degrees just before toe-off.
5. During swing, ankle dorsiflexion assists toe clearance.
6. Running retains stance and swing/contact-flight organization, but exact foot-strike mechanics vary by runner and strike pattern; the authored run profile is therefore intentionally a game-animation profile rather than a claim of one universal human running gait.
7. A crouched gait uses the same foot structures but is authored here with shorter stride, lower swing clearance and sustained ankle dorsiflexion to support the low body posture.

## Sources

- Godot 4.7 Skeleton3D class reference:
  https://docs.godotengine.org/en/4.7/classes/class_skeleton3d.html
- Brockett CL, Chapman GJ. Biomechanics of the ankle:
  https://pmc.ncbi.nlm.nih.gov/articles/PMC4994968/
- Leardini A, O'Connor JJ, Giannini S. Biomechanics of the natural, arthritic, and replaced human ankle joint:
  https://pmc.ncbi.nlm.nih.gov/articles/PMC3918177/
- Nester CJ et al. Movement of the human foot in 100 pain free individuals aged 18–45:
  https://pmc.ncbi.nlm.nih.gov/articles/PMC4260241/
- Three-Dimensional Kinematics of the Human Metatarsophalangeal Joint during Level Walking:
  https://pmc.ncbi.nlm.nih.gov/articles/PMC4266096/
- Recognition of Foot-Ankle Movement Patterns in Long-Distance Runners:
  https://pmc.ncbi.nlm.nih.gov/articles/PMC7300177/

## Rig abstraction

Per foot, the deform/control chain is:

`ankle -> subtalar -> midfoot -> ball/MTP -> toe/IP`

A separate `heel_contact` helper is used conceptually for heel-rocker contact. It is not represented as an anatomical joint.

### Why five controls

- **ankle / talocrural** — primary sagittal dorsiflexion and plantarflexion.
- **subtalar** — small inversion/eversion channel so the foot is not rigid in the frontal plane.
- **midfoot proxy** — controlled compliance/arch articulation instead of treating the tarsal region as a solid block.
- **ball / MTP proxy** — forefoot rocker and push-off pivot.
- **toe / IP proxy** — secondary toe shape change after the ball joint.

This is deliberately less complex than real foot anatomy. The human foot contains many articulations; reproducing every joint would add rigging and skinning cost without meaningful benefit to this game's camera distance and Android performance target.

## Animation profiles

### Walk

Authored stance fraction: 0.60.

Key visual sequence:
1. slight plantarflexed heel contact,
2. controlled foot lowering,
3. ankle dorsiflexion as the body advances,
4. heel rise,
5. ball/MTP dorsiflexion during forefoot rocker,
6. plantarflexion into toe-off,
7. swing dorsiflexion and foot clearance.

### Run

Authored support fraction: 0.40.

The profile emphasizes:
- faster loading,
- larger propulsion,
- stronger forefoot articulation,
- explicit flight,
- larger swing clearance.

Exact rearfoot/forefoot strike behavior remains an art-direction choice because running mechanics differ by strike pattern.

### Crouch walk

Authored support fraction: 0.70.

The profile emphasizes:
- short stride,
- low swing clearance,
- sustained dorsiflexion in support,
- restrained toe-off,
- reduced vertical motion.

## Runtime boundary

Implemented:
- data contract,
- joint naming,
- auxiliary Skeleton3D bone creation,
- rest offsets,
- walk/run/crouch gait sampling,
- per-joint production limits,
- sample application to Skeleton3D,
- isolated regression test.

Not implemented:
- final full-body avatar mesh,
- skin weights,
- imported avatar ankle-bone mapping,
- AnimationTree integration,
- IK / ground adaptation,
- final first-person or third-person avatar presentation,
- physical-device verification.

Adding bones to a Skeleton3D does **not** automatically create mesh deformation. The final avatar asset must be authored/weight-painted to the same joint chain or converted during the model pipeline.

## Next art step

Use this contract to create the full foot/leg model sheet and an articulated motion-reference video. The visual test must visibly demonstrate independent ankle, subtalar/midfoot compliance, ball pivot and toe articulation instead of rotating a single rigid foot sprite.
