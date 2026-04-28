---
type: lab
id: W3-Lab6b
title: Codex no-op bridge stub
week: 3
duration_min: 75
prerequisites: [W3-Lab6, W2-Lab4b]
worldcpj_ct: [CT-07, CT-08]
roles: [common, sandbox]
references: [R-33, R-34, R-35, R-36, R-37, R-38]
deliverables: [bridge_stub, sandbox_pr_review_notes]
---

# Lab 6b — Codex no-op bridge stub

## 禁止リスト (重要)

本 Lab で Codex に作らせてはいけないコード:

**Lab 4b 流用 (継続)**:

- IK 実装、KDL 導入、URDF parsing、trajectory 生成、controller 操作、安全判断の自動化

**Lab 6b 固有 (追加)**:

- 実 simulator 起動 (`subprocess` で `gz sim` 等の自動化)
- 実 `ros_gz_bridge` 操作 (`subprocess` で `parameter_bridge` 起動等)
- Affordance 判定の自動化

Codex がこれらを含むコードを出した場合は **採用しない**。Sandbox PR Review Notes の「採用しない提案」に記録。

「制御しない bridge stub」として、bridge の **境界 / ログ / 失敗条件** だけを見る教材。

## Codex 利用ガイド (このLab 必須)

CONVENTIONS.md §6 Codex 統合パターンの共通テンプレを適用 (Week 3 = 必須):

### prompt 前 5 項目

`tools/codex_prompt_template.md` から複写、本 Lab 用に記入:

- **目的**: provisional schema **input 4 field** (`scene_packet` / `robot_state` / `candidate_set` / `action_intent`) を JSON file から読み込み、各 field 名と型を INFO log に出力する no-op bridge stub。**output 4 field は本 stub の対象外** (`simulation_bridge_draft.md` の設計対象、Lab 6 で扱った)
- **入力**: JSON file (`example_scene_packet.json`、教材内雛形)
- **制約**: Python 3.10、`json` + `sys` 標準ライブラリのみ (依存追加禁止)、`rclpy` 不要 (finite script、常駐 ROS node ではない)、上記禁止リスト遵守
- **成功条件**: (1) `python3 bridge_stub.py example_scene_packet.json` が **exit code 0** で正常終了、(2) input 4 field (scene_packet / robot_state / candidate_set / action_intent) すべてについて `recv field=` log が出力される、(3) `python3 -m py_compile bridge_stub.py` が syntax error なく通る
- **検証コマンド**: 教材内 example_scene_packet.json で 1 回実行 (詳細は手順 Step 4)

### 委ねない判断

- Affordance schema の設計
- 評価指標の選定
- 安全境界の決定
- 実機投入可否の判断

これらは PJ (人間) が決める。Codex は実装補助。

### レビュー観点 (Sandbox PR Review Notes に記録)

- diff summary
- 動く根拠 (検証コマンド実行ログ)
- 壊れうる条件 (edge case、依存条件、環境差)
- 採用しない提案 (Codex が提案したが取らなかった選択肢 + 理由)
- 追加修正 (Codex 出力にユーザーが加えた修正)
- **schema 整合性** (Week 3 追加): provisional schema の input 4 field すべてが log に出ているか、output 4 field を扱っていないか

## 前提

- Lab 6 完了 (provisional schema 8 field 理解)
- W1 Lab 0 で Codex 接続確認済 (workspace + GitHub connector)

## 手順

### Step 1: prompt 5 項目を Sandbox に書く

```bash
cd ~/Develop/Sandbox_<name>
mkdir -p wk3/lab6b
# wk3/lab6b/codex_prompt_lab6b.md に上記「prompt 前 5 項目」の内容をそのまま記入
```

### Step 2: 教材内 example_scene_packet.json を Sandbox にコピー

教材内雛形 (provisional schema input 4 field を realistic に埋めた sample):

```json
{
  "scene_packet": {
    "image_url": "/tmp/scene_001.png",
    "obstacles": [
      {"id": "box1", "pose": [0.5, 0.0, 0.05]},
      {"id": "wall1", "pose": [1.0, 0.0, 0.5]}
    ],
    "timestamp": 1745800000
  },
  "robot_state": {
    "joints": {"j1": 0.0},
    "ee_pose": [0.3, 0.0, 0.4, 0.0, 0.0, 0.0],
    "battery": 0.95
  },
  "candidate_set": [
    {"id": "cand_001", "grasp_pose": [0.5, 0.0, 0.1, 0.0, 0.0, 0.0], "score": 0.82},
    {"id": "cand_002", "grasp_pose": [0.5, 0.05, 0.1, 0.0, 0.0, 0.5], "score": 0.71}
  ],
  "action_intent": {
    "selected_id": "cand_001",
    "approach_axis": "z",
    "speed_scale": 0.3
  }
}
```

