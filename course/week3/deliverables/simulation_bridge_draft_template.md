---
type: template
id: W3-T-SIM-BRIDGE-DRAFT
title: Simulation Bridge Draft (template)
week: 3
duration_min: 15
prerequisites: [W3-Lab6]
worldcpj_ct: [CT-08]
roles: [common, sim]
references: []
deliverables: []
---

# Simulation Bridge Draft

> このテンプレートを自 Sandbox にコピーし、Lab 6 完了時に **8 field を 1 行以上で記入**。
>
> **空欄 NG / 未確定なら「未確定 / SP4-5 で評価予定」可**。
>
> plan §8.3 の provisional schema を採用 (WorldCPJ 本物 schema は SP4-5 / Q1 後半で確定予定)。

## Sample case

`<例: SP1 turtlesim / SP2 Panda demo + mock_hardware / SP2 minimal_robot mock_hardware / 独自 case>`

## input 4 field

| field | 記入内容 |
|---|---|
| `scene_packet` | `<sensor 画像 / obstacle 一覧 / 環境状態 等>` |
| `robot_state` | `<joint angle / pose / 速度 / battery 等>` |
| `candidate_set` | `<把持候補 / 動作候補 一覧 (例: 6-DOF pose 列)>` |
| `action_intent` | `<選択された 1 候補 (例: 選んだ把持 pose)>` |

## output 4 field

| field | 記入内容 |
|---|---|
| `observation` | `<simulator から返す観測 (画像 / sensor / TF 等)>` |
| `execution_result` | `<success / fail boolean、または status enum>` |
| `failure_reason` | `<enum: collision / unreachable / timeout / etc.>` |
| `metrics` | `<task-specific KPI (例: 成功率 / time-to-grasp / collision count)>` |

## 自由記述

### 詰まった点

TBD

### 次に試したいこと

TBD

### WorldCPJ 本物 schema 確定への接続

WorldCPJ 本体プロジェクトでの schema 確定タイミング (SP4 / Q1 後半 Affordance schema 設計フェーズ) を待つ。確定後は本 draft を上書きする前提。

---

| 記入者 | 記入日 |
|---|---|
| `<name>` | `YYYY-MM-DD` |
