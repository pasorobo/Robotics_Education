---
type: guide
id: ROOT-README
title: Robotics Education Course
date: 2026-04-27
---

# Robotics Education Course

このリポジトリは、ROS2 Humble を用いたロボティクスシミュレーション教育コース（Phase 0）の教材・ツール・参考資料を一元管理する場所です。対象は Phase 0 教育対象チームで、ROS2 の基礎から Gazebo シミュレーション、自律ナビゲーション、Codex 活用演習まで4週間で習得することを目指します。SP1（Superpower 1）では Week 1 の教材・テンプレート・ツールおよびリファレンス R-01〜R-39 を提供します。

## このリポジトリの構成

```
Robotics_Education/
├── docs/               # 教育計画、仕様書、規約、用語集、参考文献一覧
├── course/             # 週別講義ノートと Lab 演習（00_setup + week1〜week4）
├── sandbox_reference/  # 模擬データ・オフライン参考資料（秘密情報禁止、実機接続禁止）
└── tools/              # ビルド補助スクリプト、lint、チェックツール
```

## はじめての方へ

以下の順番で読み進めてください。

1. `docs/Robotics_simulation_phase0_education_plan.md` — コース全体の教育計画と目標
2. `docs/CONVENTIONS.md` — ファイル命名規則・ブランチ規則・フロントマター規約
3. `course/00_setup/` — 環境構築手順（ROS2 Humble インストール、ワークスペース初期化）
4. `course/week1/` — Week 1 講義ノートと Lab 演習

## SP1で何ができるか

SP1（スプリント1）で整備されたコンテンツの概要です。

- **Week 1 講義ノート（Lecture）:** 9本中3本（L01 ROS2概論、L02 ノード・トピック・サービス、L03 Gazebo基礎）
- **Week 1 Lab 演習:** 12本中3本（Lab1 環境確認、Lab2 tf2 view_frames、Lab3 Gazebo起動確認）
- **テンプレート:** 2本（講義ノートテンプレート、Lab演習テンプレート）
- **ツール:** 4本（lint スクリプト、フロントマター検証、リンクチェック、ビルド補助）
- **リファレンス:** R-01〜R-39（ROS2公式ドキュメント、Gazebo、Nav2、外部チュートリアルなど）

## 今後の予定

| スプリント | 対象週 | 主なコンテンツ |
|------------|--------|----------------|
| SP2        | Week 2 | SLAM、Nav2基礎、Lab4〜6 |
| SP3        | Week 3 | 自律ナビゲーション応用、Lab7〜9 |
| SP4        | Week 4 | Codex本格運用、統合演習、Lab10〜12 |

ロードマップの詳細は仕様書 §4.1 を参照してください: `docs/superpowers/specs/2026-04-27-robotics-course-sp1-design.md`

## 用語と参照

- **用語集:** `docs/glossary.md`
- **参考文献:** `docs/references.md`
- **規約:** `docs/CONVENTIONS.md`

## ライセンス・連絡先

Internal team document. Contact: project owners.
