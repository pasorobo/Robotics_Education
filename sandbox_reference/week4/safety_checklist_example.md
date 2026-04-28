---
type: reference
id: W4-REF-SAFETY-CHECKLIST
title: safety_checklist example — Phase 0 training_draft_only (instructor fill demo)
week: 4
duration_min: 30
prerequisites: [W4-L8, W4-Lab8]
worldcpj_ct: [CT-09]
roles: [common, safety]
references: [R-30, R-31, R-32]
deliverables: [safety_checklist]
---

# safety_checklist example (Phase 0 training_draft_only)

> **artifact_status**: sandbox_example
>
> Phase 0 では `phase0_status: training_draft_only` 固定。`q1_blocker_if_unreviewed: true` で Q1 W1 開始前 review が blocker であることを明示。
>
> stop_condition の named 5 項目を enabled、`other` は未使用 (必要時のみ `other_stop_condition_detail` 付きで使用)。
>
> `forbidden_operations[].id` 英語 snake_case、`description_ja` 日本語可。

## YAML body (filled)

```yaml
artifact_status: sandbox_example

safety_check_id: safety_check_q1_w1_pilot_001
q1_package_id: q1_reduced_lv1_pkg_001
session_description: "Q1 W1 pilot trial (1 object × 1 attempt)"

phase0_status: training_draft_only
q1_blocker_if_unreviewed: true

safety_owner: TBD (Q1 W1 開始前に WorldCPJ Safety Role Owner と決定)
review_due: before_q1_w1_start
review_status: not_reviewed
reviewer_name: TBD
reviewer_role: TBD
reviewed_at: TBD
review_notes: ""

sop_reference:
  document_name: TBD (現場 SOP draft)
  document_path: TBD
  approval_status: not_approved

operator:
  present: false
  name: TBD
  qualification: TBD

stop_condition:
  - e_stop_not_verified
  - operator_not_present
  - sop_not_reviewed
  - workspace_not_cleared
  - unexpected_motion_or_command
other_stop_condition_detail: ""

forbidden_operations:
  - id: no_real_robot_motion_without_review
    description_ja: "責任者 review 前に実機を動作させない"
  - id: no_dual_arm_coordination
    description_ja: "Q1 縮小 Lv1 では双腕協調動作を扱わない"
  - id: no_human_collaboration_mode
    description_ja: "Q1 縮小 Lv1 では人協調モードを有効にしない"

safe_no_action_conditions:
  - id: pose_uncertainty_above_threshold
    description_ja: "pose 不確実性が閾値を超える場合は何もしない"
  - id: sensor_data_stale
    description_ja: "sensor data が 1 秒以上古い場合は何もしない"

review_log:
  - reviewer: TBD
    date: TBD
    decision: not_reviewed
    conditions: []

notes: |
  Phase 0 training_draft_only。Q1 W1 開始前に responsible safety
  reviewer による review が必要 (q1_blocker_if_unreviewed: true)。
```
