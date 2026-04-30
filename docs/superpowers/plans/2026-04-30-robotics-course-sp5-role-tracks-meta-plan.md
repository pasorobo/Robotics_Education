---
type: plan
id: PLAN-SP5
title: Robotics Education Course - Sub-Project 5 (Optional Role Track Meta-frame, A2-Lite) 実装計画
date: 2026-04-30
status: ready
sub_project: SP5
related_spec: docs/superpowers/specs/2026-04-30-robotics-course-sp5-role-tracks-meta-design.md
---

# Robotics Education Course — SP5 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build SP5 (Optional Role Track Meta-frame, A2-Lite) — final state 138 files (SP4 polish base 128 + SP5 new 10: 8 course/role_tracks + 1 spec + 1 plan), satisfying 5 verification gates with 78 new SP5 G4 patterns (per-stub generic 56 + track-specific exact 7 + index 6 + Codex boundary 4 + root README 2 + self-reference 3). 10 new files + 2 modified files.

**Architecture:** Mono-repo continuation from SP4. New `course/role_tracks/` directory containing 1 index README + 7 stub READMEs (one per track). All stubs are A2-Lite skeleton: declare `stub_only: true` + `do_not_implement_yet: true` + `activation_status: inactive`, body 30-50 行程度 (front matter 除外). No track content (lecture / lab / template) is implemented. SP4 Q1 Package (spec / template / example の 3 件) は無変更、各 stub が `q1_touchpoint` で back-reference を保持する only direction. Tool extension: `tools/check_structure.sh` extends SPEC_FILES/PLAN_FILES (T1) + EXPECTED_FILES + COURSE_TEN_KEY_FILES + 78 G4 patterns block (T9 strict activation, root README G4 deferred to T10). No `tools/verify_env.sh` modification (SP5 robotics runtime 要求なし).

**Tech Stack:** Markdown (with YAML front matter), Bash 5.x. No new runtime / library dependency.

**Authoritative reference:** `docs/superpowers/specs/2026-04-30-robotics-course-sp5-role-tracks-meta-design.md` (commit `4f0cbc0`, status approved, reviewer Go judgment received). When in doubt, defer to spec §-numbers cited in each task.

**Pre-conditions already satisfied:**
- SP1 + SP2 + SP3 + SP4 + SP4 polish complete and merged to `main` (HEAD `4f0cbc0`, 128 tracked files at SP4 polish close, also SP5 spec already in main as commit `1861c15` + polish `4f0cbc0`)
- Local git identity: `pasorobo` / `goo.mail01@yahoo.com` (per-repo local config)
- Previous SP4 acceptance: 5 gates PASS (PASS 446 / FAIL 0 / WARN 0 for check_structure.sh, --week 4 PASS WARN 1, --week 1 PASS WARN 1)
- SP4 Q1 Package 3 件 (spec / template / example) は SP5 implementation 中も **無変更を維持** する (acceptance criterion)
- SP5 spec review by external reviewer: Go judgment + 2 軽微修正 reflected (commit `4f0cbc0`)

**Working branch:** Create `course/sp5-role-tracks-meta` from `main` at start (Task 0 below). All work in this plan happens on that branch. Merge to `main` only after Task 10 (final 5-gate validation).

**Total tasks:** 11 (numbered T0–T10 where T8b is between T8 and T9, displayed inline with T1-T10 numbering for sub-task continuity).

---

## Conventions for Plan Execution

- **Each task ends with a commit.** Commit prefixes per CONVENTIONS.md §2.1: `feat:`, `docs:`, `lab:`, `tool:`, `resource:`, `chore:`, `fix:`, `spec:`.
- **Commit author/email** is set per-repo to `pasorobo` / `goo.mail01@yahoo.com`. Do not change.
- **No Co-Authored-By trailer.** Do not add `Co-Authored-By:` lines or any reference to AI/coding agents in commit messages (per memory file `feedback_commit_style.md`).
- **G3 expectation for SP5**: SP5 does not modify `tools/verify_env.sh`. Existing `--week 1` and `--week 4` regression should continue PASSing.
- **Documentation files** must follow CONVENTIONS.md §2 (front matter, naming). When in conflict between this plan and CONVENTIONS.md, **CONVENTIONS.md wins**.
- **Two-stage check_structure.sh activation (spec §11.1, §11.2)**:
  - T1 adds **SPEC_FILES/PLAN_FILES SP5 entries only** — strict EXPECTED_FILES / G4 patterns block remains absent. Mid-tasks T2-T8b commits do NOT add SP5 expected files / G4 patterns to the active validator.
  - T9 is the **SP5 strict activation** task: populates EXPECTED_FILES with 8 SP5 entries, COURSE_TEN_KEY_FILES with 8 SP5 entries, and inserts 76 patterns (per-stub 56 + track-specific 7 + index 6 + Codex 4 + self-reference 3). **root README G4 (2 patterns) は除外**、T10 で追加。
  - T10 adds **root README G4 (2 patterns)** in the same commit that updates root README. Final 78 patterns active at T10.
- **`activation_status` placement (spec §15.3)**: SP5 implementation 時点では全 stub `activation_status: inactive` で固定。将来 SP5x activation で値を変える際は同 commit で G4 pattern も更新する設計 (本 SP5 plan では対象外、SP5x 側の責務)。
- **Q1 Package 無変更 (spec §12.3)**: `docs/superpowers/specs/2026-04-28-robotics-course-sp4-design.md` / `course/week4/deliverables/q1_reduced_lv1_execution_package_template.md` / `sandbox_reference/week4/q1_reduced_lv1_execution_package_example.md` の 3 件は SP5 implementation 中も無変更を維持。`q1_touchpoint` は track stub 側からの back-reference のみ。
- **References policy (spec §17)**: SP5 では新 R-* references を追加しない。index README / stub README front matter `references` field は **空 `[]` または最小限**。
- **5 objects x 3 trials の表記**: G4 patterns / activation_trigger では ASCII `x` を使用、display 用途のみ Unicode `×` 許容 (spec §3.5)。

---

## Task 0: Branch setup

**Files:**
- (no file changes; git branch only)

- [ ] **Step 1: Confirm baseline state**

```bash
git rev-parse HEAD
git status --short
git ls-files | wc -l
```
Expected: HEAD = `4f0cbc0` (SP5 spec polish), no untracked, file count = `129` (SP4 polish 128 + SP5 spec 1).

- [ ] **Step 2: Create and switch to working branch**

```bash
git checkout -b course/sp5-role-tracks-meta
```
Expected: switched to a new branch.

- [ ] **Step 3: Verify identity**

```bash
git config user.name
git config user.email
```
Expected: `pasorobo` and `goo.mail01@yahoo.com`. If different, do NOT change global; instead fix local: `git config user.name pasorobo && git config user.email goo.mail01@yahoo.com`.

- [ ] **Step 4: No commit yet** (branch creation alone is not committed). Move to Task 1.

---

## Task 1: tools/check_structure.sh — SPEC_FILES / PLAN_FILES に SP5 entries 追加

**Files:**
- Modify: `tools/check_structure.sh` (extend `SPEC_FILES` array to include SP5 spec; `PLAN_FILES` to include SP5 plan)

Spec §10.2, §11.1.

**Pre-condition**: This task assumes the SP5 plan file (this very file you are reading) has already been committed to `main` and is therefore visible from the working branch via `git log main --oneline`. The SP5 spec is commit `1861c15` + polish `4f0cbc0`. The SP5 plan must exist before T1 registers it in PLAN_FILES, otherwise `check_pattern_must` for plan 7-key validation will fail-warn.

- [ ] **Step 1: Verify SP5 spec + plan files exist**

```bash
ls -1 docs/superpowers/specs/2026-04-30-robotics-course-sp5-role-tracks-meta-design.md
ls -1 docs/superpowers/plans/2026-04-30-robotics-course-sp5-role-tracks-meta-plan.md
```
Expected: both paths print, no `cannot access` error.

- [ ] **Step 2: Inspect current SPEC_FILES / PLAN_FILES**

```bash
sed -n '218,240p' tools/check_structure.sh
```
Confirm presence of SP1/SP2/SP3/SP4 spec and plan entries (SP4 added in SP4 T3).

- [ ] **Step 3: Add SP5 entries**

Edit the `SPEC_FILES=(...)` array to add the SP5 design spec path on a new line before the closing `)`:

