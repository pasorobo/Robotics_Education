---
type: template
id: W4-T-Q1-PACKAGE
title: Q1 Reduced Lv1 Execution Package template — Phase 0 → Q1 handoff artifact 自体
week: 4
duration_min: 90
prerequisites: [W4-L7, W4-L8, W4-T-EPISODE-RECORD, W4-T-TRIAL-SHEET, W4-T-SAFETY-CHECKLIST]
worldcpj_ct: [CT-04, CT-05, CT-06, CT-09]
roles: [common, logging, safety, sandbox]
references: [R-28, R-29, R-30, R-31, R-32]
deliverables: [q1_reduced_lv1_execution_package]
---

# q1_reduced_lv1_execution_package_template

> **artifact_status**: template
>
> 本 template は **Phase 0 → Q1 handoff artifact 自体**。Formal handover ceremony / 別文書は out-of-scope。Q1 全体 scope / gate / owner / `re_judge_gates` の meta package として、W1-W3 templates を `source_artifact_path` で参照型 traceability する (data の copy ではない)。

## 設計趣旨

- 8 行 meta + `q1_w1_preflight` + `re_judge_gates` 4 件 + handoff note 構成
- 各 row には `source_artifact_path` (W1-W3 artifact への参照) + `source_template` (元 template の id) + `review_status` (Phase 0 default `not_reviewed`)
- `re_judge_gates` は 4 件固定 (`q1_w1_pre_start` / `q1_w1_exit` / `q1_mid_point` / `q1_closeout`)
- Q1 W1 preflight 8 項目 (5 物体 × 3 trials 直行禁止、1 pilot trial 経由必須)
- Q1 W2+ detail は deferred 明示 (silent omission 禁止)、`q1_mid_point` で判断する

## YAML body skeleton

```yaml
artifact_status: template
phase0_handoff: true

# Identity / meta
q1_package_id:                    # unique id
bridge_schema_version: provisional_v1   # provisional_v1 | not_applicable | unknown
q1_execution_mode: TBD            # mock | sim | real | operator_in_the_loop | TBD
owner_role: "Q1 Reduced Lv1 planning owner"
next_decision_owner: "WorldCPJ Safety Role Owner"

# Phase 0 review pointer
phase0_review_summary_path: sandbox/wk4/lab8b/sandbox_review_summary.md
phase0_review_summary_status: not_reviewed   # self_reviewed | reviewed_with_conditions | not_reviewed
phase0_to_q1_handoff_note: |
  Formal handover ceremony/document is out of scope for Phase 0.
  This Q1 Reduced Lv1 Execution Package itself acts as the
  Phase 0 → Q1 handoff artifact.

# 8 meta rows (all reference W1-W3/W4 artifacts via source_artifact_path)
rows:
  - row: 1_scope_lv1_boundary
    content: |
      対象: CC Gate 0-a (5 objects × 3 trials) + MS Lv1 (fixed observation baseline)
      非対象: 人協調 / 双腕 / マルチロボ / ベースライン再現多数
    source_artifact_path: docs/Robotics_simulation_phase0_education_plan.md
    source_template: education_plan_section_1
    review_status: not_reviewed

  - row: 2_target_task_gate
    content: |
      CC Gate 0-a (5 物体 grasp) + MS Lv1 (fixed observation baseline) の詳細
    source_artifact_path: docs/Robotics_simulation_phase0_education_plan.md
    source_template: education_plan_section_2
    review_status: not_reviewed

  - row: 3_environment_stack
    content: |
      Ubuntu 22.04 / ROS 2 Humble / Gazebo Fortress / MoveIt 2 / ros2_control の version 固定
    source_artifact_path: course/00_setup/, sandbox_reference/week1/sandbox_setup_log_example.md
    source_template: SP1-T-SANDBOX-SETUP-LOG
    review_status: not_reviewed

  - row: 4_robot_adapter_readiness
    content: |
      mock / sim / real boundary、SP2 mock_adapter_v0 baseline
    source_artifact_path: sandbox_reference/week2/robot_readiness_mini_report_example.md
    source_template: W2-T-ROBOT-READINESS
    review_status: not_reviewed

  - row: 5_simulation_bridge_status
    content: |
      provisional schema 8 fields (input 4 + output 4)、simulator 選択 (Gazebo / MuJoCo / ManiSkill / Isaac)
    source_artifact_path: sandbox_reference/week3/simulation_bridge_draft_example.md
    source_template: W3-T-SIM-BRIDGE-DRAFT
    review_status: not_reviewed

  - row: 6_logging_episode_plan
    content: |
      1 episode evidence 仕様 (bag_info.txt, metadata.yaml, terminal log; raw bag commit 禁止)
    source_artifact_path: sandbox/wk4/lab8/episode_record.md
    source_template: W4-T-EPISODE-RECORD
    review_status: not_reviewed

  - row: 7_trial_kpi_plan
    content: |
      5 objects × 3 trials skeleton (15 planned rows)、KPI: kpi_grasp_success, kpi_time_to_grasp_sec
    trial_sheet_id: TBD
    source_artifact_path: sandbox/wk4/lab8/trial_sheet.md
    source_template: W4-T-TRIAL-SHEET
    review_status: not_reviewed

  - row: 8_safety_review_go_no_go
    content: |
      Q1 W1 開始前 blocker conditions:
      - safety_checklist review_status MUST be approved
      - SOP MUST be approved by responsible safety reviewer
      - 1 pilot trial review COMPLETED before 5×3 trials
    safety_check_id: TBD
    source_artifact_path: sandbox/wk4/lab8/safety_checklist.md
    source_template: W4-T-SAFETY-CHECKLIST
    review_status: not_reviewed

# Q1 W1 preflight (8 items)
q1_w1_preflight:
  - "tools/verify_env.sh --week 4 PASS (validates SP4 logging baseline; sim/real execution may need additional W2/W3 or Q1-specific checks)"
  - "ros2 doctor or documented equivalent environment smoke check"
  - "mock adapter no-op execution confirmed"
  - "required topics listed"
  - "rosbag2 minimal record confirmed for required topics"
  - "safety_checklist reviewed by responsible owner (review_status: approved)"
  - "1 object × 1 pilot trial executed"
  - "pilot review COMPLETED before proceeding to 5 objects × 3 trials"

# Re-judge gates (4 fixed)
re_judge_gates:
  - gate_id: q1_w1_pre_start
    purpose: "Phase 0 成果物の Q1 移行可否確認"
    decisions: ["safety review approved", "env smoke test passed", "no-action dry run completed"]
  - gate_id: q1_w1_exit
    purpose: "1 pilot trial 後の再判断"
    decisions: ["proceed from 1 pilot trial to 15 planned trials", "continue pilot", "replan"]
  - gate_id: q1_mid_point
    purpose: "W2 以降 detail の確定 (Phase 0 で prescribe しない)"
    decisions: ["update failure taxonomy", "update KPI", "update operator workflow"]
  - gate_id: q1_closeout
    purpose: "Lv1 継続可否"
    decisions: ["proceed to MS Lv1", "revise Phase 0 artifacts", "escalate"]

# Free-text section
free_text_section:
  open_questions: ""
  blockers_for_q1: ""
```
