---
type: spec
id: SPEC-SP3
title: Robotics Education Course - Sub-Project 3 (Week 3 Simulation Bridge) 設計書
date: 2026-04-28
status: pending_user_review
sub_project: SP3
related_plan: docs/superpowers/plans/2026-04-28-robotics-course-sp3-plan.md
---

# Robotics Education Course — SP3 設計書

## 0. メタ情報

| 項目 | 値 |
|---|---|
| 設計対象 | Sub-Project 3 (Week 3: Simulation Bridge) |
| 期間目安 | 〜2026-05-15 (Week 3 完了に合わせる) |
| 原典 | [`docs/Robotics_simulation_phase0_education_plan.md`](../../Robotics_simulation_phase0_education_plan.md) §4.4 |
| 計画§対応 | §4.4 (Week 3) + §8.3 (Simulation Bridge Draft) + §運用ルール |
| 前提 | SP1 + SP2 完了 (commit `a3287ca` mainにmerge済、71 ファイル + tools/ 完備) |
| 後続 | SP4 (Week 4 Logging/Eval/Safety + Q1統合) |
| 想定総ファイル数 | **設計完了時 28 新規 + 3 修正 = 31、writing-plans 後 29 新規 + 3 修正 = 32** |
| 想定累計 | 現行 main 71 + SP3 design 28 = 99、writing-plans 後 100 |

---

## 1. 全体スコープと SP1/SP2 からの継承

### 1.1 SP3 ミッション

Week 3 (Simulation Bridge) の教材を SP1/SP2 で確立した型に沿って追加し、全員が **Gazebo Fortress 起動確認 (Lab 5)** + **plan §8.3 の 8 field provisional schema を題材に WorldCPJ I/O schema を draft する設計演習 (Lab 6)** + **Codex no-op bridge stub の生成→PR レビュー一巡 (Lab 6b)** + **4-simulator 用途差 table から自分の case の simulator を選択判断 (`simulator_decision_table`)** ができる状態にする。

**二軸の方針** (SP2 と同じ): 全員向け教材の標準ルートは **mock 中心 + 設計演習中心** (質問 1 の判断 B、質問 3 の判断 B)。一方、instructor が `sandbox_reference/week3/` に残す模範実装は **Gazebo Fortress + ros_gz_bridge を可能な範囲で実走** (Sandbox Bridge Role Owner Stretch 案内)。**MuJoCo / ManiSkill / Isaac の hands-on は SP3 全員ベースラインに含めない** (SP5 Sim Role / Sandbox Bridge Role Owner Stretch で扱う)。

### 1.2 SP1/SP2 からの継承 (新規設計しないもの)

| 継承項目 | SP1/SP2 で確立済 | SP3 で利用 |
|---|---|---|
| リポジトリ階層 | `course/`, `sandbox_reference/`, `tools/`, `docs/` | `course/week3/` を追加 |
| 命名規約 (Lecture `l<n>`, Lab `lab<n>[a-z]?`) | CONVENTIONS.md §1 | L5/L6, Lab5/Lab6/Lab6b を新設 |
| 共通 front matter (10キー) + type別マトリクス | CONVENTIONS.md §2 | template/lecture/lab/reference/week すべてに適用 |
| Codex 統合パターン (Lab Xb 共通セクション) | CONVENTIONS.md §6 | Lab 6b で **2 回目の本格運用** (Lab 4b 型 + schema 整合性 レビュー観点追加) |
| .gitignore / Lab 成果物 commit ルール | CONVENTIONS.md §3 | bridge YAML は軽量、`example_scene_packet.json` は教材内雛形 |
| references.md ID システム | docs/references.md (R-01〜R-39) | R-18〜R-25 を front matter で参照 |
| `tools/new_week_skeleton.sh` | 完成済 | **SP3 開始時に `bash tools/new_week_skeleton.sh 3`** |
| `tools/check_structure.sh` | G1/G2/G4/G5a 自動化 (SP2 で W2 拡張) | **SP3 完了時に再実行**、SP1+SP2+SP3 expected files 全件を検証 |
| `tools/verify_env.sh` | --week N モード対応 (SP2 で実装済) | SP3 で `--week 3` モードを追加 (Gazebo 必須に復活、MoveIt2 / ros2_control は SKIP に下げる) |
| `tools/codex_prompt_template.md` | 完成済 | **Lab 6b 入口で利用必須化** (Lab 4b 同型) |
| Lab 4b 禁止リストの基本セット | IK / KDL / URDF parsing / trajectory / controller 操作 / 安全判断自動化 | **Lab 6b にも適用 + 追加禁止** (実 simulator 起動、実 ros_gz_bridge 操作、Affordance 判定の自動化) |

### 1.3 SP3 で新規設計するもの

| 新規 | 内容 |
|---|---|
| Week 3 教材 (Lecture × 2, Lab × 3, Template × 2, Week README × 1) | L5 Gazebo Fortress + ros_gz_bridge、L6 4-simulator 用途差 + Sim Bridge の役割、Lab5 Gazebo 起動確認 + bridge YAML 設計、Lab6 schema mapping draft、Lab6b Codex no-op bridge stub、simulation_bridge_draft、simulator_decision_table、course/week3/README.md |
| Sandbox reference week3/ (13 ファイル) | 各 Lab の walk-through 軽量証跡 + 2 template 記入例 + codex_prompt_lab6b.md + bridge_stub.py + execution_log + example_scene_packet.json |
| `tools/verify_env.sh` の `--week 3` モード追加 | gz CLI (gz/ign いずれか) 必須、ros-humble-ros-gz package 必須、ros_gz_bridge binary (`ros2 pkg prefix ros_gz_bridge`) 必須、colcon 必須、MoveIt2 / ros2_control / Panda config は SKIP |
| `tools/check_structure.sh` 拡張 | EXPECTED_FILES に SP3 28 件追加、10キー必須対象に W3 追加、G4 patterns 53 件追加、`check_python_syntax` helper 新規 + `find sandbox_reference -name "*.py"` ループ追加 (W2 noop_logger.py + W3 bridge_stub.py 両方対象) |
| `README.md` (root) 更新 | SP3 行を「完了」に変更、`SP3 で何ができるか` 段落追加 |

### 1.4 SP3 で **作らない** もの (YAGNI 明示)

| 不作成 | 理由 |
|---|---|
| MuJoCo / ManiSkill / Isaac の install 手順 + hands-on | SP5 Sim Role / Sandbox Bridge Role Owner Stretch |
| 実 ros_gz_bridge で SP2 minimal_robot を Gazebo 上で動かす統合 | Sandbox Bridge Role Owner Stretch、Robot Adapter Role と統合する SP6+ |
| `<gazebo>` URDF extension 拡張、SDF world ファイル設計 | Sandbox Bridge Role Owner Stretch |
| WorldCPJ 本物の Affordance schema、candidate_set, scene_packet の確定 | WorldCPJ 本体プロジェクトのスコープ。SP3 は plan §8.3 の field 名を provisional schema として使う |
| Trial Sheet、Episode Record、Safety Checklist テンプレ | SP4 |
| Q1 Reduced Lv1 Execution Package | SP4 |
| W4 教材 (L7/L8, Lab7/8/8b) | SP4 |
| Gazebo Harmonic 移行 | SP6+ (Fortress EOL 2026-09 の手前) |

### 1.5 SP3 完了時の状態 (エンドステート)

- `course/week3/` 完成 (Lecture 2 + Lab 3 + Template 2 + README + sandbox_reference 13 件)
- `tools/verify_env.sh --week 3` PASS (Full SP3 gate)、または partial (sudo 不可環境では content complete として SP4 着手可)
- `tools/check_structure.sh` PASS (Python `py_compile` 含む)
- 全員ベースライン: Gazebo Fortress 起動確認 (Lab 5 = 環境依存 evidence) + 4-simulator 用途差理解 + WorldCPJ provisional schema 8 field draft (Lab 6 = schema design artifact) + Codex no-op bridge stub Python real execution PR レビュー一巡 (Lab 6b) + 自分の case 用 simulator 選択判断
- Sim Bridge / Sandbox Bridge Role Owner Stretch: 実 ros_gz_bridge 起動 + minimal_robot Gazebo 統合は Robot Readiness Mini Report 「次段階」欄で記録
- README.md `今後の予定` テーブルの SP3 行が完了状態に更新
- SP3 完了時 expected files: **100 件 (SP1+SP2 ベース 71 + SP3 新規 28 + plan 1)**
- Q1 reduced Lv1 W3 開始日 (2026-05-11) に間に合う
- SP4 (Logging / Eval / Safety + Q1統合) 着手準備完了

### 1.6 SP3 の難所 (事前対応)

