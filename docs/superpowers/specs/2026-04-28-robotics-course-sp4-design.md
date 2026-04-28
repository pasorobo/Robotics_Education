---
type: spec
id: SPEC-SP4
title: Robotics Education Course - Sub-Project 4 (Week 4 Logging / Eval / Safety + Q1 Reduced Lv1 Execution Package) 設計書
date: 2026-04-28
status: approved
sub_project: SP4
related_plan: docs/superpowers/plans/2026-04-28-robotics-course-sp4-plan.md
---

# Robotics Education Course — SP4 設計書

## 0. メタ情報

| 項目 | 値 |
|---|---|
| Sub-Project | SP4 (Phase 0 4 週目、最終 regular SP) |
| Week scope | Week 4 (Logging / Evaluation / Safety + Phase 0 統合) |
| Phase 0 完了との関係 | 本 SP4 完了をもって Phase 0 教材は揃う。Phase 0 完了宣言は控えめに、Q1 移行条件 (safety review / pilot trial / re_judge_gates) を明示する |
| Q1 (縮小 Lv1) との関係 | Phase 0 教育の最終成果物として `q1_reduced_lv1_execution_package_template` を提供。本 template は Phase 0 → Q1 の handoff artifact 自体として機能 (formal handover ceremony は out-of-scope) |
| Implementation 方式 | Subagent-Driven Development (SP1-SP3 と同一)。約 18 tasks |
| commit identity | pasorobo / goo.mail01@yahoo.com (local config)、Co-Authored-By / Coding Agent 言及禁止 |

## 1. Goal

Phase 0 受講者が以下を獲得することを目的とする。

1. **rosbag2 + episode_record の理解**: 1 task attempt の構造化記録を書ける
2. **Safety SOP / safe no-action / operator confirmation の語彙獲得**: Phase 0 と Q1 の境界を理解する
3. **Q1 縮小 Lv1 Execution Package の作成能力**: W1-W3 で作った 3 templates を参照しながら、Q1 W1 開始前に必要な meta plan を書ける
4. **Sandbox 全体の最終レビューと Q1 移行教訓の言語化**: W1-W4 を振り返り、Q1 W1 開始時の注意点を 3+ 項目で残す

## 2. Scope

### 2.1 In scope (SP4 で扱うこと)

- L7 (rosbag2 + MCAP + episode_record concept)
- L8 (Safety SOP + safe no-action + Phase 0/Q1 境界)
- Lab 7 (episode_record 記入演習、SP1 W1 Lab 1 turtlesim bag 再利用)
- Lab 8 (Q1 Package + safety_checklist + trial_sheet skeleton 統合演習)
- Lab 8b (Sandbox 最終レビュー、Codex 利用は **任意**)
- 4 templates (`episode_record_template` / `trial_sheet_template` / `safety_checklist_template` / `q1_reduced_lv1_execution_package_template`)
- sandbox_reference/week4/ examples (positive 例 + 1 negative 例 + 任意 Codex pattern 例)
- `tools/verify_env.sh --week 4` mode
- `tools/check_structure.sh` の SP4 patterns 拡張 (mode 分岐 / negative-example handling / inline-code strip 方針更新)
- `docs/references.md` への R-28〜R-32 追記

### 2.2 Out of scope

#### Q1 execution
- 5 物体 × 3 trials の **実行** (Phase 0 では skeleton 作成のみ)
- 1 pilot trial の **実行** (Q1 W1 で実施)
- safety review **実施** (template 記入のみ、reviewer は Q1 W1 開始前に確定)
- SOP **承認** (現場責任者の責務)
- emergency drill / E-stop 実機テスト
- operator workflow の現場検証

#### ROS / robotics 機能
- MCAP plugin の **実 install + 録画** (Phase 0 Stretch、未 install で WARN のみ)
- `services` / `actions` recording (`ros2 bag` は topic recording のみ baseline)
- rosbag2 custom storage plugin 作成
- bag → 別 format 変換、bag replay の実行 (Lab 7 では `bag_info.txt` 参照のみ)

#### Traceability / linkage
- Q1 Package と外部 PM tool (Jira/Linear/Notion 等) の自動連携
- W1-W3 artifact と Q1 trial 結果の自動 join
- KPI dashboard / 可視化

#### 教育構造
- Phase 0 → Q1 の **正式 handover ceremony / handover document** (Q1 Package 自体が handoff artifact として機能)
- Role 別 track (Robot Adapter Role 専門 / Sim Bridge Role 専門 / Logging Role 専門) — SP5 (任意) 候補
- Phase 0 修了試験 / 認定
- 多言語化 (日本語 baseline + 英語 keys のみ)

## 3. Architecture overview

### 3.1 4 templates 階層分離

| Template | 責務 (source of truth) | 配置 |
|---|---|---|
| `episode_record` | 1 task attempt の構造化記録 (env / params / outcome / failure_reason / log path) | `course/week4/deliverables/episode_record_template.md` |
| `trial_sheet` | N trials の集計表 (1 row = 1 trial) | `course/week4/deliverables/trial_sheet_template.md` |
| `safety_checklist` | pre-execution safety 確認 (SOP 読解 / E-stop 認識 / operator 配置) | `course/week4/deliverables/safety_checklist_template.md` |
| `q1_reduced_lv1_execution_package` | **Q1 全体 scope / gate / owner / re_judge_gates の meta package** (他 3 templates をコピーせず参照型 traceability で束ねる) | `course/week4/deliverables/q1_reduced_lv1_execution_package_template.md` |

**Source of truth 表**:

| 情報 | source of truth | 参照先 |
|---|---|---|
| 1 episode 詳細 | `episode_record_template` | `trial_sheet` → `episode_id`、Q1 Package §6 |
| N trials 集計 | `trial_sheet_template` | Q1 Package §7 → `trial_sheet_id` |
| pre-execution safety 確認 | `safety_checklist_template` | Q1 Package §8 → `safety_check_id` |
| Q1 全体 scope / gate / owner | `q1_reduced_lv1_execution_package_template` | (top-level) |
| sandbox W1-W4 review + Q1 移行教訓 | `sandbox_review_summary` (Lab 8b 出力) | Q1 Package `phase0_review_summary_path` 明示 field で参照 |
| W1 環境設定 | `course/00_setup/` (SP1) | Q1 Package §3 |
| W2 Robot Adapter readiness | `robot_readiness_mini_report_template` (SP2) | Q1 Package §4 |
| W3 Sim Bridge schema | `simulation_bridge_draft_template` (SP3) | Q1 Package §5 |

### 3.2 Phase 0 → Q1 handoff の構造

Q1 Package は **data の copy ではなく `source_artifact_path` + `source_template` + `review_status` で参照する** 設計。これにより:

- 単一の data source per template (W2 Adapter readiness の真は SP2 template、Q1 Package はそれを指す)
- W1-W3 artifact 更新時に Q1 Package を全書き直しせずに済む
- Q1 Package は handoff artifact 自体として機能、別途 ceremony 文書は out-of-scope

### 3.3 共通 linkage keys (4 templates 横断)

| key | 範囲 | 値域 |
|---|---|---|
| `q1_package_id` | 全 4 templates | unique id, **`not_applicable`** (`artifact_status: sandbox_example` で許容) |
| `safety_check_id` | safety_checklist (root) + trial_sheet (parent) | unique id |
| `trial_sheet_id` | trial_sheet (root) + Q1 Package §7 | unique id, **`not_applicable`** (sandbox_example 許容) |
| `trial_id` | trial_sheet (per row) + episode_record (parent) | unique id, **`training_*`** prefix or **`not_applicable`** (sandbox_example 許容) |
| `episode_id` | episode_record (root) + trial_sheet (per row) | unique id |
| `object_id` | trial_sheet + episode_record | 5 物体 id, **`turtlesim_training_object`** / **`not_applicable`** (sandbox_example 許容) |
| `attempt_index` | trial_sheet + episode_record | 1-3 |
| `environment_mode` | episode_record + Q1 Package §3 | `mock` / `sim` / `real` |
| `adapter_version` | episode_record + Q1 Package §4 | `mock_adapter_v0` / `not_applicable` / `unknown` |
| `bridge_schema_version` | episode_record + Q1 Package §5 | `provisional_v1` / `not_applicable` / `unknown` |
| `log_path` | episode_record | external bag path |
| `evidence_path` | episode_record | sandbox_reference 内 lightweight 証跡 path |
| `commit_sha` | episode_record + Q1 Package | sandbox repo sha or `TBD` |
| `review_status` | safety_checklist + Q1 Package + episode_record | `not_reviewed` / `reviewed_with_conditions` / `approved` / `blocked` |
| `artifact_status` | 全 templates + sandbox examples (**body 配置、front matter ではない**) | `template` / `sandbox_example` / `q1_draft` / `q1_reviewed` / `q1_approved` / `intentionally_invalid_example` |
| `phase0_status` | safety_checklist | `training_draft_only` |
| `q1_blocker_if_unreviewed` | safety_checklist | `true` (Phase 0 default) |