```bash
    "docs/superpowers/specs/2026-04-30-robotics-course-sp5-role-tracks-meta-design.md"
```

Edit the `PLAN_FILES=(...)` array to add the SP5 plan path on a new line before the closing `)`:

```bash
    "docs/superpowers/plans/2026-04-30-robotics-course-sp5-role-tracks-meta-plan.md"
```

- [ ] **Step 4: Run check_structure.sh — both SP5 docs should PASS the 7-key G2 check**

```bash
bash tools/check_structure.sh; echo "exit=$?"
```
Expected: exit 0. PASS count increases by 2 vs previous baseline (was 446 after SP4, should now be 448).

- [ ] **Step 5: Commit**

```bash
git add tools/check_structure.sh
git commit -m "$(cat <<'EOF'
tool: register SP5 spec/plan in G2 7-key validation

Spec §10.2, §11.1. Adds SP5 design spec and SP5 plan to SPEC_FILES /
PLAN_FILES arrays so check_structure.sh's existing 7-key
(type/id/title/date/status/sub_project/related_*) validation covers
them. Course 10-key COURSE_TEN_KEY_FILES list is NOT extended here;
SP5 course/role_tracks files are added in Task 9 with the strict
activation pass.
EOF
)"
```

---

## Task 2: course/role_tracks/README.md (index)

**Files:**
- Create: `course/role_tracks/README.md` (track index, `type: index`, `references: []`)

Spec §7 (index README content invariants), §10.4 (G4 index patterns).

- [ ] **Step 1: Create directory**

```bash
mkdir -p course/role_tracks
```

- [ ] **Step 2: Write `course/role_tracks/README.md`**

Use this exact content:

````markdown
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

# SP5 Role Tracks — Optional Track Frame

## 目的 / Frame only 宣言

本 frame は Phase 0 (SP1-SP4) を完了したメンバーが、Q1 観察結果に応じて必要部分だけ深掘りするための optional role track 群の入口である。

**SP5 は track content を実装しない**。各 track stub は `stub_only: true` + `do_not_implement_yet: true` + `activation_status: inactive` で意図的 deferred を明示している。lecture / lab / template / detailed procedure は **作らない**。

## 順序は実装優先順位ではない

The order of tracks in this index is **not an implementation priority**. Each track is activated only when the corresponding Q1 observation or review gate indicates a need.

この一覧の順序は実装優先順位ではない。各 track は、Q1 W1 preflight や review gate の観察結果により必要性が確認された時点で個別に発火する。

## Tracks (7 stubs)

- [environment_toolchain_readiness](environment_toolchain_readiness/README.md) — Q1 W1 preflight environment/toolchain readiness gap stub
- [robot_adapter_readiness](robot_adapter_readiness/README.md) — Q1 §4 adapter readiness / mock-to-real boundary stub
- [simulation_bridge](simulation_bridge/README.md) — Q1 §5 simulator selection / bridge schema stub
- [logging_evidence_chain](logging_evidence_chain/README.md) — Q1 §6 episode/trial/evidence chain stub
- [trial_kpi_evaluation](trial_kpi_evaluation/README.md) — Q1 §7 KPI taxonomy / 5 objects x 3 trials protocol stub
- [safety_review_sop](safety_review_sop/README.md) — Q1 §8 SOP / responsible reviewer / risk assessment stub
- [execution_coordination_governance](execution_coordination_governance/README.md) — Q1 W1 preflight pilot/operator + re_judge_gates + Codex/agentic governance stub (cross-cutting)

## Activation の流れ

各 track stub の `activation_trigger` は Q1 W1 preflight / `re_judge_gates` の observation 発火型。activation 時に当該 track の `future_spec_id: sp5x_candidate_<track_id>` を実 SP5x (例: SP5a, SP5b, ...) として brainstorming 開始する。SP5x 番号は activation 時に割り当て、SP5 meta では事前固定しない。

## Future non-stub candidate

- `ms_belief_navigation`: not included in SP5 A2-Lite stubs. It may become a future track only if Q1 MS Lv1 (fixed observation baseline) observation reveals a belief / navigation-specific gap (Nav2, Kachaka, etc.).

## SP1 legacy-name mapping

SP1 spec §5 anticipated 7 role tracks with role-name axis. SP5 A2-Lite re-aligns to Q1 observation axis. The mapping:

- `affordance_calibration` (SP1): folded into `trial_kpi_evaluation`.
- `robot_adapter_safety` (SP1): split into `robot_adapter_readiness` and `safety_review_sop`.
- `logging_gate_eval` (SP1): split into `logging_evidence_chain` and `trial_kpi_evaluation`.
- `simulation_bridge` (SP1): retained as `simulation_bridge`.
- `ms_belief_navigation` (SP1): deferred as a future non-stub candidate (above).
- `cc_gate_0a` (SP1): treated as an evaluation target inside `trial_kpi_evaluation`, not as a standalone role track.
- `agentic_workflow_sandbox` (SP1): folded into `execution_coordination_governance`.
````

- [ ] **Step 3: Verify front matter parses (10-key)**

```bash
awk '/^---$/{c++; if(c==2)exit; next} c==1' course/role_tracks/README.md | grep -E "^(type|id|title|week|duration_min|prerequisites|worldcpj_ct|roles|references|deliverables):"
```
Expected: 10 lines printed (one per key).

- [ ] **Step 4: Verify all 6 index G4 patterns present (preview, not yet active until T9)**

```bash
F=course/role_tracks/README.md
grep -qF "role_tracks" "$F" && echo "index role_tracks OK"
grep -qE "(順序.*優先順位.*ではない|order.*not.*priority)" "$F" && echo "index priority disclaimer OK"
grep -qF "Q1 W1 preflight" "$F" && echo "index activation context OK"
grep -qF "activation_trigger" "$F" && echo "index meta key OK"
grep -qF "sp5x_candidate_" "$F" && echo "index naming convention OK"
grep -qF "stub_only" "$F" && echo "index A2-Lite signal OK"
```
Expected: 6 OK.

- [ ] **Step 5: Commit**

```bash
git add course/role_tracks/README.md
git commit -m "$(cat <<'EOF'
docs: add course/role_tracks index (SP5 frame only)

Spec §7. type:index, 10-key front matter, references:[] (SP5
references policy: minimal & internal-first). Body declares
frame-only intent, bilingual "順序は優先順位ではない" disclaimer,
7 stubs Markdown link list, activation flow note, future non-stub
candidate (ms_belief_navigation), and SP1 legacy-name mapping
(affordance/robot_adapter_safety/logging_gate_eval/simulation_bridge/
ms_belief_navigation/cc_gate_0a/agentic_workflow_sandbox).

Index G4 patterns (6) will be activated in Task 9 (strict mode).
EOF
)"
```

---

## Task 3: environment_toolchain_readiness stub

**Files:**
- Create: `course/role_tracks/environment_toolchain_readiness/README.md` (`type: reference`, body 30-50 行程度)

Spec §8 (stub README content invariants), §10.4 (G4 per-stub patterns), §5.3 (activation_trigger 確定文).

- [ ] **Step 1: Create directory**

```bash
mkdir -p course/role_tracks/environment_toolchain_readiness
```

- [ ] **Step 2: Write the stub**

````markdown
---
type: reference
id: SP5-RT-ENVIRONMENT-TOOLCHAIN-READINESS
title: environment_toolchain_readiness — Optional Role Track stub (frame only, do not implement yet)
week: 5
duration_min: 0
prerequisites: [SP1, SP2, SP3, SP4]
worldcpj_ct: [CT-04]
roles: [common, environment]
references: []
deliverables: []
---

# environment_toolchain_readiness — Role Track stub (frame only)

## Track meta

