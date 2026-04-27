---
type: lab
id: W2-Lab3
title: RViz Planning (Panda demo)
week: 2
duration_min: 60
prerequisites: [W2-L3]
worldcpj_ct: [CT-06]
roles: [common, adapter]
references: [R-08, R-09, R-11]
deliverables: [planning_evidence]
---

# Lab 3 — RViz Planning (Panda demo)

## 目的

MoveIt 2 Panda demo を RViz で起動し、planning scene / IK / trajectory を **Plan 成功 / Plan 失敗の両方** で体験する。

## 前提

- SP1 setup 完了 (`bash tools/verify_env.sh` PASS または WARN のみ)
- SP2 setup: `sudo apt install ros-humble-moveit ros-humble-moveit-resources-panda-moveit-config` 完了

(SP2 setup 確認: `bash tools/verify_env.sh --week 2` PASS)

## 手順

### Step 1: demo 起動

```bash
source /opt/ros/humble/setup.bash
ros2 launch moveit_resources_panda_moveit_config demo.launch.py
```

RViz が起動し、Panda アームが表示される。Planning タブ (左パネル) を開く。

### Step 2: Plan 成功例

- start state: `<current>` を選ぶ
- goal state: `<random valid>` を選ぶ (joint range 内のランダム pose)
- `Plan` ボタン → 緑線で trajectory が表示される (成功)
- `Plan & Execute` → mock execution、Panda が動いて goal pose に到達

terminal を確認: `move_group` が `Solution found in N seconds` のようなログを出している。これを `planning_evidence.md` に貼付する。

### Step 3: Plan 失敗例

以下のいずれかで失敗を観察する。**(1) または (2)** が最易ルート:

1. **joint limit 外 goal** (推奨、最易)
   - goal state を手動設定 (interactive marker または Joints タブ)
   - 例: `panda_joint1` を `+3.0` (joint limit 超え) にする
   - `Plan` → `MoveIt Failed` または `No motion plan found`
2. **unreachable pose** (推奨)
   - end-effector を床下や腕の物理的届かない pose に設定
   - `Plan` → 失敗
3. **planning timeout** (中級) — `planning_time` を短くして難易度高い pose
4. **collision object 追加** (上級) — `Scene Objects` タブで goal に重なる Box を追加

terminal で `move_group` の失敗ログ (`No motion plan found` 等) を確認し、`planning_evidence.md` に貼付する。

### Step 4: planning_evidence.md を作成し Sandbox に commit

自 Sandbox `wk2/lab3/planning_evidence.md` を作成、内容:

- Plan 成功例の terminal log 抜粋 (5-10 行)
- Plan 失敗例の terminal log 抜粋 (5-10 行)
- planning scene の Mermaid 流れ図 (start_state → planning_scene → IK → trajectory → execute or fail)

詳細フォーマット例: `sandbox_reference/week2/lab3/planning_evidence.md` (instructor 例) を参照。

### Step 5: Sandbox に commit / PR

```bash
git add wk2/lab3/planning_evidence.md
git commit -m "lab: W2 Lab 3 planning evidence"
git push origin <your-branch>
gh pr create --title "wk2-lab3" --body "Plan 成功 + 失敗 各 1 件記録"
```

## 提出物方針

**実走 log (`planning_evidence.md` の terminal log 抜粋) が正**。

RViz スクリーンショットは **任意 / 補助扱い**:
- 1 MB 以下 PNG
- `wk2/lab3/assets/` 配下
- CHECKLIST 合格条件には含めない (CONVENTIONS.md §9 図表方針 + §3.2 commit 対象ルール準拠)

## 合格条件

合格条件は [CHECKLIST.md](./CHECKLIST.md) を参照。

## 参照

- R-08: MoveIt2 Getting Started
- R-09: MoveIt Quickstart in RViz
- R-11: ros2_control Humble docs