**`artifact_status` ルール**:
- `sandbox_example` → `q1_package_id` / `trial_sheet_id` / `trial_id` / `object_id` を `not_applicable` または `training_*` 許容
- `q1_draft` 以降 → `q1_package_id` / `trial_id` / `object_id` は concrete value 必須

### 3.4 共通 taxonomies

- **result**: `success | failure | blocked | skipped | unknown`
- **failure_reason** (10 値 + `none`): `none | perception_failure | planning_failure | control_or_execution_failure | sim_bridge_failure | environment_or_setup_failure | safety_blocked | operator_error | logging_or_data_failure | unknown`
  - `result: success` → `failure_reason: none` 必須 (空欄 NG)
  - `result: failure/blocked/skipped` → taxonomy から選択 (`unknown` 容認)
- **trial_status**: `planned | executed | skipped | blocked`
- **environment_mode**:
  - `mock` = educational / no-robot execution (turtlesim 再利用含む)
  - `sim` = robot simulation (Gazebo-based 等)
  - `real` = real robot or operator-in-the-loop
- **stop_condition** (safety_checklist): `e_stop_not_verified | operator_not_present | sop_not_reviewed | workspace_not_cleared | unexpected_motion_or_command | other`
  - `other` 使用時は `other_stop_condition_detail` 空欄 NG

## 4. File list

### 4.1 設計時点 vs 実装完了時点の区別

| Stage | 新規 | 修正 | git ls-files 累計 |
|---|---|---|---|
| **SP3 完了直後** (現状) | — | — | 100 |
| **SP4 spec doc commit 直後** | +1 (本 spec のみ) | 0 | 101 |
| **SP4 plan doc commit 直後** | +1 (plan) | 0 | 102 |
| **SP4 implementation 完了** | +26 (course/sandbox) | 5 (modify、ファイル数は変わらず) | **128** |
| **planned delta 合計** | **28 new** (26 + spec + plan) | **5 modify** | 33 changed files |

### 4.2 新規 26 (course/week4/ + sandbox_reference/week4/)

#### course/week4/ (16 files)

```
course/week4/README.md                                           type: week
course/week4/lectures/l7_rosbag2_mcap_episode_record.md          type: lecture
course/week4/lectures/l8_safety_sop_safe_no_action.md            type: lecture
course/week4/labs/lab7_episode_record/README.md                  type: lab
course/week4/labs/lab7_episode_record/CHECKLIST.md               (G2 対象外)
course/week4/labs/lab7_episode_record/HINTS.md                   (G2 対象外)
course/week4/labs/lab8_q1_execution_package/README.md            type: lab
course/week4/labs/lab8_q1_execution_package/CHECKLIST.md         (G2 対象外)
course/week4/labs/lab8_q1_execution_package/HINTS.md             (G2 対象外)
course/week4/labs/lab8b_sandbox_final_review/README.md           type: lab
course/week4/labs/lab8b_sandbox_final_review/CHECKLIST.md        (G2 対象外)
course/week4/labs/lab8b_sandbox_final_review/HINTS.md            (G2 対象外)
course/week4/deliverables/episode_record_template.md             type: template
course/week4/deliverables/trial_sheet_template.md                type: template
course/week4/deliverables/safety_checklist_template.md           type: template
course/week4/deliverables/q1_reduced_lv1_execution_package_template.md  type: template
```

#### sandbox_reference/week4/ (10 files)

**Top-level examples (6)**:
```
sandbox_reference/week4/episode_record_example.md                         type: reference
sandbox_reference/week4/trial_sheet_example.md                            type: reference
sandbox_reference/week4/safety_checklist_example.md                       type: reference
sandbox_reference/week4/q1_reduced_lv1_execution_package_example.md       type: reference
sandbox_reference/week4/sandbox_review_summary_example.md                 type: reference
sandbox_reference/week4/bad_q1_package_example.md                         type: reference  (negative-example)
```

**Lab walk-through (3)**:
```
sandbox_reference/week4/lab7/README.md     type: reference
sandbox_reference/week4/lab8/README.md     type: reference
sandbox_reference/week4/lab8b/README.md    type: reference
```

**Optional Codex example (1)**:
```
sandbox_reference/week4/codex_pattern_extract_example.md     type: reference  (Lab 8b 任意)
```

### 4.3 修正 5 (G4 で内容追加検査、ファイル数変動なし)

```
README.md                       # Week 4 link 追加
course/README.md                # Week 4 entry 追加
tools/verify_env.sh             # --week 4 mode 追加
tools/check_structure.sh        # SP4 EXPECTED_FILES + G4 patterns + mode 分岐実装
docs/references.md              # R-28〜R-32 追加
```

## 5. Lecture content invariants

### 5.1 L7: rosbag2 + MCAP + episode_record

`course/week4/lectures/l7_rosbag2_mcap_episode_record.md` (~150 行)

| § | 必須内容 |
|---|---|
| 目的 | rosbag2 = ROS 2 標準 record/replay tool、MCAP = storage plugin、episode_record = 1 task attempt の構造化記録 |
| 1. rosbag2 全体像 | record / play / info、SP1 W1 Lab 1 で実走済、storage backend (default sqlite3 + MCAP option) |
| 2. SP1 W1 Lab 1 reuse | `sandbox_reference/week1/lab1/{bag_info.txt, rosbag_metadata.yaml, terminal_5min.log}` を Lab 7 で再利用、再録画不要 |
| 3. MCAP plugin | 概念紹介のみ (R-29)、`ros-humble-rosbag2-storage-mcap` install + `--storage mcap`、**Phase 0 では Stretch (install 任意)** |
| 4. episode_record の意味 | 1 task attempt = episode_record / N trials 集計 = trial_sheet (責務分離) |
| 5. bag → episode_record mapping | (a) Files / Bag size / Storage id → `log_summary` (b) Duration → `duration_sec` (c) Start / End が出力に含まれる場合のみ → `start_time` / `end_time` (d) Topic information → `recorded_topics` (e) raw bag は commit せず、`bag_info.txt` / `rosbag_metadata.yaml` / terminal log を `evidence_path` に格納 |
| 6. failure_reason taxonomy | §3.4 列挙、Phase 0 では `unknown` 容認 (空欄 NG)、`result` と分離 |
| 7. Humble baseline 注記 | `ros2 bag` は topic recording を扱う、MCAP install / MCAP recording は Stretch、`services/actions recording` は **Course baseline 範囲外** |
| 8. よくある誤解 | (1) bag commit (NG) (2) episode_record と trial_sheet 混同 (3) MCAP を Phase 0 必須と誤認 (4) Duration から start/end を推定 (NG) |

References: R-28, R-29

### 5.2 L8: Safety SOP + safe no-action + operator confirmation

`course/week4/lectures/l8_safety_sop_safe_no_action.md` (~180 行)

