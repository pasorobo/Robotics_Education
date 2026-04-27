---
type: lecture
id: W1-L1
title: ROS 2 基礎 (node/topic/service/action/launch)
week: 1
duration_min: 45
prerequisites: [W1-L0]
worldcpj_ct: [CT-01, CT-07]
roles: [common]
references: [R-01, R-04, R-05]
deliverables: []
---

# ROS 2 基礎

## 目的

ROS 2 を構成する5つの基本概念 — node / topic / service / action / launch — を定義レベルで理解し、CLI で実際に確認できるようにする。またログ・bag が評価証跡として動画より優先される理由を把握する。

## 1. ROS 2 とは

ROS 2 (Robot Operating System 2) は、ロボットソフトウェアを構築するための **DDS (Data Distribution Service) ベースのミドルウェアフレームワーク**である。ROS 1 との主な違いは、マスターノード (`roscore`) が不要になった点、DDS による通信の信頼性・QoS 設定が標準化された点、Python 3 / C++17 対応が前提となった点、そしてリアルタイム性を意識した設計になった点である。本コースでは ROS 2 Humble または Iron を前提とする。

## 2. node

**node** は ROS 2 の実行単位であり、1つのプロセス内に複数の node を持つことができる (`rclpy.executors` や component によるコンテナ化)。各 node は名前空間付きの名前を持ち、`/robot/camera_node` のように階層表記される。

- 1プロセス1node が最も理解しやすい構成
- 複数nodeを1プロセスに収める **Composable Node** はリアルタイムシステムで有効
- node は起動時にパラメータを受け取り、動作を変更できる

```bash
# 実行中の node を確認
ros2 node list

# 特定 node の詳細 (pub/sub/service の一覧)
ros2 node info /turtlesim
```

## 3. topic

**topic** は **pub/sub (非同期)** 通信モデルを提供するチャンネルである。publisher は topic に対してメッセージを送信し、subscriber は受信する。送受信者は互いを知らなくてよい (疎結合)。

### QoS (Quality of Service)

ROS 2 の topic は QoS プロファイルによって通信挙動を制御できる。

| QoS ポリシー | 設定値例 | 用途 |
|---|---|---|
| Reliability | RELIABLE / BEST_EFFORT | センサ速報 vs コマンド |
| Durability | VOLATILE / TRANSIENT_LOCAL | 最新値を後から取得したいか |
| History | KEEP_LAST(N) / KEEP_ALL | バッファ深度 |

```bash
ros2 topic list
ros2 topic echo /turtle1/pose
ros2 topic info /turtle1/cmd_vel --verbose
ros2 topic hz /turtle1/pose
```

## 4. service

**service** は **同期 request/response** 通信である。クライアントがリクエストを送り、サーバが応答を返すまでブロック (またはコールバック待ち) する。短時間で完了する処理に向く。

```bash
ros2 service list
ros2 service call /clear std_srvs/srv/Empty
ros2 service type /spawn
```

- topic と異なり、**応答が保証される** (タイムアウトを設定する場合も多い)
- 処理時間が長い場合は action を使うべき

## 5. action

**action** は **長時間処理 + フィードバック** のための通信パターンである。Goal を送信し、Feedback を受け取りながら、最終的に Result を受け取る。内部的には topic と service の組み合わせで実装されている。

```
Client  --[Goal]-->      Server
Client  <--[Feedback]--  Server  (繰り返し)
Client  <--[Result]--    Server  (完了時)
```

```bash
ros2 action list
ros2 action info /turtle1/rotate_absolute
ros2 action send_goal /turtle1/rotate_absolute \
  turtlesim/action/RotateAbsolute "{theta: 1.57}"
```

- ロボットアームの軌道実行、ナビゲーション移動など「時間のかかる操作」に使う
- **キャンセル (cancel)** も標準サポート

## 6. launch

**launch** ファイルは複数の node を一括起動・設定するための記述ファイルである。ROS 2 では **Python形式** と **XML形式** の両方が使える。

### Python 形式 (推奨)

```python
from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='turtlesim',
            executable='turtlesim_node',
            name='turtlesim',
            parameters=[{'background_r': 0}],
        ),
        Node(
            package='turtlesim',
            executable='turtle_teleop_key',
            name='teleop',
        ),
    ])
```

### XML 形式

```xml
<launch>
  <node pkg="turtlesim" exec="turtlesim_node" name="turtlesim"/>
  <node pkg="turtlesim" exec="turtle_teleop_key" name="teleop"/>
</launch>
```

```bash
ros2 launch turtlesim multisim.launch.py
```

- Python 形式は **条件分岐・引数・インクルード** が柔軟に書ける
- XML 形式は記述が簡潔で CI での可読性が高い
- launch は単なる shell script ではなく、**ROS 2 のライフサイクル管理** に統合されている

## 7. CLI 構造

ROS 2 の CLI は `ros2 <verb> <noun>` の規則的な構造を持つ。

```
ros2 <動詞>   <対象>       [オプション]
ros2 topic    echo         /turtle1/pose
ros2 node     list
ros2 node     info         /turtlesim
ros2 service  call         /clear std_srvs/srv/Empty
ros2 action   send_goal    /turtle1/rotate_absolute ...
ros2 launch   turtlesim    multisim.launch.py
ros2 bag      record       -a
ros2 bag      play         ./my_bag
ros2 param    list         /turtlesim
ros2 param    get          /turtlesim background_r
```

補完は `source /opt/ros/$ROS_DISTRO/setup.bash` の後に Tab キーで有効になる。

## 8. なぜログが評価証跡か

本コースの運用ルール「**動画だけを成果にしない**」の根拠を整理する。

| 証跡の種類 | 再現性 | 定量分析 | 差分確認 | 推奨 |
|---|---|---|---|---|
| 動画 (mp4 など) | 低 (再収録が必要) | 困難 | 不可 | 補助のみ |
| rosbag | 高 (完全再生) | 可能 | 可能 | **主証跡** |
| ログファイル | 高 | 可能 | git diff 可能 | **主証跡** |
| スクリーンショット | 低 | 不可 | 不可 | 補助のみ |

`ros2 bag record -a` で収録した bag ファイルはすべての topic を時系列で保持しており、後から `ros2 bag play` で完全再現できる。また `ros2 bag info` でメッセージ数・頻度を定量確認できる。動画は直感的だが、**何が起きたかをデータとして示せない**。評価者が確認すべきは「動くように見える」ではなく「正しい値が正しい頻度で流れている」である。

## 9. よくある誤解

### 誤解 1: topic は関数呼び出しである

topic の pub/sub は**非同期**であり、publisher はメッセージを投げたあと応答を待たない。subscriber がいなくてもエラーにならない。「関数を呼んで結果を受け取る」処理が必要なら service または action を使う。

### 誤解 2: launch は単なる shell script である

`ros2 launch` は単に複数プロセスを `&` で起動するシェルスクリプトではない。ROS 2 launch フレームワークは以下を担う:
- **パラメータ注入** (`parameters=[...]`)
- **名前空間・リマップ** (`remappings=[...]`)
- **ライフサイクル管理** (起動順序・依存関係)
- **終了時のクリーンアップ** (子プロセスの連鎖終了)

shell script で代替するとこれらが失われ、bag 再生時に環境が再現できなくなる。

## 次のLab

[Lab 1: turtlesim + rosbag](../labs/lab1_turtlesim_rosbag/README.md) で実際に node を起動し、topic を確認して bag を収録・再生する。
