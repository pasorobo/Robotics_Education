---
type: spec
id: SPEC-SP5
title: Robotics Education Course - Sub-Project 5 (Optional Role Track Meta-frame, A2-Lite) 設計書
date: 2026-04-30
status: approved
sub_project: SP5
related_plan: docs/superpowers/plans/2026-04-30-robotics-course-sp5-role-tracks-meta-plan.md
---

# Robotics Education Course — SP5 設計書

## 0. メタ情報

| 項目 | 値 |
|---|---|
| Sub-Project | SP5 (Phase 0 完了後、optional) |
| Scope | role_tracks meta-frame only (A2-Lite) |
| Phase 0 完了との関係 | SP1-SP4 完了済 (main HEAD `8fdf787`、128 files)。SP5 は Phase 0 完了後の optional 拡張 |
| Q1 (縮小 Lv1) との関係 | Q1 Package を **直接修正しない**。各 role track stub が Q1 Package §3-§8 / `q1_w1_preflight` / `re_judge_gates` への back-reference を保持 |
| Implementation 方式 | Subagent-Driven Development (SP1-SP4 と同一)。約 11 tasks |
| commit identity | pasorobo / goo.mail01@yahoo.com (local config)、Co-Authored-By / Coding Agent 言及禁止 |

## 1. Goal

Phase 0 (SP1-SP4) を完了したメンバーが、Q1 の担当 role に応じて必要部分だけ深掘りするための **optional role track 群の枠組み** を定義する。

SP5 は **track content を実装しない**。track 群の構造・命名・activation criteria・Q1 Package との接続を定義する meta-spec である。

SP5 の役割を一文で: **Q1 observation から SP5x per-track brainstorming へ移るための handoff frame**。Q1 execution の代替ではなく、Q1 observation → role-specific follow-up の橋。

## 2. Scope

### 2.1 In scope

- role_tracks 全体の目的記述
- track registry (7 tracks の最小情報)
- directory / naming convention
- Q1 Package §3-§8 + `q1_w1_preflight` + `re_judge_gates` への back-reference linkage matrix
- 各 track の `activation_trigger` (Q1 W1 preflight observation 発火型)
- 各 track の `future_spec_id` (`sp5x_candidate_<track_id>` 形式)
- 各 track の `activation_status: inactive` (SP5 完了時点 default 固定)
- SP5x 起動条件 (when to start a per-track sub-project)
- "順序は実装優先順位ではない" 明記
- ms_belief_navigation 8th 追加 protocol

### 2.2 Out of scope

#### Track content
- 各 track の full lecture / full lab / role-specific SOP / real robot setup procedure / Q1 W2+ detailed procedure / track-specific templates
- `_track_template.md`

#### Q1 Package 修正
- 既存 SP4 spec / Q1 Package template / Q1 Package example の forward reference 追加 (将来 SP5x activation 時または Q1 Package 更新時に扱う)

#### Validation framework
- 新 verify_env.sh `--week N` mode
- 新 G4_MUST_NOT_PATTERNS (SP4 既存は継続実行のみ)
- 新 G4_NEGATIVE_EXAMPLE_PATTERNS (SP4 既存は継続実行のみ)
- 新 type 値 (`type: track` 等は導入しない)

#### Naming / numbering
- SP5a / SP5b / ... 番号の事前割当
- `sp5x_candidate_*` 以外の future_spec_id 形式
- track 優先順位の固定

#### Reference
- 新 R-* references の追加
- index README / stub README front matter `references` field に外部 technical references を背負わせる (内部 reference 中心、`references: []` または最小限)

#### ceremony / governance
- formal track activation ceremony
- track owner 事前指名 (activation 時に決める)
- Q1 W2+ detail prescribe

#### directory
- `course/week5/` (SP5 は Week 5 教材ではない)
- `course/role_tracks/_track_template.md`
- `course/README.md` (引き続き存在しない、T6 教訓継続)

## 3. Architecture overview

### 3.1 3 layers + back-reference traceability

| layer | source of truth | 配置 |
|---|---|---|
| **Why** (構造の理由・out-of-scope・SP5x 起動条件) | SP5 meta-spec | `docs/superpowers/specs/2026-04-30-robotics-course-sp5-role-tracks-meta-design.md` |
| **What** (7 tracks の registry / index) | `course/role_tracks/README.md` | course tree |
| **Where** (各 track の landing page stub) | `course/role_tracks/<track_id>/README.md` × 7 | course tree |

### 3.2 Q1 Package linkage は back-reference 方向のみ

**SP5 では既存 SP4 Q1 Package を直接修正しない**。各 role track stub が `q1_touchpoint` として Q1 Package §3-§8 / `q1_w1_preflight` / `re_judge_gates` への **back-reference** を持つ。将来 Q1 Package を更新する場合は、当該 track stub を参照先として追加できる (forward-reference 追加は将来の Q1 更新または SP5x activation 時の作業)。

### 3.3 References policy: minimal & internal-first

- index README / stub README front matter `references` field は **空 `[]` または最小限**
- 外部 technical references (R-28..R-32 等) を index README が背負わない
- 内部 references 中心: SP4 Q1 Package、SP5 meta-spec、他 SP1-SP4 internal course artifacts

### 3.4 SP4 設計思想との整合