```yaml
track_id: environment_toolchain_readiness
role: Environment / Toolchain Role
purpose: "Q1 W1 preflight で environment/toolchain readiness gap が観察された場合に深掘りする optional role track"
prerequisites:
  - SP1 completed
  - SP2 completed
  - SP3 completed
  - SP4 completed (Q1 Package available)
expected_learner: "Q1 で environment_stack / ROS 2 sourcing / tooling readiness を担当するメンバー"
q1_touchpoint:
  - q1_package:3_environment_stack
  - q1_w1_preflight:item_1_verify_env_week4
  - q1_w1_preflight:item_2_ros2_doctor_or_equivalent
activation_trigger: "Activate this track if Q1 W1 preflight reveals environment_stack version drift, ROS 2 sourcing issue, or tooling readiness gap."
future_spec_id: sp5x_candidate_environment_toolchain_readiness
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

## What this track is for

Q1 W1 preflight (`tools/verify_env.sh --week 4` または `ros2 doctor` 同等物) で観察される environment_stack の version drift / ROS 2 sourcing 問題 / tooling readiness gap に対応する optional role track。Phase 0 (SP1-SP4) で確立した baseline (Ubuntu 22.04 / ROS 2 Humble / Gazebo Fortress / MoveIt 2 / ros2_control) からのズレが Q1 実行を阻害する場合に深掘りする。

## When to activate

Q1 Package §3 environment_stack 行の `review_status` が `reviewed_with_conditions` または `blocked` となり、`q1_w1_preflight` item 1 (verify_env --week 4) または item 2 (ros2 doctor or equivalent) の結果が pre-start gate (`re_judge_gates:q1_w1_pre_start`) で課題として記録された時。

## What not to implement yet

本 stub は `stub_only: true` であり、environment setup procedure / verify_env mode 拡張 / OS-level recovery playbook 等の content は SP5 では作らない。activation 時に新 sub-project (`sp5x_candidate_environment_toolchain_readiness`) として brainstorming → spec → plan → implementation を行う。
````

- [ ] **Step 3: Verify all 8 generic G4 patterns present**

```bash
F=course/role_tracks/environment_toolchain_readiness/README.md
for kw in "track_id:" "q1_touchpoint:" "activation_trigger:" "future_spec_id:" "stub_only: true" "do_not_implement_yet: true" "out_of_scope:" "activation_status: inactive"; do
    grep -qF "$kw" "$F" && echo "ETR generic '$kw' OK" || echo "ETR FAIL: '$kw' missing"
done
grep -qF "future_spec_id: sp5x_candidate_environment_toolchain_readiness" "$F" && echo "ETR exact value OK"
```
Expected: 8 generic OK + 1 exact value OK = 9 OK, 0 FAIL.

- [ ] **Step 4: Verify body row count (review acceptance, 30-50 行)**

```bash
awk '/^---$/{c++; if(c==2){flag=1; next}} flag{print}' course/role_tracks/environment_toolchain_readiness/README.md | wc -l
```
Expected: 30-50 程度 (front matter を除外した body 行数)。範囲外でも G4 hard gate ではないため警告のみ。

- [ ] **Step 5: Commit**

```bash
git add course/role_tracks/environment_toolchain_readiness/
git commit -m "$(cat <<'EOF'
docs: add environment_toolchain_readiness track stub (SP5-RT)

Spec §8 §5.3 §10.4. type:reference, 10-key front matter,
references:[]. Body declares 8 fields (track_id / q1_touchpoint /
activation_trigger / future_spec_id:sp5x_candidate_environment_
toolchain_readiness / activation_status:inactive / stub_only:true /
do_not_implement_yet:true / out_of_scope) plus 3 prose sections
(What this track is for / When to activate / What not to implement
yet). q1_touchpoint canonical IDs: q1_package:3_environment_stack +
q1_w1_preflight item 1/2.

Stub G4 patterns will be activated in Task 9 (strict mode).
EOF
)"
```

---

## Task 4: robot_adapter_readiness stub

**Files:**
- Create: `course/role_tracks/robot_adapter_readiness/README.md` (`type: reference`, body 30-50 行)

Spec §8, §10.4, §5.3.

- [ ] **Step 1: Create directory**

```bash
mkdir -p course/role_tracks/robot_adapter_readiness
```

- [ ] **Step 2: Write the stub**

````markdown
---
type: reference
id: SP5-RT-ROBOT-ADAPTER-READINESS
title: robot_adapter_readiness — Optional Role Track stub (frame only, do not implement yet)
week: 5
duration_min: 0
prerequisites: [SP1, SP2, SP4]
worldcpj_ct: [CT-06]
roles: [common, adapter]
references: []
deliverables: []
---

# robot_adapter_readiness — Role Track stub (frame only)

## Track meta

```yaml
track_id: robot_adapter_readiness
role: Robot Adapter Role
purpose: "Q1 W1 preflight で adapter readiness / mock-to-real boundary gap が観察された場合に深掘りする optional role track"
prerequisites:
  - SP1 completed
  - SP2 completed (Robot Adapter / safe no-action baseline)
  - SP4 completed (Q1 Package available)
expected_learner: "Q1 で robot adapter readiness / mock-to-real boundary / IK mock / URSim setup を担当するメンバー"
q1_touchpoint:
  - q1_package:4_robot_adapter_readiness
  - q1_w1_preflight:item_3_mock_adapter_noop
activation_trigger: "Activate this track if Q1 W1 preflight reveals adapter readiness gap, mock-to-real boundary ambiguity, or no-op adapter validation gap."
future_spec_id: sp5x_candidate_robot_adapter_readiness
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

## What this track is for

Q1 W1 preflight (`q1_w1_preflight:item_3_mock_adapter_noop`) で観察される robot adapter の readiness gap (mock_adapter_v0 が no-op を実行できない / mock-to-real boundary が曖昧 / IK mock が未実装 / URSim setup が確立していない) に対応する optional role track。SP2 で確立した mock_hardware_adapter baseline + safe no-action policy の延長線で深掘りする。

## When to activate

Q1 Package §4 robot_adapter_readiness 行の `review_status` が `reviewed_with_conditions` または `blocked` となり、`q1_w1_preflight` item 3 (mock adapter no-op) が pre-start gate (`re_judge_gates:q1_w1_pre_start`) で課題として記録された時。

## What not to implement yet

本 stub は `stub_only: true` であり、URSim install 自動化 / URDF + IK mock adapter (KDL ベース) Codex 課題 / adapter capability matrix の content は SP5 では作らない。activation 時に新 sub-project (`sp5x_candidate_robot_adapter_readiness`) として brainstorming → spec → plan → implementation を行う。
````

- [ ] **Step 3: Verify all 8 generic G4 patterns + 1 exact value**

```bash
F=course/role_tracks/robot_adapter_readiness/README.md
for kw in "track_id:" "q1_touchpoint:" "activation_trigger:" "future_spec_id:" "stub_only: true" "do_not_implement_yet: true" "out_of_scope:" "activation_status: inactive"; do
    grep -qF "$kw" "$F" && echo "RAR generic '$kw' OK" || echo "RAR FAIL: '$kw' missing"
done
grep -qF "future_spec_id: sp5x_candidate_robot_adapter_readiness" "$F" && echo "RAR exact value OK"
```
Expected: 9 OK.

- [ ] **Step 4: Commit**

```bash
git add course/role_tracks/robot_adapter_readiness/
git commit -m "$(cat <<'EOF'
docs: add robot_adapter_readiness track stub (SP5-RT)

Spec §8 §5.3 §10.4. type:reference, 10-key front matter,
references:[]. Body declares 8 fields plus 3 prose sections.
q1_touchpoint canonical IDs: q1_package:4_robot_adapter_readiness +
q1_w1_preflight:item_3_mock_adapter_noop. SP1 robot_adapter_safety
の adapter side をここに分離 (safety side は safety_review_sop track
へ separate). future_spec_id: sp5x_candidate_robot_adapter_readiness.

Stub G4 patterns will be activated in Task 9 (strict mode).
EOF
)"
```

---

## Task 5: simulation_bridge stub

**Files:**
- Create: `course/role_tracks/simulation_bridge/README.md` (`type: reference`, body 30-50 行)

Spec §8, §10.4, §5.3.

- [ ] **Step 1: Create directory**

```bash
mkdir -p course/role_tracks/simulation_bridge
```

- [ ] **Step 2: Write the stub**

````markdown
---
type: reference
id: SP5-RT-SIMULATION-BRIDGE
title: simulation_bridge — Optional Role Track stub (frame only, do not implement yet)
week: 5
duration_min: 0
prerequisites: [SP1, SP3, SP4]
worldcpj_ct: [CT-08]
roles: [common, sim, sandbox]
references: []
deliverables: []
---

# simulation_bridge — Role Track stub (frame only)

## Track meta

