---
type: lab
id: W4-Lab7
title: Lab 7 — episode_record 記入演習 (W1 turtlesim bag 再利用)
week: 4
duration_min: 45
prerequisites: [W1-Lab1, W4-L7]
worldcpj_ct: [CT-04, CT-05]
roles: [common, logging]
references: [R-28]
deliverables: [episode_record]
---

# Lab 7 — episode_record 記入演習

## 目的

`episode_record_template` を Sandbox にコピーし、SP1 W1 Lab 1 turtlesim bag を題材に **全 field を記入** することで、bag → episode_record mapping を体得する。

> **重要**: Because this is a **Phase 0 training episode**, it is **not counted as a Q1 CC Gate 0-a trial**. Q1-specific linkage keys (`q1_package_id` / `trial_sheet_id` / `trial_id` / `object_id`) には `not_applicable` または `training_*` を使用すること。

## 前提

- SP1 W1 Lab 1 完了 (sandbox_reference/week1/lab1/ に bag_info.txt 等が存在)
- W4 L7 受講済

## 手順

### Step 1: template を Sandbox にコピー

```bash
mkdir -p ~/sandbox/wk4/lab7
cp course/week4/deliverables/episode_record_template.md ~/sandbox/wk4/lab7/episode_record.md
```

### Step 2: SP1 W1 Lab 1 bag を題材に全 field 記入

`sandbox_reference/week1/lab1/bag_info.txt` を見ながら、`~/sandbox/wk4/lab7/episode_record.md` の YAML body を fill する。

### Step 3: 推奨 fixed values

```yaml
artifact_status: sandbox_example
episode_id: episode_w1_lab1_001
q1_package_id: not_applicable
trial_sheet_id: not_applicable
trial_id: training_trial_w1_lab1_001
object_id: turtlesim_training_object
attempt_index: 1
environment_mode: mock
adapter_version: not_applicable
bridge_schema_version: not_applicable
result: success
failure_reason: none
evidence_path: sandbox_reference/week1/lab1/bag_info.txt
log_path: not_applicable    # raw bag は commit しない
review_status: not_reviewed
```

### Step 4: Sandbox commit (raw bag commit 禁止)

```bash
cd ~/sandbox && git add wk4/lab7/episode_record.md && git commit -m "lab: W4 Lab 7 episode_record fill"
```

## 提出物

- `~/sandbox/wk4/lab7/episode_record.md` (Sandbox 内、Course repo には commit しない)

## 次のLab

→ [Lab 8 — Q1 Reduced Lv1 Execution Package 統合](../lab8_q1_execution_package/README.md)