| SP4 pattern | SP5 での対応 |
|---|---|
| Q1 Package = handoff artifact 自体 | role_tracks frame = Q1 observation から SP5x per-track brainstorming へ移るための handoff frame |
| `source_artifact_path` 参照型 | track stub が `future_spec_id` (`sp5x_candidate_*`) と `q1_touchpoint` (Q1 Package row への back-reference) を持つ |
| `phase0_status: training_draft_only` | `stub_only: true` + `do_not_implement_yet: true` |
| `re_judge_gates` 4 件 (deferred 明示) | track stub の `activation_trigger` (deferred 明示、observation-driven) |
| failure_reason taxonomy で `unknown` 容認 | track の `activation_status: inactive` を default。`TBD` は track の `owner` / `activation_date` など将来運用で確定する field に限定使用 |
| course/README.md 不在の T6 教訓 | SP5 modify は最小限 — `tools/check_structure.sh` (validation 登録) + `README.md` (root に `course/role_tracks/README.md` への link 追加、discoverability 向上) |
| SP4 polish: G1 echo header の hardcoded count 削除 | SP5 でも entry 数を hardcode しない |
| SP4 polish: spec §4.3 で実 modify 数明記 | SP5 spec §4.7 でも実 modify 数 (2) を明記 |

## 4. File list

### 4.1 設計時点 vs 実装完了時点の区別

| Stage | 新規 | 修正 | git ls-files 累計 |
|---|---|---|---|
| **SP4 polish 完了直後** (current) | — | — | 128 |
| **SP5 spec doc commit 直後** | +1 (本 spec のみ) | 0 | 129 |
| **SP5 plan doc commit 直後** | +1 (plan) | 0 | 130 |
| **SP5 implementation 完了** | +8 (1 index + 7 stubs) | 2 (modify、ファイル数は変わらず) | **138** |
| **planned delta 合計** | **10 new** (8 + spec + plan) | **2 modify** | 12 changed files |

### 4.2 新規 8 (course/role_tracks/)

```
course/role_tracks/README.md                                            type: index
course/role_tracks/environment_toolchain_readiness/README.md            type: reference
course/role_tracks/robot_adapter_readiness/README.md                    type: reference
course/role_tracks/simulation_bridge/README.md                          type: reference
course/role_tracks/logging_evidence_chain/README.md                     type: reference
course/role_tracks/trial_kpi_evaluation/README.md                       type: reference
course/role_tracks/safety_review_sop/README.md                          type: reference
course/role_tracks/execution_coordination_governance/README.md          type: reference
```

### 4.3 修正 2 (G4 で内容追加検査、ファイル数変動なし)

```
README.md                       # 今後の予定 SP5 行更新 + course/role_tracks/README.md への link 追加
tools/check_structure.sh        # SP5 EXPECTED_FILES + COURSE_TEN_KEY_FILES + SPEC_FILES + PLAN_FILES + G4 patterns block
```

`tools/verify_env.sh` 触らない / `docs/references.md` 触らない / `course/README.md` 引き続き存在しない (T6 教訓継続)。

### 4.4 root README link は file へ

root README に追加する link は **`course/role_tracks/README.md` への Markdown link** (directory link ではない、G5a 安定性のため):

```markdown
[Optional Role Track frame](course/role_tracks/README.md)
```

## 5. Track registry — 確定 7 tracks (B 修正)

### 5.1 採用方針

**Option B (Q1 gap aligned) + 2 rename + canonical ID format**。SP1 由来の role-name 軸ではなく Q1 Package / preflight / re_judge_gates 観察軸で命名。

### 5.2 確定 7 tracks

| # | track_id | role |
|---|---|---|
| 1 | `environment_toolchain_readiness` | Environment / Toolchain Role |
| 2 | `robot_adapter_readiness` | Robot Adapter Role |
| 3 | `simulation_bridge` | Sim Bridge / Sandbox Bridge Role |
| 4 | `logging_evidence_chain` | Logging Role |
| 5 | `trial_kpi_evaluation` | Evaluation / Trial Role |
| 6 | `safety_review_sop` | Safety / Compliance Role |
| 7 | `execution_coordination_governance` | Execution Coordination / Workflow Governance Role (cross-cutting) |

各 track の `future_spec_id`: `sp5x_candidate_<track_id>` (例: `sp5x_candidate_robot_adapter_readiness`)。SP5a/SP5b/... 番号は activation 時に割当 (§1 方針)。

各 track の `activation_status`: `inactive` (default、SP5 完了時点で全 track inactive)。

### 5.3 各 track の確定 q1_touchpoint (canonical ID format)

#### 1. environment_toolchain_readiness
```yaml
q1_touchpoint:
  - q1_package:3_environment_stack
  - q1_w1_preflight:item_1_verify_env_week4
  - q1_w1_preflight:item_2_ros2_doctor_or_equivalent
activation_trigger: "Activate this track if Q1 W1 preflight reveals environment_stack version drift, ROS 2 sourcing issue, or tooling readiness gap."
```

#### 2. robot_adapter_readiness
```yaml
q1_touchpoint:
  - q1_package:4_robot_adapter_readiness
  - q1_w1_preflight:item_3_mock_adapter_noop
activation_trigger: "Activate this track if Q1 W1 preflight reveals adapter readiness gap, mock-to-real boundary ambiguity, or no-op adapter validation gap."
```

#### 3. simulation_bridge
```yaml
q1_touchpoint:
  - q1_package:5_simulation_bridge_status
  - re_judge_gates:q1_w1_exit
  - re_judge_gates:q1_mid_point
activation_trigger: "Activate this track if Q1 W1 preflight or q1_w1_exit gate reveals simulator selection, bridge schema, or sim-to-logging integration gap."
```
(具体 simulator 名は activation_trigger に含めない、prose でも具体名は最小限)

