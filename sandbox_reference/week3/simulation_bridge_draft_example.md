---
type: reference
id: REF-W3-SIM-BRIDGE-DRAFT-EXAMPLE
title: Simulation Bridge Draft 記入例 (instructor case)
week: 3
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-08]
roles: [common, sim]
references: []
deliverables: []
---

# Simulation Bridge Draft (記入例)

> instructor case = Panda demo (Lab 3) + minimal_robot mock_hardware (Lab 4) を sample case として 8 field 全埋め。

## Sample case

SP2 Panda demo (RViz Plan + Execute、mock execution) + SP2 minimal_robot URDF (mock_components/GenericSystem、ros2_control)

## input 4 field

| field | 記入内容 |
|---|---|
| `scene_packet` | RGB-D 画像 + obstacle 一覧 (mock 環境では検出オブジェクト 0)。実機では Realsense + ArUco fixture から取得 |
| `robot_state` | minimal_robot の `/joint_states` (j1 のみ) + ee_pose 計算結果 (URDF + FK)。Panda demo 時は 7 joint |
| `candidate_set` | 把持候補 6-DOF pose 列。SP3 では provisional (空 list でも可)、SP4-5 で Affordance schema と接続して埋める |
| `action_intent` | 選択された 1 候補。SP3 では provisional、Q1 後半 で Selection Logic と接続 |

## output 4 field

| field | 記入内容 |
|---|---|
| `observation` | mock_hardware から `/joint_states` (実 sensor 画像なし)。Stretch: Gazebo 拡張すれば camera 画像も |
| `execution_result` | success / fail boolean。mock では「すべて success」(物理が無いため fail しようがない) |
| `failure_reason` | mock では常に `null`。実機では `enum` (collision / unreachable / timeout / safe_no_action) |
| `metrics` | mock では `null`。実機では task-specific KPI (例: 成功率、time-to-grasp、collision count) |

## 自由記述

### 詰まった点

なし。Lab 3 + Lab 4 の sample case 流用で素直に埋まった。

### 次に試したいこと

SP4 (W4) で trial sheet / episode_record を埋める時に、本 draft の output 4 field と接続できるか確認。

### WorldCPJ 本物 schema 確定への接続

SP4 (Q1 終盤) trial sheet 設計と並行して WorldCPJ Affordance schema が確定する見込み。本 draft は provisional として位置づけ、SP4 完了時に再 review 予定。

---

| 記入者 | 記入日 |
|---|---|
| pasorobo (instructor) | 2026-04-28 |
