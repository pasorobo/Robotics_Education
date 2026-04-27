---
type: setup
id: SETUP-GAZEBO-FORTRESS
title: Gazebo Fortress セットアップ
week: 0
duration_min: 15
prerequisites: []
worldcpj_ct: []
roles: [common]
references: [R-18, R-19]
deliverables: []
---

# Gazebo Fortress セットアップ

## 前提

- Ubuntu 22.04 (Jammy Jellyfish)
- ROS 2 Humble がインストール済みであること ([ubuntu_2204_humble_setup.md](./ubuntu_2204_humble_setup.md) 参照)
- `sudo` 権限を持つユーザーアカウント

## 手順

公式手順 (R-18) に基づきます。

### 1. Gazebo apt ソースの追加

```bash
sudo curl -sSL https://packages.osrfoundation.org/gazebo.gpg \
  -o /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] \
  http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" \
  | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null

sudo apt update
```

### 2. Gazebo Fortress のインストール

Fortress 世代は `gz-fortress` または `ignition-fortress` パッケージ名が使われます。

```bash
sudo apt install -y gz-fortress
```

インストールできない場合は以下を試してください:

```bash
sudo apt install -y ignition-fortress
```

### 3. ROS 2 - Gazebo ブリッジのインストール

```bash
sudo apt install -y ros-humble-ros-gz
```

### 4. 起動確認

```bash
gz sim -v 4 shapes.sdf
```

または旧コマンド名が使われる環境では:

```bash
ign gazebo -v 4 shapes.sdf
```

3次元シーン (球・立方体などの形状) が GUI ウィンドウに表示されれば成功です。

## 検証

```bash
# コマンドが存在するか確認
command -v gz || command -v ign

# バージョン確認
gz sim --version 2>/dev/null || ign gazebo --version 2>/dev/null
```

ROS ブリッジの確認:

```bash
source /opt/ros/humble/setup.bash
ros2 pkg list | grep ros_gz
```

## EOL 注意

> **Gazebo Fortress は 2026-09 にサポート終了 (EOL) 予定です。**

SP6 以降で Gazebo **Harmonic** への移行レビューを行う予定です (spec §4.5)。SP1〜SP5 の範囲では Fortress を使用します。Fortress で構築したシミュレーション資材は Harmonic 移行時に SDF / launch ファイルの修正が必要になる場合があります。

## 参照

- [R-18] Gazebo Fortress ROS installation — https://gazebosim.org/docs/fortress/ros_installation/
- [R-19] Gazebo Fortress ROS2 integration — https://gazebosim.org/docs/fortress/ros2_integration/
