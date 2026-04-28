---
type: reference
id: W4-REF-LAB8-README
title: Lab 8 walk-through summary (instructor case)
week: 4
duration_min: 10
prerequisites: [W4-Lab8]
worldcpj_ct: [CT-04, CT-05, CT-09]
roles: [common, logging, safety]
references: [R-28, R-30]
deliverables: []
---

# Lab 8 walk-through summary

instructor case = Q1 Reduced Lv1 planning owner として 3 templates を統合した想定。

詳細は以下を参照:
- [`../q1_reduced_lv1_execution_package_example.md`](../q1_reduced_lv1_execution_package_example.md)
- [`../safety_checklist_example.md`](../safety_checklist_example.md)
- [`../trial_sheet_example.md`](../trial_sheet_example.md)

## 観察された挙動

- Q1 Package 8 行で W1-W3 templates を `source_artifact_path` で参照、data は copy せず
- safety_checklist は `phase0_status: training_draft_only` / `q1_blocker_if_unreviewed: true`
- trial_sheet は 15 planned rows skeleton (W1 turtlesim 混入なし)
- `q1_w1_preflight` 8 項目、`re_judge_gates` 4 件 (`q1_w1_pre_start` / `q1_w1_exit` / `q1_mid_point` / `q1_closeout`)
