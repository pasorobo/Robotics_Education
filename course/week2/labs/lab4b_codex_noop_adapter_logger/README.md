---
type: lab
id: W2-Lab4b
title: Codex no-op adapter logger (生成→PR→人間レビュー一巡)
week: 2
duration_min: 60
prerequisites: [W2-Lab4]
worldcpj_ct: [CT-06, CT-07]
roles: [common, adapter, sandbox]
references: [R-33, R-34, R-35, R-36, R-37, R-38]
deliverables: [sandbox_pr_review_notes]
---

# Lab 4b — Codex no-op adapter logger

## 禁止リスト (重要)

本 Lab で Codex に作らせてはいけないコード:

- **IK 実装** (Inverse Kinematics の解法)
- **KDL 導入** (kinematics ライブラリ)
- **URDF parsing** (URDF を読んで joint info を抽出する処理)
- **trajectory 生成** (時間付き joint 列の出力)
- **controller 操作** (controller_manager API、controller spawn / kill)
- **安全判断の自動化** (条件付き停止、自動 emergency stop 等)

Codex がこれらを含むコードを出した場合は **採用しない**。Sandbox PR Review Notes の「採用しない提案」に記録する。

「制御しない adapter」として、adapter の **境界 / ログ / 失敗条件** だけを見る教材。

## Codex 利用ガイド (このLab 必須)

CONVENTIONS.md §6 Codex 統合パターンの共通テンプレを適用:

### prompt 前 5 項目

`tools/codex_prompt_template.md` から複写、本 Lab 用に記入:

- **目的**: mock_hardware で動く `/joint_states` を受信し INFO log に出力する no-op adapter logger を作る
- **入力**: ROS 2 topic `/joint_states` (sensor_msgs/msg/JointState)
- **制約**: ROS 2 Humble、rclpy のみ (依存追加禁止)、Python 3.10、上記禁止リスト遵守、Ctrl-C で graceful shutdown
- **成功条件**: `python3 noop_logger.py` 起動成功、`/joint_states` 受信のたびに INFO ログ (joint name + position + timestamp)、Ctrl-C で例外なく終了
- **検証コマンド**: Lab 4 launch を background 起動 → `python3 noop_logger.py` → 5 秒 INFO ログ流れる

### 委ねない判断

- Affordance schema の設計
- 評価指標の選定
- 安全境界の決定
- 実機投入可否の判断

これらは PJ (人間) が決める。Codex は実装補助。

### レビュー観点 (Sandbox PR Review Notes に記録)

- diff summary: どのファイルがどう変わったか
- 動く根拠: 検証コマンドの実行ログ
- 壊れうる条件: edge case、依存条件、環境差
- 採用しない提案: Codex が提案したが取らなかった選択肢と理由
- 追加修正: Codex 出力にユーザーが加えた修正

## 前提

- Lab 4 完了 (mock_hardware が動く環境)
- W1 Lab 0 で Codex 接続確認済 (workspace + GitHub connector)

## 手順

### Step 1: prompt 5 項目を書く

自 Sandbox `wk2/lab4b/codex_prompt_lab4b.md` を作成。上記「prompt 前 5 項目」の内容をそのまま記入する (formatting は markdown table または見出し別 section で OK)。

### Step 2: Codex に依頼

ChatGPT Enterprise → Codex を開き、上記 prompt を渡す。生成対象: `wk2/lab4b/noop_logger.py`。

期待: ~30-50 行 Python、`rclpy.Node` 継承、`/joint_states` subscriber、INFO log 出力、Ctrl-C で graceful shutdown。

### Step 3: diff を読む (禁止リスト違反確認)

Codex 出力 diff を必ず読む。**禁止リスト違反**:

- `from kinpy import` / `import kdl` / `from urdf_parser_py import` → IK / KDL / URDF parsing → 採用しない
- `JointTrajectory` import → trajectory 生成 → 採用しない
- `controller_manager_msgs` import → controller 操作 → 採用しない

違反時は Codex に「禁止リスト違反のため再生成」と指示し、Sandbox PR Review Notes の「採用しない提案」に記録。

### Step 4: mock_hardware 環境で実行 + INFO log 取得

別 terminal で Lab 4 launch を background 起動 (Lab 4 README Step 4 と同じ):

```bash
cd ~/lab4_ws
source install/setup.bash
ros2 launch minimal_robot_bringup minimal_lab4.launch.py > /tmp/lab4_launch.log 2>&1 &
LAUNCH_PID=$!
sleep 5
```

Lab 4b 本体の noop_logger を timeout 付き実行:

```bash
cd ~/<sandbox_dir>
timeout 5s python3 wk2/lab4b/noop_logger.py \
    > wk2/lab4b/execution_log.txt 2>&1 || true

# Cleanup
kill "$LAUNCH_PID" 2>/dev/null || true
wait "$LAUNCH_PID" 2>/dev/null || true
```

期待: `execution_log.txt` に 5 秒分の INFO ログ (`recv name=[...] pos=[...] ts=...`)。

### Step 5: Sandbox PR Review Notes 記入

自 Sandbox `wk2/lab4b/Sandbox_PR_Review_Notes.md` を作成 (template `course/week2/deliverables/sandbox_pr_review_notes_template.md` を複写)。**全 6 行を記入** (空欄 NG):

| 項目 | 記入内容 (例) |
|---|---|
| task split | prompt 5 項目を `wk2/lab4b/codex_prompt_lab4b.md` に記録、本 Notes は参照のみ |
| Codex prompt | (上記 prompt の要約) |
| diff summary | `noop_logger.py` 1 ファイル新規、~30 行、`rclpy.Node` 継承、`/joint_states` subscriber、INFO log |
| human review | **動く根拠**: execution_log.txt の INFO ログ抜粋 / **壊れうる条件**: `/joint_states` の `name` と `position` 配列長不一致 / **採用しない提案**: (もしあれば記録、なければ「なし」と書く) / **追加修正**: (もしあれば記録、なければ「なし」と書く) |
| debug evidence | execution_log.txt の INFO ログ 5 行抜粋 |
| judgment boundary | 安全判断は人間: 禁止リスト (IK/URDF parsing/trajectory/controller 操作/安全判断自動化) を遵守、コメントヘッダで明記 |

### Step 6: PR 作成

```bash
cd ~/<sandbox_dir>
git add wk2/lab4b/codex_prompt_lab4b.md wk2/lab4b/noop_logger.py wk2/lab4b/execution_log.txt wk2/lab4b/Sandbox_PR_Review_Notes.md
git commit -m "lab: W2 Lab 4b Codex no-op adapter logger"
git push origin <your-branch>
gh pr create --title "wk2-lab4b" --body "Codex 生成→人間レビュー一巡"
```

## 提出物

- `wk2/lab4b/codex_prompt_lab4b.md` (prompt 5 項目)
- `wk2/lab4b/noop_logger.py` (Codex 生成 + diff レビュー済)
- `wk2/lab4b/execution_log.txt` (実行 INFO ログ)
- `wk2/lab4b/Sandbox_PR_Review_Notes.md` (全 6 行記入)
- PR URL

## 合格条件

合格条件は [CHECKLIST.md](./CHECKLIST.md) を参照。

## 参照

- R-33: Git Book
- R-34: GitHub Docs: Working with forks
- R-35: GitHub Docs: Fork a repository
- R-36: Codex web docs
- R-37: Using Codex with your ChatGPT plan
- R-38: Codex Enterprise Admin Setup
