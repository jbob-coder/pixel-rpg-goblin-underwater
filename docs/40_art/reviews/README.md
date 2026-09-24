# 40_art/reviews — Visual Asset QA Archive

Status: ACTIVE REVIEW RECORDS
Last reconciled: 2026-09-02

## Purpose

Store per-asset review decisions that apply `docs/40_art/asset_pipeline/ASSET_QA_GATES.md` to an actual generated/reference asset.

This folder does not own art direction, entity design, asset lineage, or runtime approval. It records the evidence used to promote, revise, reject, or supersede a specific revision.

## Review result vocabulary

Use exactly one primary decision:
- `SELECT` — may be promoted to the permitted-use level stated in the review;
- `REVISE` — useful direction exists but the current revision is unsafe for the intended next stage;
- `REJECT` — do not continue this visual direction/revision except as provenance;
- `SUPERSEDE` — a newer verified revision replaces this one.

A review must also state the permitted use after review. Examples:
- `DISCUSSION_ONLY`;
- `MODELING_REFERENCE_OK`;
- `DETAIL_REFERENCE_OK`;
- `CONVERSION_TEST_OK`;
- `RUNTIME_2D_TEST_OK`.

Never infer permission from the review decision alone.

## Required review structure

Each review should record:
1. stable asset ID and exact filename;
2. Drive/file identity if persistence is verified;
3. owning design authority;
4. intended role;
5. evidence inspected;
6. pass/fail by applicable QA gate;
7. concrete defects, not vague aesthetic dislike;
8. what is still useful in the current revision;
9. exact revision requirements;
10. decision and permitted use;
11. next bounded action.

## Core law

**Review the earliest defective stage and repair there.**

If the concept views disagree, do not send them to image-to-3D and hope retopology fixes the contradiction.
If the real source lacks detail, do not treat an upscale as recovered technical information.
If a model scale is wrong, correct the model/authoritative measurements rather than compensating with camera scale.

## Current first review

- `HUNTER_BASE_01_H02_v001_QA.md` — Hunter Base 01 turnaround/scale v001.