---
type: lab
id: W4-Lab8
title: Lab 8 — Q1 Reduced Lv1 Execution Package + safety_checklist + trial_sheet skeleton 統合
week: 4
duration_min: 120
prerequisites: [W4-L7, W4-L8, W4-T-EPISODE-RECORD, W4-T-TRIAL-SHEET, W4-T-SAFETY-CHECKLIST, W4-T-Q1-PACKAGE]
worldcpj_ct: [CT-04, CT-05, CT-06, CT-09]
roles: [common, logging, safety, sandbox]
references: [R-28, R-30, R-31, R-32]
deliverables: [q1_reduced_lv1_execution_package, safety_checklist, trial_sheet]
---

# Lab 8 — Q1 Reduced Lv1 Execution Package + safety_checklist + trial_sheet skeleton 統合

## 目的

W1-W3 で作った 3 templates (sandbox_setup_log / robot_readiness_mini_report / simulation_bridge_draft) を、Q1 移行 artifact として束ねる。

3 templates (`q1_reduced_lv1_execution_package_template` + `safety_checklist_template` + `trial_sheet_template`) を Sandbox にコピーし、参照型 traceability で fill する。

## 前提

- W1-W3 全 Labs 完了
- W4 L7 / L8 受講済
- W4 4 templates すべて読了

## 手順

### Step 1: 3 templates を Sandbox にコピー

```bash
mkdir -p ~/sandbox/wk4/lab8
cp course/week4/deliverables/q1_reduced_lv1_execution_package_template.md ~/sandbox/wk4/lab8/q1_reduced_lv1_execution_package.md
cp course/week4/deliverables/safety_checklist_template.md ~/sandbox/wk4/lab8/safety_checklist.md
cp course/week4/deliverables/trial_sheet_template.md ~/sandbox/wk4/lab8/trial_sheet.md
```

### Step 2: Q1 Package 8 行を W1-W3 templates 参照で fill

各 row に `source_artifact_path` (W1-W3 artifact への path) + `source_template` (元 template id) + `review_status: not_reviewed` を記入する。**コピーではなく参照** すること。

- Row 3 (environment_stack): `source_artifact_path: course/00_setup/, sandbox/wk1/sandbox_setup_log.md`
- Row 4 (robot_adapter_readiness): `source_artifact_path: sandbox/wk2/robot_readiness_mini_report.md`
- Row 5 (simulation_bridge_status): `source_artifact_path: sandbox/wk3/simulation_bridge_draft.md`
- Row 6 (logging_episode_plan): `source_artifact_path: sandbox/wk4/lab8/episode_record.md` (Lab 7 で書いたもの)
- Row 7 (trial_kpi_plan): `source_artifact_path: sandbox/wk4/lab8/trial_sheet.md`
- Row 8 (safety_review_go_no_go): `source_artifact_path: sandbox/wk4/lab8/safety_checklist.md`

### Step 3: safety_checklist を fill

- `phase0_status: training_draft_only`
- `q1_blocker_if_unreviewed: true`
- `safety_owner: TBD (Q1 W1 開始前に WorldCPJ Safety Role Owner と決定)`
- `review_status: not_reviewed`
- `reviewer_name: TBD` / `reviewer_role: TBD` / `reviewed_at: TBD`
- Q1 Package §8 の `safety_check_id` から本 safety_checklist を参照

### Step 4: trial_sheet を 15 planned rows skeleton として作成

5 objects × 3 trials = 15 rows、全 row:
- `trial_status: planned`
- `result: unknown`
- `failure_reason: unknown`
- `episode_id: TBD`

W1 turtlesim training episode は **混入禁止** (Lab 7 で別途扱う)。Q1 Package §7 の `trial_sheet_id` から本 trial_sheet を参照。

### Step 5: q1_w1_preflight 8 項目を Q1 Package に記入

template 既定の 8 項目を確認・記入:

1. `tools/verify_env.sh --week 4` PASS
2. ros2 doctor or documented equivalent environment smoke check
3. mock adapter no-op execution confirmed
4. required topics listed
5. rosbag2 minimal record confirmed for required topics
6. safety_checklist reviewed by responsible owner (`review_status: approved`)
7. **1 object × 1 pilot trial executed**
8. **pilot review COMPLETED before proceeding to 5 objects × 3 trials** (5×3=15 trials 直行禁止 — 5 物体 × 3 trials 直行禁止)

### Step 6: re_judge_gates 4 件を確認・記入

`q1_w1_pre_start` / `q1_w1_exit` / `q1_mid_point` / `q1_closeout` の 4 件。Q1 W2+ detail は **deferred 明示** (silent omission 禁止) — `q1_mid_point` で判断する旨を記載。

### Step 7: Sandbox commit

```bash
cd ~/sandbox && git add wk4/lab8/ && git commit -m "lab: W4 Lab 8 Q1 Package + safety_checklist + trial_sheet skeleton"
```

## 提出物

- `~/sandbox/wk4/lab8/q1_reduced_lv1_execution_package.md` (8 rows + preflight + gates fill)
- `~/sandbox/wk4/lab8/safety_checklist.md` (training_draft_only)
- `~/sandbox/wk4/lab8/trial_sheet.md` (15 planned rows skeleton)

## 次のLab

→ [Lab 8b — Sandbox 最終レビュー (Codex 任意)](../lab8b_sandbox_final_review/README.md)
