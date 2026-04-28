---
type: lab
id: W3-Lab5
title: Gazebo + ros_gz_bridge YAML
week: 3
duration_min: 60
prerequisites: [W3-L5]
worldcpj_ct: [CT-08]
roles: [common, sim]
references: [R-18, R-19]
deliverables: [bridge_config_yaml]
---

# Lab 5 — Gazebo + ros_gz_bridge YAML

## 目的

Gazebo Fortress 起動確認 (gz/ign 両系統) + `ros_gz_bridge` YAML 設計 (`/clock` mandatory + `/joint_states` 概念例)。real bridge 起動は Stretch goal (Sandbox Bridge Role Owner)。

## 前提

- SP1 setup + SP2 setup 完了
- SP3 用に `sudo apt install gz-fortress ros-humble-ros-gz ros-humble-ros-gz-bridge` 完了 (sudo 不可なら version 確認のみで合格可)
- (`bash tools/verify_env.sh --week 3` で確認)

## 手順

### Step 1: Gazebo CLI version 確認

```bash
gz sim --version
# または (Fortress 過渡期環境)
ign gazebo --version
```

どちらかで version が出れば OK。

### Step 2: Gazebo GUI 起動確認

```bash
gz sim shapes.sdf
# または
ign gazebo shapes.sdf
```

GUI が立ち上がり、3 物体が表示されれば OK。X11 困難時:

```bash
gz sim --headless-rendering shapes.sdf
# または
ign gazebo --headless-rendering shapes.sdf
```

最悪、Step 1 の version 確認のみで合格可 (CHECKLIST 縮退)。

### Step 3: bridge_config.yaml を Sandbox に作成

自 Sandbox `wk3/lab5/bridge_config.yaml` を作成。以下の **完全な雛形** を写経:

```yaml
# /clock (mandatory) - gz transport の /clock を ROS 2 /clock topic に bridge
- ros_topic_name: "/clock"
  gz_topic_name: "/clock"
  ros_type_name: "rosgraph_msgs/msg/Clock"
  gz_type_name: "ignition.msgs.Clock"
  direction: GZ_TO_ROS

# /joint_states (Stretch、概念例) - joint を持つ robot model が必要
# shapes.sdf にはロボット joint がないため real run には別 robot model 拡張が必要
# - ros_topic_name: "/joint_states"
#   gz_topic_name: "/world/default/model/<robot>/joint_state"
#   ros_type_name: "sensor_msgs/msg/JointState"
#   gz_type_name: "ignition.msgs.Model"
#   direction: GZ_TO_ROS
```

### Step 4: (Stretch、Sandbox Bridge Role Owner) 実 ros_gz_bridge で /clock 起動

joint を持つ robot model を別途準備して `/joint_states` まで実 bridge は SP6+ または Sandbox Bridge Role Owner で扱う。本 Step では `/clock` 1 topic のみ Stretch:

Terminal 1: gz sim auto-run (paused 回避):

```bash
gz sim -r shapes.sdf
# または
ign gazebo -r shapes.sdf
```

Terminal 2: ros_gz_bridge を /clock で起動:

```bash
ros2 run ros_gz_bridge parameter_bridge \
    --ros-args -p config_file:=$(pwd)/wk3/lab5/bridge_config.yaml
```

Terminal 3: ROS 2 側で /clock 確認:

```bash
ros2 topic list | grep /clock
timeout 5s ros2 topic echo /clock --once
```

`/clock` が ROS 2 側に流れていれば Stretch 達成。

## 提出物

mandatory:
- `wk3/lab5/bridge_config.yaml` (Sandbox commit、教材雛形写経)

Stretch (Sandbox Bridge Role Owner):
- `wk3/lab5/bridge_run.log` (real ros_gz_bridge 起動 log)
- `wk3/lab5/bridge_topic_list.txt` (`ros2 topic list` 出力 + `/clock` 確認)

## 合格条件

合格条件は [CHECKLIST.md](./CHECKLIST.md) を参照。

## 参照

- R-18: Gazebo Fortress ROS installation
- R-19: Gazebo Fortress ROS2 integration