| 難所 | SP3 対応 |
|---|---|
| Gazebo Fortress install (sudo password 必要) | SP2 と同じく sudo 不可環境では Lab 5 を hand-author fallback (spec §4.8 縮退ルール、SP2 で実証済). Real run は instructor 環境で sudo 利用可能になった時に上書き |
| WorldCPJ 本物の schema 未確定 | plan §8.3 の 8 field 名を provisional schema として使い、Course 独自 schema を発明しない |
| Lab 6 設計演習の評価難 | CHECKLIST で「8 field 各々を 1 行以上で **自分の case を埋めた** こと」を条件化、空欄 NG (Robot Readiness と同じパターン) |
| 4-simulator 用途差表の根拠 | 教育計画§4.4 + R-18〜R-27 の公式 docs を引用元、各 simulator のキー特性 (rendering / contact / parallel data / ROS 統合) を列挙、`simulator_decision_table_template.md` の column はその key 特性に対応 |

---

## 2. SP3 ファイル一覧

### 2.1 全件サマリ

**設計完了時点: 新規 28 / 修正 3 / 計 31 ファイル**。`writing-plans` skill 実行後に **plan ファイル 1 件追加** され、最終 SP3 着手時は新規 29 + 修正 3 = 32 ファイル。

現行 `main` は git ls-files = 71 ファイル (SP2 完了後)。SP3 design 完了時点で +28 新規 = 99、writing-plans 後に +1 plan = 100 ファイル。修正 3 件 (verify_env.sh / check_structure.sh / root README) は新規 count に含まない (上書き)。

### 2.2 新規ファイル詳細

#### A. Week 3 Lectures (2 ファイル)

| # | path | 種別 | 骨子 |
|---|---|---|---|
| 1 | `course/week3/lectures/l5_gazebo_fortress_ros2_bridge.md` | new | Gazebo Fortress 全体像 (sim-rendering/physics/sensor/transport)、`gz sim` CLI と起動確認、`ros_gz_bridge` の役割、bridge YAML 最小書き方 (`/clock` mandatory + `/joint_states` 概念例)、QoS / topic 名 mapping 注意点、Gazebo Fortress EOL (2026-09) と Harmonic 将来移行 (R-18, R-19) |
| 2 | `course/week3/lectures/l6_simulator_landscape.md` | new | 4-simulator 用途差: Gazebo / MuJoCo / ManiSkill / Isaac、各 simulator のキー特性、4×4 比較 table、Sim Bridge の役割 (Sim I/O ↔ WorldCPJ schema 翻訳層)、`simulator_decision_table` を埋めて自分の case を選ぶ判断練習 (R-18, R-20, R-21, R-22, R-23, R-24, R-25) |

#### B. Week 3 Labs (3 lab × 3 ファイル = 9 ファイル)

| # | path | 種別 | 骨子 |
|---|---|---|---|
| 3 | `course/week3/labs/lab5_gazebo_topic_bridge/README.md` | new | Gazebo CLI version 確認 (gz / ign 両系統 fallback) + GUI 起動確認 (X11 困難時 `--headless-rendering` または version 確認のみで合格可) + `bridge_config.yaml` 写経 (`/clock` mandatory + `/joint_states` 概念コメントアウト併記) + Stretch real `ros_gz_bridge` |
| 4 | `course/week3/labs/lab5_gazebo_topic_bridge/CHECKLIST.md` | new | mandatory 4 項目 (gz version / GUI 起動 / bridge_config.yaml 写経 / `/joint_states` 概念例として理解) + Stretch 3 項目 |
| 5 | `course/week3/labs/lab5_gazebo_topic_bridge/HINTS.md` | new | 6 項目 (gz install 失敗 / gz vs ign / X11 困難時 / bridge YAML mapping / Stretch robot model 拡張 / `/clock` paused 状態の対処 — Play ボタン or `-r` flag) |
| 6 | `course/week3/labs/lab6_sim_to_worldcpj_schema/README.md` | new | plan §8.3 provisional schema の 8 field を自分の MS Lv1 / CC Gate 0-a 想定 case で埋める設計演習。教材内に「埋め方ガイド」 + sample case (Panda demo with mock_hardware) 提示、`simulation_bridge_draft_template.md` を Sandbox にコピーして 8 field 全埋め |
| 7 | `course/week3/labs/lab6_sim_to_worldcpj_schema/CHECKLIST.md` | new | 4 項目 (Sandbox commit / 8 field すべて 1 行以上記入 (空欄 NG、未確定 OK) / 自分の sample case を 1 行で書ける / WorldCPJ 本物 schema は SP4-5 / Q1 後半で確定する旨理解) |
| 8 | `course/week3/labs/lab6_sim_to_worldcpj_schema/HINTS.md` | new | 3 項目 (provisional schema field の Sandbox 内記述例 / 自分の case 流用案内 / WorldCPJ 本体 schema 確定タイミング) |
| 9 | `course/week3/labs/lab6b_codex_noop_bridge_stub/README.md` | new | 冒頭に禁止リスト (Lab 4b 流用 + 追加: 実 simulator 起動 / 実 ros_gz_bridge 操作 / Affordance 判定自動化) + Codex 利用ガイド + prompt 5 項目 + 6 step 手順 (prompt 記入 / Codex 依頼 / diff 確認 / Python 実行 + log 取得 / Sandbox PR Review Notes 記入 + schema 整合性確認 / PR 作成) + `example_scene_packet.json` 教材内雛形 |
| 10 | `course/week3/labs/lab6b_codex_noop_adapter_logger/CHECKLIST.md` | new | 8 項目 (prompt 5 項目記述 / Codex diff 読了 / `python3 bridge_stub.py example_scene_packet.json` exit code 0 / input 4 field の `recv field=` log 出力 / `python3 -m py_compile` 通る / Sandbox PR Review Notes 6 行記入 / schema 整合性確認 (input 4 field、output 4 field は本 stub 対象外) / 禁止リスト遵守人間確認) |
| 11 | `course/week3/labs/lab6b_codex_noop_bridge_stub/HINTS.md` | new | 5 項目 (Codex 接続再確認 / Python syntax check `python3 -m py_compile` / JSON file load の最小実装 / schema 整合性チェックの観点 (input 4 field のみ、output 4 field は対象外) / 禁止語含有時の対処 (rclpy / KeyboardInterrupt も「不要として採用しない」)) |

#### C. Week 3 Templates (2 ファイル)

| # | path | 種別 | 骨子 |
|---|---|---|---|
| 12 | `course/week3/deliverables/simulation_bridge_draft_template.md` | new | plan §8.3 の 8 field md table 化 (input: scene_packet / robot_state / candidate_set / action_intent、output: observation / execution_result / failure_reason / metrics)、各行の埋め方ガイド、空欄 NG (Robot Readiness と同じパターン)、Sample case 欄 + 自由記述 (詰まった点 / 次に試したいこと / WorldCPJ 本物 schema 確定への接続) |
| 13 | `course/week3/deliverables/simulator_decision_table_template.md` | new | 4-simulator (Gazebo / MuJoCo / ManiSkill / Isaac) × 4 軸 (rendering / contact / parallel data / ROS 統合) 比較 table + 自分の case 用「私の case = …」「選んだ simulator = …」「選んだ理由 = …」 |

#### D. Week 3 README (1 ファイル)

| # | path | 種別 | 骨子 |
|---|---|---|---|
| 14 | `course/week3/README.md` | new | front matter (`type: week, week: 3`)、目的 (3 本柱: Gazebo 起動確認 + provisional schema 設計演習 + Codex no-op bridge stub PR レビュー)、所要時間目安、Lecture / Lab / Template 一覧、合格条件サマリ (教育計画§4.4 末尾)、参照、Stretch goal 案内 (Sim Bridge / Sandbox Bridge Role Owner) |

#### E. Sandbox Reference Week 3 (13 ファイル)

