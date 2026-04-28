---
type: reference
id: W4-REF-LAB7-README
title: Lab 7 walk-through summary (instructor case)
week: 4
duration_min: 5
prerequisites: [W4-Lab7]
worldcpj_ct: [CT-04]
roles: [common, logging]
references: [R-28]
deliverables: []
---

# Lab 7 walk-through summary

instructor case = SP1 W1 Lab 1 turtlesim bag を題材に Lab 7 を完了した想定。

詳細は [`../episode_record_example.md`](../episode_record_example.md) を参照。

## 観察された挙動

- Q1-specific linkage keys (`q1_package_id` / `trial_sheet_id` / `trial_id` / `object_id`) は `not_applicable` または `training_*` に設定
- `evidence_path` で SP1 W1 Lab 1 bag_info.txt を参照、raw bag は commit せず
- mock 環境のため `result: success` / `failure_reason: none` / `bridge_schema_version: not_applicable` / `adapter_version: not_applicable`
