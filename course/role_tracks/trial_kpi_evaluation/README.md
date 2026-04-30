---
type: reference
id: SP5-RT-TRIAL-KPI-EVALUATION
title: trial_kpi_evaluation — Optional Role Track stub (frame only, do not implement yet)
week: 5
duration_min: 0
prerequisites: [SP1, SP4]
worldcpj_ct: [CT-01, CT-02, CT-07]
roles: [common, evaluation]
references: []
deliverables: []
---

# trial_kpi_evaluation — Role Track stub (frame only)

## Track meta

```yaml
track_id: trial_kpi_evaluation
role: Evaluation / Trial Role
purpose: "q1_w1_exit や q1_mid_point で KPI taxonomy / trial aggregation / CC Gate 0-a 5 objects x 3 trials evaluation protocol gap が観察された場合に深掘りする optional role track"
prerequisites:
  - SP1 completed
  - SP4 completed (trial_sheet 15 planned rows skeleton + Q1 Package §7 trial_kpi_plan)
expected_learner: "Q1 で CC Gate 0-a evaluation / KPI taxonomy / trial 集計 を担当するメンバー"
q1_touchpoint:
  - q1_package:7_trial_kpi_plan
  - re_judge_gates:q1_w1_exit
activation_trigger: "Activate this track if q1_w1_exit or q1_mid_point gate reveals KPI taxonomy, trial aggregation, or CC Gate 0-a 5 objects x 3 trials evaluation protocol gap."
future_spec_id: sp5x_candidate_trial_kpi_evaluation
activation_status: inactive
stub_only: true
do_not_implement_yet: true
out_of_scope:
  - full lecture
  - full lab
  - role-specific SOP
  - real robot setup procedure
  - Q1 W2+ detailed procedure
  - track-specific templates
```

## What this track is for

`re_judge_gates:q1_w1_exit` (1 pilot trial 後の再判断) または `q1_mid_point` (W2 以降 detail の確定) で観察される KPI taxonomy の不足 / trial aggregation 方法の曖昧 / CC Gate 0-a 5 objects x 3 trials evaluation protocol gap (例: 統計手法 / failure_reason refinement) に対応する optional role track。SP4 で確立した trial_sheet 15 planned rows skeleton + Q1 Package §7 trial_kpi_plan + KPI fields (`kpi_grasp_success` / `kpi_time_to_grasp_sec`) の延長線で深掘りする。SP1 `cc_gate_0a` track はこの track の中の evaluation target として扱われる (independent track ではない)。

## When to activate

Q1 Package §7 trial_kpi_plan 行の `review_status` が `reviewed_with_conditions` または `blocked` となり、`q1_w1_exit` または `q1_mid_point` gate で課題として記録された時。

## What not to implement yet

本 stub は `stub_only: true` であり、KPI 統計分析 lab / failure taxonomy 改訂手順 / trial aggregation tooling / Modern Robotics 索引 (affordance evaluation 側) の content は SP5 では作らない。activation 時に新 sub-project (`sp5x_candidate_trial_kpi_evaluation`) として brainstorming → spec → plan → implementation を行う。
