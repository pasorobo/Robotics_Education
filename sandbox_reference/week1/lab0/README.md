---
type: reference
id: REF-W1-LAB0-README
title: Lab 0 instructor walk-through summary
week: 1
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-07]
roles: [common, sandbox]
references: [R-33, R-34, R-35]
deliverables: []
---

# Lab 0 — Instructor walk-through summary

Note: instructor uses Robotics_Education directly as Sandbox example (separate `Sandbox_<name>` repo は作成しない).

## 実行コマンドサマリ (擬似)

実際の学習者が行う想定手順:

```bash
gh repo create Sandbox_pasorobo --private --confirm
git clone git@github.com:pasorobo/Sandbox_pasorobo.git ~/Develop/Sandbox_pasorobo
cd ~/Develop/Sandbox_pasorobo
git config user.name "pasorobo"
git config user.email "goo.mail01@yahoo.com"
git switch -c learner/pasorobo/wk1-sandbox-init
echo "# Sandbox_pasorobo (instructor)" > README.md
git add README.md
git commit -m "docs: introduce instructor sandbox"
git push -u origin learner/pasorobo/wk1-sandbox-init
gh pr create --title "wk1: sandbox init" --body "Lab 0 setup PR"
gh pr review <pr-number> --comment --body "self-review: README structure looks fine"
```

## 実際に instructor がやったこと

本リポジトリ root commit `af9ac7e` が Lab 0 相当の "first PR" の役割を果たしている。Sandbox_pasorobo は別途作成せず、Robotics_Education をそのまま Sandbox の実例として使用。

## 詰まった点 / 注意

- git identity 未設定で初回 commit 失敗 → local config (`git config user.name` / `git config user.email`) で解決
- GitHub remote 未設定のため push 未実施 (本リポジトリ直接運用のため不要)

## 提出物

このREADME + [codex_connection_check.md](./codex_connection_check.md)
