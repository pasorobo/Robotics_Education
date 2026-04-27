---
type: lab
id: W1-Lab1
title: turtlesim と rosbag2 の最小操作
week: 1
duration_min: 60
prerequisites: [W1-L1]
worldcpj_ct: [CT-07]
roles: [common, logging]
references: [R-01, R-04]
deliverables: [bag_info_log, terminal_log]
---

# Lab 1 — turtlesim と rosbag2 の最小操作

## 目的

- ROS 2 CLI の基本的な感触を身につける
- bag 録画 / 再生 / info の一連の流れを体験する
- 評価証跡 = 軽量ファイル (bag 本体ではなく info・metadata・log) という原則を実践する

## 前提

- `course/00_setup/` の手順をすべて完了していること
- 自 Sandbox リポジトリ (`~/Develop/Sandbox_<name>/`) が存在し、ROS 2 環境が動作すること

## 手順

### Step 0: 録画開始 (script で terminal をログ化)

```bash
mkdir -p ~/Develop/Sandbox_<name>/wk1/lab1
script -q ~/Develop/Sandbox_<name>/wk1/lab1/terminal_5min.log -c "bash"
```

新シェルが起動する。**本 Lab 内のすべてのコマンドはこのシェルで打つ。**

### Step 1: turtlesim 起動

別 terminal で実行:

```bash
ros2 run turtlesim turtlesim_node
```

亀のウィンドウが表示されることを確認する。

### Step 2: 操作 turtle

別 terminal で実行:

```bash
ros2 run turtlesim turtle_teleop_key
```

矢印キーで亀を動かせることを確認する。

### Step 3: topic 観察

script シェル (Step 0 のシェル) で実行:

```bash
ros2 topic list
ros2 topic info /turtle1/cmd_vel
ros2 topic echo /turtle1/cmd_vel
```

`ros2 topic echo` を実行したまま teleop でキーを押し、値が出ることを確認してから Ctrl-C で停止。

### Step 4: bag record

script シェルで実行 (30秒録画):

```bash
ros2 bag record -o /tmp/turtle_bag /turtle1/cmd_vel /turtle1/pose
```

record 中に teleop で亀を動かす。30秒後に Ctrl-C で停止。

### Step 5: bag info → bag_info.txt

```bash
ros2 bag info /tmp/turtle_bag > ~/Develop/Sandbox_<name>/wk1/lab1/bag_info.txt
cat ~/Develop/Sandbox_<name>/wk1/lab1/bag_info.txt
```

`Duration:`、`/turtle1/cmd_vel`、`/turtle1/pose` が表示されることを確認する。

### Step 6: metadata 軽量コピー

`.db3` や `rosbag2_*/` ディレクトリ自体は **commit しない**。metadata YAML だけをコピーする:

```bash
cp /tmp/turtle_bag/metadata.yaml ~/Develop/Sandbox_<name>/wk1/lab1/rosbag_metadata.yaml
```

### Step 7: bag 再生

turtlesim を再起動して位置をリセットする (Step 1 の terminal で Ctrl-C → 再度起動)。  
別 terminal で再生:

```bash
ros2 bag play /tmp/turtle_bag
```

亀が Step 4 で録画した動きを再現することを確認する。

### Step 8: script 終了

script シェル (Step 0 のシェル) で実行:

```bash
exit
```

script が終了し `terminal_5min.log` が確定する。

### Step 9: Sandbox に commit/PR

**提出する 3 ファイルのみ** を Sandbox に commit する:

```bash
cd ~/Develop/Sandbox_<name>
git add wk1/lab1/bag_info.txt wk1/lab1/rosbag_metadata.yaml wk1/lab1/terminal_5min.log
git commit -m "lab1: add turtlesim rosbag artifacts"
git push origin main
```

GitHub 上で PR を作成し、レビューを依頼する。

## bag 本体 commit 禁止 (重要)

提出するのは以下の 3 点のみ:

| ファイル | 内容 |
|---|---|
| `bag_info.txt` | `ros2 bag info` の出力テキスト |
| `rosbag_metadata.yaml` | rosbag2 ディレクトリ内 `metadata.yaml` を `cp` した軽量コピー |
| `terminal_5min.log` | `script` コマンドで記録した terminal ログ |

`/tmp/turtle_bag/` 全体、`.db3` ファイル、`.mcap` ファイル、`rosbag2_*/` ディレクトリは Sandbox に **commit しない**。`.gitignore` でブロックされるが、意識して守ること。

## 提出物

上記 Step 9 参照。`bag_info.txt`、`rosbag_metadata.yaml`、`terminal_5min.log` の 3 ファイルのみ。

## 合格条件

合格条件は [CHECKLIST.md](./CHECKLIST.md) を参照。

## 参照

- R-01: ROS 2 公式ドキュメント
- R-04: rosbag2 公式ドキュメント
