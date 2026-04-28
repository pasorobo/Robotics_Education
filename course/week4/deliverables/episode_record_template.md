---
type: template
id: W4-T-EPISODE-RECORD
title: episode_record template — 1 task attempt の構造化記録
week: 4
duration_min: 30
prerequisites: [W4-L7]
worldcpj_ct: [CT-04, CT-05]
roles: [common, logging]
references: [R-28, R-29]
deliverables: [episode_record]
---

# episode_record_template

> **artifact_status**: template
>
> Phase 0 受講者は本 template を Sandbox `wk4/lab7/` にコピーし、SP1 W1 Lab 1 turtlesim bag を題材に全 field を記入する (Lab 7)。

## 設計趣旨

- 1 task attempt の構造化記録。N trials の集計は `trial_sheet` (responsibility separation)
- `result: success` の場合 `failure_reason: none` を必ず入れる (空欄 NG)
- `evidence_path` は `sandbox_reference/` 内 lightweight 証跡を指す。raw bag は commit しない
- `artifact_status: sandbox_example` の場合、`q1_package_id` / `trial_sheet_id` / `trial_id` / `object_id` は `not_applicable` または `training_*` 許容
- `artifact_status: q1_draft` 以降の場合、`q1_package_id` / `trial_id` / `object_id` は concrete value 必須

## YAML body skeleton

```yaml
artifact_status: template

# Linkage keys
episode_id:           # unique id, e.g., episode_q1_obj1_attempt1_001
q1_package_id:        # unique id | not_applicable
trial_sheet_id:       # unique id | not_applicable
trial_id:             # unique id | training_* | not_applicable
object_id:            # object_1..5 | turtlesim_training_object | not_applicable
attempt_index:        # 1-3 | null

# Environment / version
environment_mode:     # mock | sim | real
adapter_version:      # mock_adapter_v0 | not_applicable | unknown
bridge_schema_version: # provisional_v1 | not_applicable | unknown

# Logs
log_path:             # external bag path | not_applicable
evidence_path:        # sandbox_reference path | not_applicable
commit_sha:           # sandbox sha | TBD

# Time
start_time:           # ISO 8601 | TBD
end_time:             # ISO 8601 | TBD
duration_sec:         # float | TBD
recorded_topics:      # list | TBD

# Outcome
result:               # success | failure | blocked | skipped | unknown
failure_reason:       # none | perception_failure | planning_failure | control_or_execution_failure | sim_bridge_failure | environment_or_setup_failure | safety_blocked | operator_error | logging_or_data_failure | unknown
review_status:        # not_reviewed | reviewed_with_conditions | approved | blocked

notes: |
  自由記述
```

## Field 説明

各 field の値域は §3.3 / §3.4 (linkage keys / taxonomies) に従う。`result` と `failure_reason` は分離 — 例: `result: success` は必ず `failure_reason: none` を伴う。Phase 0 では `failure_reason: unknown` 容認 (空欄 NG)。