#### 4. logging_evidence_chain
```yaml
q1_touchpoint:
  - q1_package:6_logging_episode_plan
  - q1_w1_preflight:item_4_required_topics
  - q1_w1_preflight:item_5_rosbag2_record
activation_trigger: "Activate this track if Q1 W1 preflight, pilot trial, or q1_w1_exit gate reveals logging/evidence chain gap, topic coverage gap, episode-to-trial linkage gap, or evidence_path completeness issue."
```

#### 5. trial_kpi_evaluation
```yaml
q1_touchpoint:
  - q1_package:7_trial_kpi_plan
  - re_judge_gates:q1_w1_exit
activation_trigger: "Activate this track if q1_w1_exit or q1_mid_point gate reveals KPI taxonomy, trial aggregation, or CC Gate 0-a 5 objects x 3 trials evaluation protocol gap."
```

#### 6. safety_review_sop
```yaml
q1_touchpoint:
  - q1_package:8_safety_review_go_no_go
  - q1_w1_preflight:item_6_safety_review
  - re_judge_gates:q1_w1_pre_start
activation_trigger: "Activate this track if q1_w1_pre_start gate reveals SOP draft, responsible reviewer, risk assessment, or site-fit safety review gap."
```

#### 7. execution_coordination_governance
```yaml
q1_touchpoint:
  - q1_w1_preflight:item_7_one_object_one_pilot_trial
  - q1_w1_preflight:item_8_pilot_review_before_15_trials
  - re_judge_gates:q1_w1_pre_start
  - re_judge_gates:q1_w1_exit
  - re_judge_gates:q1_mid_point
  - re_judge_gates:q1_closeout
activation_trigger: "Activate this track if q1_w1_pre_start, q1_w1_exit, q1_mid_point, or q1_closeout gate reveals operator workflow, pilot review process, re_judge_gates operation, or Codex/agentic workflow governance gap."
```

### 5.4 SP1 legacy-name mapping (paper trail)

SP1 spec §5 anticipated 7 role tracks with role-name axis. SP5 A2-Lite re-aligns to Q1 observation axis:

- `affordance_calibration` (SP1): folded into `trial_kpi_evaluation`.
- `robot_adapter_safety` (SP1): split into `robot_adapter_readiness` and `safety_review_sop`.
- `logging_gate_eval` (SP1): split into `logging_evidence_chain` and `trial_kpi_evaluation`.
- `simulation_bridge` (SP1): retained as `simulation_bridge`.
- `ms_belief_navigation` (SP1): deferred as a future non-stub candidate (§16).
- `cc_gate_0a` (SP1): treated as an evaluation target inside `trial_kpi_evaluation`, not as a standalone role track.
- `agentic_workflow_sandbox` (SP1): folded into `execution_coordination_governance`.

## 6. Directory / naming convention

### 6.1 Directory 構造

```
course/role_tracks/
├── README.md                                      # track index (type: index)
├── environment_toolchain_readiness/
│   └── README.md                                  # stub (type: reference)
├── robot_adapter_readiness/
│   └── README.md
├── simulation_bridge/
│   └── README.md
├── logging_evidence_chain/
│   └── README.md
├── trial_kpi_evaluation/
│   └── README.md
├── safety_review_sop/
│   └── README.md
└── execution_coordination_governance/
    └── README.md
```

`_track_template.md` は作らない (A2-Lite 方針)。

### 6.2 Naming convention

| element | rule | 例 |
|---|---|---|
| directory name | `<track_id>` (snake_case) | `robot_adapter_readiness/` |
| stub README path | `course/role_tracks/<track_id>/README.md` | `course/role_tracks/robot_adapter_readiness/README.md` |
| stub README front matter id | `SP5-RT-<TRACK-ID-UPPER-HYPHEN>` | `SP5-RT-ROBOT-ADAPTER-READINESS` |
| stub README front matter type | `reference` | — |
| index README path | `course/role_tracks/README.md` | — |
| index README front matter id | `SP5-ROLE-TRACKS-INDEX` | — |
| index README front matter type | `index` | — |
| `track_id` (body) | snake_case | `robot_adapter_readiness` |
| `future_spec_id` (body) | `sp5x_candidate_<track_id>` | `sp5x_candidate_robot_adapter_readiness` |
| `activation_status` (body) | `inactive` (SP5 完了時点 default) | — |

**SP5-RT-... 採用理由**: `W5-T-...` だと `course/week5/` や Week 5 lecture が存在するように誤読される。SP5 は Week 5 教材ではなく optional role track frame のため、`SP5-RT-` (Role Track) prefix が安全。

## 7. Index README content invariants

### 7.1 Front matter (10-key、`references: []` または最小限)

```yaml
---
type: index
id: SP5-ROLE-TRACKS-INDEX
title: SP5 Role Tracks — Optional Track Frame (frame only, do not implement track content yet)
week: 5
duration_min: 0
prerequisites: [SP1, SP2, SP3, SP4]
worldcpj_ct: [CT-01, CT-02, CT-04, CT-05, CT-06, CT-07, CT-08, CT-09]
roles: [common]
references: []
deliverables: []
---
```

`references: []` は SP5 references policy (§3.3) に準拠。R-28..R-32 を index README が背負わない。

### 7.2 Body sections

