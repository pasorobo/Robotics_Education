---
type: template
id: W4-T-TRIAL-SHEET
title: trial_sheet template — N trials 集計表 (5 objects × 3 trials)
week: 4
duration_min: 30
prerequisites: [W4-L7]
worldcpj_ct: [CT-05]
roles: [common, logging]
references: [R-28]
deliverables: [trial_sheet]
---

# trial_sheet_template

> **artifact_status**: template
>
> Phase 0 受講者は本 template を Sandbox `wk4/lab8/` にコピーし、**15 planned rows** を `trial_status: planned` で skeleton として作成する (Lab 8)。executed rows への更新は Q1 W1 以降の作業。

## 設計趣旨

- 1 row = 1 trial。`total_planned_rows: 15` (5 objects × 3 trials = CC Gate 0-a baseline)
- planned rows は `trial_status: planned` / `result: unknown` / `failure_reason: unknown` / `episode_id: TBD`
- executed への遷移には `episode_id` / `result` / `failure_reason` の concrete fill が必要
- `trial_status: skipped` / `blocked` 使用時は `skip_or_block_reason` 空欄 NG
- W1 turtlesim training episode は混入禁止 (Lab 7 で別途 episode_record で扱う)

## YAML body skeleton

```yaml
artifact_status: template

trial_sheet_id:        # unique id
q1_package_id:         # link to Q1 Package
safety_check_id:       # link to safety_checklist
batch_description:     # "CC Gate 0-a 5 objects × 3 trials" 等
total_planned_rows: 15

rows:
  # Row example 1 (planned)
  - trial_id: trial_001
    object_id: object_1
    attempt_index: 1
    trial_status: planned         # planned | executed | skipped | blocked
    result: unknown               # success | failure | blocked | skipped | unknown
    failure_reason: unknown       # none | <taxonomy> | unknown
    episode_id: TBD               # link to episode_record, or "TBD" if planned
    kpi_grasp_success: null       # bool, or null if planned
    kpi_time_to_grasp_sec: null   # float, or null if planned
    skip_or_block_reason: ""      # required when trial_status=skipped|blocked
    notes: ""

  # Row example 2 (executed — for reference shape only)
  - trial_id: trial_002
    object_id: object_1
    attempt_index: 2
    trial_status: executed
    result: success
    failure_reason: none
    episode_id: episode_q1_obj1_attempt2_002
    kpi_grasp_success: true
    kpi_time_to_grasp_sec: 4.2
    skip_or_block_reason: ""
    notes: |
      grasp success on 1st try
```

> **Note**: template 本体は構造例 1-2 row のみ示す。**fully expanded 15 rows skeleton は `sandbox_reference/week4/trial_sheet_example.md` に置く** (T16 で作成)。

## Phase 0 用法

15 rows を planned skeleton として作成するのが Lab 8 acceptance。空欄 NG (`unknown` / `TBD` で埋める)。
