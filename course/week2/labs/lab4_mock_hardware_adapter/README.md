---
type: lab
id: W2-Lab4
title: mock_hardware adapter (最小 ROS package + colcon build)
week: 2
duration_min: 75
prerequisites: [W2-L4, W2-Lab3]
worldcpj_ct: [CT-06]
roles: [common, adapter]
references: [R-11, R-12]
deliverables: [robot_readiness_mini_report]
---

# Lab 4 — mock_hardware adapter

## 目的

`ros2_control` の `mock_components/GenericSystem` を使い、最小 ROS package を colcon build → ros2 launch で起動し、Robot Adapter 段階のうち **no-op / mock_hardware 段階** (controller / hardware interface 境界 + `/joint_states` の流れ) を観察する。

**URDF + IK mock 段階は本 Lab では扱わない**。Robot Readiness Mini Report の `next gate` 欄に「URDF + IK mock adapter を別 PR で検討」と記録する (Stretch goal、Robot Adapter Role Owner)。

## 前提

- SP1 setup 完了
- SP2 setup: `sudo apt install ros-humble-ros2-control ros-humble-ros2-controllers python3-colcon-common-extensions` 完了
- (`bash tools/verify_env.sh --week 2` PASS で確認)

## 手順

### Step 1: workspace 作成

```bash
mkdir -p ~/lab4_ws/src
cd ~/lab4_ws/src
```

### Step 2: package を作成 — 5 ファイルを写経

最小 ROS package `minimal_robot_bringup` を作成。以下の **5 ファイル** をそのまま自 workspace に作成する。

#### `~/lab4_ws/src/minimal_robot_bringup/package.xml`

```xml
<?xml version="1.0"?>
<package format="3">
  <name>minimal_robot_bringup</name>
  <version>0.0.1</version>
  <description>Minimal ros2_control mock_hardware demo for Week 2 Lab 4</description>
  <maintainer email="learner@example.com">learner</maintainer>
  <license>MIT</license>

  <buildtool_depend>ament_cmake</buildtool_depend>

  <exec_depend>ros2_control</exec_depend>
  <exec_depend>ros2_controllers</exec_depend>
  <exec_depend>controller_manager</exec_depend>
  <exec_depend>robot_state_publisher</exec_depend>
  <exec_depend>xacro</exec_depend>

  <export>
    <build_type>ament_cmake</build_type>
  </export>
</package>
```

#### `~/lab4_ws/src/minimal_robot_bringup/CMakeLists.txt`

```cmake
cmake_minimum_required(VERSION 3.8)
project(minimal_robot_bringup)

find_package(ament_cmake REQUIRED)

install(
  DIRECTORY urdf config launch
  DESTINATION share/${PROJECT_NAME}
)

ament_package()
```

#### `~/lab4_ws/src/minimal_robot_bringup/urdf/minimal_robot.urdf`

```xml
<?xml version="1.0"?>
<robot name="minimal_robot">
  <link name="base_link"/>
  <joint name="j1" type="revolute">
    <parent link="base_link"/>
    <child link="link1"/>
    <axis xyz="0 0 1"/>
    <limit lower="-1.57" upper="1.57" effort="10" velocity="1.0"/>
    <origin xyz="0 0 0" rpy="0 0 0"/>
  </joint>
  <link name="link1"/>
  <ros2_control name="MinimalSystem" type="system">
    <hardware>
      <plugin>mock_components/GenericSystem</plugin>
    </hardware>
    <joint name="j1">
      <command_interface name="position"/>
      <state_interface name="position"/>
      <state_interface name="velocity"/>
    </joint>
  </ros2_control>
</robot>
```

#### `~/lab4_ws/src/minimal_robot_bringup/config/controllers.yaml`

```yaml
controller_manager:
  ros__parameters:
    update_rate: 100  # Hz

    joint_state_broadcaster:
      type: joint_state_broadcaster/JointStateBroadcaster

    forward_position_controller:
      type: forward_command_controller/ForwardCommandController

forward_position_controller:
  ros__parameters:
    joints:
      - j1
    interface_name: position
```

#### `~/lab4_ws/src/minimal_robot_bringup/launch/minimal_lab4.launch.py`

