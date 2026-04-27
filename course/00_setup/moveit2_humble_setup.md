---
type: setup
id: SETUP-MOVEIT2
title: MoveIt 2 セットアップ (demo 起動まで)
week: 0
duration_min: 15
prerequisites: []
worldcpj_ct: []
roles: [common]
references: [R-08, R-09]
deliverables: []
---

# MoveIt 2 セットアップ (demo 起動まで)

## 前提

- Ubuntu 22.04 (Jammy Jellyfish)
- ROS 2 Humble がインストール済みであること ([ubuntu_2204_humble_setup.md](./ubuntu_2204_humble_setup.md) 参照)
- Gazebo Fortress は任意 (MoveIt 2 demo 起動には不要)

## 手順

公式チュートリアル (R-08) に基づきます。

### 1. MoveIt 2 パッケージのインストール

```bash
sudo apt update
sudo apt install -y \
  ros-humble-moveit \
  ros-humble-moveit-resources-panda-moveit-config
```

`ros-humble-moveit` はコア・プランナ・RViz プラグインを含みます。`ros-humble-moveit-resources-panda-moveit-config` は demo 用の Panda ロボット設定です。

### 2. ROS 環境の読み込み

```bash
source /opt/ros/humble/setup.bash
```

`~/.bashrc` に既に追記済みであれば新しいターミナルを開くだけで有効になります。

### 3. MoveIt 2 demo の起動

```bash
ros2 launch moveit_resources_panda_moveit_config demo.launch.py
```

RViz が起動し、Panda ロボットアームの planning scene が表示されれば成功です。  
左パネルの **MotionPlanning** タブから Goal State を変更して **Plan & Execute** を押すと動作計画が確認できます。

## SP1 の到達線

**SP1 のゴール: demo 起動 + RViz planning scene が表示できること。**

自前ロボットの URDF/SRDF 作成・MoveIt Setup Assistant を用いた設定は **SP2 (W2 Lab 3-4)** の範囲です。SP1 では MoveIt 2 の動作確認のみを行います。

## 検証

```bash
# パッケージがインストールされているか確認
dpkg -l | grep ros-humble-moveit
```

以下の行が含まれていれば OK:

```
ii  ros-humble-moveit  ...
ii  ros-humble-moveit-resources-panda-moveit-config  ...
```

demo 起動の確認:

```bash
source /opt/ros/humble/setup.bash
ros2 launch moveit_resources_panda_moveit_config demo.launch.py
```

RViz ウィンドウが開き、ロボットモデルが表示されれば環境構築完了です。

## 参照

- [R-08] MoveIt2 Getting Started — https://moveit.picknik.ai/main/doc/tutorials/getting_started/getting_started.html
- [R-09] MoveIt Quickstart in RViz — https://moveit.picknik.ai/main/doc/tutorials/quickstart_in_rviz/quickstart_in_rviz_tutorial.html
