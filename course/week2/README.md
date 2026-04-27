---
type: week
id: W2-README
title: Week 2 - Manipulation / Robot Adapter
week: 2
duration_min: 420
prerequisites: [W1-L0, W1-L1, W1-L2, W1-Lab0, W1-Lab1, W1-Lab2]
worldcpj_ct: [CT-01, CT-02, CT-06, CT-07, CT-09]
roles: [common, adapter, calibration, safety]
references: [R-08, R-09, R-10, R-11, R-12, R-13, R-14, R-15, R-16, R-17, R-30, R-31]
deliverables: [robot_readiness_mini_report, sandbox_pr_review_notes]
---

# Week 2 — Manipulation / Robot Adapter

## 目的

実機投入の前に、MoveIt2 / Robot Adapter 段階 / Calibration 最小語彙 / Safety 最小語彙 / Codex PR レビューの判断基準を全員で揃える。3 本柱:

1. **MoveIt2 Panda demo** で planning scene / IK / trajectory / collision-aware planning を体験 (Lab 3)
2. **mock_hardware adapter 境界** を `ros2_control` で観察 (Lab 4)
3. **Codex no-op adapter logger** を生成→PR→人間レビューの一巡で実走 (Lab 4b)

URSim / 実機 / URDF+IK mock adapter は **Stretch goal** (Robot Adapter / Safety Role Owner 限定)。Robot Readiness Mini Report の「次段階」欄に記録。

## 所要時間

| 区分 | 目安 |
|---|---|
| Lectures (L3 + L4) | 95 分 |
| Labs (Lab 3 + 4 + 4b) | 195 分 |
| Templates 記入 (Robot Readiness + PR Review Notes) | 30 分 |
| 余白 (詰まった時の調査) | 100 分 |
| **合計** | **約 7 時間** |

## Lecture 一覧

| ID | タイトル | 所要 | リンク |
|---|---|---|---|
| W2-L3 | MoveIt 2 概観 | 45 分 | [l3](./lectures/l3_moveit2_overview.md) |
| W2-L4 | Robot Adapter + Calibration + Safety 最小語彙 | 50 分 | [l4](./lectures/l4_robot_adapter_calibration_safety.md) |

## Lab 一覧

| ID | タイトル | 所要 | リンク |
|---|---|---|---|
| W2-Lab3 | RViz Planning (Panda demo) | 60 分 | [lab3](./labs/lab3_rviz_planning/README.md) |
| W2-Lab4 | mock_hardware adapter | 75 分 | [lab4](./labs/lab4_mock_hardware_adapter/README.md) |
| W2-Lab4b | Codex no-op adapter logger | 60 分 | [lab4b](./labs/lab4b_codex_noop_adapter_logger/README.md) |

## 提出物テンプレート

| テンプレート | リンク |
|---|---|
| Robot Readiness Mini Report | [template](./deliverables/robot_readiness_mini_report_template.md) |
| Sandbox PR Review Notes | [template](./deliverables/sandbox_pr_review_notes_template.md) |

## 合格条件サマリ

教育計画 §4.3 末尾より:

- MoveIt2 は planning scene / IK / trajectory / controller の合成層であると説明できる
- Python adapter は orchestration / bridge に留めるべきと説明できる
- `no-op → URDF+IK mock → URSim → real` の段階と各段階で評価できることを説明できる
- camera intrinsic / hand-eye / fixture / reprojection error の最低意味を説明できる
- Codex 出力 (adapter / mock コード) について 入力 / 出力 / 失敗時挙動 / ログの有無を自分でレビューできる
- Robot Readiness Mini Report の全 7 行 (空欄 NG) を記入できる

## Stretch goal (任意、Robot Adapter / Safety Role Owner)

W2 ベースライン外の発展課題。Robot Readiness Mini Report の「次段階」欄に記録:

- URSim 実環境セットアップ (UR ROS2 driver、URCapX、PolyScopeX 接続)
- URDF + IK mock adapter (KDL ベース) を別 PR で実装
- camera_calibration package のハンズオン (SP5 Calibration Role)

## 参照

外部リソース台帳: [docs/references.md](../../docs/references.md)

主に W2 で参照するもの: R-08 (MoveIt2 Getting Started), R-09 (MoveIt Quickstart RViz), R-10 (MoveIt Python API), R-11 (ros2_control), R-12 (ros2_controllers), R-13 (UR ROS2 Driver Usage), R-14 (UR External Control URCapX), R-15 (camera_calibration), R-16 (image_pipeline), R-17 (MoveIt Hand-Eye), R-30 (UR Safety FAQ), R-31 (UR safety manual)