```yaml
track_id: simulation_bridge
role: Sim Bridge / Sandbox Bridge Role
purpose: "Q1 W1 preflight や q1_w1_exit で simulator selection / bridge schema / sim-to-logging integration gap が観察された場合に深掘りする optional role track"
prerequisites:
  - SP1 completed
  - SP3 completed (Gazebo Fortress + ros_gz_bridge baseline)
  - SP4 completed (Q1 Package available)
expected_learner: "Q1 で simulation bridge / provisional schema / alternative simulators を担当するメンバー"
q1_touchpoint:
  - q1_package:5_simulation_bridge_status
  - re_judge_gates:q1_w1_exit
  - re_judge_gates:q1_mid_point
activation_trigger: "Activate this track if Q1 W1 preflight or q1_w1_exit gate reveals simulator selection, bridge schema, or sim-to-logging integration gap."
future_spec_id: sp5x_candidate_simulation_bridge
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

## What this track is for

Q1 W1 preflight または `re_judge_gates:q1_w1_exit` / `q1_mid_point` で観察される simulator selection (Gazebo を継続するか alternative に切り替えるか) / provisional schema 8 fields の運用判断 / sim-to-logging integration gap に対応する optional role track。SP3 で確立した Gazebo Fortress baseline と provisional schema の延長線で深掘りする。

## When to activate

Q1 Package §5 simulation_bridge_status 行の `review_status` が `reviewed_with_conditions` または `blocked` となり、`q1_w1_exit` または `q1_mid_point` gate で課題として記録された時。

## What not to implement yet

本 stub は `stub_only: true` であり、alternative simulator (MuJoCo / ManiSkill / Isaac 等) の install 手順 / hands-on lab / `<gazebo>` URDF extension / SDF world ファイル設計 の content は SP5 では作らない。activation 時に新 sub-project (`sp5x_candidate_simulation_bridge`) として brainstorming → spec → plan → implementation を行う。具体 simulator 名を本 stub の prose に追加しない方針 (spec §3.5)。
````

- [ ] **Step 3: Verify**

```bash
F=course/role_tracks/simulation_bridge/README.md
for kw in "track_id:" "q1_touchpoint:" "activation_trigger:" "future_spec_id:" "stub_only: true" "do_not_implement_yet: true" "out_of_scope:" "activation_status: inactive"; do
    grep -qF "$kw" "$F" && echo "SB generic '$kw' OK"
done
grep -qF "future_spec_id: sp5x_candidate_simulation_bridge" "$F" && echo "SB exact value OK"
```
Expected: 9 OK.

- [ ] **Step 4: Commit**

```bash
git add course/role_tracks/simulation_bridge/
git commit -m "$(cat <<'EOF'
docs: add simulation_bridge track stub (SP5-RT)

Spec §8 §5.3 §10.4. type:reference, 10-key front matter,
references:[]. Body declares 8 fields plus 3 prose sections.
q1_touchpoint canonical IDs: q1_package:5_simulation_bridge_status +
re_judge_gates:q1_w1_exit + re_judge_gates:q1_mid_point. SP1
simulation_bridge naming retained. future_spec_id:
sp5x_candidate_simulation_bridge. Specific simulator names
(MuJoCo / ManiSkill / Isaac etc.) are intentionally NOT enumerated
in stub prose per spec §3.5.

Stub G4 patterns will be activated in Task 9 (strict mode).
EOF
)"
```

---

## Task 6: logging_evidence_chain stub

**Files:**
- Create: `course/role_tracks/logging_evidence_chain/README.md` (`type: reference`, body 30-50 行)

Spec §8, §10.4, §5.3.

- [ ] **Step 1: Create directory**

```bash
mkdir -p course/role_tracks/logging_evidence_chain
```

- [ ] **Step 2: Write the stub**

````markdown
---
type: reference
id: SP5-RT-LOGGING-EVIDENCE-CHAIN
title: logging_evidence_chain — Optional Role Track stub (frame only, do not implement yet)
week: 5
duration_min: 0
prerequisites: [SP1, SP4]
worldcpj_ct: [CT-07]
roles: [common, logging]
references: []
deliverables: []
---

# logging_evidence_chain — Role Track stub (frame only)

## Track meta

```yaml
track_id: logging_evidence_chain
role: Logging Role
purpose: "Q1 W1 preflight / pilot trial / q1_w1_exit で logging/evidence chain gap が観察された場合に深掘りする optional role track"
prerequisites:
  - SP1 completed (W1 Lab 1 turtlesim bag baseline)
  - SP4 completed (episode_record / trial_sheet / Q1 Package §6 logging_episode_plan)
expected_learner: "Q1 で rosbag2 / MCAP / episode_record / trial_sheet / evidence_path を担当するメンバー"
q1_touchpoint:
  - q1_package:6_logging_episode_plan
  - q1_w1_preflight:item_4_required_topics
  - q1_w1_preflight:item_5_rosbag2_record
activation_trigger: "Activate this track if Q1 W1 preflight, pilot trial, or q1_w1_exit gate reveals logging/evidence chain gap, topic coverage gap, episode-to-trial linkage gap, or evidence_path completeness issue."
future_spec_id: sp5x_candidate_logging_evidence_chain
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

## What this track is for

Q1 W1 preflight (`q1_w1_preflight:item_4_required_topics`、`item_5_rosbag2_record`) または pilot trial / `re_judge_gates:q1_w1_exit` で観察される logging/evidence chain gap (記録 topic 不足 / episode-to-trial linkage 欠落 / evidence_path completeness 不備 / MCAP plugin 必要性) に対応する optional role track。SP4 で確立した episode_record + trial_sheet + Q1 Package §6 logging_episode_plan の延長線で深掘りする。

## When to activate

Q1 Package §6 logging_episode_plan 行の `review_status` が `reviewed_with_conditions` または `blocked` となり、`q1_w1_preflight` item 4 / item 5、または `q1_w1_exit` gate で課題として記録された時。

## What not to implement yet

本 stub は `stub_only: true` であり、MCAP plugin の install + 実録画手順 / rosbag2 custom storage plugin / bag → episode_record automation tooling / LeRobot との差分検討 の content は SP5 では作らない。activation 時に新 sub-project (`sp5x_candidate_logging_evidence_chain`) として brainstorming → spec → plan → implementation を行う。
````

- [ ] **Step 3: Verify**

```bash
F=course/role_tracks/logging_evidence_chain/README.md
for kw in "track_id:" "q1_touchpoint:" "activation_trigger:" "future_spec_id:" "stub_only: true" "do_not_implement_yet: true" "out_of_scope:" "activation_status: inactive"; do
    grep -qF "$kw" "$F" && echo "LEC generic '$kw' OK"
done
grep -qF "future_spec_id: sp5x_candidate_logging_evidence_chain" "$F" && echo "LEC exact value OK"
```
Expected: 9 OK.

- [ ] **Step 4: Commit**

```bash
git add course/role_tracks/logging_evidence_chain/
git commit -m "$(cat <<'EOF'
docs: add logging_evidence_chain track stub (SP5-RT)

Spec §8 §5.3 §10.4. type:reference, 10-key front matter,
references:[]. Body declares 8 fields plus 3 prose sections.
q1_touchpoint canonical IDs: q1_package:6_logging_episode_plan +
q1_w1_preflight item 4/5. SP1 logging_gate_eval を分割した logging
side (evaluation side は trial_kpi_evaluation track). MCAP install
hands-on は SP4 で Stretch、本 track activation 時に深掘り対象。
future_spec_id: sp5x_candidate_logging_evidence_chain.

Stub G4 patterns will be activated in Task 9 (strict mode).
EOF
)"
```

---

## Task 7: trial_kpi_evaluation stub

**Files:**
- Create: `course/role_tracks/trial_kpi_evaluation/README.md` (`type: reference`, body 30-50 行)

Spec §8, §10.4, §5.3.

- [ ] **Step 1: Create directory**

```bash
mkdir -p course/role_tracks/trial_kpi_evaluation
```

- [ ] **Step 2: Write the stub**

````markdown
---
type: reference
id: SP5-RT-TRIAL-KPI-EVALUATION
title: trial_kpi_evaluation — Optional Role Track stub (frame only, do not implement yet)
week: 5
duration_min: 0
prerequisites: [SP1, SP4]
worldcpj_ct: [CT-01, CT-02, CT-07]
roles: [common, evaluation]
references: []
deliverables: []
---

# trial_kpi_evaluation — Role Track stub (frame only)

## Track meta

