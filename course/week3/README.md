---
type: week
id: W3-README
title: Week 3 - Simulation Bridge
week: 3
duration_min: 420
prerequisites: [W2-Lab3, W2-Lab4, W2-Lab4b]
worldcpj_ct: [CT-07, CT-08]
roles: [common, sim, sandbox]
references: [R-18, R-19, R-20, R-21, R-22, R-23, R-24, R-25, R-33, R-34, R-35, R-36, R-37, R-38]
deliverables: [simulation_bridge_draft, simulator_decision_table]
---

# Week 3 — Simulation Bridge

## 目的

Simulation を **WorldCPJ schema 翻訳** + **simulator 比較選択** 視点で扱う。3 本柱:

1. **Gazebo Fortress 起動確認 + ros_gz_bridge YAML 設計** (Lab 5) — `/clock` mandatory + `/joint_states` 概念例
2. **provisional schema 8 field 設計演習** (Lab 6) — plan §8.3 流用、自分の MS Lv1 / CC Gate 0-a 想定 case で埋める
3. **Codex no-op bridge stub PR レビュー一巡** (Lab 6b) — Lab 4b 同型 + 追加禁止リスト (実 simulator/bridge/Affordance 自動判定)

`simulator_decision_table` で 4-simulator (Gazebo / MuJoCo / ManiSkill / Isaac) 用途差を理解し、自分の case にどれを使うか判断できる。

MuJoCo / ManiSkill / Isaac の hands-on は **Stretch goal** (SP5 Sim Role / Sandbox Bridge Role Owner)。

## 所要時間

| 区分 | 目安 |
|---|---|
| Lectures (L5 + L6) | 95 分 |
| Labs (Lab 5 + 6 + 6b) | 195 分 |
| Templates 記入 (simulation_bridge_draft + simulator_decision_table) | 30 分 |
| 余白 (詰まった時の調査) | 100 分 |
| **合計** | **約 7 時間** |

## Lecture 一覧

| ID | タイトル | 所要 | リンク |
|---|---|---|---|
| W3-L5 | Gazebo Fortress + ros_gz_bridge | 45 分 | [l5](./lectures/l5_gazebo_fortress_ros2_bridge.md) |
| W3-L6 | 4-simulator landscape + Sim Bridge の役割 | 50 分 | [l6](./lectures/l6_simulator_landscape.md) |

## Lab 一覧

| ID | タイトル | 所要 | リンク |
|---|---|---|---|
| W3-Lab5 | Gazebo + ros_gz_bridge YAML | 60 分 | [lab5](./labs/lab5_gazebo_topic_bridge/README.md) |
| W3-Lab6 | provisional schema 8 field 設計演習 | 60 分 | [lab6](./labs/lab6_sim_to_worldcpj_schema/README.md) |
| W3-Lab6b | Codex no-op bridge stub | 75 分 | [lab6b](./labs/lab6b_codex_noop_bridge_stub/README.md) |

## 提出物テンプレート

| テンプレート | リンク |
|---|---|
| Simulation Bridge Draft (provisional schema 8 field) | [template](./deliverables/simulation_bridge_draft_template.md) |
| Simulator Decision Table (4 simulator × 4 軸) | [template](./deliverables/simulator_decision_table_template.md) |

## 合格条件サマリ

教育計画 §4.4 末尾より:

- Gazebo は ROS 2 連携と robot model / bridge 検証に使うと説明できる
- MuJoCo / ManiSkill / Isaac の用途差を説明できる (rendering / contact / parallel data / ROS 統合)
- Simulation の出力を `episode_record` / `trial sheet` / `Gate Eval` に渡す I/O として書ける (provisional schema 流用)
- Simulator 比較だけでは WorldCPJ 成果にならないと説明できる (Sim Bridge の本質 = WorldCPJ schema 翻訳)
- AI が提案した schema や metrics を採用する前に、WorldCPJ Affordance schema、評価指標、安全境界と照合できる

## Stretch goal (任意、Sim Bridge / Sandbox Bridge Role Owner)

W3 ベースライン外の発展課題。Robot Readiness Mini Report の「次段階」欄に記録:

- 実 `ros_gz_bridge` で SP2 minimal_robot を Gazebo 上で動かす統合 (`<gazebo>` URDF extension 拡張)
- MuJoCo / ManiSkill / Isaac の hands-on (SP5 Sim Role)
- WorldCPJ 本物 schema 確定後の bridge 実装 (SP4-5 / Q1 後半)

## 参照

外部リソース台帳: [docs/references.md](../../docs/references.md)

主に W3 で参照するもの: R-18 (Gazebo Fortress ROS install), R-19 (Gazebo Fortress ROS2 integration), R-20 (MuJoCo Documentation), R-21 (MuJoCo Python), R-22 (ManiSkill Documentation), R-23 (ManiSkill Quickstart), R-24 (NVIDIA Isaac Sim learning docs), R-25 (Isaac Lab tutorials), R-33〜R-38 (Codex)