| § | 必須内容 |
|---|---|
| 目的 | Safety SOP の役割 + Phase 0 と Q1 の境界確定 |
| 1. SOP の役割 | 何を/誰が/どの順で/どう確認、責任者明示、現場固有性 |
| 2. emergency / safeguard / protective stop の運用区別 | **emergency stop = `last_resort` / `manual_reset_required` / `not_normal_stop` / `not_auto_resume`** (作動後 manual reset + visual assessment + power restore が必要、自動復帰しない、通常停止として使わない)。UR public manual: emergency stop is a complementary protective measure, NOT a safeguard. It is not designed to prevent injury. (R-30, R-31) safeguard = 外部入力 + 復旧可。protective = controller 自己判断 + 復旧可 |
| 3. safe no-action | 不確実時に何もしないのが default、判断不能時の fail-safe |
| 4. operator confirmation | 人による明示承認、大きい動作前の手動 ack。**operator confirmation は safety review や SOP approval の代替ではない。承認済み手順の中で特定動作に進む前の明示 ack として使う** |
| 5. SOP / safety_checklist / Q1 Package §safety の関係 | SOP = 現場手順書 / safety_checklist = pre-execution 確認表 (Phase 0 では training draft) / Q1 Package §safety = meta plan (両者参照 + go/no-go) |
| 6. Phase 0 と Q1 の Safety 境界 | **Phase 0 で扱う**: vocab / SOP draft 読解 / operator+reviewer+stop_condition 記入 / 禁止操作明示 / safe no-action default。**Phase 0 で扱わない**: 実 E-stop 機能 / 現場 SOP 承認 / 実機 trial 安全 / emergency drill |
| 7. 必須注意文 | 「UR safety references are used as instructional examples. Actual Q1 execution must follow the applicable robot model, site SOP, risk assessment, and responsible safety reviewer decision.」 + 「Phase 0 safety_checklist is not an approval artifact. It is a training draft + handoff artifact for Q1 safety review.」 |
| 8. ISO 10218-1/-2:2025 概要 | 産業ロボット + アプリケーションの安全要求事項。本 Course は overview 引用のみ、原文購入前提 (R-32) |
| 9. よくある誤解 | (1) emergency stop を通常停止に使う (2) Phase 0 safety_checklist を実機 OK と誤認 (3) operator confirmation で safety review を代替 |

References: R-30, R-31, R-32

**L8 must-not 規約**: L8 lecture 本文では `non-recoverable` という語を一切使わない (禁止理由は本 spec のみ記載)。`自動復帰` は `自動復帰しない` のみ許容、`自動復帰する` / `自動復帰できる` は禁止。

## 6. Lab content invariants

### 6.1 Lab 7 — episode_record 記入演習

**前提**: SP1 W1 Lab 1 完了、W4 L7 完了
**Q1 区別注記 (必須)**: README 冒頭で「Because this is a Phase 0 training episode, it is not counted as a Q1 CC Gate 0-a trial. Use `not_applicable` or `training_*` identifiers for Q1-specific linkage keys.」

**手順 (4 step)**:
1. `episode_record_template.md` を Sandbox `wk4/lab7/` にコピー
2. SP1 W1 Lab 1 turtlesim bag を題材に全 field 記入
3. 推奨 fixed values:
   ```
   q1_package_id: not_applicable
   trial_sheet_id: not_applicable
   trial_id: training_trial_w1_lab1_001
   object_id: turtlesim_training_object
   attempt_index: 1
   environment_mode: mock
   adapter_version: not_applicable
   bridge_schema_version: not_applicable
   result: success
   failure_reason: none
   evidence_path: sandbox_reference/week1/lab1/bag_info.txt
   log_path: <raw bag path>  # commit しない
   review_status: not_reviewed
   artifact_status: sandbox_example
   ```
4. Sandbox commit、bag commit 禁止

**CHECKLIST**: (1) template コピー全 field 記入 (2) `q1_package_id` / `trial_sheet_id` / `trial_id` / `object_id` を `not_applicable` または `training_*` で記入 (3) `evidence_path` で W1 bag_info.txt 参照 (4) `result: success` + `failure_reason: none` + `environment_mode: mock` + `bridge_schema_version: not_applicable` + `adapter_version: not_applicable` (5) failure_reason taxonomy 内から選択

**Lab 7 complete if**: episode_record exists / W1 lightweight evidence linked via `evidence_path` / `result` `failure_reason` non-empty / W1 turtlesim marked as training/mock not Q1 trial

### 6.2 Lab 8 — Q1 Package + safety_checklist + trial_sheet skeleton 統合

**前提**: W1-W3 全 Labs 完了、W4 L7/L8 完了

**手順 (6 step)**:
1. 3 templates を Sandbox `wk4/lab8/` にコピー
2. Q1 Package 8 行を W1-W3 templates 参照で fill (各行 `source_artifact_path` + `source_template` + `review_status`)
3. safety_checklist fill: `phase0_status: training_draft_only` / `q1_blocker_if_unreviewed: true` / `safety_owner: TBD` / `reviewer_name: TBD` / `reviewer_role: TBD` / `reviewed_at: TBD` / `review_status: not_reviewed`
4. trial_sheet を **15 planned rows skeleton** として作成 (5 objects × 3 trials、全 row `trial_status: planned` / `result: unknown` / `failure_reason: unknown` / `episode_id: TBD`)
5. `q1_w1_preflight` 8 項目記入
6. `re_judge_gates` **4 件** (`q1_w1_pre_start` / `q1_w1_exit` / `q1_mid_point` / `q1_closeout`) 記入

**CHECKLIST**: (1) Q1 Package 8 行 + 各行 `source_artifact_path` + `source_template` + `review_status` (2) コピーではなく **参照** (linkage keys 使用) (3) safety_checklist `review_status: not_reviewed` + `q1_blocker_if_unreviewed: true` (4) trial_sheet 15 planned rows (W1 turtlesim 等 training episode 混入禁止) (5) `q1_w1_preflight` 8 項目、5×3=15 trials 直行禁止 + 1 pilot 経由明示 (6) `re_judge_gates` 4 件 (7) Q1 W2+ detail は deferred 明示 (silent omission 禁止)

**Lab 8 complete if**: Q1 Package 8 rows reference W1-W3 artifacts / safety_checklist filled as `training_draft_only` / trial_sheet has 15 planned rows (no mixing) / `q1_w1_preflight` and `re_judge_gates` (4 件) explicit / Q1 W2+ deferred with decision gates

### 6.3 Lab 8b — Sandbox 最終レビュー (Codex 任意)

**README 冒頭**: 「Lab 8b の Codex 利用は **任意**」明示

**禁止リスト (Lab 8b 固有)**:
- 「Codex may summarize review notes that mention IK / KDL / URDF / trajectory / controller issues. **Codex must not implement, debug, scope-expand, or make execution/safety decisions** for those areas in Lab 8b.」
- 「Q1 縮小 Lv1 の scope 判断 (CC/MS どこまで、人協調/双腕入れるか) を Codex に委ねない」 (must not make scope decisions)

**手順 (4 step)**:
1. Sandbox W1-W4 全体を自己レビュー、`sandbox_review_summary.md` を `wk4/lab8b/` に作成
2. Phase 0 振り返り 5+ patterns (手書き、必須)
3. Q1 移行教訓 3+ items
4. (任意 Codex 補助) 累積 PR Review Notes pattern 抽出、accepted/rejected 分離記録

**CHECKLIST 出力 matrix**:

| 項目 | Codex 使用なし | Codex 使用あり |
|---|---|---|
| Human-found patterns (5+) | 必須 | 必須 |
| Codex-suggested patterns | **N/A 明示** | 必須 (3+) |
| Accepted / rejected suggestions | N/A | 必須 |
| Final review summary | 必須 | 必須 |
| Q1 migration lessons (3+) | 必須 | 必須 |
| Scope decision by human | 必須 | 必須 |

**Lab 8b complete if**: 5+ human-found patterns / 3+ Q1 migration lessons / Codex usage optional and clearly separated if used / scope decision explicitly human-owned

## 7. Template content invariants (4 templates)

### 7.1 episode_record_template

`course/week4/deliverables/episode_record_template.md` (`type: template`、10-key front matter)

**Body 必須 fields**:

```
artifact_status: template
episode_id: <unique id>
q1_package_id: <unique id | not_applicable>
trial_sheet_id: <unique id | not_applicable>
trial_id: <unique id | training_* | not_applicable>
object_id: <object_1..5 | turtlesim_training_object | not_applicable>
attempt_index: <1-3 | null>
environment_mode: <mock | sim | real>
adapter_version: <mock_adapter_v0 | not_applicable | unknown>
bridge_schema_version: <provisional_v1 | not_applicable | unknown>
log_path: <external bag path | not_applicable>
evidence_path: <sandbox_reference path | not_applicable>
commit_sha: <sandbox sha | TBD>
start_time: <ISO 8601 | TBD>
end_time: <ISO 8601 | TBD>
duration_sec: <float | TBD>
recorded_topics: <list | TBD>
result: <success | failure | blocked | skipped | unknown>
failure_reason: <none | <taxonomy> | unknown>
review_status: <not_reviewed | reviewed_with_conditions | approved | blocked>
notes: <自由記述>
```