| # | path | 種別 | 骨子 |
|---|---|---|---|
| 15 | `sandbox_reference/week3/simulation_bridge_draft_example.md` | new (`type: reference` 10キー) | instructor case (Panda demo + mock_hardware を sample case として 8 field 全埋め) |
| 16 | `sandbox_reference/week3/simulator_decision_table_example.md` | new (`type: reference` 10キー) | 4-simulator × 4 軸比較 table 記入例 + instructor 自身の選択 (Course 教材開発 case → Gazebo 第一選択、ManiSkill は Q1 後半 RL 検討時) |
| 17 | `sandbox_reference/week3/lab5/README.md` | new (`type: reference` 10キー) | Lab 5 walk-through summary、instructor case 注記 (Gazebo install 状況、X11 利用可否) |
| 18 | `sandbox_reference/week3/lab5/bridge_config.yaml` | new (front matter なし) | `ros_gz_bridge` YAML (`/clock` mandatory + `/joint_states` 概念コメントアウト併記)、教材内 Lab 5 雛形と同内容 |
| 19 | `sandbox_reference/week3/lab5/bridge_run.log` | new (front matter なし) | wrapper logging で「starting parameter_bridge for /clock」明示行 + parameter_bridge 起動時の出力 (real run なら実出力、hand-author なら仕様準拠) |
| 20 | `sandbox_reference/week3/lab5/bridge_topic_list.txt` | new (front matter なし) | bridge 起動後の `ros2 topic list` 出力 + `timeout 5s ros2 topic echo /clock --once` 出力 (hang 防止のため timeout 付き) |
| 21 | `sandbox_reference/week3/lab6/README.md` | new (`type: reference` 10キー) | Lab 6 walk-through summary、instructor が Panda demo + mock_hardware case で provisional schema 8 field を埋めた経緯 |
| 22 | `sandbox_reference/week3/lab6/scene_packet_design.md` | new (`type: reference` 10キー) | instructor の埋めた provisional schema draft (8 field 全埋め) |
| 23 | `sandbox_reference/week3/lab6b/README.md` | new (`type: reference` 10キー) | Lab 6b walk-through summary、instructor case (Codex 利用なし、prompt 5 項目に従って手書き、Lab 4b 同型運用) |
| 24 | `sandbox_reference/week3/lab6b/codex_prompt_lab6b.md` | new (`type: reference` 10キー) | prompt 5 項目記入例 (目的: provisional schema input 4 field を JSON file から読んで INFO log 出力、入力: example_scene_packet.json、制約: Python 3.10 + json + sys + 禁止リスト + 追加禁止、成功条件: exit code 0 + input 4 field log + py_compile 通る、検証コマンド) + 禁止リスト言及 |
| 25 | `sandbox_reference/week3/lab6b/example_scene_packet.json` | new (front matter なし) | provisional schema input 4 field を realistic に埋めた sample JSON (Panda demo + mock_hardware case) |
| 26 | `sandbox_reference/week3/lab6b/bridge_stub.py` | new (front matter なし) | finite script 手書き実装 (~30-40 行 Python)、`json.load` で example_scene_packet.json を読み、各 field 名 + 型 + value を `recv field=<name> type=<type> value=<value>` INFO log 出力、return 0 で正常終了 |
| 27 | `sandbox_reference/week3/lab6b/execution_log.txt` | new (front matter なし) | REAL Python 実行ログ (`python3 bridge_stub.py example_scene_packet.json` を実走) — 起動行 + input 4 field 各々の `recv field=` 行 |

#### F. Tool 拡張 (2 ファイル修正)

