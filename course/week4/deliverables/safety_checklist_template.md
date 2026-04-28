---
type: template
id: W4-T-SAFETY-CHECKLIST
title: safety_checklist template — pre-execution safety 確認 (Phase 0 では training draft)
week: 4
duration_min: 45
prerequisites: [W4-L8]
worldcpj_ct: [CT-09]
roles: [common, safety]
references: [R-30, R-31, R-32]
deliverables: [safety_checklist]
---

# safety_checklist_template

> **artifact_status**: template
>
> 本 checklist は Phase 0 では **training draft** (`phase0_status: training_draft_only`)。Q1 W1 開始前に責任ある reviewer が `review_status: approved` にすること が **blocker** (`q1_blocker_if_unreviewed: true`)。Phase 0 safety_checklist は **approval artifact ではない**。

## 設計趣旨

- pre-execution safety 確認の構造化表
- `review_status: approved` は `reviewer_name` / `reviewer_role` / `reviewed_at` が埋まっている場合のみ許可 (Lab 8 CHECKLIST + bad example で検証)
- `stop_condition: other` 使用時は `other_stop_condition_detail` 空欄 NG
- `forbidden_operations[].id` は英語 snake_case、`description_ja` は日本語可 (現場 SOP との整合のため)

## YAML body skeleton

```yaml
artifact_status: template

# Identity / linkage
safety_check_id:                  # unique id
q1_package_id:                    # link to Q1 Package
session_description:              # "Q1 W1 pilot trial" 等

# Phase 0 status (default: training_draft_only)
phase0_status: training_draft_only
q1_blocker_if_unreviewed: true

# Owner / review
safety_owner: TBD                 # Q1 W1 開始前に確定
review_due: before_q1_w1_start
review_status: not_reviewed       # not_reviewed | reviewed_with_conditions | approved | blocked
reviewer_name: TBD
reviewer_role: TBD                # responsible_safety_reviewer | safety_owner | TBD
reviewed_at: TBD                  # ISO 8601 | TBD
review_notes: ""

# SOP reference
sop_reference:
  document_name: TBD
  document_path: TBD
  approval_status: not_approved   # not_approved | approved | unknown

# Operator
operator:
  present: false
  name: TBD
  qualification: TBD

# Stop conditions (named 5 + other)
stop_condition:
  - e_stop_not_verified
  - operator_not_present
  - sop_not_reviewed
  - workspace_not_cleared
  - unexpected_motion_or_command
other_stop_condition_detail: ""   # required when stop_condition includes "other"

# Forbidden operations (id English snake_case + description_ja)
forbidden_operations:
  - id: example_no_real_robot_motion_without_review
    description_ja: "責任者 review 前に実機を動作させない"

# Safe no-action conditions
safe_no_action_conditions:
  - id: example_pose_uncertainty_above_threshold
    description_ja: "pose 不確実性が閾値を超える場合は何もしない"

# Review log
review_log:
  - reviewer: TBD
    date: TBD
    decision: not_reviewed
    conditions: []

notes: ""
```

## Phase 0 必須注意文

UR safety references are used as **instructional examples**. Actual Q1 execution must follow the applicable robot model, site SOP, risk assessment, and responsible safety reviewer decision.

Phase 0 safety_checklist is **not an approval artifact**. It is a **training draft** + handoff artifact for Q1 safety review.