**Rules**: `result: success` → `failure_reason: none` 必須。`evidence_path` は sandbox_reference 内 lightweight 証跡を指す、raw bag は commit しない。

### 7.2 trial_sheet_template

`course/week4/deliverables/trial_sheet_template.md` (`type: template`、10-key)

**Body 必須 fields**:

```
artifact_status: template
trial_sheet_id: <unique id>
q1_package_id: <unique id>
safety_check_id: <unique id>
batch_description: <"CC Gate 0-a 5 objects × 3 trials" 等>
total_planned_rows: 15
rows:
  - trial_id: trial_001
    object_id: <object_1..5>
    attempt_index: <1-3>
    trial_status: <planned | executed | skipped | blocked>
    result: <success | failure | blocked | skipped | unknown>
    failure_reason: <none | <taxonomy> | unknown>
    episode_id: <unique id | TBD>
    kpi_grasp_success: <bool | null>
    kpi_time_to_grasp_sec: <float | null>
    skip_or_block_reason: <string | "">
    notes: <自由記述>
  # template 本体は 1-2 row の構造例のみを示す。fully expanded 15 rows は
  # sandbox_reference/week4/trial_sheet_example.md に置く。
```

**Phase 0 用法**: 15 rows は **planned skeleton** として作成 (`trial_status: planned`、空欄 NG)。executed への更新には `episode_id` / `result` / `failure_reason` / log reference が必要。`skipped` / `blocked` 使用時は `skip_or_block_reason` 記入。

### 7.3 safety_checklist_template

`course/week4/deliverables/safety_checklist_template.md` (`type: template`、10-key)

**Body 必須 fields**:

```
artifact_status: template
safety_check_id: <unique id>
q1_package_id: <unique id>
session_description: <"Q1 W1 pilot trial" 等>
phase0_status: training_draft_only
q1_blocker_if_unreviewed: true
safety_owner: TBD
review_due: before_q1_w1_start
review_status: <not_reviewed | reviewed_with_conditions | approved | blocked>
reviewer_name: TBD
reviewer_role: <responsible_safety_reviewer | safety_owner | TBD>
reviewed_at: <ISO 8601 | TBD>
review_notes: ""
sop_reference:
  document_name: <name | TBD>
  document_path: <path | TBD>
  approval_status: <not_approved | approved | unknown>
operator:
  present: false
  name: TBD
  qualification: TBD
stop_condition:
  - e_stop_not_verified
  - operator_not_present
  - sop_not_reviewed
  - workspace_not_cleared
  - unexpected_motion_or_command
other_stop_condition_detail: ""
forbidden_operations:
  - id: <english_snake_case_id>
    description_ja: <現場 SOP との整合用日本語記述>
safe_no_action_conditions:
  - id: <english_snake_case_id>
    description_ja: <日本語記述>
review_log:
  - reviewer: TBD
    date: TBD
    decision: not_reviewed
    conditions: []
notes: <自由記述>
```

**Rules**: `review_status: approved` は `reviewer_name` / `reviewer_role` / `reviewed_at` が埋まっている場合のみ許可 (G4 で検査)。`stop_condition: other` 使用時は `other_stop_condition_detail` 空欄 NG。

### 7.4 q1_reduced_lv1_execution_package_template

`course/week4/deliverables/q1_reduced_lv1_execution_package_template.md` (`type: template`、10-key)

**Body 必須 fields** (8 行 meta + meta keys + preflight + gates):

```
artifact_status: template
phase0_handoff: true
q1_package_id: <unique id>
bridge_schema_version: <provisional_v1 | not_applicable | unknown>
q1_execution_mode: <mock | sim | real | operator_in_the_loop | TBD>
owner_role: <e.g., Q1 Reduced Lv1 planning owner>
next_decision_owner: <e.g., WorldCPJ Safety Role Owner>
phase0_review_summary_path: sandbox/wk4/lab8b/sandbox_review_summary.md
phase0_review_summary_status: <self_reviewed | reviewed_with_conditions | not_reviewed>
phase0_to_q1_handoff_note: |
  Formal handover ceremony/document is out of scope for Phase 0.
  This Q1 Reduced Lv1 Execution Package itself acts as the
  Phase 0 → Q1 handoff artifact.

rows:
  - row: 1_scope_lv1_boundary
    content: |
      対象: CC Gate 0-a (5 objects × 3 trials) + MS Lv1 (fixed observation baseline)
      非対象: 人協調 / 双腕 / マルチロボ / ベースライン再現多数
    source_artifact_path: docs/Robotics_simulation_phase0_education_plan.md#1
    source_template: <education plan §1>
    review_status: not_reviewed
  - row: 2_target_task_gate
    ...
  - row: 3_environment_stack
    source_artifact_path: course/00_setup/, sandbox_setup_log_example.md
    source_template: SP1 setup
    ...
  - row: 4_robot_adapter_readiness
    source_artifact_path: sandbox_reference/week2/robot_readiness_mini_report_example.md
    source_template: W2-T-ROBOT-READINESS
    ...
  - row: 5_simulation_bridge_status
    source_artifact_path: sandbox_reference/week3/simulation_bridge_draft_example.md
    source_template: W3-T-SIM-BRIDGE-DRAFT
    ...
  - row: 6_logging_episode_plan
    source_template: W4-T-EPISODE-RECORD
    ...
  - row: 7_trial_kpi_plan
    trial_sheet_id: <link>
    source_template: W4-T-TRIAL-SHEET
    ...
  - row: 8_safety_review_go_no_go
    safety_check_id: <link>
    source_template: W4-T-SAFETY-CHECKLIST
    ...

q1_w1_preflight:
  - tools/verify_env.sh --week 4 PASS (validates SP4 logging baseline; sim/real execution may need additional W2/W3 or Q1-specific checks)
  - ros2 doctor or documented equivalent environment smoke check
  - mock adapter no-op execution confirmed
  - required topics listed
  - rosbag2 minimal record confirmed for required topics
  - safety_checklist reviewed by responsible owner (review_status: approved)
  - 1 object × 1 pilot trial executed
  - pilot review COMPLETED before proceeding to 5 objects × 3 trials

re_judge_gates:
  - gate_id: q1_w1_pre_start
    purpose: Phase 0 成果物の Q1 移行可否確認
    decisions: [safety review approved, env smoke test passed, no-action dry run completed]
  - gate_id: q1_w1_exit
    purpose: 1 pilot trial 後の再判断
    decisions: [proceed from 1 pilot trial to 15 planned trials, continue pilot, replan]
  - gate_id: q1_mid_point
    purpose: W2 以降 detail の確定
    decisions: [update failure taxonomy / KPI / operator workflow]
  - gate_id: q1_closeout
    purpose: Lv1 継続可否
    decisions: [proceed to MS Lv1, revise Phase 0 artifacts, escalate]

free_text_section:
  open_questions: <記入欄>
  blockers_for_q1: <記入欄>
```

## 8. Sandbox reference content (10 files)

### 8.1 episode_record_example.md
SP1 W1 Lab 1 turtlesim bag 題材。`q1_package_id: not_applicable` / `trial_sheet_id: not_applicable` / `trial_id: training_trial_w1_lab1_001` / `object_id: turtlesim_training_object` / `environment_mode: mock` / `result: success` / `failure_reason: none` / `bridge_schema_version: not_applicable` / `adapter_version: not_applicable` / `evidence_path: sandbox_reference/week1/lab1/bag_info.txt`

### 8.2 trial_sheet_example.md
**15 rows すべて planned** (`trial_status: planned` / `result: unknown` / `failure_reason: unknown` / `episode_id: TBD`)。W1 turtlesim training episode は **混入禁止**、別 section に「executed row example only — NOT a Q1 CC Gate 0-a trial」として分離記載。

