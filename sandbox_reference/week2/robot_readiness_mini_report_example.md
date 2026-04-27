---
type: reference
id: REF-W2-ROBOT-READINESS-EXAMPLE
title: Robot Readiness Mini Report 記入例 (instructor case)
week: 2
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-06, CT-09]
roles: [common, adapter, calibration, safety]
references: []
deliverables: []
---

# Robot Readiness Mini Report (記入例)

> instructor が SP2 walk-through を実走した時点での記入例。
> このリポジトリ自体を Sandbox 兼 Course content として運用しているため、robot_id は Lab 3 で扱った Panda demo + Lab 4 で組んだ minimal_robot (mock_hardware) を併記。

| 項目 | 記入内容 |
|---|---|
| robot_id | `Panda demo (Lab 3 RViz planning) + minimal_robot (Lab 4 mock_hardware)` |
| adapter stage | `mock_hardware (URDF+IK mock 未到達)` |
| ROS interface | `controller_manager + mock_components/GenericSystem + joint_state_broadcaster + forward_position_controller。MoveIt 2 (Lab 3 のみ)、UR ROS2 driver 未接続` |
| calibration state | `intrinsic / extrinsic / hand-eye / fixture すべて 未確認 / SP5 で評価予定 (実カメラ未接続)` |
| safety state | `emergency stop / safeguard / protective / safe no-action / operator confirmation すべて 未確認 / SP4 で評価予定 / 実機接続なし` |
| logging state | `rosbag2 OK (W1 Lab 1 で実証)。controller_spawn.log + controllers_list.txt + joint_states_echo.log を sandbox_reference/week2/lab4/ に記録。Lab 3 の planning_evidence.md を sandbox_reference/week2/lab3/ に記録` |
| next gate | `URDF + IK mock adapter を別 PR で検討 (Robot Adapter Role Owner Stretch)。Q1 Reduced Lv1 開始までに Lab 3-4b 教材として安定化。SP3 で Gazebo bridge と連携、SP4 で trial sheet と連携` |

## 自由記述

### 詰まった点

- なし。`mock_components/GenericSystem` は ros2_control の標準機能で素直に動いた。
- launch 起動順 (controller_manager → spawner) は `RegisterEventHandler(OnProcessExit)` で正しく直列化できた。

### 次に試したいこと

- SP3 (W3) で minimal_robot URDF を Gazebo Fortress でも load できるよう拡張。
- SP4 (W4) で controller_spawn.log を rosbag2 経由で trial sheet と連携。

### Phase 0 後の宿題 (Stretch goal)

- URDF + IK mock adapter (KDL ベース) を別 PR で実装。題材: minimal_robot に j2 を追加し 2-DOF 化、PoseStamped を IK 解いて `/joint_states` に流す adapter
- URSim 接続 (Robot Adapter / Safety Role Owner)
- camera_calibration ハンズオン (Calibration Role)

---

| 記入者 | 記入日 |
|---|---|
| pasorobo (instructor) | 2026-04-27 |
