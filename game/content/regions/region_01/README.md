# Region 01 Runtime Content Projection

Status: DERIVED RUNTIME DATA / DOCS AUTHORITY OWNS VALUES

`hunt01_graybox_build_manifest.json` is byte-identical to the current authoritative file:

`docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.json`

It exists under the production Godot project because Godot `res://` cannot consume repository files above the project root at runtime/export.

Rules:
- never hand-edit this projection independently;
- update the owning docs manifest first;
- regenerate/copy the projection;
- run `tests/quality/hunt01/hunt01_production_projection_preflight.py`;
- CI must fail if the two JSON documents differ semantically or by required identity.

The projection is content/build data, not mutable runtime state and not persistence authority.