### 8.3 safety_checklist_example.md
`phase0_status: training_draft_only` / `q1_blocker_if_unreviewed: true` / `safety_owner: TBD (Q1 W1 開始前に WorldCPJ Safety Role Owner と決定)` / `review_status: not_reviewed` / `reviewer_name: TBD` / `reviewer_role: TBD` / `reviewed_at: TBD`。stop_condition の named 5 項目 enabled、`other` 未使用。`forbidden_operations[].id` 英語、`description_ja` 日本語。

### 8.4 q1_reduced_lv1_execution_package_example.md
instructor case = **Q1 Reduced Lv1 planning owner for Course / Robot Adapter / Sim Bridge integration**。8 行 fill、各行 W1-W3 artifacts 参照、`q1_w1_preflight` 8 項目、`re_judge_gates` **4 件**、`bridge_schema_version: provisional_v1` / `q1_execution_mode: TBD` / `phase0_handoff: true` / `phase0_review_summary_path` 記入。

### 8.5 sandbox_review_summary_example.md
Lab 8b instructor case (Codex 利用なし、自己レビュー手書き)。W1-W4 振り返り 5+ patterns + Q1 移行教訓 3+ + scope 判断 (人間 100%)。「Codex 補助使った場合」「使わなかった場合」両 column、利用なし case で `Codex-suggested patterns: N/A` 明示。

### 8.6 bad_q1_package_example.md (negative example)
`artifact_status: intentionally_invalid_example` + `do_not_copy: true`。冒頭「不採用例」太字。bad pattern 4 件: (1) safety review marked done without reviewer (2) trial_sheet copies template content (3) Q1 W2-W3 omitted without re_judge_gates (4) Codex accepted without rationale。**positive G4 patterns 除外** + **negative-example 専用 G4 patterns で検査**。dead link は Markdown link にせず plain text placeholder で書く (`source_artifact_path: missing/path/example.md  # intentionally invalid`)。

### 8.7 lab7/README.md, lab8/README.md, lab8b/README.md
walk-through summary + instructor case 注記

### 8.8 codex_pattern_extract_example.md (任意)
任意 Codex 利用 example、instructor case では「もし Codex を使うなら」の擬似例。

## 9. Validation Gates (G1-G5a) extension specs

### 9.1 G1 (file existence)

`tools/check_structure.sh` の `EXPECTED_FILES` 配列に **26 + 1 (spec) + 1 (plan) = 28 entries** 追加。

検証 timing による期待 file 数:

| Stage | EXPECTED_FILES に含まれる SP4 files | G1 PASS 条件 |
|---|---|---|
| Spec doc commit 直後 | spec のみ (1) | spec 存在 |
| Plan doc commit 直後 | spec + plan (2) | 2 file 存在 |
| Implementation 完了 | 28 files 全て | 全 file 存在 |

**実装方針**: T2 (validation framework extension) では SP4 EXPECTED_FILES 全件追加せず、各 task 完了時に該当 file を順次追加するか、**T16/T17 で SP4 strict pattern set を最終有効化** する 2 段階方式を採る (Section 11.2 参照)。

### 9.2 G2 (front matter)

既存 G2 実装の二系統を継続:

| 系統 | files | required keys |
|---|---|---|
| course 10-key | `COURSE_TEN_KEY_FILES` 配列 (course/week*/ 主要 + sandbox_reference/week*/ 主要、CHECKLIST/HINTS は **対象外**) | `type id title week duration_min prerequisites worldcpj_ct roles references deliverables` (10) |
| spec 7-key | `SPEC_KEYS` (docs/superpowers/specs/) | `type id title date status sub_project related_plan` (7) |
| plan 7-key | `PLAN_KEYS` (docs/superpowers/plans/) | `type id title date status sub_project related_spec` (7) |

**SP4 で `COURSE_TEN_KEY_FILES` に追加する 20 files** (CHECKLIST.md / HINTS.md は除外):

```
course/week4/README.md
course/week4/lectures/l7_rosbag2_mcap_episode_record.md
course/week4/lectures/l8_safety_sop_safe_no_action.md
course/week4/labs/lab7_episode_record/README.md
course/week4/labs/lab8_q1_execution_package/README.md
course/week4/labs/lab8b_sandbox_final_review/README.md
course/week4/deliverables/episode_record_template.md
course/week4/deliverables/trial_sheet_template.md
course/week4/deliverables/safety_checklist_template.md
course/week4/deliverables/q1_reduced_lv1_execution_package_template.md
sandbox_reference/week4/episode_record_example.md
sandbox_reference/week4/trial_sheet_example.md
sandbox_reference/week4/safety_checklist_example.md
sandbox_reference/week4/q1_reduced_lv1_execution_package_example.md
sandbox_reference/week4/sandbox_review_summary_example.md
sandbox_reference/week4/bad_q1_package_example.md
sandbox_reference/week4/codex_pattern_extract_example.md
sandbox_reference/week4/lab7/README.md
sandbox_reference/week4/lab8/README.md
sandbox_reference/week4/lab8b/README.md
```

**course/week4/README.md**: `type: week` (W1-W3 precedent と整合)

**`artifact_status` の配置**: front matter には入れない (10-key 規約維持)。**body 冒頭**に YAML-like block として配置。G2 は無変更、`artifact_status` は G4 body pattern として検査。

### 9.3 G3 (verify_env.sh --week 4)

#### 9.3.1 必須 check (PASS 条件、behavior-first 順序、repo root 解決)

```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

has_ros_pkg_or_deb() {
  local ros_pkg="$1"
  local deb_pkg="$2"
  if command -v ros2 >/dev/null 2>&1 && ros2 pkg list 2>/dev/null | grep -q "^${ros_pkg}$"; then
    return 0
  fi
  dpkg-query -W -f='${Status}' "${deb_pkg}" 2>/dev/null | grep -q "install ok installed"
}
```

| check | 実装 | 失敗時 |
|---|---|---|
| ROS 2 command | `command -v ros2 >/dev/null` | FAIL ("ROS 2 environment is not sourced. Try: source /opt/ros/humble/setup.bash") |
| ROS_DISTRO | `[ "${ROS_DISTRO:-}" = "humble" ]` | FAIL |
| ros2 bag command | `ros2 bag --help >/dev/null 2>&1` | FAIL |
| rosbag2 default storage | `has_ros_pkg_or_deb rosbag2_storage_default_plugins ros-humble-rosbag2-storage-default-plugins` | FAIL |
| Python 3.10+ | `python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3,10) else 1)'` | FAIL |
| Lab 7 source evidence | `test -f "${REPO_ROOT}/sandbox_reference/week1/lab1/bag_info.txt"` | FAIL ("Lab 7 reuses SP1 W1 Lab 1 bag evidence; complete SP1 first") |

#### 9.3.2 Stretch check (WARN 条件)

| check | 実装 | 失敗時 |
|---|---|---|
| MCAP plugin | `has_ros_pkg_or_deb rosbag2_storage_mcap ros-humble-rosbag2-storage-mcap` | WARN ("rosbag2_storage_mcap not found; MCAP hands-on remains Stretch") |

#### 9.3.3 stdout 仕様

```
[SP4] Week 4 environment check
[OK]   ROS 2 command available
[OK]   ROS_DISTRO=humble
[OK]   ros2 bag available
[OK]   rosbag2 default storage plugin available
[OK]   Python >= 3.10 (3.10.12)
[OK]   Lab 7 source evidence found: sandbox_reference/week1/lab1/bag_info.txt
[WARN] rosbag2_storage_mcap not found; MCAP hands-on remains Stretch
[SKIP] MoveIt2 check skipped for week 4
[SKIP] Gazebo check skipped for week 4
[SKIP] ros2_control check skipped for week 4
[SUMMARY] PASS with 1 WARN
```

FAIL あり → exit 1。WARN のみ → exit 0。

### 9.4 G4 (content patterns)

#### 9.4.1 Pattern 配列構造 (mode 明示)

```bash
# 各 entry: mode|file|pattern  (mode = fixed | regex)

G4_MUST_PATTERNS=()
G4_MUST_NOT_PATTERNS=()
G4_NEGATIVE_EXAMPLE_PATTERNS=()
G4_EXCLUDE_FROM_POSITIVE=()    # bad_example を positive G4 から除外
G5A_EXCLUDE_FILES=()           # bad_example の dead link を G5a 除外
```

