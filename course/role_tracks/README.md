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

本 frame (`course/role_tracks`) は Phase 0 (SP1-SP4) を完了したメンバーが、Q1 観察結果に応じて必要部分だけ深掘りするための optional role track 群の入口である。

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