これを `wk3/lab6b/example_scene_packet.json` に保存。

### Step 3: Codex に依頼 → bridge_stub.py 生成

ChatGPT Enterprise → Codex を開き、Step 1 の prompt を渡す。生成対象: `wk3/lab6b/bridge_stub.py`。

期待: ~30-40 行 Python、`json.load` で JSON file 読み込み、`recv field=<name> type=<type> value=<value>` 形式で INFO log 出力、`return 0` で正常終了 (finite script、Ctrl-C 不要)。

### Step 4: diff を読む (禁止リスト + 追加禁止 違反確認)

Codex 出力 diff を必ず読む:

- 禁止リスト (Lab 4b 流用): `from kinpy import` / `import kdl` / `import urdf_parser_py` / `JointTrajectory` / `controller_manager_msgs` → 採用しない
- **追加禁止 (Lab 6b 固有)**:
  - `subprocess` / `os.system` で `gz sim` 等を起動 → 採用しない (実 simulator 起動禁止)
  - `subprocess` で `parameter_bridge` 等を起動 → 採用しない (実 ros_gz_bridge 操作禁止)
  - 「if score > threshold: action = ...」のような Affordance 自動判定 → 採用しない

違反時は Codex に「禁止リスト違反のため再生成」と指示し、Sandbox PR Review Notes の「採用しない提案」に記録。

不要 import (`rclpy`、`KeyboardInterrupt` 処理) も「不要として採用しない」(本 Lab は finite script のため、Lab 4b の常駐 node とは別)。

### Step 5: 実行 + INFO log 取得

```bash
python3 wk3/lab6b/bridge_stub.py wk3/lab6b/example_scene_packet.json \
    > wk3/lab6b/execution_log.txt 2>&1
PY_EXIT=$?
echo "py_exit=$PY_EXIT"   # expect 0

# 検証
grep -c "recv field=" wk3/lab6b/execution_log.txt   # expect 4
python3 -m py_compile wk3/lab6b/bridge_stub.py && echo "syntax OK"
```

期待: `py_exit=0`、`grep -c "recv field=" = 4` (input 4 field 各々の log)、`syntax OK`。

### Step 6: Sandbox PR Review Notes 記入 + PR 作成

W2 template (`course/week2/deliverables/sandbox_pr_review_notes_template.md`) を流用、6 行記入:

| 項目 | 記入内容 (例) |
|---|---|
| task split | prompt 5 項目を `wk3/lab6b/codex_prompt_lab6b.md` に記録 |
| Codex prompt | (上記 prompt 要約) |
| diff summary | `bridge_stub.py` 1 ファイル新規、~30 行 Python、json.load + recv field= INFO log + return 0 (finite script) |
| human review | **動く根拠**: execution_log.txt の `recv field=` 4 行 / **壊れうる条件**: JSON file が無い場合の `FileNotFoundError`、JSON parse error / **採用しない提案**: rclpy import (不要)、KeyboardInterrupt 処理 (不要、finite script) / **追加修正**: なし / **schema 整合性**: input 4 field すべて log に出ている、output 4 field は本 stub では扱わない (Lab 6 設計対象) |
| debug evidence | execution_log.txt の `recv field=` 抜粋 |
| judgment boundary | 安全判断は人間: 禁止リスト + 追加禁止 (実 simulator/bridge/Affordance 自動判定) を遵守、コメントヘッダで明記 |

```bash
git add wk3/lab6b/codex_prompt_lab6b.md wk3/lab6b/example_scene_packet.json wk3/lab6b/bridge_stub.py wk3/lab6b/execution_log.txt wk3/lab6b/sandbox_pr_review_notes.md
git commit -m "lab: W3 Lab 6b Codex no-op bridge stub"
git push origin <your-branch>
gh pr create --title "wk3-lab6b" --body "Codex 生成→人間レビュー一巡 + schema 整合性確認"
```

## 提出物

- `wk3/lab6b/codex_prompt_lab6b.md` (prompt 5 項目)
- `wk3/lab6b/example_scene_packet.json` (provisional schema input 4 field 例)
- `wk3/lab6b/bridge_stub.py` (Codex 生成 + diff レビュー済 finite script)
- `wk3/lab6b/execution_log.txt` (実行 INFO ログ、input 4 field の recv field= 含む)
- `wk3/lab6b/sandbox_pr_review_notes.md` (W2 template 流用、6 行記入 + schema 整合性)
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
