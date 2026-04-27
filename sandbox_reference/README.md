---
type: guide
id: SANDBOXREF-README
title: Sandbox Reference (instructor snapshot)
date: 2026-04-27
---

# Sandbox Reference

このディレクトリは **instructor が先に Course を走らせた1スナップショット** です。

> **これは唯一解ではありません。** 学習者は自分の `Sandbox_<name>` repo (本リポジトリの外側) を別に作り、自分の手順でbranch/commit/PRを行ってください。本ディレクトリは行き詰まった時の「お手本の1例」です。

## 構成

- `week1/` — Week 1 (Lab 0/1/2 + 2 templates 記入例)
- `week2/` — SP2で追加
- `week3/` — SP3で追加
- `week4/` — SP4で追加

## 軽量証跡の原則

- bag本体 (`.db3`, `.mcap`, `rosbag2_*/`) はここにも置きません。`.gitignore` で block 済。
- 提出物は `bag_info.txt`, `rosbag_metadata.yaml`, `terminal_*.log`, `frame_inventory.md` などの軽量ファイルのみ。
- 詳細は [CONVENTIONS.md §3](../docs/CONVENTIONS.md) 参照。
