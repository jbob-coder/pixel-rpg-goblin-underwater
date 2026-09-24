# Hunt-01 Tracking Runtime

Purpose: runtime interpretation of physical evidence for the first Region 01 hunt.

Authority split:
- world/evidence coordinates remain under `docs/10_world/regions/REGION_01/` and the Hunt-01 manifest;
- this package owns runtime clue collection history, freshness/confidence/activity interpretation, and player-facing rough route inference;
- presentation may expose rough direction and route confidence but must not reveal exact Monster coordinates from tracking data;
- audio is optional for this first proof and cannot be required to complete the clue chain.

Current files:
- `hunt01_tracking_runtime.gd` — deterministic runtime state/inference;
- `../../../content/regions/region_01/hunt01_tracking_evidence.json` — first-proof evidence profiles.

Current first-proof semantics:
- fresh heavy prints and bank damage establish the River Ford lead;
- the wallow confirms recent activity but does not itself choose an exit;
- the old Rootwood scrape remains legal territory history with `OLD / WEAK` confidence;
- fresh water-exit prints toward `R01_S03` outweigh that old S02 clue;
- feeding remains and flattened grass progress the trail to `OBSERVATION_READY`;
- tactical-node debug discs remain hidden during normal exploration.

Verification owner:
`game/tests/region01_hunt01_graybox_runtime_test.gd`.

Phone/user acceptance is deferred and does not block additional independent gameplay layers; automated/static/headless/build evidence must still be recorded precisely.
