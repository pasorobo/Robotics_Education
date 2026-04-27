---
type: template
id: W2-T-PR-REVIEW-NOTES
title: Sandbox PR Review Notes (template)
week: 2
duration_min: 15
prerequisites: [W2-Lab4b]
worldcpj_ct: [CT-07]
roles: [common, sandbox]
references: [R-36, R-37, R-38]
deliverables: []
---

# Sandbox PR Review Notes

> Lab 4b および以降の Codex 必須 Lab (W3 Lab 6b、W4 Lab 8b) で **1 PR ごとにコピーして 6 行記入**。
>
> **空欄 NG**。Codex 利用なし (手書き) の場合も、各行に「Codex 利用なし、手書き」「採用しない提案: なし」など明示的に書くこと。

| 項目 | 記入内容 |
|---|---|
| task split | `<人間が定義した目的 / 入力 / 制約 / 成功条件 / 検証コマンド (prompt 5 項目)。詳細は別ファイル wk*/lab*/codex_prompt_*.md を参照>` |
| Codex prompt | `<Codex に依頼した範囲。設計判断を委ねていないことを確認。Codex 利用なしの場合は「Codex 利用なし、手書き」と明記>` |
| diff summary | `<変更ファイル / 責務 / 主要ロジック>` |
| human review | `<動く根拠 (検証コマンド実行ログ) / 壊れうる条件 (1 件以上) / 採用しない提案 (1 件以上、なければ「なし」) / 追加修正 (1 件以上、なければ「なし」)>` |
| debug evidence | `<失敗ログ / 最小再現 / 修正前後のコマンド結果>` |
| judgment boundary | `<人間が決めた Affordance schema / 評価指標 / 安全境界 / 実機投入可否>` |

## 関連リンク

- PR URL: `<https://github.com/<user>/Sandbox_<name>/pull/N>`
- 関連 Lab: `<course/week*/labs/lab*/README.md>`
- 関連 commit hash: `<7-char abbrev>`

---

| 記入者 | 記入日 |
|---|---|
| `<name>` | `YYYY-MM-DD` |
