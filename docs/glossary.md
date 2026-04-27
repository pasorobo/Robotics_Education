---
type: guide
id: DOCS-GLOSSARY
title: 英↔日 用語と短い定義
date: 2026-04-27
---

# 英↔日 用語と短い定義

各用語は最低2列 (英語、日本語の短い定義) を持つ。詳細解説は該当 Lecture 本文に置き、ここは検索用の 1-line index に留める。

## ROS 2
| 英 | 日本語の短い定義 |
|---|---|
| `node` | ROS 2 の最小実行単位。1プロセスが1つ以上のnodeを持つ |
| `topic` | 非同期 pub/sub メッセージング |
| `service` | 同期 request/response |
| `action` | 長時間処理 + フィードバック |
| `launch` | 複数ノード起動の宣言ファイル (Python/XML) |
| QoS | Quality of Service。reliability/durability/history |
| TF | 座標変換ツリー (`tf2_ros`) |
| URDF | ロボット記述XML |
| `robot_state_publisher` | URDF + joint state から TF を発行する標準ノード |
| `rosbag2` | ROS 2 公式の記録/再生 |
| `MCAP` | コンテナフォーマット (rosbag2 storage plugin) |

## Frames (空間座標)
| 英 | 日本語の短い定義 |
|---|---|
| `map` | 静的世界座標 |
| `odom` | オドメトリ起点 (連続だがdrift) |
| `base_link` | ロボット本体 |
| `camera_link` | カメラ筐体 |
| `tool0` | エンドエフェクタ取付 |

## MoveIt
| 英 | 日本語の短い定義 |
|---|---|
| planning scene | 環境形状 + ロボット状態の表現 |
| IK | Inverse Kinematics。目標 pose → joint 解 |
| trajectory | 時間付き joint 列 |
| controller | 軌道を駆動系に渡す層 |

## Calibration / Perception
| 英 | 日本語の短い定義 |
|---|---|
| intrinsic | カメラ固有 (焦点距離, 光学中心, 歪み) |
| extrinsic | カメラ↔他フレームの相対 pose |
| hand-eye | カメラ-ハンド (またはbase) 間 calibration |
| ArUco | 既知模様marker |
| reprojection error | calibration 評価値 (px) |

## Safety (UR系)
| 英 | 日本語の短い定義 |
|---|---|
| emergency stop | 非常停止。安全停止カテゴリ1。最終手段 |
| safeguard stop | 防護停止。外部入力。動作再開可 |
| protective stop | 保護停止。コントローラ自己判断 |
| safe no-action | 不確実時に何もしない (Robot Adapter方針) |
| operator confirmation | 人による明示承認 |
| SOP | Standard Operating Procedure |

## Git / GitHub
| 英 | 日本語の短い定義 |
|---|---|
| branch | 作業系列 |
| commit | スナップショット |
| remote | 外部リポジトリ参照 |
| PR (Pull Request) | 取り込み依頼 |
| review | PRへのコメント/承認 |
| fork | 外部repoの自分Copy |
| upstream | fork元 |

## Codex / AI協働
| 英 | 日本語の短い定義 |
|---|---|
| Codex | OpenAI のコード支援AI (ChatGPT Enterprise内で利用) |
| workspace | Enterprise単位の利用空間 |
| GitHub connector | Codex が repo を読む権限 |
| prompt前5項目 | 目的/入力/制約/成功条件/検証コマンド (`tools/codex_prompt_template.md`) |
| 委ねない判断 | Affordance schema、評価指標、安全境界、実機投入可否 |

## WorldCPJ 用語
| 英 | 日本語の短い定義 |
|---|---|
| CT-XX | Capability Topic 番号 (原典 §1) |
| Affordance | 操作可能性 |
| episode_record | 1試行の記録 |
| trial sheet | 試行記録表 |
| Gate Eval | ゲート評価 |
| Sandbox | 各メンバーの個別 GitHub repo (`Sandbox_<name>`) |
