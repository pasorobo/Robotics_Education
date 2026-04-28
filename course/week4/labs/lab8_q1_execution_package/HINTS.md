# Lab 8 HINTS

## W1-W3 各 template の引き方

| Q1 Package row | source template | source_artifact_path 例 |
|---|---|---|
| 3_environment_stack | SP1-T-SANDBOX-SETUP-LOG | `sandbox/wk1/sandbox_setup_log.md` |
| 4_robot_adapter_readiness | W2-T-ROBOT-READINESS | `sandbox/wk2/robot_readiness_mini_report.md` |
| 5_simulation_bridge_status | W3-T-SIM-BRIDGE-DRAFT | `sandbox/wk3/simulation_bridge_draft.md` |
| 6_logging_episode_plan | W4-T-EPISODE-RECORD | `sandbox/wk4/lab8/episode_record.md` |
| 7_trial_kpi_plan | W4-T-TRIAL-SHEET | `sandbox/wk4/lab8/trial_sheet.md` |
| 8_safety_review_go_no_go | W4-T-SAFETY-CHECKLIST | `sandbox/wk4/lab8/safety_checklist.md` |

## コピーではなく参照する理由

- W1-W3 artifact が更新されても Q1 Package を全書き直しせずに済む
- 単一の data source per template を保つ (W2 Adapter readiness の真は W2 template、Q1 Package はそれを指す)
- handoff 後 Q1 W1 で W2/W3 artifact が修正されても Q1 Package は path 参照だけで追従

## phase0_status: training_draft_only 必須

safety_checklist は Phase 0 では **training draft**。`phase0_status: training_draft_only` を必ず明示し、`q1_blocker_if_unreviewed: true` で Q1 W1 開始前 review が blocker であることを宣言する。

## q1_w1_preflight の 5×3=15 trials 直行禁止

5 物体 × 3 trials = 15 trials を一気に流すのは禁止。必ず以下を経由する:

1. 1 物体 × 1 trial の pilot trial を実行
2. pilot trial の review が完了 (`q1_w1_exit` gate)
3. その後初めて 15 trials 計画に進む

CHECKLIST の `1 pilot trial` / `pilot review` キーワードはこの規約を表す。

## 自分の case が思いつかない時

以下のいずれかの架空 case を採用してよい:

- Course 教材開発担当 (本 Course を Q1 で更新する想定)
- Robot Adapter Role 担当 (W2 で書いた robot_readiness_mini_report の延長で Q1 を計画)
- Sim Bridge Role 担当 (W3 で書いた simulation_bridge_draft の延長で Q1 を計画)

## Q1 W2+ detail を Phase 0 で prescribe しない

`re_judge_gates` の `q1_mid_point` で「W2+ detail (failure taxonomy 改訂 / KPI / operator workflow) は本 gate で判断」と明示する。Phase 0 で W2+ scope に踏み込まない。