| # | path | 種別 | 修正内容 |
|---|---|---|---|
| 28 | `tools/verify_env.sh` | modify | **`--week 3` モード追加**: gz CLI 必須 (gz または ign のいずれか OK)、`ros-humble-ros-gz` package 必須、`ros2 pkg prefix ros_gz_bridge` で binary 解決必須、MoveIt 2 / ros2_control / ros2_controllers / Panda config は SKIP (SP2 で扱った)、colcon は依然必須 |
| 29 | `tools/check_structure.sh` | modify | `EXPECTED_FILES` に SP3 28 件 (#1-27 + 本spec) を追加。10キー必須対象 (COURSE_TEN_KEY_FILES) に W3 lecture/lab/template/sandbox_reference 系を追加。G4 patterns 53 件追加 (§5.2)。新 helper `check_python_syntax` 追加 + `find sandbox_reference -name "*.py"` ループで W2 noop_logger.py + W3 bridge_stub.py 両方を `python3 -m py_compile` 検査 |

#### G. Root 更新 (1 ファイル修正)

| # | path | 種別 | 修正内容 |
|---|---|---|---|
| 30 | `README.md` (root) | modify | `今後の予定` テーブルの SP3 行を「**完了 (Week 3 — Simulation Bridge)**」に変更、`SP3 で何ができるか` 段落追加 (3 本柱: Gazebo 起動確認 / provisional schema 設計演習 / Codex no-op bridge stub レビュー) |

#### H. Spec + Plan (1 新規 + 1 後工程)

| # | path | 種別 | 内容 |
|---|---|---|---|
| 31 | `docs/superpowers/specs/2026-04-28-robotics-course-sp3-design.md` | new | 本文書 |
| (後工程) | `docs/superpowers/plans/2026-04-28-robotics-course-sp3-plan.md` | new (writing-plans skill で生成) | SP3 design 完了後、別 skill で生成 |

### 2.3 ファイル数集計

| 区分 | 新規 | 修正 |
|---|---|---|
| A. Lectures | 2 | 0 |
| B. Labs | 9 | 0 |
| C. Templates | 2 | 0 |
| D. Week README | 1 | 0 |
| E. Sandbox reference | 13 | 0 |
| F. Tools | 0 | 2 |
| G. Root/docs | 0 | 1 |
| H. Spec | 1 | 0 |
| **合計 (design 完了時点)** | **28 新規** | **3 修正** |
| (writing-plans 後追加) | +1 plan | — |

### 2.4 SP3 で **作らない** もの (再確認)

セクション 1.4 と整合。

---

## 3. Lecture / Lab / Template 内容仕様

### 3.1 L5 (Gazebo Fortress + ros_gz_bridge) 内容不変条件

`course/week3/lectures/l5_gazebo_fortress_ros2_bridge.md` (~150-180 行目安)

8 sections + 次のLab:
1. 目的: Gazebo Fortress を ROS 2 連携 + robot model 検証の場として理解、`ros_gz_bridge` は gz topic ↔ ROS topic の翻訳層
2. Gazebo Fortress 全体像 (sim-rendering / physics / sensor / transport)、Mermaid 流れ図
3. gz CLI 最低操作 (`gz sim --version`、`gz sim shapes.sdf`、`gz topic -l`、`--headless-rendering`)
4. ros_gz_bridge の役割 (gz transport ↔ ROS 2 topic 双方向 mapping、parameter_bridge 実体)
5. bridge YAML 最小書き方 (`/clock` mandatory + `/joint_states` 概念コメントアウト併記)
6. QoS / topic 名 mapping 注意点
7. Gazebo Fortress EOL (2026-09) + Harmonic 将来移行 (SP6+)
8. よくある誤解 (3 件)

References: R-18, R-19

### 3.2 L6 (4-simulator landscape + Sim Bridge の役割) 内容不変条件

`course/week3/lectures/l6_simulator_landscape.md` (~180-220 行目安)

9 sections + 次のLab:
1. 目的
2. Gazebo (要約、詳細は L5)
3. MuJoCo (軽量接触/制御/学習実験、Python API、ROS 2 統合は薄い)
4. Isaac Sim / Lab (高忠実度 rendering + synthetic data + large-scale RL、**インストールサイズが大きい / NVIDIA stack 依存が強い**、Robot Learning Watch 教材)
5. ManiSkill (manipulation benchmark + parallel data 収集、GPU、SP5 Sim Role hands-on 候補)
6. 4×4 比較 table
7. Sim Bridge の役割 (Sim I/O ↔ WorldCPJ schema 翻訳層)
8. `simulator_decision_table` を埋める判断練習
9. よくある誤解

References: R-18, R-20, R-21, R-22, R-23, R-24, R-25

### 3.3 Lab 5 (Gazebo + ros_gz_bridge YAML) 内容不変条件

**README 必須内容**:

- 前提: SP1 setup + `bash tools/verify_env.sh --week 3` PASS
- 手順 (4 step):
  1. **Gazebo CLI version 確認** — `gz sim --version` または `ign gazebo --version` (Fortress 過渡期両系統 OK)
  2. **Gazebo GUI 起動確認** — `gz sim shapes.sdf` または `ign gazebo shapes.sdf`、X11 困難時 `--headless-rendering` または version 確認のみで合格可
  3. `bridge_config.yaml` を Sandbox に作成 — 教材雛形写経 (`/clock` mandatory + `/joint_states` 概念コメントアウト併記)
  4. (Stretch) 実 `ros_gz_bridge` で `/clock` 起動: `ros2 run ros_gz_bridge parameter_bridge --ros-args -p config_file:=$(pwd)/bridge_config.yaml` + `ros2 topic list` 確認
- 提出物: `bridge_config.yaml` (Sandbox commit)、Stretch なら `bridge_run.log` + `bridge_topic_list.txt`
- bridge_config.yaml 教材内雛形:

```yaml
# /clock (mandatory)
- ros_topic_name: "/clock"
  gz_topic_name: "/clock"
  ros_type_name: "rosgraph_msgs/msg/Clock"
  gz_type_name: "ignition.msgs.Clock"
  direction: GZ_TO_ROS

# /joint_states (Stretch、概念例 — joint を持つ robot model が必要)
# - ros_topic_name: "/joint_states"
#   gz_topic_name: "/world/default/model/<robot>/joint_state"
#   ros_type_name: "sensor_msgs/msg/JointState"
#   gz_type_name: "ignition.msgs.Model"
#   direction: GZ_TO_ROS
```

**CHECKLIST mandatory** (4 項目):
- [ ] Gazebo CLI version 取得 (`gz sim --version` **または** `ign gazebo --version`)
- [ ] Gazebo GUI 起動 (`gz sim shapes.sdf` **または** `ign gazebo shapes.sdf`、X11 困難時は `--headless-rendering` または version 確認のみで合格可)
- [ ] `bridge_config.yaml` を Sandbox に commit (教材雛形の `/clock` mandatory 部分を写経、`/joint_states` 概念例コメントアウト併記)
- [ ] `/joint_states` bridge は **概念例として理解** (実行は Stretch、joint を持つ robot model が必要)

**CHECKLIST Stretch** (3 項目、Sandbox Bridge Role Owner):
- [ ] joint を持つ robot model (例: SP2 minimal_robot を `<gazebo>` extension 拡張) を Gazebo で起動
- [ ] 実 `ros_gz_bridge` で `/clock` + (拡張なら) `/joint_states` mapping
- [ ] `ros2 topic list` で両 ROS topic 確認

**HINTS** (6 項目):
- gz install 失敗 (apt source `packages.osrfoundation.org`、SP1 setup 再実行)
- `gz` vs `ign` コマンド名差異 (Fortress 過渡期両系統 fallback)
- X11 forwarding 困難時 (`--headless-rendering` または version 確認のみで合格可)
- bridge YAML の `ros_topic_name` と `gz_topic_name` mapping ルール
- Stretch hands-on の robot model 拡張 (SP6+ または Sandbox Bridge Role Owner、`<gazebo>` URDF extension)
- **`/clock` が流れない (Stretch 実行時)**: Gazebo paused 状態 → GUI で **Play ボタン**、CLI で `gz sim -r shapes.sdf` (auto-run flag) または `ign gazebo -r shapes.sdf`、それでも厳しい場合は learner baseline は version + YAML 写経まで、`/clock` real-run は instructor sandbox_reference 側で取得

References: R-18, R-19

### 3.4 Lab 6 (Sim → WorldCPJ schema 設計演習) 内容不変条件

**README 必須内容**:

- 前提: L6 完了
- 手順 (4 step):
  1. `simulation_bridge_draft_template.md` を自 Sandbox にコピー
  2. plan §8.3 provisional schema 8 field を **自分の MS Lv1 / CC Gate 0-a 想定 case で埋める**
  3. 教材内「埋め方ガイド」 (各 field の意味と sample case の埋め方ヒント) を参照
  4. **8 field 全埋め** (空欄 NG、未確定なら「未確定 / SP4-5 で評価予定」可)
- 教材内 sample case: Panda demo + mock_hardware (SP2 で動かしたもの) を題材に、各 field の埋め方を 1 行ずつヒント提示
- 提出物: `simulation_bridge_draft.md` (Sandbox commit、8 field 全埋め)

**CHECKLIST** (4 項目):
- [ ] `simulation_bridge_draft.md` を Sandbox に commit
- [ ] **input 4 field すべて 1 行以上で記入** (`scene_packet`, `robot_state`, `candidate_set`, `action_intent`)
- [ ] **output 4 field すべて 1 行以上で記入** (`observation`, `execution_result`, `failure_reason`, `metrics`)
- [ ] 自分の sample case (例: Panda demo + mock_hardware、または独自 case) を 1 行で書ける、WorldCPJ 本物 schema の確定は SP4-5 / Q1 後半である旨理解

**HINTS** (3 項目):
- provisional schema 各 field の埋め方例
- 自分の case が思いつかない時: SP1 lab1 turtlesim、SP2 Panda demo、minimal_robot mock_hardware のいずれかを流用可
- WorldCPJ 本体での schema 確定は SP4 (Q1 終盤) または Q1 後半の Affordance schema 設計フェーズ

References: R-18 (Gazebo), 教育計画 §8.3

### 3.5 Lab 6b (Codex no-op bridge stub) 内容不変条件

**README 必須内容**:

- **冒頭に禁止リスト** (太字、Lab 4b 流用 + 追加):
  - 禁止 (Lab 4b 流用): IK 実装、KDL 導入、URDF parsing、trajectory 生成、controller 操作、安全判断自動化
  - **追加禁止 (Lab 6b 固有)**: 実 simulator 起動 (`subprocess` で `gz sim` 等の自動化)、実 `ros_gz_bridge` 操作、Affordance 判定の自動化
- Codex 利用ガイド (CONVENTIONS.md §6 共通テンプレ):
  - prompt 5 項目を `tools/codex_prompt_template.md` から複写
  - 委ねない判断: Affordance schema、評価指標、安全境界、実機投入可否
  - レビュー観点: diff summary / 動く根拠 / 壊れうる条件 / 採用しない提案 / 追加修正 + **schema 整合性** (Week 3 追加)
- 前提: Lab 6 完了 (provisional schema 理解)、W1 Lab 0 で Codex 接続確認済
- 手順 (6 step):
  1. prompt 5 項目を `wk3/lab6b/codex_prompt_lab6b.md` に書く
     - 目的: `example_scene_packet.json` (provisional schema **input 4 field**) を読み込み、各 field 名と型を INFO log 出力する no-op `bridge_stub.py`。**output 4 field は本 stub の対象外** (`simulation_bridge_draft.md` の設計対象、Lab 6 で扱った)
     - 入力: JSON file
     - 制約: Python 3.10 + json + sys 標準ライブラリのみ + 禁止リスト + 追加禁止
     - 成功条件: (1) `python3 bridge_stub.py example_scene_packet.json` が exit code 0 で正常終了、(2) input 4 field すべてについて `recv field=` log が出力される、(3) `python3 -m py_compile bridge_stub.py` が syntax error なく通る
     - 検証コマンド: 教材内 example_scene_packet.json で 1 回実行
  2. Codex に prompt → `bridge_stub.py` 生成
  3. diff 読了 (禁止リスト + 追加禁止の違反確認)
  4. `python3 bridge_stub.py example_scene_packet.json > execution_log.txt 2>&1; PY_EXIT=$?` 実行 + INFO log 取得
  5. Sandbox PR Review Notes (W2 template 流用) 6 行記入 + **schema 整合性確認** (input 4 field すべてが log に出ているか、output 4 field は本 stub では扱わない)
  6. PR 作成
- 教材内に `example_scene_packet.json` 雛形提示 (provisional schema input 4 field を埋めた sample JSON)

**CHECKLIST** (8 項目):
- [ ] prompt 5 項目を書いた
- [ ] Codex 出力 `bridge_stub.py` の diff を読んだ
- [ ] **`python3 bridge_stub.py example_scene_packet.json` が exit code 0 で正常終了**
- [ ] **input 4 field すべてについて `recv field=` log が出力される**
- [ ] **`python3 -m py_compile bridge_stub.py` が syntax error なく通る**
- [ ] Sandbox PR Review Notes 6 行すべて記入 (W2 template 流用)
- [ ] **schema 整合性確認**: provisional schema の input 4 field (`scene_packet`, `robot_state`, `candidate_set`, `action_intent`) すべてが log に出ている、**output 4 field は本 stub では扱わない** (`simulation_bridge_draft.md` の設計対象、Lab 6 で完了済)
- [ ] **禁止リスト遵守を人間が確認**: bridge_stub.py に IK / URDF parsing / trajectory / controller / 安全判断自動化 / 実 simulator / 実 ros_gz_bridge / Affordance 自動判定 の **実コード** がないことを目視確認 (コメント言及や "Does not start simulator" 等の説明文は OK)

**HINTS** (5 項目):
- bridge_stub.py は **finite script** (常駐 ROS node ではない)。`python3 bridge_stub.py example_scene_packet.json` で 1 回実行し JSON 1 ファイル分の log を出力して終了する設計。timeout 不要、Ctrl-C 不要
- Codex が `rclpy` import や `KeyboardInterrupt` 処理を含むコードを生成した場合 → **不要なため採用しない** (Notes 「採用しない提案」に記録)
- Python syntax check は `python3 -m py_compile bridge_stub.py`
- JSON file load の最小実装 (`with open(path) as f: data = json.load(f)`)
- schema 整合性チェックの観点 — 本 stub は **input 4 field のみ** を JSON load して INFO log 出力する設計。output 4 field は `simulation_bridge_draft.md` 設計演習 (Lab 6) で扱う対象であり、本 stub の実行対象外

References: R-33〜R-38 (Codex)

### 3.6 simulation_bridge_draft template 内容不変条件

`course/week3/deliverables/simulation_bridge_draft_template.md` (10キー、`type: template`)

**Template body**:
- 説明 (Lab 6 完了時に Sandbox にコピー、8 field を 1 行以上で記入、空欄 NG、未確定 OK)
- Sample case 欄 (1 行)
- 8 field md table:

| 区分 | field | 記入内容 |
|---|---|---|
| input | `scene_packet` | `<sensor 画像 / obstacle 一覧 / 環境状態 等>` |
| input | `robot_state` | `<joint angle / pose / 速度 / battery 等>` |
| input | `candidate_set` | `<把持候補 / 動作候補 一覧 (例: 6-DOF pose 列)>` |
| input | `action_intent` | `<選択された 1 候補 (例: 選んだ把持 pose)>` |
| output | `observation` | `<simulator から返す観測 (画像 / sensor / TF 等)>` |
| output | `execution_result` | `<success / fail boolean、または status enum>` |
| output | `failure_reason` | `<enum: collision / unreachable / timeout / etc.>` |
| output | `metrics` | `<task-specific KPI>` |

- 自由記述: `## 詰まった点`, `## 次に試したいこと`, `## WorldCPJ 本物 schema 確定への接続`
- 記入者・記入日

### 3.7 simulator_decision_table template 内容不変条件

`course/week3/deliverables/simulator_decision_table_template.md` (10キー、`type: template`)

**Template body**:
- 4 simulator × 4 軸 比較 table (Gazebo / MuJoCo / ManiSkill / Isaac × rendering / contact / parallel data / ROS 2 統合)
- 「私の case = …」「選んだ simulator = …」「選んだ理由 = …」記述欄
- Phase 0 後の宿題欄
- 記入者・記入日

### 3.8 Sandbox reference week3/ 内容仕様 (新規 13 ファイル)

主要 G4 patterns 確認用 (詳細 §5.2):

#### 3.8.1 lab6b/bridge_stub.py (~30-40 行 finite script)
- ヘッダコメントに「Does not start simulator. Does not run real ros_gz_bridge. Does not auto-judge Affordance.」明記
- `import json`, `import sys`、`json.load` で JSON file 読み込み、`recv field=<name> type=<type> value=<value>` 形式で INFO log 出力、`return 0` で正常終了

```python
#!/usr/bin/env python3
"""
no-op bridge stub. Finite script (not a long-running ROS node).
Loads JSON file (provisional schema input 4 fields only) and prints INFO log,
then exits with code 0.

Does not start simulator. Does not run real ros_gz_bridge.
Does not auto-judge Affordance.

Output 4 fields (observation/execution_result/failure_reason/metrics) are
the design target of simulation_bridge_draft.md (Lab 6) and out of scope
for this stub.
"""
import json
import sys


def main() -> int:
    if len(sys.argv) < 2:
        print("Usage: bridge_stub.py <example_scene_packet.json>", file=sys.stderr)
        return 2
    with open(sys.argv[1]) as f:
        data = json.load(f)
    print(f"bridge_stub started, loaded {sys.argv[1]}")
    for field, value in data.items():
        type_name = type(value).__name__
        print(f"recv field={field} type={type_name} value={value}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
```

### 3.9 言語規約 (CONVENTIONS.md §10 準拠)

- 散文は日本語、ファイル名・コード識別子・JSON field 名・branch 名・commit message は英語
- `bridge_stub.py` 内コメントは英語推奨
- README 内手順コマンド (`gz sim ...`, `python3 bridge_stub.py ...`) は当然英語
- bridge_config.yaml 内コメントは英語推奨

---

## 4. Sandbox Reference Walk-through Plan

### 4.1 SP3 着手前: instructor 環境セットアップ

```bash
sudo apt update
sudo apt install -y \
    gz-fortress \
    ros-humble-ros-gz \
    ros-humble-ros-gz-bridge

bash tools/verify_env.sh --week 3
```

期待: `verify_env.sh --week 3` で gz CLI + ros-humble-ros-gz + ros_gz_bridge binary + colcon + ROS 2 Humble 全 PASS、MoveIt 2 / ros2_control / Panda config は SKIP。

### 4.2 Lab 5 walk-through

#### 4.2.1 mandatory baseline

```bash
mkdir -p sandbox_reference/week3/lab5
source /opt/ros/humble/setup.bash

# version 確認 (gz / ign 両系統 fallback)
gz sim --version > sandbox_reference/week3/lab5/_gz_version.txt 2>&1 || \
ign gazebo --version > sandbox_reference/week3/lab5/_gz_version.txt 2>&1

# bridge_config.yaml は教材雛形と同内容を sandbox にコピー
# (内容は §3.3 に提示)
```

#### 4.2.2 instructor Stretch (real `/clock` bridge)

```bash
# Terminal 1: gz sim auto-run、gz / ign 両系統 fallback
(gz sim -r shapes.sdf > /tmp/gz_sim.log 2>&1 || \
 ign gazebo -r shapes.sdf > /tmp/gz_sim.log 2>&1) &
GZ_PID=$!
sleep 5

# Terminal 2: ros_gz_bridge を /clock 1 topic で起動
# wrapper で明示ログを bridge_run.log の冒頭に書き出し、parameter_bridge の stdout 不確実性を補完
{
    echo "starting parameter_bridge for /clock"
    echo "config_file=$(pwd)/sandbox_reference/week3/lab5/bridge_config.yaml"
    echo "ros2 run ros_gz_bridge parameter_bridge --ros-args -p config_file:=..."
    ros2 run ros_gz_bridge parameter_bridge \
        --ros-args -p config_file:=$(pwd)/sandbox_reference/week3/lab5/bridge_config.yaml
} > sandbox_reference/week3/lab5/bridge_run.log 2>&1 &
BRIDGE_PID=$!
sleep 5

# /clock が ROS 2 側に流れているか確認 (timeout 付き、hang 防止)
ros2 topic list | tee sandbox_reference/week3/lab5/bridge_topic_list.txt
timeout 5s ros2 topic echo /clock --once \
    >> sandbox_reference/week3/lab5/bridge_topic_list.txt 2>&1 || true

# Cleanup
kill "$BRIDGE_PID" 2>/dev/null || true
wait "$BRIDGE_PID" 2>/dev/null || true
kill "$GZ_PID" 2>/dev/null || true
wait "$GZ_PID" 2>/dev/null || true
```

#### 4.2.3 sudo 不可環境の縮退

SP2 同型: Lab 5 を hand-author ルートに切り替え、bridge_config.yaml は教材雛形コピー、bridge_run.log + bridge_topic_list.txt は仕様準拠 hand-author。README に instructor case 注記。

### 4.3 Lab 6 walk-through (Sim 不要)

```bash
mkdir -p sandbox_reference/week3/lab6
# scene_packet_design.md を作成 (8 field 全埋め draft、Panda demo + mock_hardware sample case)
```

### 4.4 Lab 6b walk-through (Sim 不要、Python finite script REAL run)

```bash
mkdir -p sandbox_reference/week3/lab6b

# Step 1: codex_prompt_lab6b.md 作成 (prompt 5 項目)
# Step 2: example_scene_packet.json 作成 (provisional schema input 4 field 例)
# Step 3: bridge_stub.py 手書き (Codex 出力擬似)
# Step 4: REAL Python execution
python3 sandbox_reference/week3/lab6b/bridge_stub.py \
    sandbox_reference/week3/lab6b/example_scene_packet.json \
    > sandbox_reference/week3/lab6b/execution_log.txt 2>&1
PY_EXIT=$?
echo "py_exit=$PY_EXIT"   # expect 0

# Step 5: 検証
grep -c "recv field=" sandbox_reference/week3/lab6b/execution_log.txt   # expect 4
python3 -m py_compile sandbox_reference/week3/lab6b/bridge_stub.py && echo "syntax OK"
```

### 4.5 simulation_bridge_draft example (sandbox_reference top level)

instructor case = Panda demo + mock_hardware を sample case として 8 field 全埋め (input 4 + output 4)。mock 環境では `failure_reason` `metrics` は `null` 等。

### 4.6 simulator_decision_table example (sandbox_reference top level)

instructor case = Course 教材開発 → Gazebo 第一選択 (ROS 2 統合標準、Q1 SP3 標準)、ManiSkill は Q1 後半 RL 検討 Stretch。

### 4.7 walk-through 依存関係

```mermaid
graph TD
    Setup[Task 0/1: Gazebo + ros_gz_bridge install + verify_env --week 2 → 3] --> Lab5[Lab 5 walk: gz version + bridge_config.yaml + Stretch /clock real run]
    Lab6[Lab 6 walk: scene_packet_design.md (Sim 不要)]
    Lab6b[Lab 6b walk: bridge_stub.py REAL run (Sim 不要、JSON file 入力)]
    Lab5 --> Templates[simulation_bridge_draft + simulator_decision_table example 記入]
    Lab6 --> Templates
    Lab6b --> Templates
```

### 4.8 失敗時の縮退

| 失敗 | 対応 |
|---|---|
| Gazebo apt install で error (sudo 不可) | Lab 5 全面 hand-author ルート、G3 partial 容認 |
| `gz sim shapes.sdf` GUI 不可 | `--headless-rendering` または version 確認のみで合格可 |
| `/clock` bridge real run で `/clock` が流れない | Gazebo paused → Play / `-r` flag、それでも不可なら learner baseline は YAML 写経まで、instructor sandbox_reference は hand-author |
| Lab 6b で Codex 利用不可 | instructor case 同様、prompt 5 項目を書いて手書き Python (Lab 4b と同型) |
| Lab 6b `bridge_stub.py` exit code 非ゼロ | JSON file path / format 確認、`json.JSONDecodeError` ならファイル内容確認 |

### 4.9 walk-through 完了の判定

instructor walk-through 完了 = `sandbox_reference/week3/` 配下の全 13 ファイルが commit され、`bash tools/check_structure.sh` が PASS。

G3 (`tools/verify_env.sh --week 3`) は instructor 環境次第:
- sudo 利用可 + Gazebo install 済 → G3 PASS (Full SP3 gate)
- sudo 不可 → G3 partial (content complete として SP4 着手可)

---

## 5. 検証 / SP3 → SP4 Transition

### 5.1 SP3 完了の正式判定基準 (5 ゲート)

| ゲート | 判定対象 | 判定方法 |
|---|---|---|
| **G1: 構造ゲート** | SP1+SP2+SP3 expected files (**71 + 28 + plan 1 = 100 ファイル**) すべて存在 | `bash tools/check_structure.sh` |
| **G2: 内容整合ゲート** | course/sandbox_reference の 10キー必須 / spec/plan 7キー / guide/checklist/hints 任意、参照先 ID 実在 | 同 lint |
| **G3: 環境ゲート** | `bash tools/verify_env.sh --week 3` で gz CLI + ros-humble-ros-gz + ros_gz_bridge binary + colcon 必須化、MoveIt 2 / ros2_control / Panda config は SKIP。**正式 SP3 完了 = G3 PASS**。sudo 不可環境では **G3 partial** を許容するが、**Full SP3 gate ではなく "content complete + G3 partial"** として完了報告に明記する。Full gate (G3 PASS) は instructor 環境で sudo 利用可能な状態で再実行することで取得 |
| **G4: 走破ゲート** | W3 全 Lab を instructor 自身が実行し、`sandbox_reference/week3/` に **期待ファイル + 内容パターン** | `tools/check_structure.sh` で内容パターンマッチ。G4 patterns **53 件追加** (§5.2) |
| **G5a: ローカルリンク** | 全 md の相対パス参照、anchor link が実在 | 同 lint |

### 5.2 G4 内容パターン検査の SP3 拡張一覧 (計 53 件)

注: 全 G4 patterns は `grep -qE` で評価。`|` はそのまま OR、dot は `[.]` でエスケープ。

```bash
# === Lab 5 (6 patterns) ===
check_pattern_must "sandbox_reference/week3/lab5/bridge_config.yaml" "ros_gz_bridge|ros_topic_name" "bridge YAML 構造"
check_pattern_must "sandbox_reference/week3/lab5/bridge_config.yaml" "/clock" "/clock mandatory bridge"
check_pattern_must "sandbox_reference/week3/lab5/bridge_config.yaml" "GZ_TO_ROS|direction" "bridge 方向指定"
check_pattern_must "sandbox_reference/week3/lab5/bridge_run.log" "ros_gz_bridge|parameter_bridge" "ros_gz_bridge 起動"
check_pattern_must "sandbox_reference/week3/lab5/bridge_run.log" "/clock" "/clock real run 証跡"
check_pattern_must "sandbox_reference/week3/lab5/bridge_topic_list.txt" "/clock" "/clock ROS 2 側到達"

# === Lab 6 (8 patterns、scene_packet_design.md 8 field 行ごと) ===
check_pattern_must "sandbox_reference/week3/lab6/scene_packet_design.md" "scene_packet" "scene_packet 行"
check_pattern_must "sandbox_reference/week3/lab6/scene_packet_design.md" "robot_state" "robot_state 行"
check_pattern_must "sandbox_reference/week3/lab6/scene_packet_design.md" "candidate_set" "candidate_set 行"
check_pattern_must "sandbox_reference/week3/lab6/scene_packet_design.md" "action_intent" "action_intent 行"
check_pattern_must "sandbox_reference/week3/lab6/scene_packet_design.md" "observation" "observation 行"
check_pattern_must "sandbox_reference/week3/lab6/scene_packet_design.md" "execution_result" "execution_result 行"
check_pattern_must "sandbox_reference/week3/lab6/scene_packet_design.md" "failure_reason" "failure_reason 行"
check_pattern_must "sandbox_reference/week3/lab6/scene_packet_design.md" "metrics" "metrics 行"

# === Lab 6b — example_scene_packet.json (4 patterns) ===
check_pattern_must "sandbox_reference/week3/lab6b/example_scene_packet.json" "scene_packet" "input field 1"
check_pattern_must "sandbox_reference/week3/lab6b/example_scene_packet.json" "robot_state" "input field 2"
check_pattern_must "sandbox_reference/week3/lab6b/example_scene_packet.json" "candidate_set" "input field 3"
check_pattern_must "sandbox_reference/week3/lab6b/example_scene_packet.json" "action_intent" "input field 4"

# === Lab 6b — bridge_stub.py (6 patterns) ===
check_pattern_must "sandbox_reference/week3/lab6b/bridge_stub.py" "json[.]load" "json.load (実コード)"
check_pattern_must "sandbox_reference/week3/lab6b/bridge_stub.py" "recv field=" "出力フォーマット固定"
check_pattern_must_not "sandbox_reference/week3/lab6b/bridge_stub.py" "subprocess" "禁止: subprocess"
check_pattern_must_not "sandbox_reference/week3/lab6b/bridge_stub.py" "os[.]system" "禁止: os.system"
check_pattern_must_not "sandbox_reference/week3/lab6b/bridge_stub.py" "KDL" "禁止: KDL"
check_pattern_must_not "sandbox_reference/week3/lab6b/bridge_stub.py" "controller_manager" "禁止: controller_manager"
# 注: IK / URDF / trajectory / 安全判断自動化 / 実 simulator / 実 ros_gz_bridge / Affordance 自動判定 は
#     ヘッダコメント誤検出回避のため自動 G4 から除外、Lab 6b CHECKLIST「禁止リスト遵守確認」項目で人間レビュー

# === Lab 6b — bridge_stub.py syntax (1 pattern) ===
check_python_syntax "sandbox_reference/week3/lab6b/bridge_stub.py" "py_compile"

# === Lab 6b — execution_log.txt (6 patterns、input 4 field 個別) ===
check_pattern_must "sandbox_reference/week3/lab6b/execution_log.txt" "recv field=scene_packet" "input 1: scene_packet log"
check_pattern_must "sandbox_reference/week3/lab6b/execution_log.txt" "recv field=robot_state" "input 2: robot_state log"
check_pattern_must "sandbox_reference/week3/lab6b/execution_log.txt" "recv field=candidate_set" "input 3: candidate_set log"
check_pattern_must "sandbox_reference/week3/lab6b/execution_log.txt" "recv field=action_intent" "input 4: action_intent log"
check_pattern_must "sandbox_reference/week3/lab6b/execution_log.txt" "bridge_stub" "起動確認"
check_min_size    "sandbox_reference/week3/lab6b/execution_log.txt" 200 "実行ログ最小サイズ"

# === Lab 6b — codex_prompt_lab6b.md (6 patterns、Lab 4b 同型) ===
check_pattern_must "sandbox_reference/week3/lab6b/codex_prompt_lab6b.md" "目的" "prompt5項目: 目的"
check_pattern_must "sandbox_reference/week3/lab6b/codex_prompt_lab6b.md" "入力" "prompt5項目: 入力"
check_pattern_must "sandbox_reference/week3/lab6b/codex_prompt_lab6b.md" "制約" "prompt5項目: 制約"
check_pattern_must "sandbox_reference/week3/lab6b/codex_prompt_lab6b.md" "成功条件" "prompt5項目: 成功条件"
check_pattern_must "sandbox_reference/week3/lab6b/codex_prompt_lab6b.md" "検証コマンド" "prompt5項目: 検証コマンド"
check_pattern_must "sandbox_reference/week3/lab6b/codex_prompt_lab6b.md" "禁止" "禁止リスト言及"

# === simulation_bridge_draft_example.md (8 patterns、8 field 行ごと) ===
check_pattern_must "sandbox_reference/week3/simulation_bridge_draft_example.md" "scene_packet" "input field 1"
check_pattern_must "sandbox_reference/week3/simulation_bridge_draft_example.md" "robot_state" "input field 2"
check_pattern_must "sandbox_reference/week3/simulation_bridge_draft_example.md" "candidate_set" "input field 3"
check_pattern_must "sandbox_reference/week3/simulation_bridge_draft_example.md" "action_intent" "input field 4"
check_pattern_must "sandbox_reference/week3/simulation_bridge_draft_example.md" "observation" "output field 1"
check_pattern_must "sandbox_reference/week3/simulation_bridge_draft_example.md" "execution_result" "output field 2"
check_pattern_must "sandbox_reference/week3/simulation_bridge_draft_example.md" "failure_reason" "output field 3"
check_pattern_must "sandbox_reference/week3/simulation_bridge_draft_example.md" "metrics" "output field 4"

# === simulator_decision_table_example.md (8 patterns、4 simulator + 4 軸 行ごと) ===
check_pattern_must "sandbox_reference/week3/simulator_decision_table_example.md" "Gazebo" "simulator 1"
check_pattern_must "sandbox_reference/week3/simulator_decision_table_example.md" "MuJoCo" "simulator 2"
check_pattern_must "sandbox_reference/week3/simulator_decision_table_example.md" "ManiSkill" "simulator 3"
check_pattern_must "sandbox_reference/week3/simulator_decision_table_example.md" "Isaac" "simulator 4"
check_pattern_must "sandbox_reference/week3/simulator_decision_table_example.md" "rendering" "軸 1"
check_pattern_must "sandbox_reference/week3/simulator_decision_table_example.md" "contact" "軸 2"
check_pattern_must "sandbox_reference/week3/simulator_decision_table_example.md" "parallel data" "軸 3"
check_pattern_must "sandbox_reference/week3/simulator_decision_table_example.md" "ROS 2 統合" "軸 4"
```

**G4 patterns 計 53 件**。

#### 新 helper: check_python_syntax

```bash
check_python_syntax() {
    local f="$1"
    local label="${2:-py_compile}"
    if [[ ! -f "$f" ]]; then
        warn "missing for python syntax check (covered by G1): $f"
        return
    fi
    if python3 -m py_compile "$f" 2>/dev/null; then
        ok
    else
        local err
        err=$(python3 -m py_compile "$f" 2>&1)
        err "Python syntax error: $f ($label)"
        printf "         %s\n" "$err"
    fi
}
```

`bash -n tools/*.sh` ループ (SP1) と並列に **Python `py_compile` ループ** を SP3 で追加:

```bash
echo
echo "==== Python syntax check on sandbox_reference/**/*.py (W2 + W3) ===="
while IFS= read -r py; do
    check_python_syntax "$py" "py_compile"
done < <(find sandbox_reference -name "*.py" 2>/dev/null)
```

対象範囲: `sandbox_reference/**/*.py`。**W2 `sandbox_reference/week2/lab4b/noop_logger.py` も対象** (SP2 で `python3 -m py_compile` PASS は実走で検証済、回帰防止になる)。W3 で追加される `sandbox_reference/week3/lab6b/bridge_stub.py` も含む。SP4 以降で更に Python ファイルが追加されたら自動的に対象拡大。

### 5.3 instructor Pre-flight (SP3 着手時の前提作業)

```bash
# 1. ROS 2 SP3 用パッケージ install — blocking (sudo 利用可能な instructor 環境の場合)
sudo apt update
sudo apt install -y \
    gz-fortress \
    ros-humble-ros-gz \
    ros-humble-ros-gz-bridge

# 2. tools/verify_env.sh の --week 3 モードを実装した上で実行 — blocking
bash tools/verify_env.sh --week 3

# 3. tools/check_structure.sh を SP3 expected files に拡張した上で実行 — 参考確認
bash tools/check_structure.sh || true

# 4. SP1/SP2 互換性回帰確認 — 参考確認、NON-BLOCKING
bash tools/verify_env.sh --week 2 || true
bash tools/verify_env.sh || true
```

#### sudo 不可環境の縮退 (SP2 同型)

instructor 環境で sudo 不可の場合の完了状態は **2 段階に分離**:

1. **Content complete**: G1, G2, G4, G5a すべて PASS、Lab 5 hand-author + Lab 6 design + Lab 6b real Python execution、教材生成は完了。SP4 brainstorming に進める状態。
2. **Full SP3 gate (G3 PASS)**: 上記 + `verify_env.sh --week 3` PASS。Gazebo + ros_gz_bridge install 済み instructor 環境で再実行することで取得。

Q1 W3 (2026-05-11 開始) スケジュール上、**1 (content complete)** で SP4 着手可能。**2 (Full gate)** は SP6+ または instructor 環境再構築時に達成。

### 5.4 自己検証 (instructor Pre-flight Lab 走破)

```
1. bash tools/check_structure.sh        # G1, G2, G4 patterns, G5a (W3 拡張版) — blocking
2. bash tools/verify_env.sh --week 3    # G3 (W3 モード正式判定) — blocking (sudo 不可なら partial 容認)
3. bash tools/verify_env.sh --week 2 || true   # SP2 互換性確認 — NON-BLOCKING
4. bash tools/verify_env.sh || true            # SP1 互換性確認 — NON-BLOCKING
5. course/week3/ をREADMEから順に読み、Lab 5/6/6b を §4 walk-through 手順で実走  # G4 本体
6. 外部URL link checker (lychee 等) を全md対象で実行    # G5b (warning扱い)
```

### 5.5 第三者検証 (任意、SP4 着手前推奨)

instructor 以外のチームメンバー 1 名に「未経験者役」で `course/week3/README.md` から走らせる:

| 観察項目 | 期待 | 失敗パターン |
|---|---|---|
| `apt install gz-fortress + ros-humble-ros-gz` が走る | YES (sudo 利用可) | apt source 不備 → SP1 setup 再実行 |
| Lab 5 で Gazebo CLI version が出る | YES | install 完全失敗 → Lab 5 hand-author ルート (CHECKLIST `version 確認のみで合格可`) |
| Lab 5 で `bridge_config.yaml` を写経できる | YES | 教材内雛形は YAML として正しい (R-19 docs 準拠) |
| Lab 6 で `simulation_bridge_draft.md` の 8 field を埋められる | YES | 自分の case が思いつかない → Panda demo / minimal_robot 流用 (HINTS 案内) |
| Lab 6b で `python3 bridge_stub.py example_scene_packet.json` が exit 0 + 4 field log | YES | env 不要、Python 3.10 + 標準ライブラリのみで完結 |
| Lab 6b で Codex (実環境) 利用可能 | YES (任意) | Codex 接続 NG → instructor case 同様 prompt 5 項目を書いて手書き |

### 5.6 SP3 着手後の主要リスクと対応

| リスク | 影響範囲 | 緩和策 |
|---|---|---|
| Gazebo apt install で error (sudo 不可、source 不備) | Task 1 setup | apt source 確認、SP1 setup 手順再実行。sudo 不可ならば Lab 5 hand-author ルート (SP2 で実証) |
| `gz` vs `ign` コマンド名差異 | Lab 5 | `verify_env.sh --week 3` の `check_either gz ign` で両系統 OK、Lab 5 README/CHECKLIST/HINTS でも両系統明記 |
| Lab 5 GUI 不可 | Lab 5 walk-through | `--headless-rendering` または version 確認のみで合格 |
| `/clock` Stretch real run で `/clock` が流れない | Lab 5 Stretch | Gazebo paused → Play / `-r` flag。それでも不可 → instructor sandbox_reference は hand-author |
| Lab 6 で 8 field を埋めるのに苦労 | Lab 6 walk-through | HINTS の埋め方例 + Panda demo / minimal_robot 流用案内、未確定 field は「未確定 / SP4-5 で評価予定」 |
| Lab 6b で Codex 利用が workspace 設定で実行不可 | Lab 6b 学習者環境 | instructor case と同様、prompt 5 項目を書いて手書き Python (Lab 4b 同型) |
| `bridge_stub.py` finite script の Codex 出力が `rclpy` import や `KeyboardInterrupt` 処理を含む | Lab 6b PR レビュー | 不要のため採用しない、Sandbox PR Review Notes 「採用しない提案」に記録 |
| `tools/check_structure.sh` への `check_python_syntax` 追加で **既存 W2 `sandbox_reference/week2/lab4b/noop_logger.py` も検査対象** | Task 2 拡張時 | SP2 完了時に noop_logger.py は `python3 -m py_compile` PASS 確認済、新 helper 追加で回帰防止になる。`find sandbox_reference -name "*.py"` で W2/W3 両方を自動カバー |

### 5.7 SP3 → SP4 移行ゲート

SP3 の 5 ゲート判定に加え:

| 項目 | 判定 |
|---|---|
| **Content complete** (G1/G2/G4/G5a PASS) | **必須** |
| **Full SP3 gate** (上記 + G3 PASS) | 推奨、sudo 不可環境では SP6+ 達成可 |
| ユーザーによる spec / 実装 / 完了報告のレビュー (G3 partial の事実明記) | 必須 |
| 本 spec が main に merge 済 | 必須 |
| `tools/new_week_skeleton.sh 4` で W4 雛形が即生成可能 | 必須 |
| `course/week3/README.md` が完成し W3 学習者導線が成立 | 必須 |
| `sandbox_reference/week3/` に **Lab ごとの適切な証跡** がある: | 必須 |
| &nbsp;&nbsp;&nbsp;&nbsp;Lab 5 = **環境依存 bridge evidence** (bridge_config.yaml + bridge_run.log + bridge_topic_list.txt、real run or hand-author) | 必須 |
| &nbsp;&nbsp;&nbsp;&nbsp;Lab 6 = **schema design artifact** (scene_packet_design.md、8 field 全埋め設計成果物、real execution は不要) | 必須 |
| &nbsp;&nbsp;&nbsp;&nbsp;Lab 6b = **Python real execution 証跡** (bridge_stub.py + execution_log.txt + codex_prompt + example_scene_packet.json、env 不要なため必ず real run) | 必須 |
| Q1 スケジュール (W3 = 2026-05-11 開始、W4 = 2026-05-18 開始) と SP4 着手日が整合 | 推奨 |
| SP4 brainstorming のための **SP3 失敗事例 / 改善メモ** が記録 | 推奨 |

### 5.8 SP3 失敗時の撤退基準

| 兆候 | 対応 |
|---|---|
| Gazebo install が dev 環境でどうしても失敗 | Lab 5 を全面 hand-author ルートに切替、G3 を「partial」と明示し SP6+ で Harmonic 移行検討時に再挑戦 |
| 実装ファイル数が 40 を超えそう | scope 縮小か SP3a / SP3b に分割 |
| Codex 連携の前提が変化 | Lab 6b と CONVENTIONS.md §6 の Week 3 行を更新 |
| `ros_gz_bridge` parameter_bridge の API が変化 | Lab 5 README / sandbox_reference bridge_config.yaml を更新、references.md R-19 最終確認日更新 |
| 教育計画原典に矛盾を発見 | 原典の修正 PR を別途作成、SP3 spec で「凍結」と注記 |

### 5.9 ユーザーレビューの観点

SP3 完了時点で見るべき 5 観点:

1. **学習者視点**: `course/week3/README.md` から始めて、未経験者が Lab 5/6/6b を 7 時間で走破できるか
2. **Phase 0 整合**: 教育計画 §4.4 表 (W3 合格条件 5 項目) を満たすか
3. **再利用性**: SP4 以降で同じ型を回せるか
4. **schema 設計の妥当性**: Lab 6 の `simulation_bridge_draft.md` が WorldCPJ 本体プロジェクトの将来 schema 確定 (SP4-5 / Q1 後半) と整合可能か
5. **コスト**: 28 新規 + 3 修正 = 31 ファイルが Q1 進行 (W3 = 2026-05-11) に間に合うか

### 5.10 SP3 完了で得られるもの (エンドステート再掲)

セクション 1.5 を最終確認:

- `course/week3/` 完成 (Lecture 2 + Lab 3 + Template 2 + README + sandbox_reference 13 件)
- `tools/verify_env.sh --week 3` PASS (Full SP3 gate)、または partial (sudo 不可環境では content complete として SP4 着手可)
- `tools/check_structure.sh` PASS (Python `py_compile` 含む)
- 全員ベースライン: Gazebo Fortress 起動確認 (Lab 5 = 環境依存 evidence) + 4-simulator 用途差理解 + WorldCPJ provisional schema 8 field draft (Lab 6 = schema design artifact) + Codex no-op bridge stub Python real execution PR レビュー一巡 (Lab 6b) + 自分の case 用 simulator 選択判断
- Sim Bridge / Sandbox Bridge Role Owner Stretch: 実 ros_gz_bridge 起動 + minimal_robot Gazebo 統合は Robot Readiness Mini Report 「次段階」欄で記録
- SP3 完了時 expected files: **100 件 (SP1+SP2 ベース 71 + SP3 新規 28 + plan 1)**
- Q1 reduced Lv1 W3 開始日 (2026-05-11) に間に合う
- SP4 (Logging / Eval / Safety + Q1統合) 着手準備完了

---

## 6. Decision Log (brainstorming合意履歴)

| # | 質問/Finding | 判断 | 反映先 |
|---|---|---|---|
| Q1 | ハンズオン野心度 | **B**: mock 中心 + Gazebo install/起動確認 + Lab 6 schema mapping 設計、実 bridge は Stretch | §1.1, §3.3, §4.2 |
| Q2 | Simulator scope | **B**: Gazebo 深 + 4-simulator用途差 table + simulator_decision_table 選択判断 | §1.4, §3.2, §3.7 |
| Q3 | WorldCPJ schema | **B**: plan §8.3 の 8 field を provisional schema として採用、Lab 6 = 設計演習 | §3.4, §3.6, §4.3 |
| Q4 | Codex Lab 6b | **A**: no-op JSON schema reader stub (`lab6b_codex_noop_bridge_stub`)、Lab 4b 同型 | §3.5, §4.4 |
| F1 (sec1) | mission 表現の精度 | (採用済、§1.1 に二軸方針明記) | §1.1 |
| F1 (sec2) | 累計ファイル数の式整合 | 71 + 28 = 99、plan 後 100 に統一 | §2.1, §5.1, §5.10 |
| F2 (sec2) | check_structure.sh 追加対象説明 | #1-27 + #31 spec = 28、plan は writing-plans 後 | §2.3 #29 |
| F3 (sec2) | Lab 5 mandatory evidence を `/clock` に限定 | `/joint_states` は概念例 / Stretch、shapes.sdf には joint なし | §3.3, §5.2 |
| F4 (sec2) | Lab 5 baseline と sandbox_reference 整合 | 学習者 baseline = YAML 写経まで、instructor sandbox_reference = `/clock` real run まで | §3.3, §4.2 |
| F5 (sec2) | verify_env.sh --week 3 で ros_gz_bridge 実体確認 | `ros2 pkg prefix ros_gz_bridge` 追加 | §2.3 #28, §4.1, §5.1 |
| F6 (sec2) | bridge_stub.py 禁止 patterns false positive | 自動 G4 = code-level only (subprocess / os.system / KDL / controller_manager)、概念語 (simulator / Affordance) は人間レビュー | §3.5, §3.8.1, §5.2 |
| F1 (sec3) | Lab 5 手順の gz / ign 二系統化 | 両系統 fallback で記述 | §3.3, §4.2 |
| F2 (sec3) | L6 references 漏れ | R-21 / R-23 を front matter に追加 | §3.2 |
| F3 (sec3) | Lab 6b 8 field / input 4 field 混乱 | 一貫して「input 4 field を読む stub、output 4 field は Lab 6 設計対象で stub 実行対象外」 | §3.5, §3.8.1 |
| F4 (sec3) | G4 regex の dot エスケープ | `json[.]load`, `os[.]system` | §3.8.1, §5.2 |
| F5 (sec3) | Isaac install size 数値削除 | 「インストールサイズが大きい」「NVIDIA stack 依存が強い」 | §3.2 |
| F1' (sec3) | Lab 5 HINTS に `/clock` paused 状態の対処 | Play ボタン / `-r` flag / learner baseline 縮退案内 | §3.3 HINTS |
| F2' (sec3) | Lab 6b finite script 化 | exit code 0 / input 4 field log / py_compile 通る、Ctrl-C 言及削除 | §3.5, §3.8.1, §4.4 |
| F1 (sec4) | bridge_stub.py 実行可能化 | dunder name / type_name 修正 | §3.8.1, §4.4 |
| F2 (sec4) | Lab 6b 実行コマンド改行修正 | バックスラッシュ継続、PY_EXIT 保存 | §4.4 |
| F3 (sec4) | codex_prompt_lab6b.md fenced code block 開閉 | heredoc 内 backslash escape | §4.4 |
| F4 (sec4) | exit code を Python 実行直後に保存 | `PY_EXIT=$?` を grep 前に取る | §4.4 |
| F5 (sec4) | Lab 5 Stretch gz / ign fallback | `(gz sim ... \|\| ign gazebo ...) &` | §4.2 |
| F6 (sec4) | `/clock` echo に timeout | `timeout 5s ros2 topic echo /clock --once ... \|\| true` | §4.2 |
| F7 (sec4) | Mermaid fence 閉じ | 開閉ペア明示 | §4.7 |
| F1 (sec5) | G4 patterns 数 (50 → 53) | execution_log.txt input 4 field 個別化で +3 | §5.1, §5.2 |
| F2 (sec5) | execution_log.txt 個別検査 | input 4 field 各々 must-check | §5.2 |
| F3 (sec5) | G3 PASS vs partial 整理 | Full SP3 gate (G3 PASS) と content complete + G3 partial を分離 | §5.1, §5.3, §5.7, §5.10 |
| F4 (sec5) | bridge_run.log wrapper logging | 明示 echo で確実な log 取得 | §4.2.2, §5.2 |
| F5 (sec5) | Python syntax check 対象範囲明確化 | `find sandbox_reference -name "*.py"` で W2 + W3 両方 | §5.2 helper note, §5.6 |
| F6 (sec5) | SP3→SP4 移行ゲート Lab 5/6/6b 性質別表現 | Lab 5 = 環境依存 evidence、Lab 6 = schema design artifact、Lab 6b = Python real execution | §5.7, §5.10 |

---

## 7. Open Questions / Future Work

SP3 スコープ外で、SP4 以降で扱う:

| 項目 | 想定対応SP |
|---|---|
| MoveIt 2 + Gazebo 統合 (`<gazebo>` URDF extension で minimal_robot を Gazebo 上に乗せる) | SP6+ または Sandbox Bridge Role Owner Stretch |
| URSim 実環境セットアップ (Robot Adapter Role Owner Stretch、SP2 で延期したもの) | SP5 |
| MuJoCo / ManiSkill / Isaac の hands-on | SP5 (Sim Role) |
| Trial Sheet / Episode Record / Safety Checklist テンプレ | SP4 |
| Q1 Reduced Lv1 Execution Package | SP4 |
| WorldCPJ 本物 Affordance schema 確定 + Course への反映 | WorldCPJ 本体プロジェクト + SP4-5 / Q1 後半 |
| Gazebo Fortress → Harmonic 移行レビュー | SP6+ (2026-09 EOL 前) |
| GitHub Actions CI 整備 | SP6+ |

---

## 8. 承認

| ロール | 承認 | 日付 |
|---|---|---|
| Brainstorming session | 全 5 セクション + 全 findings 反映 | 2026-04-28 |
| ユーザー最終レビュー | 未承認 (本spec commit後に依頼予定。承認時に `status: approved` へ更新) | 未確定 |

承認後、`writing-plans` skill で `docs/superpowers/plans/2026-04-28-robotics-course-sp3-plan.md` を生成する。