```yaml
track_id: trial_kpi_evaluation
role: Evaluation / Trial Role
purpose: "q1_w1_exit や q1_mid_point で KPI taxonomy / trial aggregation / CC Gate 0-a 5 objects x 3 trials evaluation protocol gap が観察された場合に深掘りする optional role track"
prerequisites:
  - SP1 completed
  - SP4 completed (trial_sheet 15 planned rows skeleton + Q1 Package §7 trial_kpi_plan)
expected_learner: "Q1 で CC Gate 0-a evaluation / KPI taxonomy / trial 集計 を担当するメンバー"
q1_touchpoint:
  - q1_package:7_trial_kpi_plan
  - re_judge_gates:q1_w1_exit
activation_trigger: "Activate this track if q1_w1_exit or q1_mid_point gate reveals KPI taxonomy, trial aggregation, or CC Gate 0-a 5 objects x 3 trials evaluation protocol gap."
future_spec_id: sp5x_candidate_trial_kpi_evaluation
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

## What this track is for

`re_judge_gates:q1_w1_exit` (1 pilot trial 後の再判断) または `q1_mid_point` (W2 以降 detail の確定) で観察される KPI taxonomy の不足 / trial aggregation 方法の曖昧 / CC Gate 0-a 5 objects x 3 trials evaluation protocol gap (例: 統計手法 / failure_reason refinement) に対応する optional role track。SP4 で確立した trial_sheet 15 planned rows skeleton + Q1 Package §7 trial_kpi_plan + KPI fields (`kpi_grasp_success` / `kpi_time_to_grasp_sec`) の延長線で深掘りする。SP1 `cc_gate_0a` track はこの track の中の evaluation target として扱われる (independent track ではない)。

## When to activate

Q1 Package §7 trial_kpi_plan 行の `review_status` が `reviewed_with_conditions` または `blocked` となり、`q1_w1_exit` または `q1_mid_point` gate で課題として記録された時。

## What not to implement yet

本 stub は `stub_only: true` であり、KPI 統計分析 lab / failure taxonomy 改訂手順 / trial aggregation tooling / Modern Robotics 索引 (affordance evaluation 側) の content は SP5 では作らない。activation 時に新 sub-project (`sp5x_candidate_trial_kpi_evaluation`) として brainstorming → spec → plan → implementation を行う。
````

- [ ] **Step 3: Verify**

```bash
F=course/role_tracks/trial_kpi_evaluation/README.md
for kw in "track_id:" "q1_touchpoint:" "activation_trigger:" "future_spec_id:" "stub_only: true" "do_not_implement_yet: true" "out_of_scope:" "activation_status: inactive"; do
    grep -qF "$kw" "$F" && echo "TKE generic '$kw' OK"
done
grep -qF "future_spec_id: sp5x_candidate_trial_kpi_evaluation" "$F" && echo "TKE exact value OK"
```
Expected: 9 OK.

- [ ] **Step 4: Commit**

```bash
git add course/role_tracks/trial_kpi_evaluation/
git commit -m "$(cat <<'EOF'
docs: add trial_kpi_evaluation track stub (SP5-RT)

Spec §8 §5.3 §10.4. type:reference, 10-key front matter,
references:[]. Body declares 8 fields plus 3 prose sections.
q1_touchpoint canonical IDs: q1_package:7_trial_kpi_plan +
re_judge_gates:q1_w1_exit. SP1 cc_gate_0a は本 track の中の
evaluation target として扱う (independent track ではない). SP1
affordance_calibration もここに folded (Q1 reduced Lv1 evaluation
framing). future_spec_id: sp5x_candidate_trial_kpi_evaluation.

Stub G4 patterns will be activated in Task 9 (strict mode).
EOF
)"
```

---

## Task 8: safety_review_sop stub

**Files:**
- Create: `course/role_tracks/safety_review_sop/README.md` (`type: reference`, body 30-50 行)

Spec §8, §10.4, §5.3.

- [ ] **Step 1: Create directory**

```bash
mkdir -p course/role_tracks/safety_review_sop
```

- [ ] **Step 2: Write the stub**

````markdown
---
type: reference
id: SP5-RT-SAFETY-REVIEW-SOP
title: safety_review_sop — Optional Role Track stub (frame only, do not implement yet)
week: 5
duration_min: 0
prerequisites: [SP2, SP4]
worldcpj_ct: [CT-09]
roles: [common, safety]
references: []
deliverables: []
---

# safety_review_sop — Role Track stub (frame only)

## Track meta

```yaml
track_id: safety_review_sop
role: Safety / Compliance Role
purpose: "q1_w1_pre_start gate で SOP draft / responsible reviewer / risk assessment / site-fit safety review gap が観察された場合に深掘りする optional role track"
prerequisites:
  - SP2 completed (W2 L4 safety vocabulary)
  - SP4 completed (W4 L8 + safety_checklist + Q1 Package §8 safety_review_go_no_go)
expected_learner: "Q1 で safety review / SOP / responsible reviewer / risk assessment を担当するメンバー (現場の safety officer / role owner)"
q1_touchpoint:
  - q1_package:8_safety_review_go_no_go
  - q1_w1_preflight:item_6_safety_review
  - re_judge_gates:q1_w1_pre_start
activation_trigger: "Activate this track if q1_w1_pre_start gate reveals SOP draft, responsible reviewer, risk assessment, or site-fit safety review gap."
future_spec_id: sp5x_candidate_safety_review_sop
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

## What this track is for

`re_judge_gates:q1_w1_pre_start` で観察される SOP draft の質 / responsible reviewer の確定 / risk assessment の depth / site-fit safety review (UR safety 深掘り、ISO 10218 適用検討、現場 SOP fit) gap に対応する optional role track。SP2 W2 L4 で確立した safety vocabulary + SP4 W4 L8 で確立した safety_checklist (training_draft_only) と Q1 Package §8 safety_review_go_no_go の延長線で深掘りする。SP1 `robot_adapter_safety` の safety side をここに分離 (adapter side は `robot_adapter_readiness` track へ separate)。

## When to activate

Q1 Package §8 safety_review_go_no_go 行の `review_status` が `not_reviewed` のまま Q1 W1 開始期日に近づいた時、または `q1_w1_preflight` item 6 (safety review) が pre-start gate (`re_judge_gates:q1_w1_pre_start`) で blocker として記録された時。

## What not to implement yet

本 stub は `stub_only: true` であり、UR safety docs 深掘り / ISO 10218 適用 hands-on / 現場 SOP テンプレート / risk assessment 手法ライブラリ / responsible reviewer onboarding kit の content は SP5 では作らない。activation 時に新 sub-project (`sp5x_candidate_safety_review_sop`) として brainstorming → spec → plan → implementation を行う。本 track の content は **必ず** site SOP / responsible safety reviewer / robot model 固有の risk assessment と整合させる必要がある (Phase 0 SP4 §11.4 と同じ境界)。
````

- [ ] **Step 3: Verify**

```bash
F=course/role_tracks/safety_review_sop/README.md
for kw in "track_id:" "q1_touchpoint:" "activation_trigger:" "future_spec_id:" "stub_only: true" "do_not_implement_yet: true" "out_of_scope:" "activation_status: inactive"; do
    grep -qF "$kw" "$F" && echo "SRS generic '$kw' OK"
done
grep -qF "future_spec_id: sp5x_candidate_safety_review_sop" "$F" && echo "SRS exact value OK"
```
Expected: 9 OK.

- [ ] **Step 4: Commit**

```bash
git add course/role_tracks/safety_review_sop/
git commit -m "$(cat <<'EOF'
docs: add safety_review_sop track stub (SP5-RT)

Spec §8 §5.3 §10.4. type:reference, 10-key front matter,
references:[]. Body declares 8 fields plus 3 prose sections.
q1_touchpoint canonical IDs: q1_package:8_safety_review_go_no_go +
q1_w1_preflight:item_6_safety_review + re_judge_gates:q1_w1_pre_start.
SP1 robot_adapter_safety の safety side をここに分離 (adapter side
は robot_adapter_readiness). 本 track content は site SOP /
responsible safety reviewer / robot model 固有 risk assessment と
整合必須 (SP4 §11.4 境界継承). future_spec_id:
sp5x_candidate_safety_review_sop.

Stub G4 patterns will be activated in Task 9 (strict mode).
EOF
)"
```

---

## Task 8b: execution_coordination_governance stub (Codex 境界 4 行 必須)

