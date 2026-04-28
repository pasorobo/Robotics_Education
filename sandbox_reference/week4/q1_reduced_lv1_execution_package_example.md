---
type: reference
id: W4-REF-Q1-PACKAGE
title: Q1 Reduced Lv1 Execution Package example — instructor fill demo (Phase 0 → Q1 handoff artifact)
week: 4
duration_min: 60
prerequisites: [W4-L7, W4-L8, W4-Lab8]
worldcpj_ct: [CT-04, CT-05, CT-06, CT-09]
roles: [common, logging, safety, sandbox]
references: [R-28, R-30, R-31, R-32]
deliverables: [q1_reduced_lv1_execution_package]
---

# Q1 Reduced Lv1 Execution Package example (instructor fill demo)

> **artifact_status**: sandbox_example
>
> Instructor case = **Q1 Reduced Lv1 planning owner for Course / Robot Adapter / Sim Bridge integration**。8 行 fill、各行 W1-W3 artifacts 参照、`q1_w1_preflight` 8 項目、`re_judge_gates` 4 件、`bridge_schema_version: provisional_v1`、`q1_execution_mode: TBD` (Q1 W1 pre_start gate で確定)。

## YAML body (filled)

```yaml
artifact_status: sandbox_example
phase0_handoff: true

q1_package_id: q1_reduced_lv1_pkg_001
bridge_schema_version: provisional_v1
q1_execution_mode: TBD
owner_role: "Q1 Reduced Lv1 planning owner for Course / Robot Adapter / Sim Bridge integration"
next_decision_owner: "WorldCPJ Safety Role Owner"

phase0_review_summary_path: sandbox/wk4/lab8b/sandbox_review_summary.md
phase0_review_summary_status: self_reviewed
phase0_to_q1_handoff_note: |
  Formal handover ceremony/document is out of scope for Phase 0.
  This Q1 Reduced Lv1 Execution Package itself acts as the
  Phase 0 → Q1 handoff artifact.

rows:
  - row: 1_scope_lv1_boundary
    content: |
      対象: CC Gate 0-a (5 objects × 3 trials = 15 trials) + MS Lv1 (fixed observation baseline)
      非対象: 人協調 / 双腕 / マルチロボ / ベースライン再現多数
    source_artifact_path: docs/Robotics_simulation_phase0_education_plan.md
    source_template: education_plan_section_1
    review_status: not_reviewed

  - row: 2_target_task_gate
    content: |
      CC Gate 0-a: 5 物体 grasp success rate baseline 確立
      MS Lv1: fixed observation baseline (camera pose 固定で観察 baseline 確立)
    source_artifact_path: docs/Robotics_simulation_phase0_education_plan.md
    source_template: education_plan_section_2
    review_status: not_reviewed

  - row: 3_environment_stack
    content: |
      Ubuntu 22.04 LTS / ROS 2 Humble / Gazebo Fortress / MoveIt 2 / ros-control / colcon
      version 固定 (SP1 setup notes 参照)
    source_artifact_path: course/00_setup/, sandbox_reference/week1/sandbox_setup_log_example.md
    source_template: SP1-T-SANDBOX-SETUP-LOG
    review_status: not_reviewed

  - row: 4_robot_adapter_readiness
    content: |
      mock_adapter_v0 baseline (W2 で実装)。sim/real は Q1 W1 pre_start gate で判断
    source_artifact_path: sandbox_reference/week2/robot_readiness_mini_report_example.md
    source_template: W2-T-ROBOT-READINESS
    review_status: not_reviewed

  - row: 5_simulation_bridge_status
    content: |
      provisional schema v1 (input 4: scene_packet/robot_state/candidate_set/action_intent
      + output 4: observation/execution_result/failure_reason/metrics)。
      simulator は Gazebo Fortress を default、MuJoCo / ManiSkill / Isaac は SP5 / 個別宿題で扱う
    source_artifact_path: sandbox_reference/week3/simulation_bridge_draft_example.md
    source_template: W3-T-SIM-BRIDGE-DRAFT
    review_status: not_reviewed

  - row: 6_logging_episode_plan
    content: |
      1 episode evidence: bag_info.txt + rosbag_metadata.yaml + terminal log。
      raw bag commit 禁止。MCAP は Stretch (ros-humble-rosbag2-storage-mcap install 任意)
    source_artifact_path: sandbox/wk4/lab7/episode_record.md
    source_template: W4-T-EPISODE-RECORD
    review_status: not_reviewed

  - row: 7_trial_kpi_plan
    content: |
      5 objects × 3 trials = 15 planned rows skeleton (Lab 8 で作成)
      KPI: kpi_grasp_success (bool), kpi_time_to_grasp_sec (float)
    trial_sheet_id: trial_sheet_q1_cc_gate_0a_001
    source_artifact_path: sandbox/wk4/lab8/trial_sheet.md
    source_template: W4-T-TRIAL-SHEET
    review_status: not_reviewed

  - row: 8_safety_review_go_no_go
    content: |
      Q1 W1 開始前 blocker conditions:
      - safety_checklist review_status MUST be approved
      - SOP MUST be approved by responsible safety reviewer
      - 1 pilot trial review COMPLETED before 5×3 trials
    safety_check_id: safety_check_q1_w1_pilot_001
    source_artifact_path: sandbox/wk4/lab8/safety_checklist.md
    source_template: W4-T-SAFETY-CHECKLIST
    review_status: not_reviewed

q1_w1_preflight:
  - "tools/verify_env.sh --week 4 PASS (validates SP4 logging baseline)"
  - "ros2 doctor or documented equivalent environment smoke check"
  - "mock adapter no-op execution confirmed"
  - "required topics listed (/joint_states, /cmd_vel, /tf, /tf_static, /clock)"
  - "rosbag2 minimal record confirmed for required topics"
  - "safety_checklist reviewed by responsible owner (review_status: approved)"
  - "1 object × 1 pilot trial executed"
  - "pilot review COMPLETED before proceeding to 5 objects × 3 trials"

re_judge_gates:
  - gate_id: q1_w1_pre_start
    purpose: "Phase 0 成果物の Q1 移行可否確認"
    decisions: ["safety review approved", "env smoke test passed", "no-action dry run completed", "q1_execution_mode を mock/sim/real のどれかに確定"]
  - gate_id: q1_w1_exit
    purpose: "1 pilot trial 後の再判断"
    decisions: ["proceed from 1 pilot trial to 15 planned trials", "continue pilot", "replan"]
  - gate_id: q1_mid_point
    purpose: "W2 以降 detail の確定 (Phase 0 で prescribe しない)"
    decisions: ["update failure taxonomy", "update KPI", "update operator workflow"]
  - gate_id: q1_closeout
    purpose: "Lv1 継続可否"
    decisions: ["proceed to MS Lv1", "revise Phase 0 artifacts", "escalate"]

free_text_section:
  open_questions: |
    - q1_execution_mode の最終確定 (mock 限定か、sim 拡張か、real まで踏むか)
    - safety_owner の人選
  blockers_for_q1: |
    - safety_checklist review_status が not_reviewed のため、Q1 W1 開始前に必ず approved にする
```
