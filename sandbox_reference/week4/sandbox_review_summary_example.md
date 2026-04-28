---
type: reference
id: W4-REF-SANDBOX-REVIEW-SUMMARY
title: sandbox_review_summary example — Lab 8b instructor case (Codex 利用なし)
week: 4
duration_min: 30
prerequisites: [W4-Lab8b]
worldcpj_ct: [CT-04, CT-05, CT-06, CT-09]
roles: [common, sandbox]
references: [R-28]
deliverables: [sandbox_review_summary]
---

# sandbox_review_summary example (Lab 8b instructor case)

> **artifact_status**: sandbox_example
>
> Instructor case = Codex 利用なし、自己レビュー手書き。本 example は Codex 補助 column を `N/A` で明示する。

## Codex 利用方針

**Codex 利用なし** (`Codex-suggested patterns: N/A`)

Codex CLI へのアクセスがない環境を想定 (帰省中のスマホ remote control を想定など)。

## Human-found patterns (5+ 必須、自分で見つけた pattern)

1. **環境 sourcing 抜け**: ROS 2 環境を source し忘れて `ros2 bag --help` が動かない事例が複数 (W1, W4 で発生)。verify_env.sh の `--week 4` で `ROS_DISTRO=humble` チェックを追加した
2. **template と example の責務分離**: template に 15 row 全部埋めるか、example だけ埋めるかが曖昧だった。spec §7.2 で「template は構造例 1-2 row、example が fully expanded」と確定
3. **bad example の dead link**: bad_q1_package_example.md の dead link が G5a を falseFAIL させかけた。plain text placeholder + G5A_EXCLUDE_FILES で対処
4. **Codex 出力で禁止リストに触れる**: W3 Lab 6b で Codex prompt に「KDL を試して」と書いて禁止 pattern に触れた事例。lab8b で禁止リスト + 「summarize は可、判断・実装は不可」を明示
5. **W1 turtlesim を Q1 trial と混同する誤解**: trial_sheet に W1 turtlesim を executed row で入れると Q1 CC Gate 0-a の 15 trials count を破壊。Lab 7 で `not_applicable` / `training_*` 規約を明示

## Codex-suggested patterns

N/A (Codex 利用なし)

## Q1 migration lessons (3+ 必須)

1. **safety_owner / reviewer は Q1 W1 開始前に必ず人選確定**: Phase 0 では `TBD` 許容だが、Q1 W1 pre_start gate で具体名を入れること
2. **q1_execution_mode の確定タイミング**: Phase 0 では `TBD`、Q1 W1 pre_start gate で `mock` / `sim` / `real` のどれかに確定する
3. **W1 turtlesim training と Q1 CC Gate 0-a trial の混同を避ける運用**: trial_sheet に W1 episode を入れない、`object_id: turtlesim_training_object` 等の training 専用 id を使う
4. **MCAP plugin の install 判断**: Phase 0 では Stretch だが、Q1 W1 で sim/real recording を MCAP で行うか sqlite3 で行うかを `q1_w1_preflight` 時点で判断
5. **`re_judge_gates` の `q1_mid_point` 活用**: Phase 0 で prescribe していない W2+ detail (failure taxonomy 改訂 / KPI / operator workflow) は本 gate で必ず判断する

## Final review summary

Phase 0 SP1-SP4 を通じて、template / example / sandbox の三層構造と参照型 traceability の運用が確立された。Q1 移行の handoff artifact として Q1 Package を採用、formal ceremony は不要。

## Scope decision (by human)

Q1 縮小 Lv1 の scope は CC Gate 0-a + MS Lv1 に限定する判断は **human 100%** で行った。Codex は本 review summary の作成にも一切利用していない。
