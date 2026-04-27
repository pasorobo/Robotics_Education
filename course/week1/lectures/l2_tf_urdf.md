---
type: lecture
id: W1-L2
title: TF / URDF
week: 1
duration_min: 45
prerequisites: [W1-L1]
worldcpj_ct: [CT-01, CT-02]
roles: [common]
references: [R-01, R-03, R-05]
deliverables: []
---

# TF / URDF

## 目的

ロボット制御で不可欠な**座標変換 (TF)** と**ロボット記述形式 (URDF)** の基礎を理解する。`map` / `odom` / `base_link` / `camera_link` / `tool0` の階層関係を把握し、frame 関連バグを自力でデバッグできる状態にする。

## 1. なぜ座標系の話か

マニピュレーション・ナビゲーション・センサ統合のすべてにおいて、「**どの座標系で表現されているか**」の取り違えは最も頻繁なバグ原因の一つである。典型的な失敗例:

- カメラで検出した物体位置を `camera_link` 座標のまま `base_link` 座標として使ってしまう
- ワールド座標 (`map`) で計画した経路をロボット座標 (`base_link`) として指令してしまう
- 時刻の異なる変換を組み合わせて整合性のない位置推定をしてしまう

TF を正しく理解することは、**frame ambiguity バグを根本から防ぐ**ことに直結する。

## 2. TF とは

TF (Transform Library) は ROS 2 が提供する**座標変換ツリー管理システム**である。

- ロボットを構成するすべての frame を**有向グラフ (ツリー)** として管理する
- 各変換は **時刻スタンプ付き** で記録される (過去の変換を参照可能)
- topic `/tf` に動的変換、`/tf_static` に静的変換が流れる

```
map
 └─ odom
     └─ base_link
         ├─ camera_link
         ├─ lidar_link
         └─ tool0  (マニピュレータの場合)
```

TF ツリーはノード間で**分散して publish** される。`robot_state_publisher` が URDF から関節変換を発行し、`slam_toolbox` や `nav2` が `map→odom` 変換を発行する。

```bash
# TF ツリーを PDF で可視化 (ros-humble-tf2-tools が必要)
ros2 run tf2_tools view_frames
```

## 3. static_transform_publisher

固定した変換 (ロボット上で動かないセンサの取り付け位置など) を宣言するには `static_transform_publisher` を使う。

```bash
# コマンドラインから直接起動
ros2 run tf2_ros static_transform_publisher \
  --x 0.1 --y 0.0 --z 0.3 \
  --roll 0 --pitch 0 --yaw 0 \
  --frame-id base_link \
  --child-frame-id camera_link
```

launch ファイルでの記述:

```python
from launch_ros.actions import Node

Node(
    package='tf2_ros',
    executable='static_transform_publisher',
    arguments=['0.1', '0', '0.3', '0', '0', '0',
               'base_link', 'camera_link'],
)
```

`/tf_static` に一度だけ publish され、新規 subscriber は接続時に自動で受信できる (TRANSIENT_LOCAL QoS)。

## 4. tf2_echo

2つの frame 間の変換をリアルタイムで確認するコマンド。

```bash
ros2 run tf2_ros tf2_echo <parent> <child>

# 例: map から base_link への変換を確認
ros2 run tf2_ros tf2_echo map base_link

# 例: base_link から camera_link への変換を確認
ros2 run tf2_ros tf2_echo base_link camera_link
```

出力例:

```
At time 1714200000.123
- Translation: [0.100, 0.000, 0.300]
- Rotation: in Quaternion [0.000, 0.000, 0.000, 1.000]
```

変換が存在しない場合や TF ツリーが切れている場合はエラーが出るため、**接続確認ツール**としても有効である。

## 5. URDF

**URDF (Unified Robot Description Format)** は XML 形式のロボット記述ファイルである。ロボットのリンク構造・関節・外観・衝突形状・慣性を定義する。

### 主要要素

| 要素 | 役割 |
|---|---|
| `<link>` | ロボットの剛体部品 (リンク) を定義 |
| `<joint>` | 2つのリンクを接続する関節を定義 (fixed/revolute/prismatic など) |
| `<visual>` | rviz 等での表示に使うメッシュや形状 |
| `<collision>` | 衝突判定に使う形状 (通常 visual より単純) |
| `<inertial>` | 質量・慣性テンソル (動力学シミュレーションに必要) |

### 最小構成例

