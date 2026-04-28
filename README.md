---
type: guide
id: ROOT-README
title: Robotics Education Course
date: 2026-04-27
---

# Robotics Education Course

このリポジトリは、ROS2 Humble を用いたロボティクスシミュレーション教育コース（Phase 0）の教材・ツール・参考資料を一元管理する場所です。対象は Phase 0 教育対象チームで、ROS2 の基礎から Gazebo シミュレーション、自律ナビゲーション、Codex 活用演習まで4週間で習得することを目指します。SP1（Sub-Project 1 / サブプロジェクト1）では Week 1 の教材・テンプレート・ツールおよびリファレンス R-01〜R-39 を提供します。

## このリポジトリの構成

```
Robotics_Education/
├── docs/
│   ├── Robotics_simulation_phase0_education_plan.md   # 原典
│   ├── CONVENTIONS.md                                 # ドキュメント規約
│   ├── glossary.md                                    # 用語表
│   ├── references.md                                  # リソース台帳
│   └── superpowers/
│       ├── specs/                                     # brainstorming 設計書
│       └── plans/                                     # 実装計画
├── course/             # 週別講義ノートと Lab 演習（00_setup + week1〜week4）
├── sandbox_reference/  # 模擬データ・オフライン参考資料（秘密情報禁止、実機接続禁止）
└── tools/              # 環境チェック・雛形生成・構造チェックスクリプト
```

## はじめての方へ

以下の順番で読み進めてください。

1. `docs/Robotics_simulation_phase0_education_plan.md` — コース全体の教育計画と目標
2. `docs/CONVENTIONS.md` — ファイル命名規則・ブランチ規則・フロントマター規約
3. `course/00_setup/` — 環境構築手順（ROS2 Humble インストール、ワークスペース初期化）
4. `course/week1/` — Week 1 講義ノートと Lab 演習

## SP1で何ができるか

SP1（Sub-Project 1 / サブプロジェクト1）で整備されたコンテンツの概要です。

- **Week 1 講義ノート（Lecture）:** Lecture 9本中3本: L0 Git/Codex/Sandbox 最小語彙、L1 ROS 2 基礎、L2 TF/URDF
- **Week 1 Lab 演習:** Lab 12本中3本: Lab 0 Sandbox Setup + Codex 接続確認、Lab 1 turtlesim + rosbag2、Lab 2 TF tree
- **テンプレート:** 2本（Skill Baseline Sheet — 8項目自己採点、Sandbox Setup Log — repo/access/identity/Codex設定記録）
- **ツール:** tools 4本: verify_env.sh (環境チェック)、new_week_skeleton.sh (次週フォルダ雛形)、codex_prompt_template.md (Codex prompt前5項目)、check_structure.sh (SP1完了判定G1/G2/G4自動化)
- **リファレンス:** R-01〜R-39（ROS2公式ドキュメント、Gazebo、Nav2、外部チュートリアルなど）

## SP2で何ができるか

Week 2 教材一式 (3 本柱):

- **MoveIt 2 Panda demo**: planning scene / IK / trajectory / collision-aware planning を RViz で体験 (Lab 3)
- **mock_hardware adapter**: 最小 ROS package + colcon build + ros2_control の `mock_components/GenericSystem` で controller / hardware interface 境界を観察 (Lab 4)
- **Codex no-op adapter logger**: Codex 生成 → PR → 人間レビュー一巡を初実走、禁止リスト遵守を人間が確認 (Lab 4b)

提出物テンプレート 2 件:

- Robot Readiness Mini Report (7 行必須記入、空欄 NG、mock 環境では「未確認 / SP4-5 で評価予定」可)
- Sandbox PR Review Notes (6 行必須記入、Codex 利用なし時も明示記述)

Stretch goal (Robot Adapter / Safety Role Owner 限定): URSim 接続、URDF + IK mock adapter (KDL ベース) は SP5 / 個別宿題で扱う。

## SP3で何ができるか

Week 3 教材一式 (3 本柱):

- **Gazebo Fortress 起動確認 + ros_gz_bridge YAML 設計** (Lab 5) — `/clock` mandatory bridge YAML を写経、`/joint_states` は概念例 (joint を持つ robot model 必要、Stretch goal)
- **provisional schema 8 field 設計演習** (Lab 6) — plan §8.3 流用 (input: scene_packet/robot_state/candidate_set/action_intent、output: observation/execution_result/failure_reason/metrics)、自分の MS Lv1 / CC Gate 0-a 想定 case で 8 field 全埋め
- **Codex no-op bridge stub PR レビュー一巡** (Lab 6b) — Lab 4b 同型 + 追加禁止リスト (実 simulator/bridge/Affordance 判定自動化)、JSON file 入力 finite Python script

提出物テンプレート 2 件:

- Simulation Bridge Draft (8 field 全埋め、空欄 NG、未確定なら「未確定 / SP4-5 で評価予定」可)
- Simulator Decision Table (4 simulator × 4 軸比較 + 自分の case 用選択判断)

Stretch goal (Sim Bridge / Sandbox Bridge Role Owner 限定): 実 ros_gz_bridge で SP2 minimal_robot を Gazebo 上で動かす統合、MuJoCo / ManiSkill / Isaac の hands-on は SP5 / 個別宿題で扱う。

## 今後の予定

| サブプロジェクト | 対象週 | 主なコンテンツ |
|------------------|--------|----------------|
| SP2 | **完了 (Week 2 — Manipulation / Robot Adapter)** |
| SP3 | **完了 (Week 3 — Simulation Bridge)** |
| SP4              | Week 4 | Logging / Evaluation / Safety + Q1統合（W4 L7-L8、Lab7、Lab8、Lab8b） |

ロードマップの詳細は仕様書 §4.1 を参照してください: `docs/superpowers/specs/2026-04-27-robotics-course-sp1-design.md`

## 用語と参照

- **用語集:** `docs/glossary.md`
- **参考文献:** `docs/references.md`
- **規約:** `docs/CONVENTIONS.md`

## ライセンス・連絡先

Internal team document. Contact: project owners.