1. **目的 / Frame only 宣言**: SP5 が frame only であり track content は実装しない旨
2. **順序は実装優先順位ではない 注記** (英語 + 日本語):
   > The order of tracks in this index is **not an implementation priority**. Each track is activated only when the corresponding Q1 observation or review gate indicates a need.
   > この一覧の順序は実装優先順位ではない。各 track は、Q1 W1 preflight や review gate の観察結果により必要性が確認された時点で個別に発火する。
3. **7 tracks リスト** (各 track への Markdown link + 一行 purpose、relative path):
   ```markdown
   - [environment_toolchain_readiness](environment_toolchain_readiness/README.md) — Q1 W1 preflight environment/toolchain readiness gap stub
   - [robot_adapter_readiness](robot_adapter_readiness/README.md) — Q1 §4 adapter readiness / mock-to-real boundary stub
   - [simulation_bridge](simulation_bridge/README.md) — Q1 §5 simulator selection / bridge schema stub
   - [logging_evidence_chain](logging_evidence_chain/README.md) — Q1 §6 episode/trial/evidence chain stub
   - [trial_kpi_evaluation](trial_kpi_evaluation/README.md) — Q1 §7 KPI taxonomy / 5 objects x 3 trials protocol stub
   - [safety_review_sop](safety_review_sop/README.md) — Q1 §8 SOP / responsible reviewer / risk assessment stub
   - [execution_coordination_governance](execution_coordination_governance/README.md) — Q1 W1 preflight pilot/operator + re_judge_gates + Codex/agentic governance stub (cross-cutting)
   ```
4. **Activation の流れ**: 各 track stub の activation_trigger は Q1 W1 preflight / re_judge_gates の observation 発火型。activation 時に当該 track の `future_spec_id: sp5x_candidate_<track_id>` を実 SP5x として brainstorming 開始
5. **Future non-stub candidate** (plain text、Markdown link なし):
   - `ms_belief_navigation`: not included in SP5 A2-Lite stubs. It may become a future track only if Q1 MS Lv1 (fixed observation baseline) observation reveals a belief / navigation-specific gap (Nav2, Kachaka, etc.).
6. **SP1 legacy-name mapping** (§5.4 と同内容、plain text bullet)

## 8. Stub README content invariants

### 8.1 Front matter (10-key、`references: []` または最小限)

```yaml
---
type: reference
id: SP5-RT-<TRACK-ID-UPPER-HYPHEN>
title: <track_id> — Optional Role Track stub (frame only, do not implement yet)
week: 5
duration_min: 0
prerequisites: [SP1, SP2, SP3, SP4]
worldcpj_ct: [<CT-XX>, ...]
roles: [<role>]
references: []
deliverables: []
---
```

### 8.2 Body 必須 fields (8 fields × 全 stub)

```yaml
track_id: <track_id>
role: <role name>
purpose: "<one sentence purpose, e.g., 'Q1 で <gap> が観察された場合に深掘りする optional role track'>"
prerequisites:
  - SP1 completed
  - SP2 completed (as applicable)
  - SP3 completed (as applicable)
  - SP4 completed (Q1 Package available)
expected_learner: "<who should use this track if activated>"
q1_touchpoint:
  - q1_package:<row_id>
  - q1_w1_preflight:<item_id>
  - re_judge_gates:<gate_id>
activation_trigger: "Activate this track if Q1 observation reveals <gap>."
future_spec_id: sp5x_candidate_<track_id>
activation_status: inactive
stub_only: true
do_not_implement_yet: true
out_of_scope:
  - full lecture
  - full lab
  - role-specific SOP
  - real robot setup procedure
  - Q1 W2+ detailed procedure
  - track-specific templates
```

### 8.3 Body prose sections (3 件、英語見出し + 日本語本文)

- `## What this track is for` — 2-3 sentences
- `## When to activate` — 2-3 sentences
- `## What not to implement yet` — 2-3 sentences

### 8.4 Body サイズ制限

10-key front matter を除く body が **30-50 行程度**。G4 hard gate ではなく **review acceptance** として確認。mini-lecture 化を避ける。

### 8.5 execution_coordination_governance 固有 (Codex 境界)

execution_coordination_governance stub の `out_of_scope` には Codex 境界 4 行を **independent entries (exact line)** として追加:

```yaml
out_of_scope:
  - full lecture
  - full lab
  - role-specific SOP
  - real robot setup procedure
  - Q1 W2+ detailed procedure
  - track-specific templates
  - Codex must not implement robotics logic
  - Codex must not make scope decisions
  - Codex must not make safety decisions
  - Codex must not replace human pilot review
```

prose section "What this track is for" にも明記:

> Codex / agentic workflow may **summarize** review notes. Codex must not implement robotics logic, expand Q1 scope, make execution decisions, make safety decisions, or replace human pilot review. SP4 Lab 8b の境界をそのまま延長する。

**重要**: Codex 境界は prose にまとめて書かず、`out_of_scope` 配列の独立 entry として 4 行で書く。圧縮表現は G4 exact match で fail する。

## 9. Q1 Package linkage matrix

