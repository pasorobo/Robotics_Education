---
type: lab
id: W3-Lab6
title: Sim-to-WorldCPJ Schema 設計
week: 3
duration_min: 45
prerequisites: [W3-L6]
worldcpj_ct: [CT-09]
roles: [common]
references: [R-18]
deliverables: [worldcpj_schema_yaml]
---

# Lab 6 — Sim-to-WorldCPJ Provisional Schema 設計

## 目的

Simulator を必要とせず、**WorldCPJ の provisional schema** (8 field 全埋め) を自分の case で設計する。
Sim 環境に依存しない純粋な schema 設計演習であり、SP1 turtlesim / SP2 Panda demo / minimal_robot など
既存の case を素材として使ってよい。

## 前提

- W3-L6 (4-simulator landscape + Sim Bridge の役割) 受講済み
- SP1 / SP2 で自分が扱った robot または simulation の case を 1 つ選択
- Simulator の実行環境は **不要** (schema 設計のみ)

## 手順

### Step 1: template copy

Sandbox に `wk3/lab6/worldcpj_schema.yaml` を作成し、下記の **8 field 雛形** を写経:

```yaml
# WorldCPJ Provisional Schema (W3-Lab6)
# !! すべての field を埋めること。空欄 NG / 未確定は暫定値 OK !!

scene_packet:       # 環境・シーン記述 (Sim world or real world snapshot)
robot_state:        # ロボット現在状態 (joint, pose, velocity 等)
candidate_set:      # 行動候補リスト (planner / policy が生成)
action_intent:      # 選択した行動意図 (why this action)
observation:        # センサ観測値 (camera, lidar, joint encoder 等)
execution_result:   # 実行後の結果 (success / fail + detail)
failure_reason:     # 失敗原因 (execution_result が fail の場合、未発生なら "N/A")
metrics:            # 評価指標 (time, distance, energy 等)
```

### Step 2: 8 field 埋め

自分が選んだ case (推奨: 下記「Sample case」参照) で **8 field すべて** に値を記入。
SP4-5 で確定する WorldCPJ 本物の schema はまだ未確定のため、ここでは **provisional** として設計。

```yaml
# 例: SP1 turtlesim case
scene_packet: "ROS2 turtlesim window, single turtle at (5.5, 5.5), no obstacles"
robot_state: "pose: x=5.5 y=5.5 theta=0.0, velocity: linear=0.0 angular=0.0"
candidate_set: "[move_forward, rotate_left, rotate_right, stop]"
action_intent: "rotate_left を選択: goal 方向 (north) に向くため"
observation: "turtlesim /turtle1/pose topic: x=5.5 y=5.5 theta=0.0"
execution_result: "success: theta が 0.0 → 1.57 に変化"
failure_reason: "N/A"
metrics: "rotation_time: 1.2s, theta_error: 0.01 rad"
```

### Step 3: 埋め方ガイド

- **空欄 NG**: 8 field すべてに何らかの値を記入 (未確定は暫定値・推測値で OK)
- **未確定 OK**: SP4-5 で実際の WorldCPJ schema が確定するまでは provisional 扱い
- **failure_reason**: 失敗が発生しない case は `"N/A"` を明記
- **metrics**: 単位を必ず付記 (例: `2.3s`, `0.5m`, `12J`)

詳細は [HINTS.md](./HINTS.md) を参照。

### Step 4: 全埋め確認

記入完了後、下記コマンドで 8 field がすべて存在するか確認:

```bash
python3 -c "
import yaml, sys
with open('wk3/lab6/worldcpj_schema.yaml') as f:
    d = yaml.safe_load(f)
fields = ['scene_packet','robot_state','candidate_set','action_intent',
          'observation','execution_result','failure_reason','metrics']
missing = [k for k in fields if not d.get(k)]
print('OK' if not missing else f'MISSING: {missing}')
"
```

`OK` が出れば合格条件を満たす。

## Sample case 推奨

| case | SP | 特徴 |
|------|----|------|
| SP1 turtlesim | SP1 | シンプル 2D、誰でも再現可 |
| SP2 Panda demo | SP2 | 7-DOF arm、joint_state 豊富 |
| SP2 minimal_robot | SP2 | URDF 自作、最小構成 |

上記以外の自前 case も歓迎。Sim 実行は不要 — **記憶・ログ・資料** から記述で OK。

## 提出物

mandatory:
- `wk3/lab6/worldcpj_schema.yaml` (Sandbox commit、8 field 全埋め)

## 合格条件

合格条件は [CHECKLIST.md](./CHECKLIST.md) を参照。

## 参照

- R-18: Gazebo Fortress ROS installation (Sim 環境参考)
