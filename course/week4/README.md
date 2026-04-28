---
type: week
id: W4-README
title: Week 4 - Logging / Evaluation / Safety + Q1 Reduced Lv1 Execution Package
week: 4
duration_min: 420
prerequisites: [W3-Lab5, W3-Lab6, W3-Lab6b]
worldcpj_ct: [CT-04, CT-05, CT-06, CT-09]
roles: [common, logging, safety, sandbox]
references: [R-28, R-29, R-30, R-31, R-32]
deliverables: [episode_record, trial_sheet, safety_checklist, q1_reduced_lv1_execution_package]
---

# Week 4 — Logging / Evaluation / Safety + Q1 Reduced Lv1 Execution Package

Phase 0 最終週。W1-W3 で作った 3 templates (sandbox_setup_log, robot_readiness_mini_report, simulation_bridge_draft) を Q1 移行 artifact として束ねる。

## 学習目標

1. **rosbag2 + episode_record の理解** — 1 task attempt の構造化記録を書ける (Lab 7)
2. **Safety SOP / safe no-action / operator confirmation の語彙獲得** — Phase 0 と Q1 の境界を理解する (L8)
3. **Q1 縮小 Lv1 Execution Package の作成能力** — W1-W3 templates を `source_artifact_path` で参照しながら、Q1 W1 開始前に必要な meta plan を書ける (Lab 8)
4. **Sandbox W1-W4 最終レビューと Q1 移行教訓の言語化** — Codex 利用は **任意** (Lab 8b)

## Lectures

- [L7 — rosbag2 / MCAP / episode_record](./lectures/l7_rosbag2_mcap_episode_record.md)
- [L8 — Safety SOP / safe no-action / Phase 0 vs Q1 boundary](./lectures/l8_safety_sop_safe_no_action.md)

## Labs

- [Lab 7 — episode_record 記入演習 (W1 turtlesim bag 再利用)](./labs/lab7_episode_record/README.md)
- [Lab 8 — Q1 Package + safety_checklist + trial_sheet skeleton 統合](./labs/lab8_q1_execution_package/README.md)
- [Lab 8b — Sandbox 最終レビュー (Codex 任意)](./labs/lab8b_sandbox_final_review/README.md)

## Templates (deliverables)

- [episode_record_template](./deliverables/episode_record_template.md) — 1 task attempt の構造化記録
- [trial_sheet_template](./deliverables/trial_sheet_template.md) — N trials 集計表 (5 objects × 3 trials)
- [safety_checklist_template](./deliverables/safety_checklist_template.md) — pre-execution safety 確認 (Phase 0 では training draft)
- [q1_reduced_lv1_execution_package_template](./deliverables/q1_reduced_lv1_execution_package_template.md) — **Q1 全体 meta package** (Phase 0 → Q1 handoff artifact 自体)

## Sandbox reference

`sandbox_reference/week4/` 以下に instructor walk-through (10 files): 6 top-level fill examples + 3 lab walk-through README + 1 optional Codex pattern extract example。

## Phase 0 完了について

本 Week 4 完了をもって Phase 0 教材は揃う。**Phase 0 完了宣言は控えめに**、Q1 移行条件 (safety review / `q1_w1_preflight` / pilot trial / `re_judge_gates` 4 件 review) を Q1 Package 上で確認すること。Formal handover ceremony / 別文書は out-of-scope — Q1 Package 自体が handoff artifact として機能する。
