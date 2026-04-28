---
type: lab
id: W4-Lab8b
title: Lab 8b — Sandbox 最終レビュー (Codex 利用は任意)
week: 4
duration_min: 60
prerequisites: [W4-Lab7, W4-Lab8]
worldcpj_ct: [CT-04, CT-05, CT-06, CT-09]
roles: [common, sandbox]
references: [R-28, R-30, R-31]
deliverables: [sandbox_review_summary]
---

# Lab 8b — Sandbox 最終レビュー (Codex 利用は任意)

## 目的

Sandbox の W1-W4 全体を自己レビューし、`sandbox_review_summary.md` に **Phase 0 振り返り 5+ patterns** + **Q1 移行教訓 3+ items** を記録する。Codex の利用は **任意**。

## Codex 利用方針

**Codex 利用は任意です** (Codex usage is optional)。Codex 利用なしでも本 Lab は合格可。

### 禁止リスト (Lab 4b / 6b 流用 + Lab 8b 固有)

- IK / KDL / URDF parsing / trajectory / controller / 安全判断自動化 (Lab 4b / 6b 同型)
- **Lab 8b 固有**: Q1 縮小 Lv1 の **scope 判断** (CC/MS どこまでやるか、人協調/双腕入れるか) を Codex に委ねない (`must not make scope decisions`)

### Codex 役割の境界

- Codex may **summarize** review notes that mention IK / KDL / URDF / trajectory / controller issues
- Codex **must not implement**, debug, scope-expand, or make execution/safety decisions for those areas in Lab 8b (`判断・実装は不可`)
- 最終 scope 判断 (`scope decision`) は **human** が行う (`scope 判断は人間`)

## 前提

- W4 Lab 7 / Lab 8 完了
- Sandbox W1-W4 全 commits 揃っている

## 手順

### Step 1: Sandbox W1-W4 全体を自己レビュー

```bash
mkdir -p ~/sandbox/wk4/lab8b
cd ~/sandbox && git log --oneline | head -50 > /tmp/sandbox_log_review.txt
```

`~/sandbox/wk4/lab8b/sandbox_review_summary.md` を作成し、以下を記載:

### Step 2: Phase 0 振り返り 5+ patterns (手書き、必須)

W1-W4 で気づいた成功 / 失敗 / 学習成果を 5 件以上、自分で見つけた pattern (**human-found patterns**) として手書きで列挙。

### Step 3: Q1 移行教訓 3+ items

Q1 W1 開始時に注意すべき点を 3 件以上 (**Q1 migration lessons**) 記載。

### Step 4: (任意 Codex 補助)

W2/W3 で書いた累積 Sandbox PR Review Notes (2-3 件) を Codex に渡し「共通 pattern を 3 行で抽出」。生成 pattern を `Codex-suggested patterns` として記録し、accepted / rejected で分離記録する。

Codex 利用なしの場合は `Codex-suggested patterns: N/A` と明示する。

## 提出物 matrix

| 項目 | Codex 使用なし | Codex 使用あり |
|---|---|---|
| Human-found patterns (5+) | 必須 | 必須 |
| Codex-suggested patterns | N/A 明示 | 必須 (3+) |
| Accepted / rejected suggestions | N/A | 必須 |
| Final review summary | 必須 | 必須 |
| Q1 migration lessons (3+) | 必須 | 必須 |
| Scope decision by human | 必須 | 必須 |

## SP4 終了

本 Lab で SP4 (Phase 0 最終週) は完了。Q1 移行は Q1 Package §8 safety review + `q1_w1_preflight` + 1 pilot trial review が完了してから。
