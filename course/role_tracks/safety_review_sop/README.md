---
type: reference
id: SP5-RT-SAFETY-REVIEW-SOP
title: safety_review_sop — Optional Role Track stub (frame only, do not implement yet)
week: 5
duration_min: 0
prerequisites: [SP2, SP4]
worldcpj_ct: [CT-09]
roles: [common, safety]
references: []
deliverables: []
---

# safety_review_sop — Role Track stub (frame only)

## Track meta

```yaml
track_id: safety_review_sop
role: Safety / Compliance Role
purpose: "q1_w1_pre_start gate で SOP draft / responsible reviewer / risk assessment / site-fit safety review gap が観察された場合に深掘りする optional role track"
prerequisites:
  - SP2 completed (W2 L4 safety vocabulary)
  - SP4 completed (W4 L8 + safety_checklist + Q1 Package §8 safety_review_go_no_go)
expected_learner: "Q1 で safety review / SOP / responsible reviewer / risk assessment を担当するメンバー (現場の safety officer / role owner)"
q1_touchpoint:
  - q1_package:8_safety_review_go_no_go
  - q1_w1_preflight:item_6_safety_review
  - re_judge_gates:q1_w1_pre_start
activation_trigger: "Activate this track if q1_w1_pre_start gate reveals SOP draft, responsible reviewer, risk assessment, or site-fit safety review gap."
future_spec_id: sp5x_candidate_safety_review_sop
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

`re_judge_gates:q1_w1_pre_start` で観察される SOP draft の質 / responsible reviewer の確定 / risk assessment の depth / site-fit safety review (UR safety 深掘り、ISO 10218 適用検討、現場 SOP fit) gap に対応する optional role track。SP2 W2 L4 で確立した safety vocabulary + SP4 W4 L8 で確立した safety_checklist (training_draft_only) と Q1 Package §8 safety_review_go_no_go の延長線で深掘りする。SP1 `robot_adapter_safety` の safety side をここに分離 (adapter side は `robot_adapter_readiness` track へ separate)。

## When to activate

Q1 Package §8 safety_review_go_no_go 行の `review_status` が `not_reviewed` のまま Q1 W1 開始期日に近づいた時、または `q1_w1_preflight` item 6 (safety review) が pre-start gate (`re_judge_gates:q1_w1_pre_start`) で blocker として記録された時。

## What not to implement yet

本 stub は `stub_only: true` であり、UR safety docs 深掘り / ISO 10218 適用 hands-on / 現場 SOP テンプレート / risk assessment 手法ライブラリ / responsible reviewer onboarding kit の content は SP5 では作らない。activation 時に新 sub-project (`sp5x_candidate_safety_review_sop`) として brainstorming → spec → plan → implementation を行う。本 track の content は **必ず** site SOP / responsible safety reviewer / robot model 固有の risk assessment と整合させる必要がある (Phase 0 SP4 §11.4 と同じ境界)。