**inline-code strip ルール**:
- **positive G4 (`G4_MUST_PATTERNS`)**: inline-code strip **しない** (YAML key field 検査が main use case)
- **must-not G4 (`G4_MUST_NOT_PATTERNS`)**: inline-code strip **する** (教育目的の言及で false positive 回避)
- **G5a**: 既存通り inline-code strip + `docs/superpowers/` exclude

#### 9.4.2 mode 分岐実装

```bash
check_g4_pattern() {
  local mode="$1" file="$2" pattern="$3" kind="$4"   # kind=must|must-not|negative
  local content
  if [ "$kind" = "must-not" ]; then
    content=$(strip_inline_code "$file")
  else
    content=$(cat "$file")
  fi
  case "$mode" in
    fixed) echo "$content" | grep -Fq -- "$pattern" ;;
    regex) echo "$content" | grep -Eq -- "$pattern" ;;
  esac
}
```

#### 9.4.3 主要 patterns 一覧

| 対象 | mode | pattern | kind |
|---|---|---|---|
| L7 lecture | fixed | `rosbag2`, `MCAP`, `episode_record`, `failure_reason`, `taxonomy`, `duration_sec`, `evidence_path`, `services/actions recording` | must |
| L7 lecture | regex | `(Stretch\|任意)`, `(Course baseline 範囲外\|out of scope for the Course baseline)` | must |
| L8 lecture | fixed | `emergency stop`, `safeguard`, `protective`, `not_normal_stop`, `not_auto_resume`, `safe no-action`, `operator confirmation`, `training draft`, `ISO 10218` | must |
| L8 lecture | regex | `(Standard Operating Procedure\|SOP)`, `(manual_reset_required\|manual reset)`, `(not an approval artifact\|approval artifact ではない)`, `(instructional examples\|教材上の例)` | must |
| L8 lecture | regex | `non.recoverable`, `自動復帰(する\|できる)`, `auto.?resume.?allowed`, `operator confirmation で safety review を代替` | **must-not** |
| Lab 7 README | fixed | `episode_record_template`, `not_applicable` | must |
| Lab 7 README | regex | `(Phase 0 training episode\|not counted as a Q1\|Q1 trial として数えない)` | must |
| episode_record_example | fixed | `training_trial_w1_lab1_001`, `turtlesim_training_object`, `evidence_path`, `result: success`, `failure_reason: none`, `bridge_schema_version: not_applicable`, `adapter_version: not_applicable`, `environment_mode: mock`, `q1_package_id: not_applicable`, `trial_sheet_id: not_applicable` | must |
| Lab 8 README | fixed | `q1_reduced_lv1_execution_package_template`, `safety_checklist_template`, `trial_sheet_template`, `source_artifact_path`, `source_template`, `15 planned rows`, `q1_w1_preflight`, `re_judge_gates`, `1 pilot trial`, `pilot review` | must |
| Lab 8 README | regex | `(5 物体 × 3 trials 直行禁止\|direct_15_trials_without_pilot)` | must |
| q1 package template | fixed | `q1_w1_pre_start`, `q1_w1_exit`, `q1_mid_point`, `q1_closeout` | must |
| q1 package example | fixed | `q1_w1_pre_start`, `q1_w1_exit`, `q1_mid_point`, `q1_closeout`, `phase0_handoff: true`, `phase0_review_summary_path`, `q1_execution_mode`, `owner_role` | must |
| Lab 8b README | regex | `(Codex 利用は.*任意\|Codex.*optional)` | must |
| Lab 8b README | fixed | `summarize`, `must not make scope decisions` | must |
| Lab 8b README | regex | `(must not implement\|判断・実装.*不可)`, `(human-found patterns\|自分で見つけた pattern)`, `(Q1 migration lessons\|Q1 移行教訓)`, `(scope decision.*human\|scope.*人間\|scope 判断は人間)` | must |
| 4 templates 共通 | fixed | `artifact_status: template` | must |
| episode_record template | fixed | `episode_id:`, `q1_package_id:`, `trial_id:`, `object_id:`, `environment_mode:`, `adapter_version:`, `bridge_schema_version:`, `evidence_path:`, `result:`, `failure_reason:`, `review_status:` | must |
| trial_sheet template | fixed | `trial_sheet_id:`, `safety_check_id:`, `total_planned_rows: 15`, `trial_status:`, `kpi_grasp_success:`, `kpi_time_to_grasp_sec:`, `skip_or_block_reason:` | must |
| safety_checklist template | fixed | `safety_check_id:`, `phase0_status: training_draft_only`, `q1_blocker_if_unreviewed: true`, `reviewer_name:`, `reviewer_role:`, `reviewed_at:`, `stop_condition:`, `other_stop_condition_detail:`, `forbidden_operations:`, `safe_no_action_conditions:`, `description_ja:` | must |
| q1 package template | fixed | `q1_package_id:`, `phase0_handoff: true`, `bridge_schema_version:`, `q1_execution_mode:`, `owner_role:`, `next_decision_owner:`, `phase0_review_summary_path:`, `phase0_to_q1_handoff_note:`, `1_scope_lv1_boundary`, `2_target_task_gate`, `3_environment_stack`, `4_robot_adapter_readiness`, `5_simulation_bridge_status`, `6_logging_episode_plan`, `7_trial_kpi_plan`, `8_safety_review_go_no_go`, `source_artifact_path:`, `source_template:`, `q1_w1_preflight:`, `re_judge_gates:` | must |
| sandbox_review_summary | regex | `(human-found patterns\|自分で見つけた pattern)`, `(Q1 migration lessons\|Q1 移行教訓)`, `Codex.*N/A` | must |
| bad_q1_package_example | fixed | `artifact_status: intentionally_invalid_example`, `do_not_copy: true` | **negative** |
| bad_q1_package_example | regex | `(不採用例\|bad example)` | **negative** |
| docs/references.md | fixed | `R-28`, `R-29`, `R-30`, `R-31`, `R-32` | must |
| tools/check_structure.sh (self) | fixed | `G4_MUST_PATTERNS`, `G4_MUST_NOT_PATTERNS`, `G4_NEGATIVE_EXAMPLE_PATTERNS`, `G4_EXCLUDE_FROM_POSITIVE`, `G5A_EXCLUDE_FILES` | must |
| tools/verify_env.sh (self) | fixed | `--week 4` | must |

参考: positive patterns はおおむね 90 前後、must-not 4 件、negative-example 3 件。

#### 9.4.4 file handling sequence

```
for file in EXPECTED_FILES:
  G1 (existence)
  G2 (front matter, COURSE_TEN_KEY_FILES vs SPEC_KEYS vs PLAN_KEYS で分岐)
  if file in G4_EXCLUDE_FROM_POSITIVE:
    skip positive G4
  else:
    apply G4_MUST_PATTERNS for this file
  apply G4_MUST_NOT_PATTERNS (全ファイル、inline-code strip)
  if file is target of G4_NEGATIVE_EXAMPLE_PATTERNS:
    apply negative-example patterns
  if file in G5A_EXCLUDE_FILES:
    skip G5a
  else:
    G5a (inline-code strip + docs/superpowers/ exclude)
```

### 9.5 G5a (local links)

既存 logic 継続。`G5A_EXCLUDE_FILES` に `sandbox_reference/week4/bad_q1_package_example.md` を追加。bad example 内の `source_artifact_path` 等は plain text placeholder で書き、Markdown link 化しない方針 (G5a exclude を最後の手段とするため)。

## 10. Acceptance criteria

### 10.1 Validation (gate PASS)

- [ ] `bash tools/verify_env.sh --week 1` PASS (regression)
- [ ] `bash tools/verify_env.sh --week 4` PASS (WARN allowed)
- [ ] `bash tools/check_structure.sh` PASS
  - [ ] G1: 28 SP4 new files exist after writing-plans (26 course/sandbox + 1 spec + 1 plan)
  - [ ] G2: course/sandbox files に valid 10-key front matter + allowed type (`week` / `lecture` / `lab` / `template` / `reference`)
  - [ ] G2: docs/superpowers spec/plan files に valid 7-key spec/plan front matter
  - [ ] G4: tools/check_structure.sh に登録された SP4 positive / must-not / negative-example patterns が全 PASS
  - [ ] G5a: SP4 local links resolve、`bad_q1_package_example.md` のみ exclude

