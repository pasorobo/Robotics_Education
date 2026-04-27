---
type: week
id: W1-README
title: Week 1 - 共通知識と環境 + Git/Codex Sandbox
week: 1
duration_min: 360
prerequisites: []
worldcpj_ct: [CT-01, CT-07]
roles: [common]
references: [R-01, R-02, R-03, R-04, R-05, R-33, R-34, R-35, R-36, R-37, R-38]
deliverables: [skill_baseline_sheet, sandbox_setup_log]
---

# Week 1 — 共通知識と環境 + Git/Codex Sandbox

## 目的

Phase 0 §4.2 の方針に従い、全員がROS 2と座標系の最低語彙を持ち、Git/Codex Sandbox基盤を立ち上げる。
ロール固有の深掘りに入る前に、チーム全員が共通の土台を持つことが本週の唯一の目標である。
Codexについては接続確認・ルール理解・prompt 5項目の練習にとどめ、生成コードの成果物への組み込みはW2以降とする。

## 所要時間

総6時間 (Lecture 3本 × 45分 + Lab 3本 × 60分 + テンプレート記入)

## Lecture 一覧

| ID | タイトル | 所要 | リンク |
|---|---|---|---|
| W1-L0 | Git/Codex/Sandbox 最小語彙 | 45分 | [l0](./lectures/l0_git_codex_sandbox.md) |
| W1-L1 | ROS 2 基礎 | 45分 | [l1](./lectures/l1_ros2_basics.md) |
| W1-L2 | TF / URDF | 45分 | [l2](./lectures/l2_tf_urdf.md) |

## Lab 一覧

| ID | タイトル | 所要 | リンク |
|---|---|---|---|
| W1-Lab0 | Sandbox Setup | 60分 | [lab0](./labs/lab0_sandbox_setup/README.md) |
| W1-Lab1 | turtlesim + rosbag | 60分 | [lab1](./labs/lab1_turtlesim_rosbag/README.md) |
| W1-Lab2 | TF tree | 60分 | [lab2](./labs/lab2_tf_tree/README.md) |

## 提出物テンプレート

| テンプレート | リンク |
|---|---|
| Skill Baseline Sheet | [template](./deliverables/skill_baseline_sheet_template.md) |
| Sandbox Setup Log | [template](./deliverables/sandbox_setup_log_template.md) |

## 合格条件サマリ

- ROS 2 の node / topic / service / action / launch の5用語を口頭で説明できる
- `ros2 topic echo` を使って任意のトピックのメッセージを端末に表示できる
- TF の frame 名・親子関係を `ros2 run tf2_tools view_frames` で可視化し説明できる
- Sandbox Setup Lab の全ステップのターミナル出力をログとして提出できる
- 自分の `Sandbox_<name>` リポジトリに最初のPRを作成しマージできる
- Codex へのprompt前5項目チェックリストを暗唱または即座に参照できる

## 参照

- R-01: ROS 2 Humble Documentation
- R-02: ROS 2 Humble Ubuntu install
- R-03: ROS 2 Humble tf2 Tutorials
- R-04: ROS 2 Humble recording and playing back data (rosbag tutorial)
- R-05: Modern Robotics, Lynch and Park
- R-33: Git Book
- R-34: GitHub Docs: Working with forks
- R-35: GitHub Docs: Fork a repository
- R-36: Codex web docs
- R-37: Using Codex with your ChatGPT plan
- R-38: Codex Enterprise Admin Setup
