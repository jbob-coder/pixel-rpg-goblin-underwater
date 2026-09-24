# Stage 1 Android Lifecycle Foundation Review — 2026-09-03

Status: REVIEW COMPLETE / SOURCE CHANGE NOT YET MADE

## Bounded piece

`ANDROID_LIFECYCLE_BACKGROUND_RESUME_FOUNDATION_REVIEW`

This pass was review-only. No lifecycle source behavior was changed.

## Inputs reviewed

- current `EVOLVE_ALIGNMENT.md`;
- current project handoff/navigation chain;
- `probes/android_stage1/docs/PROBE_TEST_PROTOCOL.md`, especially Test 7 — lifecycle;
- `probes/android_stage1/project.godot`;
- `probes/android_stage1/scripts/boot.gd`;
- `probes/android_stage1/scripts/probe_world.gd`;
- current view-continuity/runtime evidence;
- official Godot 4.7 Node and InputEventScreenTouch documentation.

Official references:
- https://docs.godotengine.org/en/4.7/classes/class_node.html
- https://docs.godotengine.org/en/4.7/classes/class_inputeventscreentouch.html

## Existing lifecycle acceptance contract

The current phone protocol requires later Galaxy A03s evidence that:
- background/resume works;
- lock/unlock does not corrupt scene state;
- switching away/back does not create duplicate ProbeWorld scenes;
- touch state does not remain stuck after resume;
- no repeatable crash/ANR occurs.

Audio lifecycle remains deferred until audio exists.

## Verified source ownership

### Scene ownership

`project.godot` has one main scene:
`res://scenes/boot.tscn`.

`boot.gd` changes to `res://scenes/probe_world.tscn` only from the explicit Start Probe action using `SceneTree.change_scene_to_file()`.

There is currently:
- no lifecycle-triggered scene creation;
- no autoload lifecycle manager;
- no source path that intentionally instantiates ProbeWorld again on resume.

Therefore there is no evidence-based justification to add scene-deduplication/reconstruction code in this probe now. Duplicate-scene behavior remains a phone verification concern rather than a current source defect.

### Persistent state

Look Speed is persisted immediately when changed through `ConfigFile` at:
`user://stage1_settings.cfg` / `controls/look_speed`.

There is no evidence that lifecycle handling needs a new save architecture. Production save/load is explicitly out of scope.

### Presentation state

Aerial ↔ first-person authoritative transform continuity is already executable/headless verified at `17 / 17 PASS` on the current build lineage.

The lifecycle review found no reason to force aerial mode, close Settings, or rebuild camera state on resume before target-device evidence shows such a defect.

### Transient touch ownership — actual current risk

`probe_world.gd` owns active touch movement through:
- `_joystick_touch_id`;
- `_joystick_vector`;
- `_joystick_reference_forward`;
- `_joystick_reference_right`.

The current `_input()` releases the joystick when a matching touch release reaches the node, and `_reset_joystick()` already clears the touch ID/vector and recenters the knob.

However, if Android pauses or the app loses focus while a finger is active, the source cannot assume a matching release will be delivered before gameplay resumes. If that release is absent, the stored touch ID/vector can remain active, producing the exact lifecycle risk named by the protocol: stuck movement and inability for a new touch to acquire the joystick.

Godot 4.7 documents:
- `NOTIFICATION_APPLICATION_RESUMED = 2014` — Android/iOS resume;
- `NOTIFICATION_APPLICATION_PAUSED = 2015` — Android/iOS pause;
- `NOTIFICATION_APPLICATION_FOCUS_IN = 2016` — desktop/mobile focus-in;
- `NOTIFICATION_APPLICATION_FOCUS_OUT = 2017` — desktop/mobile focus-out.

Godot 4.7 `InputEventScreenTouch` also exposes `canceled`. The current release branch already handles a delivered canceled/released touch when `pressed == false`, but OS lifecycle transitions still require a defensive transient-state boundary because an event may not arrive in the source path being protected.

## Root-cause decision

Do **not** add broad lifecycle architecture.

The smallest justified source behavior is:
**clear only transient joystick/touch movement state when the application pauses, resumes, loses focus, or regains focus.**

Use the existing `_reset_joystick()` owner rather than creating a second reset implementation.

Why all four lifecycle/focus boundaries:
- pause/focus-out stop stale input as soon as control leaves the app;
- resume/focus-in are idempotent defensive boundaries if the preceding OS signal/event ordering differs;
- repeated reset is safe because `_reset_joystick()` is already idempotent for touch ID/vector/knob state.

Do not change:
- Hunter transform;
- `_first_person` state;
- camera tuning;
- Settings open/closed state;
- saved Look Speed;
- world boundary;
- Monster collision;
- production save architecture.

## Highest available verification design

The next source pass can be verified above static inspection using an executable Godot headless test.

Planned runtime regression:
1. instantiate the real ProbeWorld;
2. seed a nonzero joystick vector and active touch ID;
3. dispatch each relevant Node application notification to the real ProbeWorld node;
4. verify touch ID becomes `-1` and joystick vector becomes `Vector2.ZERO`;
5. verify Hunter transform, first-person state, Settings state and Look Speed are not mutated by the lifecycle reset;
6. verify repeated notifications remain idempotent;
7. verify no duplicate ProbeWorld node is created in the SceneTree;
8. run the existing static/collision/boundary/view-continuity regressions;
9. run Godot parse/smoke, Android export and APK integrity.

This headless notification injection verifies the source response contract, not Android OS delivery. Actual background/resume, lock/unlock, crash/ANR and gesture behavior remain Galaxy A03s-only evidence.

## Documentation debt noted

`PROBE_TEST_PROTOCOL.md` contains stale historical counts/text (`123 / 123`, old directional-button wording, and pre-continuity pending language). The lifecycle implementation pass should reconcile that owning protocol with the current `154/154`, `8/8`, `12/12`, `17/17` evidence while preserving phone-only gates as unverified.

## Exact next piece selected

`ANDROID_LIFECYCLE_TRANSIENT_INPUT_RESET_IMPLEMENTATION_AND_HEADLESS_REGRESSION`

Scope is limited to lifecycle/focus-triggered reset of transient joystick state plus executable regression/build verification and protocol/handoff updates.

No performance tuning, production lifecycle manager, save architecture, combat or domain code belongs in that piece.
