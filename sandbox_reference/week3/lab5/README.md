---
type: reference
id: REF-W3-LAB5-BRIDGE-EXAMPLE
title: Gazebo + ros_gz_bridge YAML 記入例 (instructor case)
week: 3
duration_min: 0
prerequisites: [W3-L5]
worldcpj_ct: [CT-08]
roles: [common, sim]
references: [R-18, R-19]
deliverables: [bridge_config.yaml, bridge_run.log, bridge_topic_list.txt]
---

# Lab 5 Sandbox Reference — Gazebo + ros_gz_bridge YAML (instructor case)

> **REAL run 注記**: このファイル群は Gazebo Sim 6.16.0 (Fortress) + ros_gz_bridge を実走させた
> instructor case サンプルです。環境: Ubuntu 22.04、ROS 2 Humble、`ign gazebo` CLI
> (Fortress 過渡期環境のため `gz` CLI 不在、`ign` のみ使用)、DISPLAY=:0 (X11 GUI 利用可)。
> bridge_run.log / bridge_topic_list.txt は実走出力です (hand-authored ではありません)。

## walk-through 概要

### Step 1: 環境確認

```bash
ign gazebo --version   # Gazebo Sim 6.16.0
source /opt/ros/humble/setup.bash
bash tools/verify_env.sh --week 3   # PASS=10/FAIL=0
```

### Step 2: bridge_config.yaml 作成

`sandbox_reference/week3/lab5/bridge_config.yaml` を教材雛形 (Lab5 README §Step3) の写経で作成。
- `/clock` エントリ: mandatory (GZ_TO_ROS)
- `/joint_states` エントリ: コメントアウト (shapes.sdf にはロボット joint がないため)

### Step 3: Gazebo 起動 (auto-run + headless)

```bash
ign gazebo -r --headless-rendering \
    /usr/share/ignition/ignition-gazebo6/worlds/shapes.sdf \
    > /tmp/gz_sim.log 2>&1 &
GZ_PID=$!
sleep 5
```

`-r` フラグで paused 状態回避。headless-rendering で X11 依存を最小化。
`GZ_PID=$!` を起動直後に確保 (fork 後すぐに代入 — foot-gun 解消パターン)。

### Step 4: ros_gz_bridge 起動 (wrapper logging)

```bash
echo "starting parameter_bridge for /clock" > bridge_run.log
echo "config: sandbox_reference/week3/lab5/bridge_config.yaml" >> bridge_run.log
echo "timestamp: $(date -u '+%Y-%m-%dT%H:%M:%SZ')" >> bridge_run.log

ros2 run ros_gz_bridge parameter_bridge \
    --ros-args -p config_file:=$(pwd)/sandbox_reference/week3/lab5/bridge_config.yaml \
    >> bridge_run.log 2>&1 &
BRIDGE_PID=$!
sleep 5
```

wrapper logging で `"starting parameter_bridge for /clock"` をログ冒頭に出力。
`BRIDGE_PID=$!` も起動直後に確保。

### Step 5: /clock 確認

```bash
ros2 topic list | tee bridge_topic_list.txt
timeout 5s ros2 topic echo /clock --once >> bridge_topic_list.txt 2>&1 || true
```

`timeout 5s` で hang 防止。`|| true` でタイムアウト時もスクリプト継続。

### Step 6: cleanup

```bash
kill $BRIDGE_PID 2>/dev/null || true
wait $BRIDGE_PID 2>/dev/null || true
kill $GZ_PID 2>/dev/null || true
wait $GZ_PID 2>/dev/null || true
```

## REAL run 結果サマリ

| ファイル | 内容 |
|---|---|
| `bridge_config.yaml` | `/clock` mandatory (GZ_TO_ROS) + `/joint_states` コメントアウト |
| `bridge_run.log` | ros_gz_bridge 0.244.23 起動、`Creating GZ->ROS Bridge: [/clock ...]` |
| `bridge_topic_list.txt` | `/clock` topic 確認、`echo /clock` で `sec: 5` 受信 |

## G4 パターン確認 (6 件)

| # | ファイル | パターン | 確認 |
|---|---|---|---|
| 1 | bridge_config.yaml | `ros_topic_name` キー存在 | OK |
| 2 | bridge_config.yaml | `/clock` エントリ | OK |
| 3 | bridge_config.yaml | `GZ_TO_ROS` direction | OK |
| 4 | bridge_run.log | `ros_gz_bridge` / `parameter_bridge` 記述 | OK |
| 5 | bridge_run.log | `/clock` bridge 起動ログ | OK |
| 6 | bridge_topic_list.txt | `/clock` topic 一覧 | OK |

## 注意事項

- `gz` CLI は Fortress 過渡期環境には存在しない。必ず `ign gazebo` を使用。
- `/joint_states` の実 bridge は shapes.sdf では不可 (ロボット joint model が必要)。
  SP6+ または別 robot model (例: Panda URDF) で拡張する。
- `ros2 topic echo /clock` を timeout なしで実行すると hang するため `timeout 5s` 必須。
