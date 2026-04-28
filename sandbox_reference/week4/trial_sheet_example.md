---
type: reference
id: W4-REF-TRIAL-SHEET
title: trial_sheet example — 15 planned rows skeleton (instructor fill demo)
week: 4
duration_min: 30
prerequisites: [W4-L7, W4-Lab8]
worldcpj_ct: [CT-05]
roles: [common, logging]
references: [R-28]
deliverables: [trial_sheet]
---

# trial_sheet example (15 planned rows skeleton)

> **artifact_status**: sandbox_example
>
> Instructor case = Q1 縮小 Lv1 CC Gate 0-a の 5 物体 × 3 trials を planned skeleton として作成した想定。**executed への遷移は Q1 W1 以降**。
>
> W1 turtlesim training episode は **混入させていない**。本 trial_sheet は Q1 trial 用、turtlesim training は episode_record_example.md で別途扱う。

## YAML body (15 planned rows)

```yaml
artifact_status: sandbox_example

trial_sheet_id: trial_sheet_q1_cc_gate_0a_001
q1_package_id: q1_reduced_lv1_pkg_001
safety_check_id: safety_check_q1_w1_pilot_001
batch_description: "Q1 Reduced Lv1 — CC Gate 0-a (5 objects × 3 trials = 15 planned rows)"
total_planned_rows: 15

rows:
  - {trial_id: trial_001, object_id: object_1, attempt_index: 1, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_002, object_id: object_1, attempt_index: 2, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_003, object_id: object_1, attempt_index: 3, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_004, object_id: object_2, attempt_index: 1, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_005, object_id: object_2, attempt_index: 2, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_006, object_id: object_2, attempt_index: 3, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_007, object_id: object_3, attempt_index: 1, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_008, object_id: object_3, attempt_index: 2, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_009, object_id: object_3, attempt_index: 3, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_010, object_id: object_4, attempt_index: 1, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_011, object_id: object_4, attempt_index: 2, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_012, object_id: object_4, attempt_index: 3, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_013, object_id: object_5, attempt_index: 1, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_014, object_id: object_5, attempt_index: 2, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_015, object_id: object_5, attempt_index: 3, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
```

## Reference: executed row example (NOT counted as Q1 trial)

For shape reference only. The W1 turtlesim training episode is recorded in `episode_record_example.md` separately and is NOT a Q1 CC Gate 0-a row.

```yaml
# Shape reference only — do not include in the 15-row count above.
- trial_id: training_trial_w1_lab1_001
  object_id: turtlesim_training_object
  attempt_index: 1
  trial_status: executed
  result: success
  failure_reason: none
  episode_id: episode_w1_lab1_001
  kpi_grasp_success: null
  kpi_time_to_grasp_sec: null
  skip_or_block_reason: ""
  notes: "Phase 0 training, NOT a Q1 CC Gate 0-a trial."
```
