---
type: lab
id: W1-Lab0
title: Sandbox 立ち上げ + Codex 接続確認
week: 1
duration_min: 60
prerequisites: [W1-L0]
worldcpj_ct: [CT-07]
roles: [common, sandbox]
references: [R-33, R-34, R-35, R-36, R-37, R-38]
deliverables: [sandbox_setup_log]
---

# Lab 0 — Sandbox 立ち上げ + Codex 接続確認

## 目的

自分の `Sandbox_<name>` repo を GitHub に作成し、最初の branch / commit / PR / review サイクルを通し、Codex workspace + GitHub connector の接続を確認する。

## 前提

`course/00_setup/` を完了していること (`bash tools/verify_env.sh` が PASS またはWARNのみ)。

## 手順

1. **GitHub で repo 作成** — `Sandbox_<name>` (例: `Sandbox_alice`)、private、README のみで初期化する。

2. **clone** — ローカルに clone する。
   ```bash
   git clone git@github.com:<you>/Sandbox_<name>.git ~/Develop/Sandbox_<name>
   ```

3. **identity 設定** — Course 推奨: 仕事用 identity を per-repo で設定する。
   ```bash
   git -C ~/Develop/Sandbox_<name> config user.name "<your-name>"
   git -C ~/Develop/Sandbox_<name> config user.email "<your-email>"
   ```

4. **最初の branch を作成**
   ```bash
   git switch -c learner/<name>/wk1-sandbox-init
   ```

5. **README に自己紹介を追加** — 1段落: 自分の Role 候補、得意領域を書く。

6. **commit + push**
   ```bash
   git add README.md
   git commit -m "docs: introduce <name>"
   git push -u origin learner/<name>/wk1-sandbox-init
   ```

7. **PR 作成** — GitHub UI または `gh pr create` で PR を作成する。description に目的・スコープを最低1行記入する。

8. **自分で PR に review コメントを1件付ける** — 練習。実際の cross-review は Lab 4b 以降。

9. **Codex 接続確認** — ChatGPT Enterprise → Codex を開き、自分の workspace と `Sandbox_<name>` への GitHub connector 接続を確認する。**コード生成は不要。接続確認のみで可。**

10. **`sandbox_setup_log_template.md` を埋める** — `course/week1/deliverables/sandbox_setup_log_template.md` の各項目を埋めて Sandbox repo に commit/PR する。(テンプレートは Task 13 で作成。現時点では Task 13 完了後に記入してください。)

## bag本体commit禁止注記

Lab 0 では bag ファイルを扱わない。ただし Lab 1/2 以降では `.db3`/`.mcap`/`rosbag2_*/` ファイルをリポジトリに commit することは禁止されている。軽量証跡 (`bag_info.txt`, `rosbag_metadata.yaml`, `terminal_*.log` 等) のみを commit すること。

## 提出物

- `sandbox_setup_log.md` — 自 Sandbox repo に commit/PR する。
- PR URL — `sandbox_setup_log.md` 内に記録する。

## 合格条件

合格条件は [CHECKLIST.md](./CHECKLIST.md) を参照。

## 参照

- R-33: GitHub Docs — Creating a repository
- R-34: GitHub Docs — Cloning a repository
- R-35: Git — git config
- R-36: GitHub Docs — Creating a pull request
- R-37: GitHub Docs — Reviewing a pull request
- R-38: ChatGPT Enterprise — Codex workspace setup