### 10.2 内容 (Section 5-8 invariants)

- [ ] L7 / L8 lecture 内容不変条件全て満足
- [ ] Lab 7 / Lab 8 / Lab 8b の README + CHECKLIST + HINTS 三点揃いで invariants 満足
- [ ] 4 templates body field 全 satisfaction (Section 7 placeholder skeleton 通り)
- [ ] sandbox_reference/week4/ 10 files complete
  - [ ] 6 top-level examples
  - [ ] 3 lab walk-through README files
  - [ ] 1 optional Codex pattern extraction example
- [ ] `bad_q1_package_example.md` が `intentionally_invalid_example` + `do_not_copy: true` で明示

### 10.3 Traceability (Lab 8 demo)

(T18 は新規 committed files を作らず、`sandbox_reference/week4/` examples で demo を完成させる方針)

- [ ] `sandbox_reference/week4/q1_reduced_lv1_execution_package_example.md` が instructor Lab 8 demo として fill 済み
- [ ] `sandbox_reference/week4/safety_checklist_example.md` が `phase0_status: training_draft_only` で fill 済み
- [ ] `sandbox_reference/week4/trial_sheet_example.md` が 15 planned rows skeleton を含む
- [ ] Q1 Package example 8 行が W1-W3 artifacts への `source_artifact_path` で参照 (コピーではない)
- [ ] re_judge_gates 4 件 (`q1_w1_pre_start` / `q1_w1_exit` / `q1_mid_point` / `q1_closeout`) 記載
- [ ] safety_checklist example が `phase0_status: training_draft_only` + `q1_blocker_if_unreviewed: true` で固定

### 10.4 Commit / merge

- [ ] feature branch 上で 18 tasks 全 commit
- [ ] commit message に `Co-Authored-By` / Coding Agent 言及なし (memory 規約遵守)
- [ ] main へ fast-forward merge 可能

(参考: git config user は pasorobo / goo.mail01@yahoo.com の local config — 本 acceptance ではなく implementation note)

## 11. Risks

### 11.1 技術 risk

| risk | 確率 | 影響 | 対策 |
|---|---|---|---|
| G4 mode 分岐実装で既存 SP1-SP3 patterns に regression | 中 | 高 | T2 で既存 patterns を `fixed` mode に明示変換、実行前に SP1-SP3 patterns 全件 PASS を確認 (T17 で `--week 1` regression check) |
| inline-code strip 方針変更 (positive で strip しない) で SP3 までの patterns が誤動作 | 中 | 中 | SP3 までの must-not patterns は strip 適用継続、positive patterns は strip しない方針へ統一前に regression test |
| repo root 解決失敗 (`SCRIPT_DIR` 取得失敗) | 低 | 中 | T4 で `BASH_SOURCE[0]` 経由の robust 実装 + symlink 経由実行のテスト |
| `ros2 pkg list` が ROS 2 sourced されていないと空返却 | 中 | 低 | `has_ros_pkg_or_deb` helper で dpkg-query にフォールバック |
| MCAP plugin install 状態が dpkg と ros2 pkg list で不一致 | 低 | 低 | WARN なので exit に影響なし |
| **T2/T3 で SP4 expected files / G4 patterns を早期有効化し、後続 task の中間 commit が check_structure FAIL** | 中 | 高 | **validation framework 実装と strict SP4 pattern activation を分離** (T2 = framework、T16/T17 = SP4 strict 有効化) |

### 11.2 教育 risk

| risk | 確率 | 影響 | 対策 |
|---|---|---|---|
| 受講者が W1 turtlesim episode を Q1 trial に混入 | 中 | 中 | Lab 7 README で「Phase 0 training episode、not counted as a Q1」を G4 必須化 + `not_applicable` / `training_*` 値を CHECKLIST で明示 |
| 受講者が safety_checklist を「実機 OK」と誤解 | 中 | 高 | L8 で「not an approval artifact」「training draft」を G4 必須化 + safety_checklist 自体に `phase0_status: training_draft_only` + `q1_blocker_if_unreviewed: true` を G4 必須化 |
| 受講者が Codex に scope 判断/safety 判断を委ねる | 中 | 高 | Lab 8b で「Codex must not implement / scope-expand / make execution or safety decisions」を G4 必須化 + 出力 matrix で human-found patterns 必須化 |
| 受講者が Q1 Package を W1-W3 templates のコピーで作る | 中 | 中 | Lab 8 README + Q1 Package template で `source_artifact_path` / `source_template` を G4 必須化、コピーではなく参照する旨明示 |
| 受講者が 5 objects × 3 trials を 1 pilot 経由せず直行 | 中 | 高 | `q1_w1_preflight` 8 項目 + `1 pilot trial` / `pilot review` を G4 必須化 |

### 11.3 運用 risk

| risk | 確率 | 影響 | 対策 |
|---|---|---|---|
| Phase 0 → Q1 移行時に safety_owner / SOP approver が未確定 | 高 | 高 | Q1 Package §8 + safety_checklist で `safety_owner: TBD` を Phase 0 default、Q1 W1 開始前 blocker 明示 |
| Q1 W2+ detail を Phase 0 で過剰 prescribe | 中 | 中 | re_judge_gates の `q1_mid_point` / `q1_closeout` で deferred 明示、Phase 0 で W2+ scope に踏み込まない |
| sandbox_review_summary が「形式的記入」で実教訓なし | 中 | 低 | Lab 8b で human-found patterns 5+ + Q1 migration lessons 3+ を G4 必須化 |
| **T18 が extra committed files を生み、G1 count と git ls-files 目標を破壊** | 中 | 中 | **T18 は `sandbox_reference/week4/` examples の review task にし、追加 committed files を作らない** (Section 12.5 参照) |

### 11.4 SP4-specific 既知 risk

- `non-recoverable` の must-not pattern が L8 教育目的の言及で false positive を起こす可能性 → L8 本文で `non-recoverable` を一切使わない方針 (must-not + spec 側のみ記載で対応)
- bad_q1_package_example の dead link 扱い → Markdown link でなく plain text placeholder で書く方針
- `ros2 doctor` が environment 変数不足で動かないケース → Lab 8 で「or documented equivalent」と逃がす

## 12. Implementation tasks 概要

writing-plans skill で展開する task 数: **約 18 tasks**

### 12.1 Task 一覧

| # | task | 主な対象 | 主な validation |
|---|---|---|---|
| T1 | docs/references.md に R-28〜R-32 追加 | docs/references.md (modify) | G4 R-28〜R-32 (T16/T17 で有効化) |
| T2 | check_structure.sh の **validation framework 拡張** (`G4_MUST_PATTERNS` / `G4_MUST_NOT_PATTERNS` / `G4_NEGATIVE_EXAMPLE_PATTERNS` / `G4_EXCLUDE_FROM_POSITIVE` / `G5A_EXCLUDE_FILES` 配列、mode 分岐 helper、inline-code strip 方針更新)。**SP4 strict expected list はまだ有効化しない** | tools/check_structure.sh (modify) | self-G4 (構造のみ) |
| T3 | check_structure.sh で SPEC_KEYS / PLAN_KEYS 分離検証 (既存 7-key 分離を確認、必要なら refactor) | tools/check_structure.sh (modify) | spec 7-key PASS |
| T4 | verify_env.sh に `--week 4` mode + repo root 基準 implementation + `has_ros_pkg_or_deb` helper | tools/verify_env.sh (modify) | self-G4 (`--week 4`) |
| T5 | course/week4/README.md (`type: week`、10-key front matter) | course/week4/README.md (new) | G1, G2, G4 |
| T6 | course/README.md に Week 4 entry + root README.md に Week 4 link | course/README.md, README.md (modify) | G1, G4 |
| T7 | L7 lecture (rosbag2 + MCAP + episode_record) | course/week4/lectures/l7_*.md | G1, G2, G4 (約 10 patterns) |
| T8 | L8 lecture (Safety SOP + safe no-action + UR/ISO refs) | course/week4/lectures/l8_*.md | G1, G2, G4 (約 13 must + 4 must-not) |
| T9 | episode_record_template (10-key + 11+ body fields) | course/week4/deliverables/ | G1, G2, G4 |
| T10 | trial_sheet_template (10-key + 7 body fields + 構造例 1-2 row、fully expanded 15 rows は example 側) | 同上 | G1, G2, G4 |
| T11 | safety_checklist_template (10-key + reviewer fields + stop_condition + forbidden_operations) | 同上 | G1, G2, G4 |
| T12 | q1_reduced_lv1_execution_package_template (10-key + 8 行 meta + 4 gates + preflight) | 同上 | G1, G2, G4 (約 22 patterns) |
| T13 | Lab 7 README/CHECKLIST/HINTS (W1 turtlesim 再利用、Q1 区別注記) | course/week4/labs/lab7_*/ | G1, G2 (README only), G4 |
| T14 | Lab 8 README/CHECKLIST/HINTS (3 templates 統合、re_judge_gates 4 件) | course/week4/labs/lab8_*/ | G1, G2 (README only), G4 |
| T15 | Lab 8b README/CHECKLIST/HINTS (Codex 任意化、出力 matrix) | course/week4/labs/lab8b_*/ | G1, G2 (README only), G4 |
| T16 | sandbox_reference/week4/ 10 files (6 top-level examples + 3 lab walk-through + 1 optional Codex example) | sandbox_reference/week4/ | G1, G2, G4 (大量、bad example は negative-example patterns) |
| T17 | check_structure.sh に **SP4 EXPECTED_FILES + COURSE_TEN_KEY_FILES + G4 patterns を最終有効化**、instructor 検証 sequence (`verify_env --week 1` + `verify_env --week 4` + `check_structure.sh`) PASS 確認 | tools/check_structure.sh (modify、最終有効化) | 全 gate PASS |
| T18 | `sandbox_reference/week4/` の Lab 8 demo examples (q1_package / safety_checklist / trial_sheet) が instructor Lab 8 demo として成立していることを review。**追加 committed files なし** | (review only、no new files) | Lab 8 / Section 8 invariants 全満足 |