| Q1 Package row / gate | linked track(s) | back-reference 方向 |
|---|---|---|
| `q1_package:1_scope_lv1_boundary` | (none) | — |
| `q1_package:2_target_task_gate` | (none) | — |
| `q1_package:3_environment_stack` | `environment_toolchain_readiness` | track stub → Q1 row |
| `q1_package:4_robot_adapter_readiness` | `robot_adapter_readiness` | track stub → Q1 row |
| `q1_package:5_simulation_bridge_status` | `simulation_bridge` | track stub → Q1 row |
| `q1_package:6_logging_episode_plan` | `logging_evidence_chain` | track stub → Q1 row |
| `q1_package:7_trial_kpi_plan` | `trial_kpi_evaluation` | track stub → Q1 row |
| `q1_package:8_safety_review_go_no_go` | `safety_review_sop` | track stub → Q1 row |
| `q1_w1_preflight:item_1_verify_env_week4` | `environment_toolchain_readiness` | track stub → preflight item |
| `q1_w1_preflight:item_2_ros2_doctor_or_equivalent` | `environment_toolchain_readiness` | track stub → preflight item |
| `q1_w1_preflight:item_3_mock_adapter_noop` | `robot_adapter_readiness` | track stub → preflight item |
| `q1_w1_preflight:item_4_required_topics` | `logging_evidence_chain` | track stub → preflight item |
| `q1_w1_preflight:item_5_rosbag2_record` | `logging_evidence_chain` | track stub → preflight item |
| `q1_w1_preflight:item_6_safety_review` | `safety_review_sop` | track stub → preflight item |
| `q1_w1_preflight:item_7_one_object_one_pilot_trial` | `execution_coordination_governance` | track stub → preflight item |
| `q1_w1_preflight:item_8_pilot_review_before_15_trials` | `execution_coordination_governance` | track stub → preflight item |
| `re_judge_gates:q1_w1_pre_start` | `safety_review_sop`, `execution_coordination_governance` | track stub → gate |
| `re_judge_gates:q1_w1_exit` | `simulation_bridge`, `logging_evidence_chain`, `trial_kpi_evaluation`, `execution_coordination_governance` | track stub → gate |
| `re_judge_gates:q1_mid_point` | `simulation_bridge`, `trial_kpi_evaluation`, `execution_coordination_governance` | track stub → gate |
| `re_judge_gates:q1_closeout` | `execution_coordination_governance` | track stub → gate |

**全 reference は track stub → Q1 Package 方向 (back-reference)**。

### 9.1 §1 / §2 が none である理由

> Q1 Package §1 scope/Lv1 boundary and §2 target task/gate are **not used as SP5 activation tracks**. They define the fixed Q1 reduced Lv1 scope. SP5 role tracks respond to execution / readiness / evidence / safety / evaluation gaps observed **after** that scope is fixed.
>
> Q1 Package §1 scope/Lv1 boundary と §2 target task/gate は SP5 activation track にしない。これらは Q1 縮小 Lv1 の固定 scope を定義する行であり、SP5 role tracks はその scope 固定後に観察される readiness / evidence / safety / evaluation gap に対応する。

## 10. Validation Gates (G1-G5a) extension specs

### 10.1 G1 (file existence)

SP5 additions to strict expected files:
- 8 course/role_tracks files (1 index + 7 stubs)
- 1 SP5 spec
- 1 SP5 plan
= **10 SP5 files**

### 10.2 G2 (front matter)

| 系統 | files | required keys |
|---|---|---|
| course 10-key | `COURSE_TEN_KEY_FILES` 配列 (8 SP5 entries) | `type id title week duration_min prerequisites worldcpj_ct roles references deliverables` |
| spec 7-key | `SPEC_FILES` (1 SP5 entry) | `type id title date status sub_project related_plan` |
| plan 7-key | `PLAN_FILES` (1 SP5 entry) | `type id title date status sub_project related_spec` |

### 10.3 G3 (verify_env.sh) — 拡張なし

SP5 は新 `--week N` mode を作らない。`tools/verify_env.sh` は modify 対象外。

### 10.4 G4 (content patterns)

#### Per-stub generic patterns (8 × 7 = 56)

| # | pattern | mode |
|---|---|---|
| 1 | `track_id:` | fixed |
| 2 | `q1_touchpoint:` | fixed |
| 3 | `activation_trigger:` | fixed |
| 4 | `future_spec_id:` | fixed |
| 5 | `stub_only: true` | fixed |
| 6 | `do_not_implement_yet: true` | fixed |
| 7 | `out_of_scope:` | fixed |
| 8 | `activation_status: inactive` | fixed |

#### Track-specific exact value patterns (1 × 7 = 7)

各 stub の `future_spec_id: sp5x_candidate_<track_id>` exact match。

#### Index README 専用 patterns (6)

| # | pattern | mode |
|---|---|---|
| 1 | `role_tracks` | fixed |
| 2 | `(順序.*優先順位.*ではない\|order.*not.*priority)` | regex |
| 3 | `Q1 W1 preflight` | fixed |
| 4 | `activation_trigger` | fixed |
| 5 | `sp5x_candidate_` | fixed |
| 6 | `stub_only` | fixed |

#### execution_coordination_governance Codex 境界 (4)

| # | pattern | mode |
|---|---|---|
| 1 | `Codex must not implement robotics logic` | fixed |
| 2 | `Codex must not make scope decisions` | fixed |
| 3 | `Codex must not make safety decisions` | fixed |
| 4 | `Codex must not replace human pilot review` | fixed |

#### root README 専用 patterns (2)

| # | pattern | mode |
|---|---|---|
| 1 | `Optional Role Track frame only` | fixed |
| 2 | `course/role_tracks/` | fixed |

#### check_structure.sh self-reference patterns (3)

| # | pattern | 意図 |
|---|---|---|
| 1 | `course/role_tracks/` | SP5 EXPECTED_FILES 登録確認 |
| 2 | `sp5x_candidate_` | track-specific value check の存在確認 |
| 3 | `2026-04-30-robotics-course-sp5` | SP5 spec/plan registration 確認 |

#### G4 patterns 累計