```xml
<?xml version="1.0"?>
<robot name="simple_robot">

  <link name="base_link">
    <visual>
      <geometry><box size="0.3 0.3 0.1"/></geometry>
    </visual>
    <collision>
      <geometry><box size="0.3 0.3 0.1"/></geometry>
    </collision>
    <inertial>
      <mass value="5.0"/>
      <inertia ixx="0.1" iyy="0.1" izz="0.1"
               ixy="0" ixz="0" iyz="0"/>
    </inertial>
  </link>

  <link name="camera_link">
    <visual>
      <geometry><box size="0.05 0.05 0.05"/></geometry>
    </visual>
  </link>

  <joint name="camera_joint" type="fixed">
    <parent link="base_link"/>
    <child link="camera_link"/>
    <origin xyz="0.1 0 0.3" rpy="0 0 0"/>
  </joint>

</robot>
```

```bash
# URDF の構文チェック
check_urdf my_robot.urdf

# xacro (マクロ展開) → URDF に変換してチェック
xacro my_robot.urdf.xacro | check_urdf /dev/stdin
```

## 6. robot_state_publisher

`robot_state_publisher` は **URDF + joint state → TF** の変換を担当する中心的なノードである。

```
URDF (robot_description パラメータ)
        +
/joint_states  (各関節の角度・位置)
        ↓
robot_state_publisher
        ↓
/tf  および  /tf_static
```

```bash
# 起動方法 (launch ファイル内)
Node(
    package='robot_state_publisher',
    executable='robot_state_publisher',
    parameters=[{'robot_description': urdf_content}],
)
```

- `fixed` 関節の変換は `/tf_static` に、可動関節の変換は `/joint_states` の更新に合わせて `/tf` に publish される
- URDF が読み込まれていない場合、TF ツリーが不完全になり **frame not found** エラーが頻発する

## 7. frame 命名 (CC/MS で重要)

本コースで扱うロボットシステムでは、以下の frame 名が標準的な役割を持つ。CC (Collaborative Competition) / MS (Manipulation Showcase) 課題での frame 取り違えを防ぐために覚えること。

| frame 名 | 役割 | publish 元の例 |
|---|---|---|
| `map` | グローバル固定座標系。地図の原点 | `slam_toolbox`, `map_server` |
| `odom` | オドメトリ原点。ドリフトあり、短期的に連続 | `diff_drive_controller` など |
| `base_link` | ロボット本体の基準座標系。ロボットと一体で動く | `robot_state_publisher` |
| `camera_link` | カメラセンサの光学中心または取り付け位置 | `robot_state_publisher` (URDF) |
| `tool0` | マニピュレータの TCP (ツールセンターポイント) | `robot_state_publisher` (URDF) |

### 階層関係

```
map  →  odom  →  base_link  →  camera_link
                              →  tool0
                              →  その他センサ link
```

- `map → odom` : ローカリゼーション結果 (ループクロージャで不連続に補正される)
- `odom → base_link` : オドメトリ積分 (連続だがドリフトあり)
- `base_link → camera_link` : カメラの取り付け変換 (固定)
- `base_link → tool0` : アームの順運動学で計算 (可変)

`tool0` はロボットアーム制御の目標位置指定に使われる。カメラで検出した物体を把持するには `camera_link → tool0` の経路を TF で解決する必要がある。

## 8. よくある誤解

### 誤解 1: `/tf` を直接 publish する

`/tf` は `tf2_ros.TransformBroadcaster` で publish するが、**URDF 管理下のリンクに対して直接 publish するのは誤り**である。`robot_state_publisher` が URDF から自動生成する変換と競合し、TF ツリーが不整合になる。URDF に定義されたリンク間変換は `robot_state_publisher` と `/joint_states` に任せること。

### 誤解 2: static transform に時間を入れる

`static_transform_publisher` が publish する変換は `/tf_static` に流れ、タイムスタンプとして `t=0` が使われる。これは仕様であり、「最新の時刻を入れないとおかしい」と考えて `tf2_ros.StaticTransformBroadcaster` に `rclpy.clock.Clock().now()` を渡すと、新規 subscriber が接続したときに変換を受け取れなくなるケースがある。固定変換には常に `StaticTransformBroadcaster` を使い、時刻は自動に任せること。

## 次のLab

[Lab 2: TF tree](../labs/lab2_tf_tree/README.md) で `static_transform_publisher` を使って frame を追加し、`tf2_echo` と `view_frames` で TF ツリーを可視化する。