**Files:**
- Create: `course/role_tracks/execution_coordination_governance/README.md` (`type: reference`, body 30-50 行 + Codex 境界 4 行 = 約 40-55 行)

Spec §8.5 (execution_coordination_governance 固有 Codex 境界), §10.4 (Codex 境界 4 fixed patterns), §5.3.

**重要**: Codex 境界 4 行は `out_of_scope` 配列の **独立 entry (exact line)** として 4 行で記載する。圧縮表現 (例: `Codex must not implement robotics logic, make scope or safety decisions, or replace human pilot review.`) は G4 exact match で fail するため禁止。

- [ ] **Step 1: Create directory**

```bash
mkdir -p course/role_tracks/execution_coordination_governance
```

- [ ] **Step 2: Write the stub**

````markdown
---
type: reference
id: SP5-RT-EXECUTION-COORDINATION-GOVERNANCE
title: execution_coordination_governance — Optional Role Track stub (frame only, do not implement yet, cross-cutting)
week: 5
duration_min: 0
prerequisites: [SP1, SP2, SP3, SP4]
worldcpj_ct: [CT-04, CT-09]
roles: [common, governance]
references: []
deliverables: []
---

# execution_coordination_governance — Role Track stub (frame only, cross-cutting)

## Track meta

```yaml
track_id: execution_coordination_governance
role: Execution Coordination / Workflow Governance Role (cross-cutting)
purpose: "q1_w1_pre_start / q1_w1_exit / q1_mid_point / q1_closeout のいずれかで operator workflow / pilot review / re_judge_gates 運用 / Codex/agentic governance gap が観察された場合に深掘りする optional role track (cross-cutting)"
prerequisites:
  - SP1 completed
  - SP2 completed (Lab 4b Codex no-op adapter logger)
  - SP3 completed (Lab 6b Codex no-op bridge stub)
  - SP4 completed (Lab 8b sandbox final review with optional Codex)
expected_learner: "Q1 で operator workflow coordination / pilot review process / re_judge_gates 運用 / Codex 補助の governance を担当するメンバー (cross-cutting role)"
q1_touchpoint:
  - q1_w1_preflight:item_7_one_object_one_pilot_trial
  - q1_w1_preflight:item_8_pilot_review_before_15_trials
  - re_judge_gates:q1_w1_pre_start
  - re_judge_gates:q1_w1_exit
  - re_judge_gates:q1_mid_point
  - re_judge_gates:q1_closeout
activation_trigger: "Activate this track if q1_w1_pre_start, q1_w1_exit, q1_mid_point, or q1_closeout gate reveals operator workflow, pilot review process, re_judge_gates operation, or Codex/agentic workflow governance gap."
future_spec_id: sp5x_candidate_execution_coordination_governance
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
  - Codex must not implement robotics logic
  - Codex must not make scope decisions
  - Codex must not make safety decisions
  - Codex must not replace human pilot review
```

## What this track is for

Q1 W1 pilot trial の coordination / pilot review が 15 trials へ進む判断 / `re_judge_gates` 4 件全体の運用 / Codex / agentic workflow を review 補助として使う場合の governance に対応する cross-cutting optional role track。SP4 Lab 8b で確立した Codex-optional + human-found patterns 5+ + scope decision by human の境界をそのまま延長する。

Codex / agentic workflow may **summarize** review notes. Codex must not implement robotics logic, expand Q1 scope, make execution decisions, make safety decisions, or replace human pilot review. SP4 Lab 8b の境界をそのまま延長する。

## When to activate

`re_judge_gates` 4 件 (`q1_w1_pre_start` / `q1_w1_exit` / `q1_mid_point` / `q1_closeout`) のいずれかで operator workflow の coordination 不足 / pilot review process の曖昧 / `re_judge_gates` 運用 (誰が gate 通過判定を出すか) / Codex 補助の governance (accepted/rejected の rationale 不足、scope decision を Codex に委ねた) が課題として記録された時。

## What not to implement yet

本 stub は `stub_only: true` であり、operator onboarding lab / pilot review template / re_judge_gates 運用 playbook / Codex governance kit / agentic workflow audit checklist の content は SP5 では作らない。activation 時に新 sub-project (`sp5x_candidate_execution_coordination_governance`) として brainstorming → spec → plan → implementation を行う。Codex 境界 4 行 (out_of_scope 配列内) は activation 後も維持する (SP4 Lab 8b 境界の継承)。
````

- [ ] **Step 3: Verify all 8 generic + 1 exact value + 4 Codex 境界 patterns**

```bash
F=course/role_tracks/execution_coordination_governance/README.md
for kw in "track_id:" "q1_touchpoint:" "activation_trigger:" "future_spec_id:" "stub_only: true" "do_not_implement_yet: true" "out_of_scope:" "activation_status: inactive"; do
    grep -qF "$kw" "$F" && echo "ECG generic '$kw' OK"
done
grep -qF "future_spec_id: sp5x_candidate_execution_coordination_governance" "$F" && echo "ECG exact value OK"
grep -qF "Codex must not implement robotics logic" "$F" && echo "ECG Codex no-implement OK"
grep -qF "Codex must not make scope decisions" "$F" && echo "ECG Codex no-scope OK"
grep -qF "Codex must not make safety decisions" "$F" && echo "ECG Codex no-safety OK"
grep -qF "Codex must not replace human pilot review" "$F" && echo "ECG Codex no-replace OK"
```
Expected: 13 OK (8 generic + 1 exact + 4 Codex).

- [ ] **Step 4: Commit**

```bash
git add course/role_tracks/execution_coordination_governance/
git commit -m "$(cat <<'EOF'
docs: add execution_coordination_governance track stub (SP5-RT, cross-cutting)

Spec §8.5 §5.3 §10.4. type:reference, 10-key front matter,
references:[]. Body declares 8 fields plus 3 prose sections.
q1_touchpoint canonical IDs: q1_w1_preflight item 7/8 + re_judge_gates
4 件全て (q1_w1_pre_start / q1_w1_exit / q1_mid_point / q1_closeout).
Cross-cutting track. SP1 agentic_workflow_sandbox をここに folded
(Codex governance side). Codex 境界 4 行 (Codex must not: implement
robotics logic / make scope decisions / make safety decisions /
replace human pilot review) を out_of_scope 配列の独立 entry として
exact line で記載 (圧縮表現は G4 fail するため禁止). future_spec_id:
sp5x_candidate_execution_coordination_governance.

Stub G4 patterns (12: 8 generic + 1 exact + 4 Codex) will be
activated in Task 9 (strict mode).
EOF
)"
```

---

## Task 9: tools/check_structure.sh — SP5 strict pattern activation (root README G4 を除く 76 patterns)

**Files:**
- Modify: `tools/check_structure.sh` (extend EXPECTED_FILES with 8 SP5 entries; COURSE_TEN_KEY_FILES with 8 SP5 entries; insert 76 G4 patterns block: per-stub generic 8×7=56 + track-specific exact 7 + index 6 + Codex boundary 4 + self-reference 3)

Spec §10 (Validation Gates extension), §11.1 (Two-stage activation), §11.2 (root README G4 timing).

**重要**: 本 task では root README G4 (2 patterns) は **追加しない**。T10 で root README update と同 commit で追加する (root README が未更新の状態で root README G4 を有効化すると T9 commit が fail するため)。

- [ ] **Step 1: Add SP5 entries to EXPECTED_FILES**

Find the existing `EXPECTED_FILES=(...)` array. Add the following lines before the closing `)`:

```bash
    # === SP5 / Role Tracks (frame only, A2-Lite) ===
    "course/role_tracks/README.md"
    "course/role_tracks/environment_toolchain_readiness/README.md"
    "course/role_tracks/robot_adapter_readiness/README.md"
    "course/role_tracks/simulation_bridge/README.md"
    "course/role_tracks/logging_evidence_chain/README.md"
    "course/role_tracks/trial_kpi_evaluation/README.md"
    "course/role_tracks/safety_review_sop/README.md"
    "course/role_tracks/execution_coordination_governance/README.md"
```

- [ ] **Step 2: Add SP5 entries to COURSE_TEN_KEY_FILES**

Find the `COURSE_TEN_KEY_FILES=(...)` array. Add the following lines before the closing `)`:

