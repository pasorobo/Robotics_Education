---
type: reference
id: REF-W3-LAB6-README
title: Lab 6 instructor walk-through summary
week: 3
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-08]
roles: [common, sim]
references: []
deliverables: []
---

# Lab 6 — Instructor walk-through summary

## 実施環境

- Sim 環境不要 (schema design artifact のため)
- 所要時間: 約 30 分 (sample case 整理 5 分、8 field 埋め 20 分、整合性確認 5 分)

## Sample case 選択

instructor case = SP2 で動かした **Panda demo (Lab 3 RViz planning) + minimal_robot mock_hardware (Lab 4)** を sample case とした。理由:

- Panda demo: planning scene + IK + trajectory を体験済 → output 4 field の `observation` `execution_result` `failure_reason` `metrics` を describe しやすい
- minimal_robot mock_hardware: ros2_control の境界を体験済 → input 4 field の `robot_state` (joint angle) を describe しやすい

## 実施内容

1. `simulation_bridge_draft_template.md` (W3 template) を流用
2. plan §8.3 の 8 field を Panda demo + minimal_robot sample case で埋める
3. mock 環境特有の null 値 (`failure_reason`, `metrics` 等) を明示
4. WorldCPJ 本物 schema 確定 (SP4 / Q1 後半) への接続を自由記述に明記

## 詰まった点

なし。Lab 3 + Lab 4 の sample case 流用で素直に埋まった。

## 提出物

- [`scene_packet_design.md`](./scene_packet_design.md): provisional schema 8 field 全埋め draft