| カテゴリ | 件数 |
|---|---|
| Per-stub generic (8 × 7) | 56 |
| Track-specific exact value | 7 |
| Index README 専用 | 6 |
| execution_coordination_governance Codex 境界 | 4 |
| root README 専用 | 2 |
| check_structure.sh self-reference | 3 |
| **総計** | **78 patterns** |

### 10.5 SP4 must-not / negative-example checks (regression として継続)

SP5 では新しい `G4_MUST_NOT_PATTERNS` / `G4_NEGATIVE_EXAMPLE_PATTERNS` を追加しない。**既存 SP4 の must-not / negative-example checks は regression gate として継続実行する** (`_strip_inline_code` / `check_pattern_must_not_strip` / `check_pattern_negative_example` 既存呼び出しは無効化しない)。

### 10.6 G5a (local links) — 拡張なし

既存 logic 継続。Index README が 7 stub への Markdown link を持つため、各 stub が EXPECTED_FILES に登録済 (§10.1) であることで link が dead でないことを自動保証。

## 11. check_structure.sh extension spec

### 11.1 Two-stage activation pattern (SP4 同型)

- **T1**: SPEC_FILES/PLAN_FILES のみ即活性 (spec/plan は既に存在)
- **T2-T8b**: 各 stub commit 中は SP5 EXPECTED_FILES が未登録なので、未完成 stub の不在で FAIL しない
- **T9**: SP5 strict mode 起動 (root README G4 を除く全 G4 patterns: 76 patterns)
- **T10**: root README update と同 commit で root README G4 (2 件) を追加 → 全 78 patterns active

### 11.2 root README G4 timing 注意

T9 で root README G4 を追加すると、root README 未更新時点で fail する。**T10 (root README update と同 commit) で活性化する** 順序を厳守。

## 12. Acceptance criteria

### 12.1 Validation gates (PASS 条件)

- [ ] `bash tools/verify_env.sh --week 1` PASS (SP1 baseline regression)
- [ ] `bash tools/verify_env.sh --week 4` PASS (SP4 logging baseline regression)
- [ ] `bash tools/check_structure.sh` PASS
  - [ ] G1: 10 SP5 new files exist after writing-plans
  - [ ] G2: course/role_tracks files に valid 10-key front matter + allowed type (`index` / `reference` のみ)
  - [ ] G2: SP5 spec/plan files に valid 7-key
  - [ ] G4: 78 SP5 patterns 全 PASS
  - [ ] G4 regression: SP1-SP4 既存 must-not / negative-example checks 全 PASS 維持
  - [ ] G5a: SP5 local links resolve

### 12.2 内容

- [ ] 7 stubs それぞれに 8 fields 全揃
- [ ] 各 stub の `future_spec_id` が `sp5x_candidate_<track_id>` exact format
- [ ] 各 stub README は body が 30-50 行程度 (review acceptance)
- [ ] 各 stub の prose section が 3 件
- [ ] execution_coordination_governance stub の `out_of_scope` に Codex 境界 4 行 (independent entries)
- [ ] index README に "順序は実装優先順位ではない" bilingual disclaimer
- [ ] index README に 7 stub への Markdown link
- [ ] index README に future non-stub candidate (`ms_belief_navigation`) plain text bullet
- [ ] index README に SP1 legacy-name mapping plain text bullet 7 件
- [ ] index README front matter `references: []`
- [ ] 各 stub README front matter `references: []` または最小限
- [ ] root README の SP5 行が `**完了 (Optional Role Track frame only — SP5x 起動の breadcrumb)**` 形式
- [ ] root README に `course/role_tracks/README.md` への Markdown link 1 行追加 (file link、directory link ではない)

### 12.3 Traceability (Q1 Package back-reference 整合性)

- [ ] 各 stub の `q1_touchpoint` が canonical ID 形式
- [ ] §9 linkage matrix と全 stub の q1_touchpoint が 1:1 整合
- [ ] **SP4 Q1 Package を直接修正していない** (3 件全て無変更):
  - `docs/superpowers/specs/2026-04-28-robotics-course-sp4-design.md`
  - `course/week4/deliverables/q1_reduced_lv1_execution_package_template.md`
  - `sandbox_reference/week4/q1_reduced_lv1_execution_package_example.md`

### 12.4 Commit / merge

- [ ] feature branch (`course/sp5-role-tracks-meta`) で 約 11 commits
- [ ] commit message に `Co-Authored-By` / Coding Agent 言及なし
- [ ] main へ fast-forward merge 可能

## 13. Risks

### 13.1 設計 risk

| risk | 確率 | 影響 | 対策 |
|---|---|---|---|
| stub README が実質的に track content になる (mini-lecture 化) | 中 | 高 | 30-50 行制限を §8.4 / acceptance §12.2 に明記。code review 時に行数 check |
| `future_spec_id` が SP5a/SP5b 事前固定に誤読される | 中 | 中 | `sp5x_candidate_<track_id>` 命名 + index README に "SP5x 番号は activation 時に割り当て" 注記 |
| SP5 が SP4 Q1 Package を後から修正する scope 膨張 | 低 | 高 | back-reference 方向のみ (track stub → Q1 Package) を §3.2 / §9 に明記。acceptance §12.3 で SP4 ファイル 3 件無変更を gate 化 |
| ms_belief_navigation を後で track 追加する際の整合性 drift | 中 | 低 | future non-stub candidate として index README に plain text 記載済。§16 で 8th 追加 protocol |
| activation_trigger 文が Q1 観察と乖離 | 低 | 中 | §5.3 で各 trigger を Q1 Package row / preflight item / gate に直接 ref |

