---
type: reference
id: W4-REF-EPISODE-RECORD
title: episode_record example — SP1 W1 Lab 1 turtlesim bag (instructor fill demo)
week: 4
duration_min: 15
prerequisites: [W1-Lab1, W4-L7]
worldcpj_ct: [CT-04, CT-05]
roles: [common, logging]
references: [R-28]
deliverables: [episode_record]
---

# episode_record example (instructor fill demo)

> **artifact_status**: sandbox_example
>
> instructor case = SP1 W1 Lab 1 turtlesim bag を題材に Lab 7 を完了した想定。Q1 trial ではないため、Q1-specific linkage keys は `not_applicable` または `training_*`。

## YAML body (filled)

```yaml
artifact_status: sandbox_example

# Linkage keys (Q1 trial と区別)
episode_id: episode_w1_lab1_001
q1_package_id: not_applicable
trial_sheet_id: not_applicable
trial_id: training_trial_w1_lab1_001
object_id: turtlesim_training_object
attempt_index: 1

# Environment
environment_mode: mock
adapter_version: not_applicable
bridge_schema_version: not_applicable

# Logs
log_path: not_applicable
evidence_path: sandbox_reference/week1/lab1/bag_info.txt
commit_sha: TBD

# Time (from bag_info.txt Duration field)
start_time: TBD
end_time: TBD
duration_sec: 300.0
recorded_topics:
  - /turtle1/cmd_vel
  - /turtle1/pose
  - /rosout
  - /parameter_events

# Outcome
result: success
failure_reason: none
review_status: not_reviewed

notes: |
  W1 Lab 1 turtlesim 5 分間 bag。mock 環境かつ Q1 trial ではないため Q1-specific
  linkage keys は not_applicable / training_*。raw bag は commit せず、
  bag_info.txt を evidence_path として参照。
```
