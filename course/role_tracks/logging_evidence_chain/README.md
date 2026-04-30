---
type: reference
id: SP5-RT-LOGGING-EVIDENCE-CHAIN
title: logging_evidence_chain — Optional Role Track stub (frame only, do not implement yet)
week: 5
duration_min: 0
prerequisites: [SP1, SP4]
worldcpj_ct: [CT-07]
roles: [common, logging]
references: []
deliverables: []
---

# logging_evidence_chain — Role Track stub (frame only)

## Track meta

```yaml
track_id: logging_evidence_chain
role: Logging Role
purpose: "Q1 W1 preflight / pilot trial / q1_w1_exit で logging/evidence chain gap が観察された場合に深掘りする optional role track"
prerequisites:
  - SP1 completed (W1 Lab 1 turtlesim bag baseline)
  - SP4 completed (episode_record / trial_sheet / Q1 Package §6 logging_episode_plan)
expected_learner: "Q1 で rosbag2 / MCAP / episode_record / trial_sheet / evidence_path を担当するメンバー"
q1_touchpoint:
  - q1_package:6_logging_episode_plan
  - q1_w1_preflight:item_4_required_topics
  - q1_w1_preflight:item_5_rosbag2_record
activation_trigger: "Activate this track if Q1 W1 preflight, pilot trial, or q1_w1_exit gate reveals logging/evidence chain gap, topic coverage gap, episode-to-trial linkage gap, or evidence_path completeness issue."
future_spec_id: sp5x_candidate_logging_evidence_chain
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

Q1 W1 preflight (`q1_w1_preflight:item_4_required_topics`、`item_5_rosbag2_record`) または pilot trial / `re_judge_gates:q1_w1_exit` で観察される logging/evidence chain gap (記録 topic 不足 / episode-to-trial linkage 欠落 / evidence_path completeness 不備 / MCAP plugin 必要性) に対応する optional role track。SP4 で確立した episode_record + trial_sheet + Q1 Package §6 logging_episode_plan の延長線で深掘りする。

## When to activate

Q1 Package §6 logging_episode_plan 行の `review_status` が `reviewed_with_conditions` または `blocked` となり、`q1_w1_preflight` item 4 / item 5、または `q1_w1_exit` gate で課題として記録された時。

## What not to implement yet

本 stub は `stub_only: true` であり、MCAP plugin の install + 実録画手順 / rosbag2 custom storage plugin / bag → episode_record automation tooling / LeRobot との差分検討 の content は SP5 では作らない。activation 時に新 sub-project (`sp5x_candidate_logging_evidence_chain`) として brainstorming → spec → plan → implementation を行う。