### 13.2 技術 risk

| risk | 確率 | 影響 | 対策 |
|---|---|---|---|
| T9 で root README G4 を活性化し T9 commit が fail | 中 | 中 | §11.2 で root README G4 を T10 で追加する順序を厳守。plan で明記 |
| T1 で plan file 未生成のまま PLAN_FILES に登録し fail | 中 | 中 | T1 prerequisite として writing-plans で plan file 生成済を明記 |
| Codex 境界 4 行を prose にまとめて書き G4 fail | 中 | 低 | §8.5 で out_of_scope 配列の独立 entry 4 行を強調 |
| SP1-SP4 既存 must-not / negative-example checks に regression | 低 | 高 | §10.5 で regression 継続を明記、final validation で `bash tools/check_structure.sh` PASS を gate 化 |
| date string drift (Section 1 = 2026-04-29、Section 4 = 2026-04-30) | 中 | 中 | 全 section で `2026-04-30` 統一済。spec self-G4 が `2026-04-30-robotics-course-sp5` を検査 |

### 13.3 運用 risk

| risk | 確率 | 影響 | 対策 |
|---|---|---|---|
| Q1 開始前に SP5x を発火させる急ぎの判断 | 中 | 中 | activation_trigger は Q1 W1 preflight observation 後を前提。Q1 開始前は inactive 維持 |
| SP5 完了 = role track 完了 と読者誤読 | 中 | 中 | root README に "frame only" 明記 + index README に "frame only 宣言" |
| 7 tracks の中で人気順に implementer が選ぶ (Q1 観察を待たずに走る) | 中 | 中 | "順序は優先順位ではない" を index README の上部に bilingual で配置、SP5x activation 条件を §15 に明文化 |

### 13.4 SP5-specific 既知 risk

- index README の SP1 legacy-name mapping が 7 件と多く、stub 30-50 行制限に対して index が肥大化する可能性 → index README は 80-120 行を目安
- 7 stubs を作る作業で重複 boilerplate が発生し、コピペミスで `track_id` が他 track と入れ違う可能性 → T9 で track-specific exact value G4 (各 stub の `future_spec_id: sp5x_candidate_<track_id>` 完全一致) が catch する
- Q1 Package row §1 / §2 が none であることへの誤解 → §9.1 内に bilingual 注記

## 14. Out-of-scope (再確認、§2.2 と整合)

### 14.1 Track content
各 track の full lecture / full lab / role-specific SOP / real robot setup procedure / Q1 W2+ detailed procedure / track-specific templates / `_track_template.md`

### 14.2 Q1 Package 修正
既存 SP4 spec / Q1 Package template / Q1 Package example の forward reference 追加 (3 件全て無変更)

### 14.3 Validation framework
新 verify_env.sh `--week N` mode / 新 G4_MUST_NOT_PATTERNS / 新 G4_NEGATIVE_EXAMPLE_PATTERNS / 新 type 値

### 14.4 Naming / numbering
SP5a / SP5b / ... 番号の事前割当 / `sp5x_candidate_*` 以外の future_spec_id 形式 / track 優先順位の固定

### 14.5 Reference
新 R-* references の追加 / index README / stub README front matter `references` field に外部 technical references を背負わせる (空 `[]` または最小限)

### 14.6 ceremony / governance
formal track activation ceremony / track owner 事前指名 / Q1 W2+ detail prescribe

### 14.7 directory
`course/week5/` / `course/role_tracks/_track_template.md` / `course/README.md`

## 15. SP5x 起動条件 + activation_status lifecycle

### 15.1 SP5x 起動条件 (5 conditions)

各 SP5x (= 当該 track の per-track sub-project) を開始する条件は以下を **全て** 満たすこと:

1. **対応する Q1 observation が記録されている**: q1_w1_preflight 該当 item に gap 観察、または `re_judge_gates` の該当 gate で当該 track の activation_trigger に合致する判断が記録された
2. **track owner が確定している**: SP5x brainstorming 開始時点で responsible role owner が特定されている
3. **non-goals が明示されている**: SP5x が当該 track の何を扱い、何を扱わないか が brainstorming Q1 で確定する
4. **expected deliverables が role track 1 件分に収まる**: SP5x が SP4 のような 18 tasks 規模に膨らまない (1 SP5x = 1 role track + 関連 lab 1-3 件 程度)
5. **当該 track stub の `activation_status` を `pending` に更新する commit が含まれる**

### 15.2 activation_status lifecycle

`inactive` (SP5 完了直後) → `pending` (SP5x brainstorming 中) → `active` (SP5x 実装中) → `completed` (SP5x merge 後)

### 15.3 activation_status と G4 の衝突対策

