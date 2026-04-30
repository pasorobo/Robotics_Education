---
type: reference
id: SP5-RT-SIMULATION-BRIDGE
title: simulation_bridge — Optional Role Track stub (frame only, do not implement yet)
week: 5
duration_min: 0
prerequisites: [SP1, SP3, SP4]
worldcpj_ct: [CT-08]
roles: [common, sim, sandbox]
references: []
deliverables: []
---

# simulation_bridge — Role Track stub (frame only)

## Track meta

```yaml
track_id: simulation_bridge
role: Sim Bridge / Sandbox Bridge Role
purpose: "Q1 W1 preflight や q1_w1_exit で simulator selection / bridge schema / sim-to-logging integration gap が観察された場合に深掘りする optional role track"
prerequisites:
  - SP1 completed
  - SP3 completed (Gazebo Fortress + ros_gz_bridge baseline)
  - SP4 completed (Q1 Package available)
expected_learner: "Q1 で simulation bridge / provisional schema / alternative simulators を担当するメンバー"
q1_touchpoint:
  - q1_package:5_simulation_bridge_status
  - re_judge_gates:q1_w1_exit
  - re_judge_gates:q1_mid_point
activation_trigger: "Activate this track if Q1 W1 preflight or q1_w1_exit gate reveals simulator selection, bridge schema, or sim-to-logging integration gap."
future_spec_id: sp5x_candidate_simulation_bridge
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

Q1 W1 preflight または `re_judge_gates:q1_w1_exit` / `q1_mid_point` で観察される simulator selection (Gazebo を継続するか alternative に切り替えるか) / provisional schema 8 fields の運用判断 / sim-to-logging integration gap に対応する optional role track。SP3 で確立した Gazebo Fortress baseline と provisional schema の延長線で深掘りする。

## When to activate

Q1 Package §5 simulation_bridge_status 行の `review_status` が `reviewed_with_conditions` または `blocked` となり、`q1_w1_exit` または `q1_mid_point` gate で課題として記録された時。

## What not to implement yet

本 stub は `stub_only: true` であり、alternative simulator (MuJoCo / ManiSkill / Isaac 等) の install 手順 / hands-on lab / `<gazebo>` URDF extension / SDF world ファイル設計 の content は SP5 では作らない。activation 時に新 sub-project (`sp5x_candidate_simulation_bridge`) として brainstorming → spec → plan → implementation を行う。具体 simulator 名を本 stub の prose に追加しない方針 (spec §5.3)。