```bash
    # === SP5 / Role Tracks (10-key required: index, reference) ===
    "course/role_tracks/README.md"
    "course/role_tracks/environment_toolchain_readiness/README.md"
    "course/role_tracks/robot_adapter_readiness/README.md"
    "course/role_tracks/simulation_bridge/README.md"
    "course/role_tracks/logging_evidence_chain/README.md"
    "course/role_tracks/trial_kpi_evaluation/README.md"
    "course/role_tracks/safety_review_sop/README.md"
    "course/role_tracks/execution_coordination_governance/README.md"
```

- [ ] **Step 3: Append SP5 G4 patterns block at the END of the existing G4 section**

Find the END of the existing G4 patterns area (after all SP1-SP4 calls, before the script's exit logic). Insert the following block:

```bash
# ---------- G4: SP5 / Role Tracks patterns ----------
echo
echo "==== G4: SP5 (Role Tracks) content patterns ===="

# Per-stub generic (8 × 7 = 56) + track-specific exact (1 × 7 = 7)
for track in environment_toolchain_readiness robot_adapter_readiness simulation_bridge \
             logging_evidence_chain trial_kpi_evaluation safety_review_sop \
             execution_coordination_governance; do
    F="course/role_tracks/${track}/README.md"
    for kw in "track_id:" "q1_touchpoint:" "activation_trigger:" "future_spec_id:" \
              "stub_only: true" "do_not_implement_yet: true" "out_of_scope:" \
              "activation_status: inactive"; do
        check_pattern_must "$F" "$kw" "SP5 stub ${track} ${kw}"
    done
    check_pattern_must "$F" "future_spec_id: sp5x_candidate_${track}" "SP5 stub ${track} sp5x_candidate"
done

# Index README (6)
INDEX="course/role_tracks/README.md"
check_pattern_must "$INDEX" "role_tracks" "SP5 index role_tracks"
check_pattern_must "$INDEX" "(順序.*優先順位.*ではない|order.*not.*priority)" "SP5 index priority disclaimer"
check_pattern_must "$INDEX" "Q1 W1 preflight" "SP5 index activation context"
check_pattern_must "$INDEX" "activation_trigger" "SP5 index meta key"
check_pattern_must "$INDEX" "sp5x_candidate_" "SP5 index naming convention"
check_pattern_must "$INDEX" "stub_only" "SP5 index A2-Lite signal"

# execution_coordination_governance Codex 境界 (4)
ECG="course/role_tracks/execution_coordination_governance/README.md"
check_pattern_must "$ECG" "Codex must not implement robotics logic" "ECG Codex no-implement"
check_pattern_must "$ECG" "Codex must not make scope decisions" "ECG Codex no-scope"
check_pattern_must "$ECG" "Codex must not make safety decisions" "ECG Codex no-safety"
check_pattern_must "$ECG" "Codex must not replace human pilot review" "ECG Codex no-replace"

# Self-reference (3)
SELF="tools/check_structure.sh"
check_pattern_must "$SELF" "course/role_tracks/" "self SP5 EXPECTED_FILES"
check_pattern_must "$SELF" "sp5x_candidate_" "self SP5 track-specific check"
check_pattern_must "$SELF" "2026-04-30-robotics-course-sp5" "self SP5 spec/plan registration"
```

- [ ] **Step 4: Verify the file still parses**

```bash
bash -n tools/check_structure.sh
```
Expected: exit 0 (no syntax error).

- [ ] **Step 5: Run check_structure.sh and confirm all SP5 patterns PASS (root README G4 はまだ追加していないため、root README 関連の警告は出ない想定)**

```bash
bash tools/check_structure.sh; echo "exit=$?"
```
Expected: exit 0. PASS count increases by 76 (+8 G1 + 8 G2 + 56 generic + 7 exact + 6 index + 4 Codex + 3 self-reference - any double-counting; specific number depends on existing baseline). All SP1-SP4 must-not / negative-example checks continue PASSing (regression maintained).

- [ ] **Step 6: Run regression on --week 1 and --week 4**

```bash
bash tools/verify_env.sh --week 1 2>&1 | tail -3
bash tools/verify_env.sh --week 4 2>&1 | tail -3
```
Expected: both PASS (WARN allowed for MoveIt / MCAP).

- [ ] **Step 7: Commit**

```bash
git add tools/check_structure.sh
git commit -m "$(cat <<'EOF'
tool: activate SP5 strict G1/G2/G4 patterns (76 of 78, root README G4 in T10)

Spec §10, §11.1. Adds SP5 entries to EXPECTED_FILES (8 files) and
COURSE_TEN_KEY_FILES (8 files). Inserts 76 G4 patterns:
- per-stub generic (8 × 7 = 56)
- track-specific exact (sp5x_candidate_<track_id> × 7 = 7)
- index README (6)
- execution_coordination_governance Codex boundary (4)
- self-reference (3)

Root README G4 (2 patterns: 'Optional Role Track frame only' +
'course/role_tracks/') is intentionally deferred to T10, where it
will be added in the same commit as the root README update. Adding
root README G4 here would fail-warn because root README is not yet
updated.

SP4 must-not / negative-example checks continue executing as
regression gates. No new G4_MUST_NOT_PATTERNS or
G4_NEGATIVE_EXAMPLE_PATTERNS introduced.
EOF
)"
```

---

## Task 10: root README update + root README G4 (2 patterns) + final 5-gate validation + ff merge

**Files:**
- Modify: `README.md` (root) — `## 今後の予定` table SP5 行更新 + 1 行 link 追加
- Modify: `tools/check_structure.sh` — root README G4 patterns 2 件追加 (同 commit)

Spec §4 (root README link is to file, not directory), §10.4 (root README 専用 patterns), §11.2 (root README G4 timing), §12 (Acceptance criteria).

- [ ] **Step 1: Inspect current root README SP5 row**

```bash
grep -nE "^\| SP[0-9]" README.md
```
Expected: SP2/SP3/SP4 rows (SP4 was updated in SP4 T6 to 完了 form). SP5 row may be in 今後の予定 table as planned form, or absent.

```bash
grep -n "SP5\|role_tracks\|Optional Role Track" README.md
```
Expected: SP5 mentions (if any) shown.

- [ ] **Step 2: Find 今後の予定 table area**

```bash
grep -n "今後の予定\|## 今後" README.md
```
Note line number; SP5 table row should be added after SP4 row (or update existing planned SP5 row).

- [ ] **Step 3: Update root README**

In `README.md`:

(a) In the `## 今後の予定` table, add or replace the SP5 row to:

```markdown
| SP5 | **完了 (Optional Role Track frame only — SP5x 起動の breadcrumb)** |
```

(b) Add a new section at an appropriate location (after SP4 section or in the same area, e.g., after `## SP4で何ができるか`) — a single line link:

```markdown
## SP5で何ができるか

Optional Role Track frame only。Phase 0 完了後の任意拡張として `course/role_tracks/` に 7 track stub (frame only) を整備。Q1 W1 preflight や `re_judge_gates` の観察結果により track が activate された時点で個別 SP5x sub-project として content を実装する。

詳細: [Optional Role Track frame](course/role_tracks/README.md)
```

(file link to `course/role_tracks/README.md`、directory link ではない、G5a 安定性のため per spec §4.4)

- [ ] **Step 4: Add root README G4 patterns to tools/check_structure.sh**

Find the end of the SP5 G4 patterns block (added in T9). Append:

```bash
# Root README SP5 entry (2)
ROOT="README.md"
check_pattern_must "$ROOT" "Optional Role Track frame only" "root README SP5 frame-only"
check_pattern_must "$ROOT" "course/role_tracks/" "root README SP5 link"
```

- [ ] **Step 5: Verify both files**

```bash
bash -n tools/check_structure.sh
grep -qF "Optional Role Track frame only" README.md && echo "root README frame-only OK"
grep -qF "course/role_tracks/README.md" README.md && echo "root README file link OK"
```
Expected: bash -n exit 0, both grep echo OK.

- [ ] **Step 6: Final 5-gate validation**

```bash
echo "==== FINAL: 5 gates ===="
echo "[Gate 1: G1/G2/G4/G5a] tools/check_structure.sh"
bash tools/check_structure.sh; G_RES=$?
echo ""
echo "[Gate 2: G3 --week 4 regression] tools/verify_env.sh --week 4"
bash tools/verify_env.sh --week 4; V4_RES=$?
echo ""
echo "[Gate 3: G3 --week 1 regression]"
bash tools/verify_env.sh --week 1 >/dev/null 2>&1; V1_RES=$?
echo "exit=$V1_RES"
echo ""
echo "==== SUMMARY ===="
echo "check_structure.sh exit: $G_RES (expected 0)"
echo "verify_env.sh --week 4 exit: $V4_RES (expected 0; WARN allowed for MCAP)"
echo "verify_env.sh --week 1 exit: $V1_RES (expected 0; WARN allowed for MoveIt)"
```
Expected: all three exits = 0.

- [ ] **Step 7: SP4 Q1 Package 無変更 verification (acceptance §12.3)**

```bash
git diff main -- docs/superpowers/specs/2026-04-28-robotics-course-sp4-design.md \
                 course/week4/deliverables/q1_reduced_lv1_execution_package_template.md \
                 sandbox_reference/week4/q1_reduced_lv1_execution_package_example.md \
                 | wc -l
```
Expected: `0` (no changes to any of the 3 SP4 Q1 Package files since branching from main).

- [ ] **Step 8: File count check**

```bash
git ls-files | wc -l
```
Expected: `138` exactly (SP4 polish 128 + SP5 spec 1 + SP5 plan 1 + 8 SP5 course/role_tracks files).

- [ ] **Step 9: Commit (root README + tools/check_structure.sh in same commit)**

```bash
git add README.md tools/check_structure.sh
git commit -m "$(cat <<'EOF'
docs+tool: SP5 root README update + root README G4 activation (final 78)

Spec §4, §10.4, §11.2. Updates root README to mark SP5 完了 with
"frame only" wording in 今後の予定 table, and adds a SP5 section
with a file link to course/role_tracks/README.md (file link, not
directory link, per spec §4.4 for G5a stability).

Adds 2 root README G4 patterns to tools/check_structure.sh in the
SAME commit (per spec §11.2 — root README G4 must not be activated
before root README is updated, otherwise check_structure.sh fails).
After this commit: 78 SP5 G4 patterns total (76 from T9 + 2 root
README), all PASS.
EOF
)"
```

- [ ] **Step 10: Final summary report (print, not committed)**

```bash
echo "SP5 (Optional Role Track Meta-frame, A2-Lite) complete."
echo ""
echo "- 10 new files (8 course/role_tracks + 1 spec + 1 plan)"
echo "- 2 modified files (README.md, tools/check_structure.sh)"
echo "- Total tracked files: $(git ls-files | wc -l)"
echo ""
echo "5 gates:"
echo "- G1 (file existence): PASS"
echo "- G2 (front matter): PASS — 10-key for course/role_tracks, 7-key for spec/plan"
echo "- G3 (--week 1, --week 4 regression): PASS [WARN allowed]"
echo "- G4 (content patterns): PASS — 78 SP5 patterns + SP1-SP4 regression maintained"
echo "- G5a (local links): PASS — index → 7 stubs auto-confirmed"
echo ""
echo "SP4 Q1 Package 3 files unchanged (acceptance §12.3 satisfied):"
echo "- docs/superpowers/specs/2026-04-28-robotics-course-sp4-design.md"
echo "- course/week4/deliverables/q1_reduced_lv1_execution_package_template.md"
echo "- sandbox_reference/week4/q1_reduced_lv1_execution_package_example.md"
echo ""
echo "All 7 track stubs in 'inactive' state. Future SP5x activation"
echo "will update activation_status + corresponding G4 pattern in"
echo "the same SP5x commit (spec §15.3)."
```

- [ ] **Step 11: ff merge to main**

```bash
git checkout main
git merge --ff-only course/sp5-role-tracks-meta
git log --oneline -12
```
Expected: fast-forward merge succeeds. Recent log shows SP5 commits ahead of `4f0cbc0` (SP5 spec polish).

- [ ] **Step 12: (optional) Push to origin**

```bash
git push origin main
```
Note: Push is optional for the implementer; the controller may handle this step explicitly per session policy (matches SP4 final flow).

---

## Self-Review (controller-side, before handing to subagents)

This checklist is for the plan controller (the person/agent who wrote this plan). Run these BEFORE dispatching subagents.

### 1. Spec coverage

| Spec section | Implementing task |
|---|---|
| §1 Goal | T2-T8b (frame only handoff frame realized via stubs) |
| §2 Scope (in / out) | T2-T8b stubs out_of_scope arrays; T9 G4 enforces; T10 root README enforces frame-only wording |
| §3 Architecture (3 layers + back-reference + references policy + SP4 alignment) | T2 (index = What), T3-T8b (stubs = Where), T1 spec/plan registration anchors meta-spec |
| §4 File list (10 new + 2 modified, 138 cumulative) | All tasks combined; T10 final count check |
| §5 Track registry (7 tracks + canonical q1_touchpoint + activation_trigger + SP1 legacy mapping) | T3-T8b each track stub; T2 index includes SP1 legacy mapping |
| §6 Directory / naming convention (SP5-RT-*, snake_case track_id, sp5x_candidate_*) | T2-T8b each stub front matter id + body track_id + future_spec_id |
| §7 Index README content invariants | T2 |
| §8 Stub README content invariants (8 fields + 3 prose sections + body 30-50 行) | T3-T8b each stub |
| §9 Q1 Package linkage matrix | T3-T8b each stub q1_touchpoint covers the matrix from track-side |
| §10 Validation Gates extension (78 G4 patterns) | T1 (SPEC/PLAN), T9 (76 patterns), T10 (root README 2 patterns) |
| §11 check_structure.sh extension (Two-stage, root README timing) | T1, T9, T10 sequencing |
| §12 Acceptance criteria | T10 final validation Steps 6-9 |
| §13 Risks | mitigated by T9/T10 split (root README timing risk), T10 Step 7 (Q1 Package無変更 verification), T8b explicit Codex 境界 4 行 (圧縮表現禁止 risk) |
| §14 Out-of-scope | T1 conventions block + each task's commit message reaffirms |
| §15 SP5x 起動条件 + activation_status lifecycle (G4 衝突対策) | T3-T8b each stub `activation_status: inactive` + SP5x 側責務 注記 in stub prose |
| §16 ms_belief_navigation 8th 追加 protocol | T2 index README contains "Future non-stub candidate" bullet; protocol details remain in spec only |
| §17 References (no new R-*, internal-first) | T2 index + T3-T8b stubs all `references: []` |
| §18 Implementation tasks overview (約 11 tasks: T0-T10) | This plan (T0-T10, where T8b is the 8th stub task between T8 and T9) |
| §19 Phase 0 → Q1 → SP5x handoff note | T10 Step 10 final summary echoes the handoff state |

No spec gap detected.

### 2. Placeholder scan

All `TBD` references in this plan are intentional and limited to:
- Spec section §15.2 lifecycle description (referenced in stub `activation_status: inactive` rationale, not appearing as literal `TBD` in any committed file content)

No `TODO` / `implement later` / `fill in details` strings outside intentional contexts.

### 3. Type / name consistency

- `SP5-RT-<TRACK-ID-UPPER-HYPHEN>` front matter id format used in all 7 stubs (T3-T8b)
- `track_id: <track_id>` snake_case body field used in all 7 stubs
- `future_spec_id: sp5x_candidate_<track_id>` exact format used in all 7 stubs (T3-T8b verify Step 3 exact value check)
- 7 track_ids consistent across plan, spec §5.2, and all stub T3-T8b files: `environment_toolchain_readiness`, `robot_adapter_readiness`, `simulation_bridge`, `logging_evidence_chain`, `trial_kpi_evaluation`, `safety_review_sop`, `execution_coordination_governance`
- 4 Codex boundary lines used consistently in T8b stub and T9 G4 pattern block: `Codex must not implement robotics logic` / `Codex must not make scope decisions` / `Codex must not make safety decisions` / `Codex must not replace human pilot review`
- 4 `re_judge_gates` ids consistent in T8b stub (`q1_w1_pre_start` / `q1_w1_exit` / `q1_mid_point` / `q1_closeout`) and matched against spec §9 linkage matrix

No drift detected.

---

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-04-30-robotics-course-sp5-role-tracks-meta-plan.md`. Two execution options:

1. **Subagent-Driven (recommended)** — I dispatch a fresh subagent per task, two-stage review (spec compliance + code quality) between tasks, fast iteration.
2. **Inline Execution** — Execute tasks T0-T10 in this session via `superpowers:executing-plans`, batched with checkpoints.

Which approach?
