---
type: reference
id: REF-W1-SANDBOX-SETUP-LOG-EXAMPLE
title: Sandbox Setup Log 記入例 (instructor)
week: 1
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-07]
roles: [common, sandbox]
references: []
deliverables: []
---

# Sandbox Setup Log (記入例 — instructor case)

> instructor は Course 開発兼 instructor 用に、本リポジトリ自体 (Robotics_Education) を Sandbox 兼 Course content として運用している。一般メンバーは別に `Sandbox_<name>` を作る。

| 項目 | 記入内容 |
|---|---|
| repo: | https://github.com/<placeholder>/Robotics_Education (まだremote未設定の場合は local-only と記載) |
| access: | owner: pasorobo / collaborators: TBD / visibility: TBD (Q1中はprivate想定) / admin確認済み: yes |
| local setup: | clone path: `/home/dev/Develop/Robotics_Education` / default branch: `main` / git user.name: `pasorobo` / git user.email: `goo.mail01@yahoo.com` (local config only) |
| first branch: | `main` (root commit `af9ac7e` — spec追加。learner用ブランチではなく直接 `main` で進めている、SP1 のscope内) |
| Codex access: | workspace: TBD / Codex local: TBD / Codex cloud: TBD / GitHub connector: TBD (Course本体ではCodexを直接利用していない、利用は学習者が各Sandboxで行う) |
| rules: | 秘密情報を置かない: yes / 実機接続しない: yes / mock/sim/offline data だけ使う: yes |

## 自由記述

### 詰まった点
- 当初 `Robotics_simulation_phase0_education_plan.md` を root に置いていたが、`docs/` 配下に集約するよう brainstorming で決定 (Decision Log Q2)。
- git identity が global 未設定で commit 失敗。local設定で対応。

### 次に試したいこと
- SP1 完了後、本リポジトリにGitHub remoteを設定し PR運用に切り替え。
- W2 着手時に Codex workspace の準備を学習者と一緒に確認。

---

| 記入者 | 記入日 |
|---|---|
| pasorobo (instructor) | 2026-04-27 |
