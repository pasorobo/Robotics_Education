---
type: reference
id: REF-W2-LAB4B-CODEX-PROMPT
title: Lab 4b Codex prompt 5 項目記入例 (instructor case)
week: 2
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-07]
roles: [common, sandbox]
references: [R-36, R-37, R-38]
deliverables: []
---

# Codex Prompt 5 項目記入例 — Lab 4b no-op adapter logger

> instructor case では Codex を直接利用せず、本 prompt に従って手書きで `noop_logger.py` を作成。Codex を使う場合は本 prompt をそのまま渡せばよい。

## 目的

mock_hardware で動く `/joint_states` topic を受信し、INFO log に joint name + position + timestamp を出力する no-op adapter logger を作る。adapter の境界 (subscribe + log のみ、制御しない) を確認する教材。

## 入力

- ROS 2 topic `/joint_states` (型: `sensor_msgs/msg/JointState`)
- mock_hardware 環境 (Lab 4 の minimal_robot_bringup launch が background で起動中)

## 制約

- ROS 2 Humble、`rclpy` のみ (依存追加禁止、`pip install` 等不要)
- Python 3.10
- Ctrl-C で graceful shutdown (例外スタックトレースを出さない)
- **禁止リスト遵守**:
  - IK 実装禁止
  - KDL 導入禁止
  - URDF parsing 禁止
  - trajectory 生成禁止 (`JointTrajectory` 等の publish 禁止)
  - controller 操作禁止 (`controller_manager_msgs` import 禁止)
  - 安全判断の自動化禁止 (条件付き停止、自動 emergency stop 等)

## 成功条件

1. `python3 noop_logger.py` 起動成功
2. `/joint_states` 受信のたびに INFO ログ出力 (フォーマット例: `recv name=['j1'] pos=[0.0] ts=...`)
3. 5 秒経過後、Ctrl-C で graceful shutdown (例外なし、終了コード 0)

## 検証コマンド

```bash
# Terminal 1: Lab 4 launch background
cd ~/lab4_ws && source install/setup.bash
ros2 launch minimal_robot_bringup minimal_lab4.launch.py > /tmp/lab4.log 2>&1 &
sleep 5

# Terminal 2: noop_logger 実行 (5 秒タイムアウト)
timeout 5s python3 noop_logger.py 2>&1 | tee execution_log.txt
# 期待: INFO ログ多数行、Ctrl-C 不要 (timeout で自然停止)

# Cleanup: launch を kill
kill %1 2>/dev/null || true
```
