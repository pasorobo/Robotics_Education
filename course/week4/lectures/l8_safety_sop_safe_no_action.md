---
type: lecture
id: W4-L8
title: Lecture 8 — Safety SOP / safe no-action / Phase 0 vs Q1 boundary
week: 4
duration_min: 60
prerequisites: [W2-L4]
worldcpj_ct: [CT-09]
roles: [common, safety]
references: [R-30, R-31, R-32]
deliverables: [safety_checklist]
---

# Lecture 8 — Safety SOP / safe no-action / Phase 0 vs Q1 boundary

## 目的

Safety **SOP** (Standard Operating Procedure) の役割を理解し、**Phase 0 と Q1 の境界** を確定する。W2 L4 で語彙は獲得済、W4 L8 では運用判断と handoff 規約を学ぶ。

[必須 G4 keywords: `Standard Operating Procedure` または `SOP`]

## 1. SOP の役割

SOP は「何を / 誰が / どの順で / どう確認するか」を定めた現場手順書。責任者の明示と現場固有性が肝。

## 2. emergency / safeguard / protective stop の運用区別

W2 L4 で語彙は説明済。本節では運用上の区別を確定する。

- **emergency stop** = `last_resort` / `manual_reset_required` / `not_normal_stop` / `not_auto_resume`。作動後は manual reset + visual assessment + power restore が必要。自動復帰しない。通常停止として使わない。UR public manual: emergency stop is a complementary protective measure, NOT a safeguard. It is not designed to prevent injury. (R-30, R-31)
- **safeguard** = 外部入力 (光カーテン / マット 等) によるトリガ。所定条件クリア後に復旧可。
- **protective stop** = controller 自己判断 (force / position 逸脱等) によるトリガ。所定条件クリア後に復旧可。

[必須 G4 keywords: `emergency stop`, `safeguard`, `protective`, `manual_reset_required` または `manual reset`, `not_normal_stop`, `not_auto_resume`]

## 3. safe no-action

不確実時に **何もしない** のが default。判断不能時の fail-safe ポリシー。Robot Adapter (W2) の方針延長線上にある。

[必須 G4 keywords: `safe no-action`]

## 4. operator confirmation

人による明示承認。大きい動作の前に手動 ack を取る。**operator confirmation は safety review や SOP approval の代替ではない**。承認済み手順の中で特定動作に進む前の明示 ack として使う。

[必須 G4 keywords: `operator confirmation`]

## 5. SOP / safety_checklist / Q1 Package §safety の関係

- **SOP** = 現場手順書 (Q1 W1 開始前に責任者が作成 + review)
- **safety_checklist** = pre-execution 確認表 (Phase 0 では training draft、`phase0_status: training_draft_only`)
- **Q1 Package §safety** = meta plan (両者への参照 + go/no-go 判断)

## 6. Phase 0 と Q1 の Safety 境界

**Phase 0 で扱う**: vocabulary 理解 / SOP draft 読解 / operator + reviewer + `stop_condition` 記入 / 禁止操作明示 / safe no-action default

**Phase 0 で扱わない**: 実 E-stop 機能 / 現場 SOP 承認 / 実機 trial 安全 / emergency drill

## 7. 必須注意文

> UR safety references are used as **instructional examples**. Actual Q1 execution must follow the applicable robot model, site SOP, risk assessment, and responsible safety reviewer decision.

> Phase 0 safety_checklist is **not an approval artifact**. It is a **training draft** + handoff artifact for Q1 safety review.

[必須 G4 keywords: `instructional examples` または `教材上の例`, `not an approval artifact` または `approval artifact ではない`, `training draft`]

## 8. ISO 10218-1/-2:2025 概要

ISO 10218-1:2025 (industrial robots) + ISO 10218-2:2025 (industrial robot applications and robot cells) が産業ロボット安全要求事項を規定する (R-32)。本 Course は overview 引用のみ、原文購入前提。

[必須 G4 keywords: `ISO 10218`]

## 9. よくある誤解

1. emergency stop を通常停止に使う → NG
2. Phase 0 safety_checklist を「実機 OK」と誤認 → NG (training draft + Q1 blocker)
3. operator confirmation は safety review の代わりにならない → NG

## 次のLab

→ [Lab 8 — Q1 Reduced Lv1 Execution Package 統合](../labs/lab8_q1_execution_package/README.md)