```python
import os
from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch.actions import RegisterEventHandler
from launch.event_handlers import OnProcessExit
from launch_ros.actions import Node

def generate_launch_description():
    pkg_share = get_package_share_directory('minimal_robot_bringup')
    urdf_path = os.path.join(pkg_share, 'urdf', 'minimal_robot.urdf')
    controllers_yaml = os.path.join(pkg_share, 'config', 'controllers.yaml')

    with open(urdf_path, 'r') as f:
        robot_description = {'robot_description': f.read()}

    rsp = Node(
        package='robot_state_publisher',
        executable='robot_state_publisher',
        output='screen',
        parameters=[robot_description],
    )

    cm = Node(
        package='controller_manager',
        executable='ros2_control_node',
        parameters=[robot_description, controllers_yaml],
        output='screen',
    )

    jsb_spawner = Node(
        package='controller_manager',
        executable='spawner',
        arguments=['joint_state_broadcaster'],
    )

    fpc_spawner = Node(
        package='controller_manager',
        executable='spawner',
        arguments=['forward_position_controller'],
    )

    delayed_fpc = RegisterEventHandler(
        event_handler=OnProcessExit(
            target_action=jsb_spawner,
            on_exit=[fpc_spawner],
        )
    )

    return LaunchDescription([rsp, cm, jsb_spawner, delayed_fpc])
```

### Step 3: colcon build

```bash
cd ~/lab4_ws
colcon build --packages-select minimal_robot_bringup
source install/setup.bash
```

期待: `Summary: 1 package finished` (~30 秒)。

### Step 4: launch 起動 (background) + 確認

```bash
mkdir -p wk2/lab4
ros2 launch minimal_robot_bringup minimal_lab4.launch.py \
    > wk2/lab4/controller_spawn.log 2>&1 &
LAUNCH_PID=$!

sleep 5

ros2 control list_controllers | tee wk2/lab4/controllers_list.txt

timeout 5s ros2 topic echo /joint_states \
    > wk2/lab4/joint_states_echo.log 2>&1 || true

# Lab 4 単体の場合はここで stop。Lab 4b に進む場合は launch を継続。
kill "$LAUNCH_PID" 2>/dev/null || true
wait "$LAUNCH_PID" 2>/dev/null || true
```

期待:
- `controller_spawn.log` に `controller_manager` の起動ログ + spawner の `Configured and activated joint_state_broadcaster` / `... forward_position_controller`
- `controllers_list.txt` に `joint_state_broadcaster` と `forward_position_controller` が `active` と表示
- `joint_states_echo.log` に 5 秒分の `/joint_states` メッセージ (各 100 Hz × 5 秒 = 500 回程度)

### Step 5: Robot Readiness Mini Report 記入

自 Sandbox `wk2/Robot_Readiness_Mini_Report.md` を作成 (template `course/week2/deliverables/robot_readiness_mini_report_template.md` を複写)。**全 7 行を記入** (空欄 NG):

| 項目 | 記入内容 (例) |
|---|---|
| robot_id | `minimal_robot (Lab 4 mock_hardware)` |
| adapter stage | `mock_hardware (URDF+IK mock 未到達)` |
| ROS interface | `controller_manager + mock_components/GenericSystem + joint_state_broadcaster + forward_position_controller` |
| calibration state | `すべて 未確認 / SP5 で評価予定 (実カメラ未接続)` |
| safety state | `すべて 未確認 / SP4 で評価予定 / 実機接続なし` |
| logging state | `controllers_list.txt + joint_states_echo.log を wk2/lab4/ に commit` |
| **next gate** | `URDF + IK mock adapter を別 PR で検討 (Robot Adapter Role Owner Stretch)` |

### Step 6: Sandbox commit / PR

```bash
git add wk2/lab4/ wk2/Robot_Readiness_Mini_Report.md
git commit -m "lab: W2 Lab 4 mock_hardware adapter"
git push origin <your-branch>
gh pr create --title "wk2-lab4" --body "controller spawn log + joint_states echo + Robot Readiness 全 7 行記入"
```

## bag 本体 commit 禁止注記

本 Lab では bag を扱わないが、`controller_spawn.log` `controllers_list.txt` `joint_states_echo.log` 以外の中間ファイル (例: colcon build 出力 `~/lab4_ws/build/`、`install/`、`log/`) は `.gitignore` で block 済 (CONVENTIONS.md §3.1)。

## 提出物

- `wk2/lab4/controller_spawn.log` (実走 log)
- `wk2/lab4/controllers_list.txt` (controller active 確認)
- `wk2/lab4/joint_states_echo.log` (`/joint_states` 5 秒分)
- `wk2/Robot_Readiness_Mini_Report.md` (全 7 行記入)

## 合格条件

合格条件は [CHECKLIST.md](./CHECKLIST.md) を参照。

## 参照

- R-11: ros2_control Humble docs
- R-12: ros2_controllers Humble
