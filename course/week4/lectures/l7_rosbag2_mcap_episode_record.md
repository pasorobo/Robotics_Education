---
type: lecture
id: W4-L7
title: Lecture 7 — rosbag2 / MCAP / episode_record
week: 4
duration_min: 60
prerequisites: [W1-Lab1]
worldcpj_ct: [CT-04, CT-05]
roles: [common, logging]
references: [R-28, R-29]
deliverables: [episode_record]
---

# Lecture 7 — rosbag2 / MCAP / episode_record

## 目的

`rosbag2` は ROS 2 標準の record/replay tool。**MCAP** は rosbag2 の storage plugin。`episode_record` は **1 task attempt** の構造化記録。本講では bag → episode_record の mapping を学ぶ。

## 1. rosbag2 全体像

`rosbag2` は `record` / `play` / `info` の 3 コマンド構成。SP1 W1 Lab 1 で実走済 (再 install 不要)。デフォルト storage backend は `sqlite3`、MCAP は plugin として追加可能 (R-28)。

[必須 G4 keywords: `rosbag2`]

## 2. SP1 W1 Lab 1 reuse 案内

Lab 7 では新たに録画せず、`sandbox_reference/week1/lab1/{bag_info.txt, rosbag_metadata.yaml, terminal_5min.log}` を再利用する。raw bag の commit は不要。

## 3. MCAP storage plugin

`ros-humble-rosbag2-storage-mcap` を install すると `--storage mcap` が使える (R-29)。**Phase 0 では Stretch (install 任意)**。verify_env --week 4 でも MCAP 不在は WARN のみ、FAIL にはしない。

[必須 G4 keywords: `MCAP`, `Stretch` または `任意`]

## 4. episode_record の意味

1 task attempt の構造化記録。N trials の集計は `trial_sheet` が担当 (責務分離)。

[必須 G4 keywords: `episode_record`]

## 5. bag → episode_record mapping

`ros2 bag info` の出力を episode_record の field に mapping する:

- Files / Bag size / Storage id → `log_summary`
- **Duration → `duration_sec`**
- Start / End が出力に含まれる場合のみ → `start_time` / `end_time`
- Topic information → `recorded_topics`
- raw bag は commit せず、`bag_info.txt` / `rosbag_metadata.yaml` / terminal log を **`evidence_path`** に格納

[必須 G4 keywords: `duration_sec`, `evidence_path`]

## 6. failure_reason taxonomy

`failure_reason` は以下の 10 値 (8 失敗 taxonomy + `none` + `unknown`):

`none | perception_failure | planning_failure | control_or_execution_failure | sim_bridge_failure | environment_or_setup_failure | safety_blocked | operator_error | logging_or_data_failure | unknown`

`result` と分離。`result: success` の場合 `failure_reason: none` 必須。Phase 0 では分類不確実なら `unknown` 容認 (空欄 NG)。

[必須 G4 keywords: `failure_reason`, `taxonomy`]

## 7. Humble baseline 注記

`ros2 bag` は **topic recording** を扱う。MCAP install / MCAP recording は Stretch。**`services/actions recording` は Course baseline 範囲外** (個別検証時のみ扱う)。

[必須 G4 keywords: `services/actions recording`, `Course baseline 範囲外` または `out of scope for the Course baseline`]

## 8. よくある誤解

1. raw bag を commit する → NG。軽量証跡 (bag_info.txt, metadata.yaml) のみ commit
2. episode_record と trial_sheet を混同 → NG。1 attempt vs N trials 集計
3. MCAP を Phase 0 必須と誤認 → NG。Stretch
4. Duration から start/end を推定 → NG。Start/End が出力に含まれる場合のみ mapping

## 次のLab

→ [Lab 7 — episode_record 記入演習](../labs/lab7_episode_record/README.md)
