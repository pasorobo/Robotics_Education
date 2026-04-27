---
type: setup
id: SETUP-README
title: 環境セットアップ概要
week: 0
duration_min: 5
prerequisites: []
worldcpj_ct: []
roles: [common]
references: [R-01, R-02, R-08, R-18]
deliverables: []
---

# 環境セットアップ概要

このディレクトリは SP1 コースを進めるために必要な開発環境の構築手順をまとめたものです。

## 前提

本コースは **Ubuntu 22.04 LTS (Jammy Jellyfish) ネイティブ環境** を前提とします。

Windows 利用者向け補足: VirtualBox 6.x または WSL2 で Ubuntu 22.04 を用意してください。Course 側では Ubuntu を前提としたコマンドのみ提供し、それ以外の環境は学習者各自の責任で動作確認すること。

## 所要時間

全手順合計 **≈ 60 分**

| 手順 | 目安 |
|------|------|
| Ubuntu 22.04 + ROS 2 Humble | 30 分 |
| Gazebo Fortress | 15 分 |
| MoveIt 2 (demo 起動まで) | 15 分 |

## SP1 で必要な範囲

- **Ubuntu 22.04** + **ROS 2 Humble** のインストール
- **Gazebo Fortress** の起動確認 (`shapes.sdf` が表示できること)
- **MoveIt 2** の demo 起動確認 (RViz planning scene が表示できること)

Full MoveIt 2 設定 (自前ロボットの SRDF 作成等) は SP2 (W2 Lab 3-4) の範囲です。

## 順序

以下の順に進めてください。

1. [Ubuntu 22.04 + ROS 2 Humble](./ubuntu_2204_humble_setup.md)
2. [Gazebo Fortress](./gazebo_fortress_setup.md)
3. [MoveIt 2 (demo 起動まで)](./moveit2_humble_setup.md)

## 検証

全手順完了後、スクリプトで一括確認できます。

```bash
# このディレクトリから
bash ./verify_setup.sh

# またはリポジトリルートから
bash ../../tools/verify_env.sh
```

すべての項目が `[PASS]` で終われば環境構築完了です。

## 参照

- [R-01] ROS 2 Humble Documentation — https://docs.ros.org/en/humble/
- [R-02] ROS 2 Humble Ubuntu install — https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html
- [R-08] MoveIt2 Getting Started — https://moveit.picknik.ai/main/doc/tutorials/getting_started/getting_started.html
- [R-18] Gazebo Fortress ROS installation — https://gazebosim.org/docs/fortress/ros_installation/
