---
type: reference
id: REF-W1-LAB0-CODEX-CHECK
title: Codex 接続確認ログ (instructor)
week: 1
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-07]
roles: [common, sandbox]
references: [R-36, R-37, R-38]
deliverables: []
---

# Codex 接続確認ログ

Note: 接続確認のみ。生成コードは含まない (Week 1 ルール — CONVENTIONS.md §6)

## 確認項目

| 確認内容 | 状態 | 備考 |
|---|---|---|
| ChatGPT Enterprise workspace に sign-in 可能 | TBD | 学習者各自確認 |
| Codex 機能が有効化されている | TBD | workspace owner 有効化 |
| Codex local mode 利用可 | TBD | OS / IDE 連携設定 |
| Codex cloud mode 利用可 | TBD | ブラウザから利用 |
| GitHub connector が承認済み | TBD | workspace owner 承認待ちの場合あり |
| 自 Sandbox repo に Codex がアクセス可能 | TBD | connector 有効化後 |

## 確認手順 (擬似)

1. ChatGPT Enterprise にブラウザでアクセスし、組織アカウントで sign-in する
2. 左サイドバーまたは設定から Codex 機能が表示されていることを確認する
3. workspace の Settings → Integrations で GitHub connector の承認状況を確認する
4. connector が承認済みであれば、自 Sandbox repo を Codex から参照できるか確認する
5. 上記テーブルの各項目を TBD → 確認済み / 未対応 に更新して提出する

## prompt 5 項目練習 (Week 1 範囲)

実際の Codex 生成は W2 Lab 4b 以降。Week 1 では `tools/codex_prompt_template.md` の 5 項目を**書く練習**まで:

1. **Role** — Codex に担わせる役割を明示する
2. **Context** — リポジトリ / ファイルの背景を伝える
3. **Task** — 具体的な作業内容を記述する
4. **Constraints** — 言語・フォーマット・禁止事項を指定する
5. **Output format** — 期待する出力形式を指定する

## instructor 自身の状態

Course 本体開発に Codex を直接利用していない。上記確認項目はすべて TBD のまま。workspace および connector の設定は学習者各自が行う前提で記載している。