**SP5 meta implementation 時点では全 track stub の `activation_status` を `inactive` で固定し、G4 でも `inactive` を検査する** (§10.4 generic pattern #8)。

**将来 SP5x activation により当該 stub を `pending` / `active` / `completed` に更新する場合、同じ SP5x spec / implementation 内で `tools/check_structure.sh` の該当 G4 pattern も更新する**。

具体的には、SP5x が当該 track の `activation_status` を変更する際、該当 stub の per-stub generic pattern #8 (`activation_status: inactive`) を新しい値 (例: `activation_status: active`) に同 commit で書き換える。

これにより validation と lifecycle state が常に一致し、G4 fail を防ぐ。SP5 meta では `inactive` のみ default 固定、他の遷移は SP5x 側の責務。

## 16. ms_belief_navigation を 8th track として追加する protocol

将来 Q1 MS Lv1 観察で belief / navigation gap が出た場合の追加 protocol:

1. SP5 meta-spec を **修正せず**、新 spec (例: `2026-XX-XX-robotics-course-sp5-ms-belief-nav-track-addition.md`) を新規 brainstorming
2. 当該 spec で 8th track の skeleton (`course/role_tracks/ms_belief_navigation/README.md`) 追加 + index README の Future non-stub candidate 行を **取り除き** + tracks list に追加
3. tools/check_structure.sh の SP5 EXPECTED_FILES / COURSE_TEN_KEY_FILES / G4 patterns に 8th track 分追加

これにより SP5 meta-spec の「7 tracks 固定 + 1 future candidate」status は historical artifact として残り、将来追加は別 spec で扱う。

## 17. References

### 17.1 SP5 では新 R-* references を追加しない

R-28〜R-32 (SP4 §13 で導入) は SP4 由来の既存 references として **本 spec 本文 prose で参照可能**。ただし:

- `course/role_tracks/README.md` (index) や stub README では外部 technical references を増やさない
- index README front matter の `references: [...]` は **空 `[]`**
- 各 stub README front matter の `references: [...]` も同様に空 `[]` または最小限。必要なら個別 stub で 1-2 件の R-id を参照する程度に留める

### 17.2 内部 spec / source references (SP5 meta-spec 本文で引用)

- SP1 spec §5: SP5 (任意) Role別トラック原案、7 tracks の SP1 命名
- SP2 spec §6 (deferred items): URSim, IK mock (KDL), camera_calibration → SP5 robot_adapter_readiness / safety_review_sop へ folded
- SP3 spec §6 (deferred items): MuJoCo / ManiSkill / Isaac hands-on → SP5 simulation_bridge へ folded
- SP4 spec §3.4 / §13 (R-28..R-32): SP5 Q1 Package back-reference の元 + 既存 references の出典
- CONVENTIONS.md §2.1: SP5 plan が継承
- memory `feedback_commit_style.md`: no Co-Authored-By / no AI mention

## 18. Implementation tasks 概要

writing-plans skill で展開する task 数: **約 11 tasks**

| # | task | 主な対象 | strict G4 起動 |
|---|---|---|---|
| T0 | Branch setup (`course/sp5-role-tracks-meta`) | (no file changes) | — |
| T1 | check_structure.sh: SP5 spec/plan を SPEC_FILES/PLAN_FILES に登録 (writing-plans が plan file 生成済み前提) | `tools/check_structure.sh` (modify) | spec 7-key + plan 7-key 即活性 |
| T2 | course/role_tracks/README.md (index) | new | strict mode は T9 で起動 |
| T3 | environment_toolchain_readiness/README.md | new | T9 |
| T4 | robot_adapter_readiness/README.md | new | T9 |
| T5 | simulation_bridge/README.md | new | T9 |
| T6 | logging_evidence_chain/README.md | new | T9 |
| T7 | trial_kpi_evaluation/README.md | new | T9 |
| T8 | safety_review_sop/README.md | new | T9 |
| T8b | execution_coordination_governance/README.md (Codex 境界 4 行 exact line 含む) | new | T9 |
| T9 | check_structure.sh strict activation: SP5 EXPECTED_FILES + COURSE_TEN_KEY_FILES + SP5 G4 patterns block (76 patterns: per-stub 8×7 + track-specific 7 + index 6 + Codex 4 + self-reference 3)。**root README G4 (2) は除外**、T10 で追加 | `tools/check_structure.sh` (modify) | 全 stub G4 PASS、root README G4 はまだ未起動 |
| T10 | root README SP5 完了 entry 更新 + root README G4 patterns 2 件追加 (同 commit) + final 5-gate validation + ff merge | `README.md` (modify)、`tools/check_structure.sh` (modify) | 全 78 G4 PASS、final validation |

合計 **約 11 tasks**。

### 18.1 instructor 検証 sequence

```bash
bash tools/verify_env.sh --week 1     # SP1 baseline regression
bash tools/verify_env.sh --week 4     # SP4 logging baseline regression (SP5 が壊していないこと)
bash tools/check_structure.sh         # G1+G2+G4+G5a 一括 (SP1-SP5 全 PASS)
git status --short
```

`--week 2` / `--week 3` は SP5 で MoveIt / Gazebo を再要求しないため必須化しない (任意の regression check として実行可)。

## 19. Phase 0 → Q1 → SP5x handoff note

本 SP5 完了後の Phase 0 → Q1 → SP5x 移行は、以下の構造で行う:

1. **Phase 0 完了** = SP1-SP4 教材揃い + Q1 Package handoff artifact 整備済
2. **SP5 完了** = role track frame 整備済、各 track stub は inactive 状態で待機
3. **Q1 W1 開始** = q1_w1_preflight 8 項目 PASS + safety_checklist review approved + 1 pilot trial executed
4. **Q1 W1 observation** で gap が観察された時、当該 track の activation_trigger と照合
5. **SP5x 起動** = §15.1 の 5 条件を全て満たした上で、当該 track stub の `activation_status: pending` 更新 + 該当 G4 pattern 更新を含む新 SP5x brainstorming → spec → plan → implementation
6. **SP5x 完了** = 当該 track の `activation_status: completed` + 該当 G4 pattern 更新

SP5 meta は固定された frame であり、各 track の中身は SP5x が responsibility を持つ。SP5x 活性化は Q1 観察 driven、事前優先順位なし。
