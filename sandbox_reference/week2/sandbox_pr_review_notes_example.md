---
type: reference
id: REF-W2-PR-REVIEW-NOTES-EXAMPLE
title: Sandbox PR Review Notes 記入例 (instructor case, Lab 4b 題材)
week: 2
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-07]
roles: [common, sandbox]
references: []
deliverables: []
---

# Sandbox PR Review Notes (記入例 — Lab 4b no-op adapter logger 題材)

> instructor case では Codex を直接利用していない (W1 Lab 0 と同じ instructor case 扱い)。prompt 5 項目に従って手書きで `noop_logger.py` を作成し、Codex 出力擬似と扱う。

| 項目 | 記入内容 |
|---|---|
| task split | prompt 5 項目を別ファイル [`./lab4b/codex_prompt_lab4b.md`](./lab4b/codex_prompt_lab4b.md) に記録。本 example では参照のみ |
| Codex prompt | instructor case のため **Codex 利用なし、prompt 5 項目に従って手書き**。Codex を使う場合は上記 prompt をそのまま渡し、生成コードを diff レビューする想定 |
| diff summary | `noop_logger.py` 1 ファイル新規。`rclpy.Node` 継承、`/joint_states` subscriber、INFO log 出力 (`recv name=[...] pos=[...] ts=...` 形式)。約 30 行。`KeyboardInterrupt` で graceful shutdown |
| human review | **動く根拠**: `execution_log.txt` で 5 秒間 INFO log が流れた / **壊れうる条件**: `/joint_states` の `name` と `position` 配列長不一致 (mock_hardware では起きないが実機では起きうる) / **採用しない提案**: なし (instructor case) / **追加修正**: なし |
| debug evidence | `execution_log.txt` の INFO log 抜粋 (`recv name=['j1'] pos=[0.0] ts=...` の繰り返し)。失敗ケースなし |
| judgment boundary | 安全判断は人間 (instructor) が判定: 禁止リスト (IK / URDF parsing / trajectory 生成 / controller 操作 / 安全判断自動化) を遵守、コメントヘッダで明記。Affordance schema は本 Lab で扱わず |

## 関連リンク

- PR URL: instructor case のため placeholder (`<learner が記入>`)
- 関連 Lab: [`course/week2/labs/lab4b_codex_noop_adapter_logger/README.md`](../../course/week2/labs/lab4b_codex_noop_adapter_logger/README.md)
- 関連 commit hash: SP2 implementation 完了時に追記

---

| 記入者 | 記入日 |
|---|---|
| pasorobo (instructor) | 2026-04-27 |
