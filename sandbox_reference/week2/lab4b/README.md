---
type: reference
id: REF-W2-LAB4B-README
title: Lab 4b instructor walk-through summary (Codex なし手書き)
week: 2
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-06, CT-07]
roles: [common, adapter, sandbox]
references: [R-33, R-34, R-35, R-36, R-37, R-38]
deliverables: []
---

# Lab 4b — Instructor walk-through summary

## instructor case 注記

instructor は Course 本体開発に Codex を直接利用していない (W1 Lab 0 と同じ instructor case)。本 walk-through では:

1. `codex_prompt_lab4b.md` に prompt 5 項目を記述
2. 本 prompt に従って `noop_logger.py` を **手書き** (Codex 出力擬似)
3. ros2_control 未インストール環境のため Lab 4 の launch は使わず、`ros2 topic pub --rate 1 /joint_states` で fake publisher を立て、その上で noop_logger.py を REAL 実行。execution_log.txt の `recv name= pos=` は実 Python callback 出力。
4. PR Review Notes は別ファイル `sandbox_reference/week2/sandbox_pr_review_notes_example.md` で記入例提示

PR URL は placeholder (`<learner が記入>`)。

## 実施環境

- Ubuntu 22.04 + ROS 2 Humble + rclpy + sensor_msgs (SP1 で確認済)
- ros2_control 未インストール環境のため Lab 4 の launch は使わず、`ros2 topic pub --rate 1 /joint_states` で fake publisher を立て、その上で noop_logger.py を REAL 実行。execution_log.txt の `recv name= pos=` は実 Python callback 出力。
- 所要時間: 約 20 分 (codex_prompt 記述 5 分、noop_logger.py 手書き 10 分、実走 + log 取得 5 分)

## 実施コマンドサマリ

```bash
source /opt/ros/humble/setup.bash

# Background: fake /joint_states publisher (ros2_control 代替)
timeout 8s ros2 topic pub --rate 1 /joint_states sensor_msgs/msg/JointState \
    '{header: {stamp: {sec: 0, nanosec: 0}, frame_id: "base_link"}, name: ["j1"], position: [0.0], velocity: [0.0], effort: [0.0]}' \
    > /tmp/pub.log 2>&1 &
PUB_PID=$!
sleep 2

# noop_logger 実行 (5 秒タイムアウト)
timeout 5s python3 sandbox_reference/week2/lab4b/noop_logger.py \
    > sandbox_reference/week2/lab4b/execution_log.txt 2>&1 || true

# Cleanup
kill "$PUB_PID" 2>/dev/null || true
wait "$PUB_PID" 2>/dev/null || true
```

## 観察された挙動

- `noop_logger started, subscribing /joint_states` が起動直後に 1 行
- `recv name=['j1'] pos=[0.0] ts=...` が fake publisher の rate (1 Hz) で受信、5 秒分 (~4-5 行)
- timeout 5s で natural exit、終了コード 124 (timeout の通常動作)
- KeyboardInterrupt は `try/except` で捕捉、stack trace なし

## 詰まった点

- なし。noop_logger.py は spec §3.8.2 の固定実装をそのまま使用。
- callback 出力フォーマット `recv name={names} pos={positions} ts={ts}` が G4 pattern (`recv name=|pos=`) と一致することを確認。

## 提出物

- [`codex_prompt_lab4b.md`](./codex_prompt_lab4b.md): prompt 5 項目記入例
- [`noop_logger.py`](./noop_logger.py): 手書き実装 (Codex 出力擬似)
- [`execution_log.txt`](./execution_log.txt): 実走 INFO ログ (REAL Python 実行、recv name= pos= 含む)
- 関連: [`../sandbox_pr_review_notes_example.md`](../sandbox_pr_review_notes_example.md)