### 12.2 Task 順序

T1 → T2 → T3 → T4 (基盤整備、framework 拡張のみ) → T5 → T6 (course 構造) → T7-T8 (lectures) → T9-T12 (templates) → T13-T15 (labs) → T16 (sandbox examples) → **T17 (SP4 strict pattern activation + 最終 validation)** → T18 (Lab 8 demo review、no new files)

各 task で test-first / 5 gate validation / commit を subagent-driven で実行。**ただし T2-T16 の中間 commit では check_structure.sh は SP4 strict mode に入っておらず、未完成 file の不在で FAIL しない**。T17 で初めて SP4 全 EXPECTED_FILES + 全 G4 patterns を有効化する。

### 12.3 instructor 検証 sequence

```bash
bash tools/verify_env.sh --week 1
bash tools/verify_env.sh --week 4
bash tools/check_structure.sh
git status --short
```

`--week 2` / `--week 3` は SP4 で MoveIt / Gazebo を再要求しない方針のため final gate に必須化しない (任意の regression check として実行可)。

### 12.4 縮退ルール (sudo 不可 / install 不可シナリオ)

| シナリオ | 影響 | 対応 |
|---|---|---|
| sudo 不可 | なし | SP1 setup 完了済み前提 |
| MCAP plugin 未 install | なし | Stretch、WARN 表示のみ |
| ros2 doctor 利用不可 | 低 | Lab 8 README で「`ros2 doctor` or documented equivalent environment smoke check」 |
| SP1 W1 Lab 1 bag 不在 | 高 | verify_env --week 4 で FAIL |
| `ros2` not sourced | 高 | FAIL + 親切な error message ("Try: source /opt/ros/humble/setup.bash") |

### 12.5 T18 方針補足

T18 は **追加 committed files を作らない** review task。Lab 8 demo の実 fill は T16 で `sandbox_reference/week4/` 内 examples として既に commit されている。T18 はそれらが Lab 8 acceptance criteria (Section 10.3) を満たしていることの最終 review。

もし将来 `sandbox/wk4/lab8/` 等に instructor 自身の fill demo を追加 commit する場合は、Section 4.1 の file count + EXPECTED_FILES + COURSE_TEN_KEY_FILES に追加し、本 spec を update する。

## 13. References (R-28 〜 R-32)

`docs/references.md` に追記する 5 件:

| id | 内容 | 用途 |
|---|---|---|
| R-28 | ROS 2 Humble rosbag2 公式 tutorial / package docs (record / play / info、Storage backend default = sqlite3) | L7 §1, §2 |
| R-29 | rosbag2_storage_mcap (rosbag2 に MCAP file format support を追加する storage plugin、`--storage mcap`) | L7 §3 (Stretch) |
| R-30 | UR (Universal Robots) public manual / safety document — emergency stop is a complementary protective measure, NOT a safeguard. It is not designed to prevent injury. | L8 §2, §7 (instructional examples) |
| R-31 | UR safety overview — emergency stop の manual reset 手順、運用区別 | L8 §2 |
| R-32 | ISO 10218-1:2025 (Robotics — Safety requirements — Part 1: Industrial robots) + ISO 10218-2:2025 (Part 2: Industrial robot applications and robot cells) overview。Use as overview reference only. The course does not reproduce paid standard text. | L8 §8 |

## 14. Spec self-review checklist

spec doc 書き終えた後、以下を inline で確認:

- [ ] **Placeholder scan**:
  - `TODO` / `implement later` / `fill in details` 残存なし
  - `TBD` は **allowlist 方式** で確認
  - intentional `TBD` (例: `safety_owner: TBD (Q1 W1 開始前に確定)`、`reviewer_name: TBD`、`reviewed_at: TBD`、planned skeleton の未実行 field) は spec 内で明示根拠あれば OK
- [ ] **Internal consistency**:
  - 26 course/sandbox + 1 spec + 1 plan = **28 new files** + **5 modified files** = **33 changed files** (full implementation 完了時) が全 section で一貫
  - git ls-files 目処: SP3 完了後 100 → SP4 完了後 128
  - sandbox_reference path が top-level 集約で全 section 一致 (lab 7/8/8b dir の examples ではなく、week4 直下に集約)
  - re_judge_gates 4 件が Section 6.2 / 7.4 / 9.4.3 / 12 で一致
  - artifact_status が body 配置 (front matter ではない) で全 section 一致
  - failure_reason taxonomy 10 値 + `none` が Section 3.4 / 7.1 / 9.4 で一致
- [ ] **Scope check**: SP4 単体で完結 (SP5 への deferred 項目は明示)
- [ ] **Ambiguity check**: 各 invariant が 1 通りに解釈可能 (例: `not_applicable` を許容する条件が `artifact_status: sandbox_example` と明示)
- [ ] **Self-G4 check 整合性**: check_structure.sh 自身の検査項目 (`G4_MUST_PATTERNS` / `G4_MUST_NOT_PATTERNS` / `G4_NEGATIVE_EXAMPLE_PATTERNS` / `G4_EXCLUDE_FROM_POSITIVE` / `G5A_EXCLUDE_FILES`) が Section 9.4.1 / 9.4.2 / 9.4.4 と一致

## 15. Phase 0 → Q1 handoff note

本 SP4 完了後の Phase 0 → Q1 移行は、以下の構造で行う:

1. **Q1 Reduced Lv1 Execution Package** (Lab 8 で作成、`sandbox_reference/week4/q1_reduced_lv1_execution_package_example.md` を instructor demo として参照) **そのものが handoff artifact**。別途 ceremony 文書は作成しない (out of scope)
2. Q1 W1 開始前に **safety_checklist の review** が完了している (`review_status: approved` + reviewer 情報 fill) ことが blocker
3. Q1 W1 開始前に **`q1_w1_preflight` 8 項目** が PASS していることが blocker (1 pilot trial 含む)
4. Q1 W1 中の判断は **`re_judge_gates`** の 4 件 (`q1_w1_pre_start` / `q1_w1_exit` / `q1_mid_point` / `q1_closeout`) で構造化
5. Q1 W2 以降の detail (failure taxonomy 改訂 / KPI / operator workflow) は Phase 0 で prescribe せず、`q1_mid_point` で判断する
6. **Phase 0 完了宣言は控えめに**。SP4 完了 = 教材揃い、Q1 移行可否は上記 1-5 の条件 review で確定する
