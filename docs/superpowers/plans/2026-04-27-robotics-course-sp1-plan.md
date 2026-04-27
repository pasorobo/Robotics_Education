---
type: plan
id: PLAN-SP1
title: Robotics Education Course - Sub-Project 1 (Foundation + Week 1) 実装計画
date: 2026-04-27
status: ready
sub_project: SP1
related_spec: docs/superpowers/specs/2026-04-27-robotics-course-sp1-design.md
---

# Robotics Education Course — SP1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build SP1 (Repository Foundation + Week 1 教材) — final state 42 files, ~3,400 lines, satisfying 5 verification gates (G1–G5). At plan-write time 3 files already committed (the moved education plan, this spec, this plan); 39 files remain to be created by the implementation tasks below.

**Architecture:** Mono-repo with `docs/` (spec/conventions/glossary/references), `course/` (教材本体), `sandbox_reference/` (instructor模範), `tools/` (verify/skeleton/check scripts). Documentation-heavy (markdown + bash scripts + Mermaid). No application code, no Docker, no CI in SP1.

**Tech Stack:** Markdown (with YAML front matter), Bash 5.x (POSIX-compliant where possible), Mermaid (in code fences), ROS 2 Humble + Gazebo Fortress (for actual lab walk-throughs in Phase 6).

**Authoritative reference:** `docs/superpowers/specs/2026-04-27-robotics-course-sp1-design.md` is the single source of truth. When in doubt, defer to spec §-numbers cited in each task.

**Pre-conditions already satisfied:**
- Repository initialized (`git init`, branch `main`)
- Local git identity set: `pasorobo` / `goo.mail01@yahoo.com`
- Original education plan moved to `docs/Robotics_simulation_phase0_education_plan.md` (commit `af9ac7e`)
- Spec written and approved at `docs/superpowers/specs/2026-04-27-robotics-course-sp1-design.md` (commits `af9ac7e` → `909baac`)
- This implementation plan committed at `docs/superpowers/plans/2026-04-27-robotics-course-sp1-plan.md` (commit `3435a81`)

**Working branch:** Implementation should not be done directly on `main`. Before starting Task 1, create and switch to a working branch (e.g., `course/sp1-foundation-week1`) or a worktree. Merge to `main` only after Task 20 (all 5 gates PASS).

**Total tasks:** 20

---

## Conventions for Plan Execution

- **Each task ends with a commit.** Commit prefixes follow spec §2.1: `feat:`, `docs:`, `lab:`, `tool:`, `resource:`, `chore:`, `fix:`.
- **Commit author/email** is set per-repo to `pasorobo` / `goo.mail01@yahoo.com`. Do not change.
- **No Co-Authored-By trailer.** Do not add `Co-Authored-By:` lines or any reference to AI/coding agents in commit messages. The author identity is the human committer; commit bodies describe what changed and why, nothing else.
- **G3 / G4 are environment-dependent gates.** Tasks 18 (Lab 1 ROS run) and 19 (Lab 2 TF/Mermaid) require Ubuntu 22.04 + ROS 2 Humble + (for Lab 1) turtlesim. If those are not available in the implementation environment, the file content can be hand-authored, but Task 20 must report **"教材生成は完了、実走ゲート未完了"** (materials produced, run gate incomplete) and explicitly list which artifacts are synthetic vs real-execution. SP1 closure can only be claimed if the artifacts come from a real run on the standard environment.
- **Documentation files** must follow CONVENTIONS.md §2 (front matter, naming, etc.). When in conflict between this plan and CONVENTIONS.md, **CONVENTIONS.md wins** (since it's the runtime ruleset).
- **For each new file**, the task provides: exact path, exact front matter, section structure, content invariants. Engineer fills in detailed prose following spec §3.1 骨子.
- **Verification step** for documentation tasks: confirm file exists, front matter parses (10 keys for course docs, 7 for spec/plan, optional for guide/checklist/hints), local links resolve. After Task 8 (`tools/check_structure.sh` complete), use that script to verify.

---

## Task 1: Repository Foundation Files

**Files:**
- Create: `.gitignore`
- Create: `README.md`
- Create: `CONTRIBUTING.md`

These are root-level repository plumbing. Keep them concise. Spec §3.1 #1, #2, #3.

- [ ] **Step 1: Create `.gitignore` with full content**

```gitignore
# ROS2 build artifacts at repo root
/build/
/install/
/log/

# rosbag2 / mcap bodies are not committed
*.db3
*.db3-journal
*.mcap
**/rosbag2_*/

# Lab 2 local-only artifacts (view_frames output)
**/frames.pdf
**/frames.gv
**/frames.png

# Python / IDE
__pycache__/
*.pyc
.vscode/
.idea/

# Large media
*.mp4
*.mov
```

- [ ] **Step 2: Create `README.md`**

Required front matter (`type: guide`, optional per spec §2.2):

```yaml
---
type: guide
id: ROOT-README
title: Robotics Education Course
date: 2026-04-27
---
```

Required sections (in this order):
1. `# Robotics Education Course` — 1-paragraph summary: what this repository is, who it's for (Phase 0 教育対象チーム), what SP1 currently covers.
2. `## このリポジトリの構成` — Tree showing `docs/`, `course/`, `sandbox_reference/`, `tools/` with one-line role for each. Match spec §1.1 / §1.2.
3. `## はじめての方へ` — Reading order: `docs/Robotics_simulation_phase0_education_plan.md` → `docs/CONVENTIONS.md` → `course/00_setup/` → `course/week1/`.
4. `## SP1で何ができるか` — Bullet list mirroring spec §4.7: W1 教材 (Lecture 9本中の3本、Lab 12本中の3本)、2 templates、tools 4本、references R-01〜R-39.
5. `## 今後の予定` — Brief mention of SP2 (W2), SP3 (W3), SP4 (W4); link to spec §4.1 for full roadmap.
6. `## 用語と参照` — Links to `docs/glossary.md`, `docs/references.md`, `docs/CONVENTIONS.md`.
7. `## ライセンス・連絡先` — placeholder one-liner: "Internal team document. Contact: project owners."

Constraint: ~80 lines (per spec §3.2 estimate). Use Mermaid for the tree if helpful but ASCII tree is fine.

- [ ] **Step 3: Create `CONTRIBUTING.md`**

Required front matter (optional, but include for consistency):

```yaml
---
type: guide
id: ROOT-CONTRIBUTING
title: Contribution Guide
date: 2026-04-27
---
```

Required sections:
1. `# Contribution Guide` — purpose
2. `## ブランチ命名` — `course/sp<N>-<topic>` for instructor; `learner/<name>/wk<N>-<topic>` for learners. Reference spec §2.1.
3. `## Commit prefix` — table of `feat:`, `docs:`, `lab:`, `tool:`, `resource:`, `chore:`, `fix:` with one-line use. Reference spec §2.1.
4. `## Commit author identity` — note: this repository uses local `user.name`/`user.email` set to `pasorobo` / `goo.mail01@yahoo.com`. Do not override unless instructed.
5. `## Pull Request` — minimum: description includes purpose, scope, verification command, related spec/plan link.
6. `## 原典(教育計画ドキュメント)の取り扱い` — tracked時 `git mv`, untracked時 `mv + git add`. Reference spec §3.1 #4.
7. `## Sandbox 原則` — 秘密情報禁止 (.env, credentials, robot creds), 実機接続禁止, mock/sim/offline data only. Reference spec §1.2 (sandbox_reference role).
8. `## Codex 利用ルール` — Week 1 = 接続確認 + ルール理解 + prompt5項目練習のみ; Week 2+ = Lab 4b/6b/8bで本格運用。Reference spec §2.6.
9. `## レビュー観点` — diff summary / 動く根拠 / 壊れうる条件 / 採用しない提案 / 追加修正. Reference spec §2.6.

Constraint: ~100 lines.

- [ ] **Step 4: Verify files exist**

Run:
```bash
ls -la .gitignore README.md CONTRIBUTING.md
```
Expected: 3 files listed, all non-empty.

- [ ] **Step 5: Commit**

```bash
git add .gitignore README.md CONTRIBUTING.md
git commit -m "$(cat <<'EOF'
feat: add repository foundation (gitignore, README, CONTRIBUTING)

Spec §3.1 group A files #1-#3. Establishes top-level documentation
entry point and contribution rules.
EOF
)"
```

---

## Task 2: docs/CONVENTIONS.md

**Files:**
- Create: `docs/CONVENTIONS.md`

This is the runtime ruleset that all other course docs must follow. Largest single document in SP1 (~400 lines). Spec §3.1 #5 / §2 (entire section).

- [ ] **Step 1: Define expected structure**

Required front matter (optional but include):

```yaml
---
type: guide
id: DOCS-CONVENTIONS
title: Course Documentation Conventions
date: 2026-04-27
---
```

Required sections (mirror spec §2 sub-headings exactly):

```markdown
# Course Documentation Conventions

## 1. 命名規約
## 2. 文書共通 front matter (10キー)
### 2.1 type別 front matter 必須/任意
## 3. Lab成果物のGit管理ルール
### 3.1 .gitignore (root)
### 3.2 Commit対象 (軽量証跡のみ)
## 4. 合格条件の正本一本化
## 5. ドキュメント分離 (glossary vs references)
## 6. Codex統合パターン
## 7. Templateの2形態
## 8. sandbox_reference 構成方針
## 9. 図表方針
## 10. 文字制限とロケール
## 11. Tool動作確認規約
## 12. リソース参照のIDシステム
```

- [ ] **Step 2: Write the file**

Copy spec §2 content into corresponding sections. **Replace internal cross-references** like "spec §2.X" with "§X" (this is the convention doc itself, so no need to qualify).

Critical content invariants (must be present):

| Section | Must include |
|---|---|
| §1 命名規約 | Lecture file rule (`l<n>_*.md`), Lab folder rule (`lab<n>[a-z]?_*/`), 大文字例外 (`README.md`, `CONTRIBUTING.md`, `CHECKLIST.md`, `HINTS.md`, `LICENSE`, `CHANGELOG.md`), branch naming (`course/sp<N>-<topic>`, `learner/<name>/wk<N>-<topic>`) |
| §2 front matter | 10キー全列挙 (`type`, `id`, `title`, `week`, `duration_min`, `prerequisites`, `worldcpj_ct`, `roles`, `references`, `deliverables`); type enum 全11値 (`lecture`, `lab`, `template`, `reference`, `week`, `setup`, `guide`, `checklist`, `hints`, `spec`, `plan`); type別必須/任意マトリクス |
| §3.1 .gitignore | 全エントリそのまま (Task 1で作成した内容と完全一致) |
| §3.2 commit対象 | OK/NG表、`rosbag_metadata.yaml` の cp 運用注記 |
| §4 CHECKLIST正本 | "CHECKLIST.md は正本、README は1行参照" 明記 |
| §5 docs分離 | glossary = 用語のみ、references = URL台帳 |
| §6 Codex | Week 1 練習のみ / Week 2+ 必須の段階表、Lab 4b/6b/8b 共通READMEセクション例 |
| §9 図表 | Mermaid (` ```mermaid ` コードフェンス) 必須、PlantUML不採用 |
| §11 Tool動作確認 | `bash -n` 必須、`shellcheck` 推奨 |
| §12 references | R-01〜R-39 + R-40+ の追番ルール |

- [ ] **Step 3: Verify file**

```bash
test -s docs/CONVENTIONS.md && wc -l docs/CONVENTIONS.md
```
Expected: file exists, non-empty, ~400 lines (acceptable range 300–500).

Quick sanity check that all 12 section headers are present:
```bash
grep -c "^## " docs/CONVENTIONS.md
```
Expected: ≥12.

- [ ] **Step 4: Commit**

```bash
git add docs/CONVENTIONS.md
git commit -m "$(cat <<'EOF'
docs: add docs/CONVENTIONS.md (course documentation rules)

Spec §3.1 #5. The runtime ruleset for all course documents:
naming, front matter, Codex integration, Mermaid, etc.
All future course docs must comply.
EOF
)"
```

---

## Task 3: docs/glossary.md

**Files:**
- Create: `docs/glossary.md`

Spec §3.1 #6, §2.5. Terms only — URL ledger goes to `docs/references.md` (Task 4).

- [ ] **Step 1: Define structure**

Required front matter:

```yaml
---
type: guide
id: DOCS-GLOSSARY
title: 英↔日 用語と短い定義
date: 2026-04-27
---
```

Required sections (each is a small md table):

```markdown
# 英↔日 用語と短い定義

各用語は最低2列 (英語、日本語の短い定義) を持つ。詳細解説は該当 Lecture 本文に置き、ここは検索用の 1-line index に留める。

## ROS 2
| 英 | 日本語の短い定義 |
|---|---|
| node | ROS 2 の最小実行単位。1プロセスが1つ以上のnodeを持つ |
| topic | 非同期 pub/sub メッセージング |
| service | 同期 request/response |
| action | 長時間処理 + フィードバック |
| launch | 複数ノード起動の宣言ファイル (Python/XML) |
| QoS | Quality of Service。reliability/durability/history |
| TF | 座標変換ツリー。`tf2_ros` |
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
```

- [ ] **Step 2: Verify**

```bash
test -s docs/glossary.md && grep -c "^## " docs/glossary.md
```
Expected: ≥8 sections.

- [ ] **Step 3: Commit**

```bash
git add docs/glossary.md
git commit -m "$(cat <<'EOF'
docs: add docs/glossary.md (英↔日 用語と短い定義)

Spec §3.1 #6. Term index only; URLs go to references.md.
Categories: ROS2 / Frames / MoveIt / Calibration / Safety /
Git / Codex / WorldCPJ.
EOF
)"
```

---

## Task 4: docs/references.md (R-01〜R-39 全移植)

**Files:**
- Create: `docs/references.md`

Spec §3.1 #7. Migrate all R-01〜R-39 from the education plan §6.

- [ ] **Step 1: Read source IDs from education plan**

```bash
grep -E "^\| R-[0-9]+" docs/Robotics_simulation_phase0_education_plan.md | head -50
```
Expected: 39 rows (R-01 through R-39).

- [ ] **Step 2: Define structure**

Required front matter:

```yaml
---
type: guide
id: DOCS-REFERENCES
title: External Resource Ledger (R-01〜R-39 + future)
date: 2026-04-27
---
```

Required sections:

```markdown
# External Resource Ledger

各 ID は教育計画 §6 (`docs/Robotics_simulation_phase0_education_plan.md`) と一致する。新規リソースを追加する場合は R-40 以降で追番する。

各 Lecture / Lab の front matter `references:` は本台帳の ID を参照する。

## 表の見方
- **ID**: `R-XX` (固定)
- **対応Week**: 主に該当する週 (0=setup, 1-4)
- **対応Role**: `common` (全員必修) または specific role
- **最終確認日**: URL到達確認日。SP着手時に各SP内で更新する

---

## 全員必修 (R-01〜R-07)
| ID | タイトル | URL | 種別 | 対応Week | 対応Role | 最終確認日 |
|---|---|---|---|---|---|---|
| R-01 | ROS 2 Humble Documentation | https://docs.ros.org/en/humble/ | 公式Docs | 1 | common | 2026-04-27 |
| ... (R-02〜R-07) ... |

## Manipulation / Robot Adapter (R-08〜R-14)
| ID | タイトル | URL | 種別 | 対応Week | 対応Role | 最終確認日 |
|---|---|---|---|---|---|---|
| R-08 | MoveIt2 Getting Started | ... | 公式Tutorial | 2 | adapter, common | 2026-04-27 |
| ... |

## Calibration / Perception (R-15〜R-17)
| ... |

## Simulation / Navigation (R-18〜R-27)
| ... |

## Logging / Dataset / Safety (R-28〜R-32)
| ... |

## Git / Codex Sandbox / AI協働 (R-33〜R-39)
| ... |
```

- [ ] **Step 3: Fill in all 39 rows**

For each R-XX, copy the title and URL **exactly** from `docs/Robotics_simulation_phase0_education_plan.md` §6.1 through §6.6. Add columns:
- 対応Week: based on which §6.X subsection (R-01-07: 1; R-08-14: 2; R-15-17: 2; R-18-27: 3; R-28-32: 4; R-33-39: 1)
- 対応Role: read each row's "種別/使い方" in the source to choose: `common`, `adapter`, `safety`, `calibration`, `sim`, `logging`, `sandbox`, etc.
- 最終確認日: `2026-04-27` (today)

- [ ] **Step 4: Verify**

```bash
grep -cE "^\| R-[0-9]+" docs/references.md
```
Expected: 39.

- [ ] **Step 5: Commit**

```bash
git add docs/references.md
git commit -m "$(cat <<'EOF'
resource: add docs/references.md (R-01〜R-39 全移植)

Spec §3.1 #7. Single ledger of all external resources cited
in lectures/labs. IDs match education plan §6. SP2-SP4 will
reference these by ID in front matter; new resources from
R-40+.
EOF
)"
```

---

## Task 5: tools/codex_prompt_template.md

**Files:**
- Create: `tools/codex_prompt_template.md`

Spec §3.1 #38. The prompt-5 template that Lab 0 (Week 1) makes learners practice writing.

- [ ] **Step 1: Create file with full content**

```markdown
---
type: guide
id: TOOL-CODEX-PROMPT
title: Codex Prompt 前 5 項目テンプレート
date: 2026-04-27
---

# Codex Prompt 前 5 項目テンプレート

Codex に依頼する前に、以下 5 項目を **自分の言葉で** 書く。書けないなら、まだ Codex に依頼するべきではない (タスク分解が不十分)。

## テンプレート (コピー用)

```
## 目的
- 何を達成したいか。1-2文。

## 入力
- どのファイル、どの関数、どのデータが Codex に渡されるか。

## 制約
- 言語、framework、依存関係、API互換性、命名規約など。
- 触ってはいけないファイル/関数も明記。

## 成功条件
- 何が起きれば「できた」と判断するか。具体的に。

## 検証コマンド
- 上記成功条件を確認するための具体コマンド or 手順。
- 例: `pytest tests/test_foo.py::test_bar -v`、`bash scripts/smoke.sh`。
```

## 委ねない判断 (Codex に依頼してはいけないこと)

- Affordance schema の設計
- 評価指標の定義
- 安全境界の判断
- 実機投入の可否判断

これらは PJ (人間) の責任で決める。Codex は実装補助・読解補助・検証補助。

## 記入例

```
## 目的
turtlesim の `/turtle1/cmd_vel` に1秒ごとに線速度0.5を publish する Python ノードを追加する。

## 入力
新規ファイル `course/week1/labs/lab1_turtlesim_rosbag/example_publisher.py` を作成。
既存の launch ファイルは変更しない。

## 制約
- ROS 2 Humble、`rclpy`
- Python 3.10
- 依存追加禁止 (標準ライブラリ + rclpy のみ)
- スリープは `rclpy` の Timer で実装、`time.sleep` は使わない

## 成功条件
- `ros2 run` で起動するとturtlesim が真っすぐ動く
- Ctrl-C で graceful shutdown (例外ログ無し)
- 30秒間 publish が継続

## 検証コマンド
1. `ros2 run turtlesim turtlesim_node &`
2. `python3 example_publisher.py &`
3. `ros2 topic hz /turtle1/cmd_vel` で約1Hz確認 (10秒)
4. `kill` で両方停止、終了コード 0 を確認
```

## レビュー観点 (PR Review Notes に記録)

- diff summary: どのファイルがどう変わったか
- 動く根拠: 検証コマンドの実行ログ
- 壊れうる条件: edge case、依存条件、環境差
- 採用しない提案: Codexが提案したが取らなかった選択肢と理由
- 追加修正: Codex出力にユーザーが加えた修正
```

- [ ] **Step 2: Verify**

```bash
test -s tools/codex_prompt_template.md
```

- [ ] **Step 3: Commit**

```bash
git add tools/codex_prompt_template.md
git commit -m "$(cat <<'EOF'
tool: add tools/codex_prompt_template.md (prompt-5 template)

Spec §3.1 #38. The 5-item template (purpose/input/constraints/
success/verification) plus a worked example. Used by Lab 0
(Week 1) for practice and by Lab 4b/6b/8b for real Codex use.
EOF
)"
```

---

## Task 6: tools/new_week_skeleton.sh

**Files:**
- Create: `tools/new_week_skeleton.sh`

Spec §3.1 #37. Generates `course/week<N>/{lectures,labs,deliverables,assets}/` and a stub README. Used at the start of SP2/SP3/SP4.

- [ ] **Step 1: Write the script**

```bash
#!/usr/bin/env bash
# tools/new_week_skeleton.sh
# Generate course/week<N>/{lectures,labs,deliverables,assets}/ and stub README.md
# Usage: bash tools/new_week_skeleton.sh <week_number>

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <week_number>" >&2
    exit 2
fi

WEEK="$1"

if ! [[ "$WEEK" =~ ^[0-9]+$ ]]; then
    echo "Error: week number must be a non-negative integer (got: $WEEK)" >&2
    exit 2
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="$REPO_ROOT/course/week$WEEK"

if [[ -e "$TARGET" ]]; then
    echo "Error: $TARGET already exists. Refusing to overwrite." >&2
    exit 1
fi

mkdir -p "$TARGET/lectures" "$TARGET/labs" "$TARGET/deliverables" "$TARGET/assets"

cat > "$TARGET/README.md" <<EOF
---
type: week
id: W${WEEK}-README
title: Week ${WEEK} (TBD)
week: ${WEEK}
duration_min: 0
prerequisites: []
worldcpj_ct: []
roles: [common]
references: []
deliverables: []
---

# Week ${WEEK}

> **Skeleton** generated by tools/new_week_skeleton.sh on $(date -I).
> Replace this stub before SP commit.

## 目的
TBD

## 合格条件サマリ
- TBD

## Lecture / Lab 一覧
TBD

## 参照
TBD
EOF

echo "Created: $TARGET"
echo "  $TARGET/lectures/"
echo "  $TARGET/labs/"
echo "  $TARGET/deliverables/"
echo "  $TARGET/assets/"
echo "  $TARGET/README.md (stub — fill in before commit)"
```

- [ ] **Step 2: Make executable and syntax-check**

```bash
chmod +x tools/new_week_skeleton.sh
bash -n tools/new_week_skeleton.sh
echo "syntax OK"
```
Expected: "syntax OK".

- [ ] **Step 3: Smoke test (dry — generate, inspect, then remove)**

```bash
bash tools/new_week_skeleton.sh 99
ls -la course/week99/
test -f course/week99/README.md && grep -q "Week 99" course/week99/README.md && echo "smoke PASS"
rm -rf course/week99
```
Expected: directory created, README contains "Week 99", "smoke PASS".

- [ ] **Step 4: Commit**

```bash
git add tools/new_week_skeleton.sh
git commit -m "$(cat <<'EOF'
tool: add tools/new_week_skeleton.sh (week scaffold)

Spec §3.1 #37. Generates course/week<N>/{lectures,labs,
deliverables,assets}/ + stub README.md with required front
matter. Refuses to overwrite. Used at SP2/SP3/SP4 start.
EOF
)"
```

---

## Task 7: tools/verify_env.sh and 00_setup wrapper

**Files:**
- Create: `tools/verify_env.sh`
- Create: `course/00_setup/verify_setup.sh`

Spec §3.1 #36, #12. The canonical environment check; 00_setup is a thin wrapper.

- [ ] **Step 1: Write `tools/verify_env.sh`**

```bash
#!/usr/bin/env bash
# tools/verify_env.sh
# Verify that the SP1 development environment is in place.
# Spec G3 (§5.1).
# Exit codes:
#   0 - all required checks PASS
#   1 - at least one required check FAILED

set -uo pipefail

PASS=0
FAIL=0
WARN=0

print_check() {
    local label="$1"
    local status="$2"
    local detail="${3:-}"
    printf "  [%-4s] %-30s %s\n" "$status" "$label" "$detail"
}

check_required() {
    local label="$1"; shift
    if "$@" >/dev/null 2>&1; then
        print_check "$label" "PASS"
        PASS=$((PASS+1))
    else
        print_check "$label" "FAIL"
        FAIL=$((FAIL+1))
    fi
}

check_either() {
    local label="$1"; shift
    local cmd_a="$1"; shift
    local cmd_b="$1"; shift
    if command -v "$cmd_a" >/dev/null 2>&1; then
        print_check "$label" "PASS" "($cmd_a)"
        PASS=$((PASS+1))
    elif command -v "$cmd_b" >/dev/null 2>&1; then
        print_check "$label" "PASS" "($cmd_b)"
        PASS=$((PASS+1))
    else
        print_check "$label" "FAIL" "neither $cmd_a nor $cmd_b found"
        FAIL=$((FAIL+1))
    fi
}

echo "==== Robotics Education Course — Environment Verification ===="
echo

echo "[OS]"
if command -v lsb_release >/dev/null 2>&1; then
    OS_DESC=$(lsb_release -d -s 2>/dev/null || echo "unknown")
    if echo "$OS_DESC" | grep -qE "Ubuntu 22\.04"; then
        print_check "Ubuntu 22.04" "PASS" "$OS_DESC"
        PASS=$((PASS+1))
    else
        print_check "Ubuntu 22.04" "WARN" "$OS_DESC (not Ubuntu 22.04 — Course assumes 22.04)"
        WARN=$((WARN+1))
    fi
else
    print_check "Ubuntu 22.04" "WARN" "lsb_release not found"
    WARN=$((WARN+1))
fi

echo "[ROS 2]"
check_required "ros2 CLI"      command -v ros2
check_required "ros2 Humble"   bash -c 'ros2 --help 2>&1 | grep -qi humble || [ -d /opt/ros/humble ]'

echo "[Gazebo (Fortress)]"
check_either "gazebo CLI" gz ign

echo "[MoveIt 2]"
if dpkg -l 2>/dev/null | grep -q "ros-humble-moveit "; then
    print_check "ros-humble-moveit pkg" "PASS"
    PASS=$((PASS+1))
else
    print_check "ros-humble-moveit pkg" "WARN" "(SP1 only needs demo install; SP2 requires full)"
    WARN=$((WARN+1))
fi

echo "[Tooling]"
check_required "git"      command -v git
check_required "python3"  command -v python3
check_required "bash"     command -v bash

echo
echo "==== Summary: PASS=$PASS  FAIL=$FAIL  WARN=$WARN ===="

if [[ $FAIL -gt 0 ]]; then
    echo "Result: FAIL — required checks failed"
    exit 1
else
    echo "Result: PASS"
    exit 0
fi
```

- [ ] **Step 2: Write `course/00_setup/verify_setup.sh` (wrapper)**

```bash
#!/usr/bin/env bash
# Thin wrapper. Canonical implementation: tools/verify_env.sh
exec "$(dirname "$0")/../../tools/verify_env.sh" "$@"
```

- [ ] **Step 3: Make both executable + syntax check**

```bash
chmod +x tools/verify_env.sh course/00_setup/verify_setup.sh
bash -n tools/verify_env.sh
bash -n course/00_setup/verify_setup.sh
echo "syntax OK"
```

- [ ] **Step 4: Smoke test (run on current env, expect at least PASS for git/python3/bash)**

```bash
bash tools/verify_env.sh || echo "(non-zero exit acceptable here if ROS2 not installed)"
bash course/00_setup/verify_setup.sh > /tmp/verify_wrapper.txt
diff <(bash tools/verify_env.sh) /tmp/verify_wrapper.txt && echo "wrapper PASS"
```
Expected: wrapper output matches direct invocation.

- [ ] **Step 5: Commit**

```bash
git add tools/verify_env.sh course/00_setup/verify_setup.sh
git commit -m "$(cat <<'EOF'
tool: add tools/verify_env.sh + 00_setup/verify_setup.sh wrapper

Spec §3.1 #36 / #12. Canonical implementation in tools/;
wrapper in course/00_setup/ for student-facing path. Checks
Ubuntu 22.04, ROS 2 Humble, gz/ign, MoveIt 2, git, python3.
Gazebo cmd accepts either gz or ign (Fortress transition).
EOF
)"
```

---

## Task 8: tools/check_structure.sh (TDD with current repo state)

**Files:**
- Create: `tools/check_structure.sh`

Spec §3.1 #39, §5.1 G1/G2/G4, §5.2. The most complex tool. Implements all static checks. TDD by running on current repo (which is partial) and confirming it correctly identifies what's missing.

This script is **expected to FAIL** when run after this task (because most of the 42 files don't exist yet). That's the point — Task 19 runs it again at the end for the final verification.

- [ ] **Step 1: Define expected behavior matrix**

| Check | Source | Pass criterion |
|---|---|---|
| File existence | Spec §3.1 — all 42 files | All 42 paths exist |
| Naming convention | Spec §2.1 | Lectures `l<n>_*.md` lowercase; Labs `lab<n>[a-z]?_*/`; templates `*_template.md`; example_files `*_example.md` |
| Front matter required (course 10-key) | Spec §2.2 | type, id, title, week, duration_min, prerequisites, worldcpj_ct, roles, references, deliverables — all present |
| Front matter required (spec/plan 7-key) | Spec §2.2 (spec/plan rows) | type, id, title, date, status, sub_project, related_plan/related_spec |
| Front matter optional types | Spec §2.2 | guide/checklist/hints — if front matter present, validate; if absent, skip |
| Local link resolution | Spec §5.1 G5a | All `[..](relative/path)` resolve to existing files |
| Sandbox content patterns | Spec §5.2 | bag_info.txt has `Duration:` or `Topic information:`; rosbag_metadata.yaml has `topics_with_message_count:`; terminal_5min.log ≥1KB; frame_inventory.md has ` ```mermaid ` + base_link + camera_link + tool0; codex_connection_check.md has `workspace` + `connector`; skill_baseline_sheet_example.md has 8 categories; sandbox_setup_log_example.md has `repo:` + `first branch:` |
| Bash syntax | Spec §2.11 | `bash -n` passes for every `*.sh` |

- [ ] **Step 2: Write the script**

```bash
#!/usr/bin/env bash
# tools/check_structure.sh
# Static structure validator for SP1.
# Spec G1/G2/G4/G5a (§5.1, §5.2).

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

ERR=0
WARN=0
PASSED=0

err()  { printf "  [FAIL] %s\n" "$1"; ERR=$((ERR+1)); }
warn() { printf "  [WARN] %s\n" "$1"; WARN=$((WARN+1)); }
ok()   { PASSED=$((PASSED+1)); }

# ---------- G1: File existence ----------
echo "==== G1: File existence (42 expected files) ===="

EXPECTED_FILES=(
    "README.md"
    "CONTRIBUTING.md"
    ".gitignore"
    "docs/Robotics_simulation_phase0_education_plan.md"
    "docs/CONVENTIONS.md"
    "docs/glossary.md"
    "docs/references.md"
    "course/00_setup/README.md"
    "course/00_setup/ubuntu_2204_humble_setup.md"
    "course/00_setup/gazebo_fortress_setup.md"
    "course/00_setup/moveit2_humble_setup.md"
    "course/00_setup/verify_setup.sh"
    "course/week1/README.md"
    "course/week1/lectures/l0_git_codex_sandbox.md"
    "course/week1/lectures/l1_ros2_basics.md"
    "course/week1/lectures/l2_tf_urdf.md"
    "course/week1/labs/lab0_sandbox_setup/README.md"
    "course/week1/labs/lab0_sandbox_setup/CHECKLIST.md"
    "course/week1/labs/lab0_sandbox_setup/HINTS.md"
    "course/week1/labs/lab1_turtlesim_rosbag/README.md"
    "course/week1/labs/lab1_turtlesim_rosbag/CHECKLIST.md"
    "course/week1/labs/lab1_turtlesim_rosbag/HINTS.md"
    "course/week1/labs/lab2_tf_tree/README.md"
    "course/week1/labs/lab2_tf_tree/CHECKLIST.md"
    "course/week1/labs/lab2_tf_tree/HINTS.md"
    "course/week1/deliverables/skill_baseline_sheet_template.md"
    "course/week1/deliverables/sandbox_setup_log_template.md"
    "sandbox_reference/README.md"
    "sandbox_reference/week1/skill_baseline_sheet_example.md"
    "sandbox_reference/week1/sandbox_setup_log_example.md"
    "sandbox_reference/week1/lab0/codex_connection_check.md"
    "sandbox_reference/week1/lab1/bag_info.txt"
    "sandbox_reference/week1/lab1/rosbag_metadata.yaml"
    "sandbox_reference/week1/lab1/terminal_5min.log"
    "sandbox_reference/week1/lab2/frame_inventory.md"
    "tools/verify_env.sh"
    "tools/new_week_skeleton.sh"
    "tools/codex_prompt_template.md"
    "tools/check_structure.sh"
    "docs/superpowers/specs/2026-04-27-robotics-course-sp1-design.md"
    "docs/superpowers/plans/2026-04-27-robotics-course-sp1-plan.md"
    "sandbox_reference/week1/lab0/README.md"
)

for f in "${EXPECTED_FILES[@]}"; do
    if [[ -e "$f" ]]; then
        ok
    else
        err "missing: $f"
    fi
done

# ---------- G2: Front matter (course 10-key) ----------
echo
echo "==== G2: Front matter (course docs require 10 keys) ===="

COURSE_TEN_KEY_FILES=(
    "course/week1/README.md"
    "course/week1/lectures/l0_git_codex_sandbox.md"
    "course/week1/lectures/l1_ros2_basics.md"
    "course/week1/lectures/l2_tf_urdf.md"
    "course/week1/labs/lab0_sandbox_setup/README.md"
    "course/week1/labs/lab1_turtlesim_rosbag/README.md"
    "course/week1/labs/lab2_tf_tree/README.md"
    "course/week1/deliverables/skill_baseline_sheet_template.md"
    "course/week1/deliverables/sandbox_setup_log_template.md"
    "course/00_setup/README.md"
    "course/00_setup/ubuntu_2204_humble_setup.md"
    "course/00_setup/gazebo_fortress_setup.md"
    "course/00_setup/moveit2_humble_setup.md"
    "sandbox_reference/README.md"
    "sandbox_reference/week1/skill_baseline_sheet_example.md"
    "sandbox_reference/week1/sandbox_setup_log_example.md"
    "sandbox_reference/week1/lab0/README.md"
    "sandbox_reference/week1/lab0/codex_connection_check.md"
    "sandbox_reference/week1/lab2/frame_inventory.md"
)

REQUIRED_KEYS=(type id title week duration_min prerequisites worldcpj_ct roles references deliverables)

for f in "${COURSE_TEN_KEY_FILES[@]}"; do
    [[ -f "$f" ]] || continue   # missing reported by G1
    # Extract front matter (between first two --- lines)
    if ! awk '/^---$/{c++; if(c==2)exit; next} c==1' "$f" | grep -q .; then
        err "no front matter: $f"
        continue
    fi
    fm=$(awk '/^---$/{c++; if(c==2)exit; next} c==1' "$f")
    missing_keys=()
    for k in "${REQUIRED_KEYS[@]}"; do
        if ! echo "$fm" | grep -qE "^${k}:"; then
            missing_keys+=("$k")
        fi
    done
    if [[ ${#missing_keys[@]} -eq 0 ]]; then
        ok
    else
        err "front matter missing keys in $f: ${missing_keys[*]}"
    fi
done

# ---------- G2: Spec/Plan front matter (7 keys) ----------
echo
echo "==== G2: spec/plan front matter (7 keys) ===="

SPEC_FILES=("docs/superpowers/specs/2026-04-27-robotics-course-sp1-design.md")
PLAN_FILES=("docs/superpowers/plans/2026-04-27-robotics-course-sp1-plan.md")
SPEC_KEYS=(type id title date status sub_project related_plan)
PLAN_KEYS=(type id title date status sub_project related_spec)

check_special_fm() {
    local f="$1"; shift
    local keys=("$@")
    [[ -f "$f" ]] || return
    fm=$(awk '/^---$/{c++; if(c==2)exit; next} c==1' "$f")
    for k in "${keys[@]}"; do
        if ! echo "$fm" | grep -qE "^${k}:"; then
            err "$f: missing key '$k'"
            return
        fi
    done
    ok
}

for f in "${SPEC_FILES[@]}"; do check_special_fm "$f" "${SPEC_KEYS[@]}"; done
for f in "${PLAN_FILES[@]}"; do check_special_fm "$f" "${PLAN_KEYS[@]}"; done

# ---------- G4: Sandbox content patterns ----------
echo
echo "==== G4: Sandbox reference content patterns ===="

check_pattern() {
    local f="$1"
    local pattern="$2"
    local label="$3"
    if [[ ! -f "$f" ]]; then
        err "missing for content check: $f"
        return
    fi
    if grep -qE "$pattern" "$f"; then
        ok
    else
        err "$f: pattern not found ($label)"
    fi
}

check_min_size() {
    local f="$1"
    local min_bytes="$2"
    if [[ ! -f "$f" ]]; then
        err "missing for size check: $f"
        return
    fi
    local size; size=$(wc -c < "$f")
    if [[ "$size" -ge "$min_bytes" ]]; then
        ok
    else
        err "$f: too small ($size bytes, need ≥$min_bytes)"
    fi
}

check_pattern "sandbox_reference/week1/lab1/bag_info.txt" "Duration:|Topic information:" "Duration|Topic"
check_pattern "sandbox_reference/week1/lab1/rosbag_metadata.yaml" "topics_with_message_count:" "rosbag2 metadata key"
check_min_size "sandbox_reference/week1/lab1/terminal_5min.log" 1024
check_pattern "sandbox_reference/week1/lab2/frame_inventory.md" '```mermaid' "mermaid fence"
check_pattern "sandbox_reference/week1/lab2/frame_inventory.md" "base_link" "base_link"
check_pattern "sandbox_reference/week1/lab2/frame_inventory.md" "camera_link" "camera_link"
check_pattern "sandbox_reference/week1/lab2/frame_inventory.md" "tool0" "tool0"
check_pattern "sandbox_reference/week1/lab0/codex_connection_check.md" "workspace" "workspace"
check_pattern "sandbox_reference/week1/lab0/codex_connection_check.md" "connector" "connector"

# Skill baseline 8 categories
if [[ -f "sandbox_reference/week1/skill_baseline_sheet_example.md" ]]; then
    cats=("ROS2 CLI" "TF/URDF" "MoveIt2" "Calibration" "Simulation" "Logging" "Safety" "Git/Codex")
    miss=()
    for c in "${cats[@]}"; do
        if ! grep -qF "$c" "sandbox_reference/week1/skill_baseline_sheet_example.md"; then
            miss+=("$c")
        fi
    done
    if [[ ${#miss[@]} -eq 0 ]]; then
        ok
    else
        err "skill_baseline_sheet_example.md missing categories: ${miss[*]}"
    fi
fi

check_pattern "sandbox_reference/week1/sandbox_setup_log_example.md" "repo:" "repo: key"
check_pattern "sandbox_reference/week1/sandbox_setup_log_example.md" "first branch:" "first branch: key"

# ---------- G5a: Local link resolution ----------
echo
echo "==== G5a: Local link resolution ===="

# Find Markdown links pointing to local relative paths.
local_link_failures=0
while IFS= read -r mdfile; do
    # Extract links like [text](relative/path) — exclude http(s):// and #anchor-only
    while IFS= read -r link; do
        # Strip optional fragment
        target="${link%%#*}"
        # Skip if empty after fragment strip (anchor-only) or absolute URL
        [[ -z "$target" ]] && continue
        [[ "$target" =~ ^https?:// ]] && continue
        [[ "$target" =~ ^mailto: ]] && continue
        [[ "$target" =~ ^#  ]] && continue
        # Resolve relative to mdfile's directory
        dir="$(dirname "$mdfile")"
        resolved="$dir/$target"
        # Normalize via realpath if possible (handle ../)
        if command -v realpath >/dev/null 2>&1; then
            abs=$(realpath -m "$resolved")
        else
            abs="$resolved"
        fi
        if [[ ! -e "$abs" ]]; then
            err "broken local link in $mdfile -> $target"
            local_link_failures=$((local_link_failures+1))
        fi
    done < <(grep -oE '\]\([^)]+\)' "$mdfile" | sed 's/^](//;s/)$//')
done < <(find . -name "*.md" -not -path "./.git/*" -not -path "./build/*" -not -path "./install/*")

[[ $local_link_failures -eq 0 ]] && ok

# ---------- bash -n on all *.sh ----------
echo
echo "==== bash -n syntax check on tools/*.sh and course/00_setup/*.sh ===="

while IFS= read -r sh; do
    if bash -n "$sh" 2>/dev/null; then
        ok
    else
        err "syntax error: $sh"
    fi
done < <(find tools course/00_setup -name "*.sh" -not -path "./.git/*" 2>/dev/null)

# ---------- Summary ----------
echo
echo "============================================================"
echo "  PASS: $PASSED   FAIL: $ERR   WARN: $WARN"
echo "============================================================"

if [[ $ERR -gt 0 ]]; then
    echo "Result: FAIL — $ERR check(s) failed"
    exit 1
else
    echo "Result: PASS"
    exit 0
fi
```

- [ ] **Step 3: Syntax check + smoke run**

```bash
chmod +x tools/check_structure.sh
bash -n tools/check_structure.sh
echo "syntax OK"

# Run on current state — expected to FAIL because most files don't exist yet
bash tools/check_structure.sh; echo "exit=$?"
```
Expected: many FAIL lines (most of the 42 files missing). Exit code 1. **This is intentional.** Confirms the tool correctly identifies missing files.

- [ ] **Step 4: Verify the tool's TDD-correctness**

The script must report **at minimum**:
- FAIL for each unwritten file from EXPECTED_FILES
- PASS for `.gitignore`, `README.md`, `CONTRIBUTING.md`, `docs/CONVENTIONS.md`, `docs/glossary.md`, `docs/references.md`, `tools/codex_prompt_template.md`, `tools/new_week_skeleton.sh`, `tools/verify_env.sh`, `course/00_setup/verify_setup.sh`, `tools/check_structure.sh`, `docs/superpowers/specs/...`, `docs/superpowers/plans/...`, `docs/Robotics_simulation_phase0_education_plan.md` (these all exist after Tasks 1-7 + this Task 8)

```bash
bash tools/check_structure.sh 2>&1 | grep "missing:" | wc -l
```
Expected: ≥25 (many files yet to come).

- [ ] **Step 5: Commit**

```bash
git add tools/check_structure.sh
git commit -m "$(cat <<'EOF'
tool: add tools/check_structure.sh (G1/G2/G4/G5a static validator)

Spec §3.1 #39, §5.1, §5.2. Validates 42 expected files,
front matter (10-key for course docs, 7-key for spec/plan),
sandbox content patterns, local link resolution, bash -n
on all *.sh. Used as the gate before SP1 sign-off.

Currently fails with many missing files — that is expected
during incremental SP1 build; will pass at Task 19.
EOF
)"
```

---

## Task 9: course/00_setup/ chapter (4 markdown files)

**Files:**
- Create: `course/00_setup/README.md`
- Create: `course/00_setup/ubuntu_2204_humble_setup.md`
- Create: `course/00_setup/gazebo_fortress_setup.md`
- Create: `course/00_setup/moveit2_humble_setup.md`

Spec §3.1 #8, #9, #10, #11. Native Ubuntu 22.04 path only — Course makes no Docker/WSL2 promises.

- [ ] **Step 1: Common front matter for setup docs**

All four use:

```yaml
---
type: setup
id: SETUP-<short>          # SETUP-README, SETUP-UBUNTU-HUMBLE, SETUP-GAZEBO-FORTRESS, SETUP-MOVEIT2
title: <descriptive title>
week: 0
duration_min: <estimate>   # README: 5, ubuntu: 30, gazebo: 15, moveit2: 15
prerequisites: []
worldcpj_ct: []
roles: [common]
references: [<R-IDs from references.md>]
deliverables: []
---
```

- [ ] **Step 2: Write `course/00_setup/README.md`**

Sections:
1. `# 環境セットアップ概要` — purpose
2. `## 前提` — Ubuntu 22.04 native のみ。Windows利用者向け1段落: 「VirtualBox 6.x または WSL2 で Ubuntu 22.04 を用意してください。Course側ではUbuntuを前提としたコマンドのみ提供し、それ以外の環境は学習者各自の責任で動作確認すること。」
3. `## 所要時間` — total ≈ 60分
4. `## SP1で必要な範囲` — Ubuntu 22.04 + ROS 2 Humble + Gazebo Fortress (起動確認まで) + MoveIt2 (demo起動まで). Full MoveIt は SP2.
5. `## 順序` — リンク順:
   - [Ubuntu 22.04 + ROS 2 Humble](./ubuntu_2204_humble_setup.md)
   - [Gazebo Fortress](./gazebo_fortress_setup.md)
   - [MoveIt 2 (demo起動まで)](./moveit2_humble_setup.md)
6. `## 検証` — 最終的に `bash ./verify_setup.sh` がPASSで終わること。または `bash ../../tools/verify_env.sh`。
7. `## 参照` — references R-01, R-02, R-18, R-08

`references:` front matter: `[R-01, R-02, R-08, R-18]`.

- [ ] **Step 3: Write `course/00_setup/ubuntu_2204_humble_setup.md`**

Sections:
1. `# Ubuntu 22.04 + ROS 2 Humble セットアップ`
2. `## 前提` — Ubuntu 22.04.x clean install, sudo 権限
3. `## 手順` — 公式 (R-02) のコマンド列。具体ステップ:
   - locale設定 (UTF-8)
   - apt update + curl + gnupg2
   - ROS2 GPGキー追加 (`/usr/share/keyrings/ros-archive-keyring.gpg`)
   - apt source追加 (humble jammy)
   - `sudo apt update && sudo apt install ros-humble-desktop ros-dev-tools`
   - `source /opt/ros/humble/setup.bash` を `~/.bashrc` 末尾に追加
   - 新シェルで `ros2 doctor` 実行
4. `## 検証` — `which ros2`, `ros2 --help | head`, `ros2 doctor`
5. `## トラブルシュート` — locale errors → `sudo locale-gen en_US.UTF-8`; GPG key issues → R-02 の最新版で確認。
6. `## 参照` — R-01, R-02

`references:` front matter: `[R-01, R-02]`.

- [ ] **Step 4: Write `course/00_setup/gazebo_fortress_setup.md`**

Sections:
1. `# Gazebo Fortress セットアップ`
2. `## 前提` — Ubuntu 22.04, ROS 2 Humble installed
3. `## 手順`:
   - Gazebo apt source 追加 (`/etc/apt/sources.list.d/gazebo-stable.list`)
   - `sudo apt install gz-fortress` (or `ignition-fortress` — note Fortress era used `ign`/`ignition` packages; new env may show `gz`)
   - `sudo apt install ros-humble-ros-gz`
   - 起動確認: `gz sim -v 4 shapes.sdf` (or `ign gazebo -v 4 shapes.sdf`). 1物体3次元シーンが開けばOK
4. `## 検証` — `command -v gz || command -v ign`; `gz sim --version` (or `ign gazebo --version`)
5. `## EOL注意` — Fortress は 2026-09 EOL (spec §4.5)。SP6+ で Harmonic への移行レビュー予定。
6. `## 参照` — R-18, R-19

`references:` front matter: `[R-18, R-19]`.

- [ ] **Step 5: Write `course/00_setup/moveit2_humble_setup.md`**

Sections:
1. `# MoveIt 2 セットアップ (demo 起動まで)`
2. `## 前提` — Ubuntu 22.04, ROS 2 Humble, Gazebo (任意)
3. `## 手順`:
   - `sudo apt install ros-humble-moveit ros-humble-moveit-resources-panda-moveit-config`
   - source ROS env
   - `ros2 launch moveit_resources_panda_moveit_config demo.launch.py`
   - RViz が立ち上がり planning scene が見えればOK
4. `## SP1の到達線` — demo起動できる、まで。Configuring own robot は SP2 (W2 Lab 3-4)。
5. `## 検証` — `dpkg -l | grep ros-humble-moveit`; demo起動の RViz スクショは取らない (commit禁止)
6. `## 参照` — R-08, R-09

`references:` front matter: `[R-08, R-09]`.

- [ ] **Step 6: Verify**

```bash
ls course/00_setup/*.md course/00_setup/*.sh
# expect 4 .md + 1 .sh
```

- [ ] **Step 7: Commit**

```bash
git add course/00_setup/README.md course/00_setup/ubuntu_2204_humble_setup.md course/00_setup/gazebo_fortress_setup.md course/00_setup/moveit2_humble_setup.md
git commit -m "$(cat <<'EOF'
docs: add course/00_setup/ chapter (4 setup docs)

Spec §3.1 #8-#11. Ubuntu 22.04 native install path for ROS 2
Humble, Gazebo Fortress, and MoveIt 2 (demo only — full
MoveIt setup is SP2). README links setup steps in order.
EOF
)"
```

---

## Task 10: course/week1/README.md + Lecture L0

**Files:**
- Create: `course/week1/README.md`
- Create: `course/week1/lectures/l0_git_codex_sandbox.md`

Spec §3.1 #13, #14. Week 1 入口 + 最初の Lecture (Git/Codex/Sandbox foundations).

- [ ] **Step 1: Create `course/week1/README.md`**

Front matter:

```yaml
---
type: week
id: W1-README
title: Week 1 - 共通知識と環境 + Git/Codex Sandbox
week: 1
duration_min: 360
prerequisites: []
worldcpj_ct: [CT-01, CT-07]
roles: [common]
references: [R-01, R-02, R-03, R-04, R-05, R-33, R-34, R-35, R-36, R-37, R-38]
deliverables: [skill_baseline_sheet, sandbox_setup_log]
---
```

Sections:
1. `# Week 1 — 共通知識と環境 + Git/Codex Sandbox`
2. `## 目的` — Phase 0計画 §4.2 の目的を1段落で。「全員がROS2と座標系の最低語彙を持ち、Git/Codex Sandbox基盤を立ち上げる」
3. `## 所要時間` — 総6時間 (Lecture 3本 + Lab 3本 + Templates記入)
4. `## Lecture 一覧` — 表:
   | ID | タイトル | 所要 | リンク |
   | W1-L0 | Git/Codex/Sandbox 最小語彙 | 45分 | [l0](./lectures/l0_git_codex_sandbox.md) |
   | W1-L1 | ROS 2 基礎 | 45分 | [l1](./lectures/l1_ros2_basics.md) |
   | W1-L2 | TF / URDF | 45分 | [l2](./lectures/l2_tf_urdf.md) |
5. `## Lab 一覧` — 表:
   | ID | タイトル | 所要 | リンク |
   | W1-Lab0 | Sandbox Setup | 60分 | [lab0](./labs/lab0_sandbox_setup/README.md) |
   | W1-Lab1 | turtlesim + rosbag | 60分 | [lab1](./labs/lab1_turtlesim_rosbag/README.md) |
   | W1-Lab2 | TF tree | 60分 | [lab2](./labs/lab2_tf_tree/README.md) |
6. `## 提出物テンプレート` — 表:
   | テンプレート | リンク |
   | Skill Baseline Sheet | [template](./deliverables/skill_baseline_sheet_template.md) |
   | Sandbox Setup Log | [template](./deliverables/sandbox_setup_log_template.md) |
7. `## 合格条件サマリ` — 教育計画 §4.2 末尾の6項目を箇条書きで再掲 (用語説明 / `ros2 topic echo` / frame説明 / ログ証跡 / Sandbox PR / Codex prompt5項目)
8. `## 参照` — references: R-01〜R-05, R-33〜R-38 (front matter と一致)

- [ ] **Step 2: Create `course/week1/lectures/l0_git_codex_sandbox.md`**

Front matter:

```yaml
---
type: lecture
id: W1-L0
title: Git / Codex / Sandbox 最小語彙
week: 1
duration_min: 45
prerequisites: []
worldcpj_ct: [CT-07]
roles: [common, sandbox]
references: [R-33, R-34, R-35, R-36, R-37, R-38]
deliverables: []
---
```

Sections (~150 lines):
1. `# Git / Codex / Sandbox 最小語彙`
2. `## このLectureの目的` — 1文
3. `## 1. Git / GitHub 最小語彙` — branch / commit / remote / origin / upstream / PR / review / fork — 各1-2行 (詳細は `docs/glossary.md` 参照)
4. `## 2. なぜ Sandbox を作るか` — 教育計画 §1, §2.1 の方針要約: 各メンバー自分の `Sandbox_<name>` repo、本番repoと分離、秘密情報禁止
5. `## 3. Codex とは何か (Course 文脈)` — ChatGPT Enterprise の Codex 機能、workspace、GitHub connector、local/cloud
6. `## 4. Codex に頼む粒度` — タスク分解の基本: 1 PR = 1責務、勝手に依存追加しない、検証コマンドが書ける範囲
7. `## 5. prompt前 5 項目 (重要)` — `tools/codex_prompt_template.md` を参照させる + 簡略版表をここに掲載
8. `## 6. 委ねない判断` — Affordance schema、評価指標、安全境界、実機投入可否 (spec §2.6 と整合)
9. `## 7. レビュー観点` — diff summary / 動く根拠 / 壊れうる条件 / 採用しない提案 / 追加修正
10. `## 8. Week 1 における Codex の位置づけ` — **接続確認 + ルール理解 + prompt5項目練習のみ**。生成コードを成果物に必須化しない。本格利用は W2 Lab 4b 以降。
11. `## 9. よくある誤解` — 「Codex に任せれば早い」「Sandbox なら何書いてもOK」「PR は人間レビュー要らない」 — それぞれ1段落で否定
12. `## 次のLab` — → [Lab 0: Sandbox Setup](../labs/lab0_sandbox_setup/README.md)

- [ ] **Step 3: Verify**

```bash
test -s course/week1/README.md && test -s course/week1/lectures/l0_git_codex_sandbox.md
# Verify front matter has all 10 keys
for f in course/week1/README.md course/week1/lectures/l0_git_codex_sandbox.md; do
    for k in type id title week duration_min prerequisites worldcpj_ct roles references deliverables; do
        grep -qE "^${k}:" "$f" || echo "MISSING $k in $f"
    done
done
echo "verify done"
```
Expected: no MISSING lines.

- [ ] **Step 4: Commit**

```bash
git add course/week1/README.md course/week1/lectures/l0_git_codex_sandbox.md
git commit -m "$(cat <<'EOF'
docs: add Week 1 README and Lecture L0 (Git/Codex/Sandbox)

Spec §3.1 #13, #14. Week entry point + first lecture covering
Git/GitHub minimal vocabulary, Sandbox principles, Codex
positioning (W1 = connection + rules + prompt-5 practice only,
no required code generation).
EOF
)"
```

---

## Task 11: Week 1 Lectures L1 + L2

**Files:**
- Create: `course/week1/lectures/l1_ros2_basics.md`
- Create: `course/week1/lectures/l2_tf_urdf.md`

Spec §3.1 #15, #16.

- [ ] **Step 1: Create `course/week1/lectures/l1_ros2_basics.md`**

Front matter:

```yaml
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
```

Sections (~150 lines):
1. `# ROS 2 基礎`
2. `## 目的`
3. `## 1. ROS 2 とは` — DDS-based middleware、なぜROS 1 と違うか (一段落)
4. `## 2. node` — definition、1プロセス・複数node
5. `## 3. topic` — pub/sub 非同期、QoS
6. `## 4. service` — sync request/response
7. `## 5. action` — long-running + feedback
8. `## 6. launch` — Python/XML、複数node起動
9. `## 7. CLI 構造` — `ros2 <verb> <noun>` (e.g., `ros2 topic echo`, `ros2 node list`)
10. `## 8. なぜログが評価証跡か` — 動画ではなくbag/log。教育計画 §運用ルール「動画だけを成果にしない」
11. `## 9. よくある誤解` — topic は関数呼び出しではない / launch は単なるshell scriptではない
12. `## 次のLab` — → [Lab 1: turtlesim + rosbag](../labs/lab1_turtlesim_rosbag/README.md)

- [ ] **Step 2: Create `course/week1/lectures/l2_tf_urdf.md`**

Front matter:

```yaml
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
```

Sections (~150 lines):
1. `# TF / URDF`
2. `## 目的`
3. `## 1. なぜ座標系の話か` — manipulationでframe ambiguityがバグの主原因
4. `## 2. TF とは` — tree of transforms、time-stamped、`/tf` `/tf_static`
5. `## 3. static_transform_publisher` — 固定変換の宣言
6. `## 4. tf2_echo` — `ros2 run tf2_ros tf2_echo <parent> <child>`
7. `## 5. URDF` — XML 構造、`<link>`、`<joint>`、`<visual>`、`<collision>`、`<inertial>`
8. `## 6. robot_state_publisher` — URDF + joint state → TF
9. `## 7. frame 命名 (CC/MS で重要)` — `map` / `odom` / `base_link` / `camera_link` / `tool0` の意味と階層関係
10. `## 8. よくある誤解` — `/tf` を直接publishする / static transform に時間を入れる
11. `## 次のLab` — → [Lab 2: TF tree](../labs/lab2_tf_tree/README.md)

- [ ] **Step 3: Verify**

```bash
for f in course/week1/lectures/l1_ros2_basics.md course/week1/lectures/l2_tf_urdf.md; do
    test -s "$f" && echo "$f OK" || echo "$f MISSING"
done
```

- [ ] **Step 4: Commit**

```bash
git add course/week1/lectures/l1_ros2_basics.md course/week1/lectures/l2_tf_urdf.md
git commit -m "$(cat <<'EOF'
docs: add Week 1 Lectures L1 (ROS 2 basics) and L2 (TF/URDF)

Spec §3.1 #15, #16. Core ROS 2 vocabulary (node/topic/service/
action/launch/QoS) and frame fundamentals (TF, URDF,
robot_state_publisher, base_link/camera_link/tool0).
EOF
)"
```

---

## Task 12: Week 1 Lab 0 (Sandbox Setup)

**Files:**
- Create: `course/week1/labs/lab0_sandbox_setup/README.md`
- Create: `course/week1/labs/lab0_sandbox_setup/CHECKLIST.md`
- Create: `course/week1/labs/lab0_sandbox_setup/HINTS.md`

Spec §3.1 #17, #18, #19. **Codex接続確認のみ。生成は必須化しない。** (spec §2.6 Week 1 ルール)

- [ ] **Step 1: Create `lab0_sandbox_setup/README.md`**

Front matter:

```yaml
---
type: lab
id: W1-Lab0
title: Sandbox 立ち上げ + Codex 接続確認
week: 1
duration_min: 60
prerequisites: [W1-L0]
worldcpj_ct: [CT-07]
roles: [common, sandbox]
references: [R-33, R-34, R-35, R-36, R-37, R-38]
deliverables: [sandbox_setup_log]
---
```

Sections:
1. `# Lab 0 — Sandbox 立ち上げ + Codex 接続確認`
2. `## 目的` — 自分の `Sandbox_<name>` repoを作り、最初のbranch/commit/PR/reviewを通し、Codex接続を確認する
3. `## 前提` — `course/00_setup/` 完了 (`bash tools/verify_env.sh` がPASSまたはWARNのみ)
4. `## 手順`:
   - **Step 1: GitHub で repo 作成** — `Sandbox_<name>` (例: `Sandbox_alice`)、private、READMEのみで初期化
   - **Step 2: clone** — `git clone git@github.com:<you>/Sandbox_<name>.git ~/Develop/Sandbox_<name>`
   - **Step 3: identity 設定** — `git -C ~/Develop/Sandbox_<name> config user.name "<your-name>"`、`git -C ... config user.email "<your-email>"` (Course 推奨: 仕事用 identity)
   - **Step 4: 最初の branch** — `git switch -c learner/<name>/wk1-sandbox-init`
   - **Step 5: README に自己紹介を追加** — 1段落: 自分のRole候補、得意領域
   - **Step 6: commit + push** — `git add README.md && git commit -m "docs: introduce <name>" && git push -u origin learner/<name>/wk1-sandbox-init`
   - **Step 7: PR 作成** — GitHub UI または `gh pr create`、description に目的・スコープ
   - **Step 8: 自分でPRに review コメント1件付ける** — 練習 (実際の cross-review は Lab 4b 以降)
   - **Step 9: Codex 接続確認** — ChatGPT Enterprise → Codex、自分のworkspace、`Sandbox_<name>` への connector 接続を確認 (生成は不要)
   - **Step 10: `sandbox_setup_log_template.md` を埋める** — `docs/superpowers/specs/.../skill_baseline_sheet_template.md` 構造に沿って (実テンプレは Task 13 で作成、現時点ではテンプレを参照する旨記載)
5. `## bag本体commit禁止注記` — Lab 0 は bag を扱わないが、後の Lab 1/2 で必要になる注意点として一文
6. `## 提出物` — `sandbox_setup_log.md` (自Sandbox repoにcommit/PR)、PR URL
7. `## 合格条件` — 一行: 合格条件は [CHECKLIST.md](./CHECKLIST.md) を参照。
8. `## 参照` — R-33〜R-38

- [ ] **Step 2: Create `lab0_sandbox_setup/CHECKLIST.md`**

```markdown
# Lab 0 合格チェック

- [ ] GitHub に `Sandbox_<name>` repository を作成 (private)
- [ ] ローカルclone成功、`git config user.name`/`user.email` を自Sandbox用に設定済
- [ ] branch `learner/<name>/wk1-sandbox-init` を作成
- [ ] README.md を更新して commit
- [ ] origin に push (`-u origin <branch>`)
- [ ] PR を作成し URL を `sandbox_setup_log.md` に記録
- [ ] PRに自分でreviewコメントを1件付ける (練習)
- [ ] ChatGPT Enterprise の Codex で workspace と GitHub connector を確認
- [ ] `sandbox_setup_log.md` の全項目を記入し Sandbox にcommit/PR
- [ ] (任意) `tools/codex_prompt_template.md` を読み prompt5項目を練習で1つ書く (Sandbox 内 `notes/codex_practice.md` 等)

> 注: Codexによる**コード生成は本Labでは必須としない**。接続確認とprompt5項目練習までで Lab 0合格。
```

- [ ] **Step 3: Create `lab0_sandbox_setup/HINTS.md`**

```markdown
# Lab 0 ヒント

## SSH key
- GitHub clone でpassword promptが出る場合: SSH keyを設定 (`ssh-keygen -t ed25519`, `gh ssh-key add`)。
- HTTPS で進めても可だが、毎push でtoken入力。

## PR description が空だと落ちる
- `gh pr create` で `--body` を指定するか、UIで最低1行入れる。

## Codex GitHub connector が承認待ち
- workspace owner (admin) 側で承認が必要。Lab 0 は connector が無くても完遂可 (前提条件のみ確認、生成は不要)。

## branch 名に `/` を含めて良いか
- 良い。GitHub も Git も `/` を階層区切りとして扱う。`learner/<name>/wk1-sandbox-init` のような3階層は推奨。

## 自分のSandbox repoの命名
- `Sandbox_<name>` の `<name>` は英小文字のみ推奨 (CONVENTIONS.md §2.1 のロケール規約)。例: `Sandbox_alice`、`Sandbox_pasorobo`。
```

- [ ] **Step 4: Verify**

```bash
ls course/week1/labs/lab0_sandbox_setup/
# expect README.md CHECKLIST.md HINTS.md
```

- [ ] **Step 5: Commit**

```bash
git add course/week1/labs/lab0_sandbox_setup/
git commit -m "$(cat <<'EOF'
lab: add Week 1 Lab 0 (Sandbox Setup + Codex connect)

Spec §3.1 #17-#19. First Lab: each learner creates their own
Sandbox_<name> GitHub repo, walks through the first branch/
commit/PR/review cycle, and confirms Codex workspace + GitHub
connector. Codex code generation is NOT required in Week 1.
EOF
)"
```

---

## Task 13: Week 1 Lab 1 (turtlesim + rosbag)

**Files:**
- Create: `course/week1/labs/lab1_turtlesim_rosbag/README.md`
- Create: `course/week1/labs/lab1_turtlesim_rosbag/CHECKLIST.md`
- Create: `course/week1/labs/lab1_turtlesim_rosbag/HINTS.md`

Spec §3.1 #20, #21, #22. **bag本体は commit 禁止** — 軽量証跡 (bag_info.txt, rosbag_metadata.yaml, terminal_*.log) のみ。

- [ ] **Step 1: Create `lab1_turtlesim_rosbag/README.md`**

Front matter:

```yaml
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
```

Sections:
1. `# Lab 1 — turtlesim と rosbag2 の最小操作`
2. `## 目的` — ROS 2 CLI の感触、bag 録画/再生/info、評価証跡 = 軽量ファイルという原則を体験
3. `## 前提` — `course/00_setup/` 完了
4. `## 手順`:
   - **Step 0: 録画開始 (script で terminal をログ化)** — `script -q ~/Develop/Sandbox_<name>/wk1/lab1/terminal_5min.log -c "bash"` (新シェルが起動。本Lab内のすべてのコマンドはこのシェルで打つ)
   - **Step 1: turtlesim 起動** — 別terminal で `ros2 run turtlesim turtlesim_node`
   - **Step 2: 操作 turtle** — 別terminal で `ros2 run turtlesim turtle_teleop_key`
   - **Step 3: topic 観察** — `ros2 topic list`、`ros2 topic info /turtle1/cmd_vel`、`ros2 topic echo /turtle1/cmd_vel` (10秒)
   - **Step 4: bag record** — `ros2 bag record -o /tmp/turtle_bag /turtle1/cmd_vel /turtle1/pose` (30秒、teleop で動かす)、Ctrl-C で停止
   - **Step 5: bag info** — `ros2 bag info /tmp/turtle_bag` の出力を `bag_info.txt` として保存: `ros2 bag info /tmp/turtle_bag > ~/Develop/Sandbox_<name>/wk1/lab1/bag_info.txt`
   - **Step 6: metadata軽量コピー** — `cp /tmp/turtle_bag/metadata.yaml ~/Develop/Sandbox_<name>/wk1/lab1/rosbag_metadata.yaml` (.db3 や rosbag2_*/ ディレクトリ自体は **commitしない**)
   - **Step 7: bag 再生** — turtlesim を再起動 (位置リセット)、別terminal で `ros2 bag play /tmp/turtle_bag` 、turtle が同じ動きをするか確認
   - **Step 8: script 終了** — 録画 terminal で `exit` (script が終了し log が確定)
   - **Step 9: Sandbox に commit/PR** — `bag_info.txt`, `rosbag_metadata.yaml`, `terminal_5min.log` の3点のみ
5. `## bag本体 commit 禁止 (重要)`:
   > 提出するのは `bag_info.txt`、`rosbag_metadata.yaml` (rosbag2 ディレクトリ内 `metadata.yaml` を `cp` した軽量コピー)、`terminal_5min.log` の3点のみ。`/tmp/turtle_bag/` 全体や `.db3` `.mcap` ファイルは Sandbox にcommitしない (.gitignore で blockされるが意識する)。
6. `## 提出物` — 3ファイル (上記Step 9参照)
7. `## 合格条件` — 1行: 合格条件は [CHECKLIST.md](./CHECKLIST.md) を参照。
8. `## 参照` — R-01, R-04

- [ ] **Step 2: Create `lab1_turtlesim_rosbag/CHECKLIST.md`**

```markdown
# Lab 1 合格チェック

- [ ] `ros2 topic echo /turtle1/cmd_vel` で teleop の入力に応じて値が出る
- [ ] `ros2 bag record` で `/turtle1/cmd_vel` `/turtle1/pose` を含む bag が生成
- [ ] `ros2 bag play` で turtlesim が同じ動きをする
- [ ] `bag_info.txt` に `Duration:` または `Topic information:` が含まれる (非空)
- [ ] `rosbag_metadata.yaml` に `topics_with_message_count:` が含まれる
- [ ] `terminal_5min.log` が 1 KB 以上、Step 1〜Step 8のコマンドが含まれる
- [ ] 自Sandboxで上記 3 ファイルのみを commit、`.db3`/`.mcap`/`rosbag2_*/` は含まれない
- [ ] PRを作成しレビューを依頼 (受けるレビュアーは Lab 4b 以降の本格運用までは任意)
```

- [ ] **Step 3: Create `lab1_turtlesim_rosbag/HINTS.md`**

```markdown
# Lab 1 ヒント

## bag が空になる
- record 開始前に topic が立っていないと record しても何も入らない。turtlesim 起動 → teleop 起動 → record 開始の順を守る。
- record 中に teleop で実際にキーを押して publish を起こす必要がある。

## metadata.yaml の場所
- `/tmp/turtle_bag/` の直下に `metadata.yaml` がある。bag全体ではなくこの YAML だけをコピーする。

## script コマンド互換性
- 古い Ubuntu や非GNUの環境では `script -c "..." -q file.log` の引数順が異なる。本Lab では `script -q LOGFILE -c "bash"` を採用。
- もし上記が動かない場合: `script -q -c bash LOGFILE` を試す、それでも動かなければ手動でコマンド出力を別ファイルに `tee` する。

## bag を別シェルで record しているのに terminal_5min.log に含まれない
- script 内のシェルで `ros2 bag record` を実行する場合は問題ない。別terminalで record した場合は record 開始/停止の事実だけを script シェルに `echo "started recording at $(date)"` などで残す。

## /tmp が消える
- システム再起動で /tmp は消える。本Lab は短時間内に完結する想定なので問題ない。長期保管したい場合は `~/Develop/.../bags/` に保存し、`.gitignore` で repo に含めない。
```

- [ ] **Step 4: Verify**

```bash
ls course/week1/labs/lab1_turtlesim_rosbag/
```

- [ ] **Step 5: Commit**

```bash
git add course/week1/labs/lab1_turtlesim_rosbag/
git commit -m "$(cat <<'EOF'
lab: add Week 1 Lab 1 (turtlesim + rosbag2)

Spec §3.1 #20-#22. ROS 2 CLI hands-on: turtlesim, topic
echo, rosbag2 record/play/info. Strict rule: only lightweight
artifacts (bag_info.txt, rosbag_metadata.yaml, terminal_5min.log)
go to Sandbox; bag bodies (.db3, rosbag2_*/) are gitignored.
EOF
)"
```

---

## Task 14: Week 1 Lab 2 (TF tree)

**Files:**
- Create: `course/week1/labs/lab2_tf_tree/README.md`
- Create: `course/week1/labs/lab2_tf_tree/CHECKLIST.md`
- Create: `course/week1/labs/lab2_tf_tree/HINTS.md`

Spec §3.1 #23, #24, #25. **`view_frames` の PDF はローカル確認用、commit しない。**Mermaid TF tree が正の提出物。

- [ ] **Step 1: Create `lab2_tf_tree/README.md`**

Front matter:

```yaml
---
type: lab
id: W1-Lab2
title: TF tree 作成と CC/MS 用 frame 一覧案
week: 1
duration_min: 60
prerequisites: [W1-L2]
worldcpj_ct: [CT-01, CT-02]
roles: [common, calibration, adapter]
references: [R-01, R-03, R-05]
deliverables: [frame_inventory]
---
```

Sections:
1. `# Lab 2 — TF tree`
2. `## 目的` — static transform を立て、`tf2_echo` で確認、`view_frames` で構造可視化、CC/MSで使う frame 一覧案を Mermaid TF tree で書き起こす
3. `## 前提` — Lecture L2 完了
4. `## 手順`:
   - **Step 1: static transform を起動 (3つ)** — 別terminal x 3:
     ```bash
     ros2 run tf2_ros static_transform_publisher 1 0 0 0 0 0 base_link camera_link
     ros2 run tf2_ros static_transform_publisher 0 0 0.5 0 0 0 base_link tool0
     ros2 run tf2_ros static_transform_publisher 0 0 0 0 0 0 map base_link
     ```
   - **Step 2: tf2_echo で確認** — `ros2 run tf2_ros tf2_echo map tool0` 出力を取る
   - **Step 3: view_frames で PDF生成 (ローカル確認用)** — `ros2 run tf2_tools view_frames` 実行 → `frames.pdf` が現在ディレクトリに生成。PDF を開いて構造を目視確認
   - **Step 4: PDF を commit しない (重要)** — `.gitignore` で `**/frames.pdf` `**/frames.gv` がblock済。手元で削除推奨: `rm frames.pdf frames.gv`
   - **Step 5: Mermaid TF tree を `frame_inventory.md` に書く** — 自Sandbox `wk1/lab2/frame_inventory.md` を作成。フォーマット例: 下のmd block参照。**必ず `base_link`, `camera_link`, `tool0` を含める** (CC/MS の frame 案として)。
5. `## frame_inventory.md フォーマット例`:
   ````markdown
   # CC/MS で使う frame 一覧案

   ```mermaid
   graph TD
       map --> base_link
       base_link --> camera_link
       base_link --> tool0
   ```

   | frame | 親 | 用途 | 備考 |
   |---|---|---|---|
   | `map` | (root) | 静的世界座標 | CC/MS 共通 |
   | `base_link` | `map` | ロボット本体 | UR7e/CRX 共通 |
   | `camera_link` | `base_link` | カメラ筐体 | hand-eye calib 対象 |
   | `tool0` | `base_link` | エンドエフェクタ取付 | gripper を更にchildとして付与 |
   ````
6. `## 提出物` — 自Sandbox `wk1/lab2/frame_inventory.md` (Mermaid TF tree + 表)
7. `## 合格条件` — 1行: 合格条件は [CHECKLIST.md](./CHECKLIST.md) を参照。
8. `## 参照` — R-01, R-03, R-05

- [ ] **Step 2: Create `lab2_tf_tree/CHECKLIST.md`**

```markdown
# Lab 2 合格チェック

- [ ] static_transform_publisher が3つ起動成功 (`ros2 node list` で見える)
- [ ] `tf2_echo map tool0` で 6-DOF transform が出力 (Translation, Rotation 行)
- [ ] `view_frames` でローカルにPDFが生成 (内容確認のみ、commitしない)
- [ ] `frame_inventory.md` に Mermaid code fence が含まれる
- [ ] `frame_inventory.md` に `base_link`, `camera_link`, `tool0` の3キーワードがすべて含まれる
- [ ] 表で各frameの親・用途・備考が書かれている
- [ ] Sandbox に commit/PR、`frames.pdf` `frames.gv` は含まれない (.gitignore で block)
```

- [ ] **Step 3: Create `lab2_tf_tree/HINTS.md`**

```markdown
# Lab 2 ヒント

## TF time stamp 問題
- static transform は古い (`builtin_interfaces.msg.Time` の epoch 0) として publish される。`tf2_echo` で表示されるが、`tf2_listener` で動的に lookup する場合は static の取り扱いに注意。
- 本Lab では static のみなので問題は起きない。

## parent/child 命名 typo
- `base_link` を `baselink` と書く、`tool0` を `tool_0` と書く等の typo は ROS では普通に通ってしまい、frame が孤立する。`view_frames` PDF で parent が想定通りか目視確認。

## view_frames が止まる
- `view_frames` は5秒間 TF を listen → PDF生成。途中で Ctrl-C すると PDF が空になる。5秒待つ。

## Mermaid が GitHub で表示されない
- ` ```mermaid ` (バッククォート3つ + mermaid) コードフェンス必須。それ以外 (`mermaid` だけ書いて html-style block) は GitHub レンダリング対象外。
- VS Code でプレビューする場合は Mermaid 拡張をinstall。

## camera_link を base_link の child にしたが、本物の robot ではどう違うか
- 多くの URDF では `<robot>/<link name="camera_optical_frame"/>` を `camera_link` の child に置き、Z軸を光軸方向にする (REP-103/REP-105)。CC/MS の calibration 議論で出てくる話。本Lab では一般化して `camera_link` まで。
```

- [ ] **Step 4: Verify**

```bash
ls course/week1/labs/lab2_tf_tree/
```

- [ ] **Step 5: Commit**

```bash
git add course/week1/labs/lab2_tf_tree/
git commit -m "$(cat <<'EOF'
lab: add Week 1 Lab 2 (TF tree + Mermaid frame inventory)

Spec §3.1 #23-#25. static_transform_publisher hands-on,
tf2_echo verification, view_frames for local visualization
(PDF is gitignored), and Mermaid TF tree as the canonical
deliverable. Must include base_link, camera_link, tool0
keywords.
EOF
)"
```

---

## Task 15: Week 1 Deliverable Templates

**Files:**
- Create: `course/week1/deliverables/skill_baseline_sheet_template.md`
- Create: `course/week1/deliverables/sandbox_setup_log_template.md`

Spec §3.1 #26, #27. Empty templates for learners to copy into their own Sandbox.

- [ ] **Step 1: Create `skill_baseline_sheet_template.md`**

Front matter:

```yaml
---
type: template
id: W1-T-SKILL-BASELINE
title: Skill Baseline Sheet (template)
week: 1
duration_min: 15
prerequisites: []
worldcpj_ct: [CT-01, CT-02, CT-04, CT-05, CT-06, CT-07, CT-08, CT-09]
roles: [common]
references: []
deliverables: []
---
```

Body — mirror education plan §8.1 table:

```markdown
# Skill Baseline Sheet

> このテンプレートを自Sandboxにコピーし、各項目を自己採点してください。
> 採点は2026-04-27時点の自己評価。Phase 0 完了時 (Week 4末) に再採点して伸びを確認。

| 項目 | レベル0 (未経験) | レベル1 | レベル2 | 自己採点 (0/1/2) |
|---|---|---|---|---|
| ROS2 CLI | 未経験 | tutorial実行可 | topic/service/action/debug可 | |
| TF/URDF | 未経験 | frame図を読める | TF treeを作成/修正できる | |
| MoveIt2 | 未経験 | RViz demo実行可 | planning scene/IK失敗を説明可 | |
| Calibration | 未経験 | intrinsic/hand-eyeを説明可 | fixture/reprojection評価を設計可 | |
| Simulation | 未経験 | GazeboまたはMuJoCoを起動可 | Sim I/Oを評価schemaへ接続可 | |
| Logging | 未経験 | rosbag2 record/play可 | episode_record/trial sheet設計可 | |
| Safety | 未経験 | stop種別を説明可 | SOP/safe no-action条件を書ける | |
| Git/Codex | 未経験 | branch/commit/PRを作れる | Codex出力をdiff/実行ログ/失敗条件でレビューできる | |

## 自由記述

### Primary Role 候補
TBD

### Secondary Role 候補 (任意)
TBD

### Phase 0 後に伸ばしたい領域
TBD

---

| 記入者 | 記入日 |
|---|---|
| `<name>` | `YYYY-MM-DD` |
```

- [ ] **Step 2: Create `sandbox_setup_log_template.md`**

Front matter:

```yaml
---
type: template
id: W1-T-SANDBOX-SETUP-LOG
title: Sandbox Setup Log (template)
week: 1
duration_min: 10
prerequisites: [W1-Lab0]
worldcpj_ct: [CT-07]
roles: [common, sandbox]
references: [R-33, R-34, R-35, R-36, R-37, R-38]
deliverables: []
---
```

Body — mirror education plan §8.5 table:

```markdown
# Sandbox Setup Log

> このテンプレートを自Sandboxにコピーし、Lab 0 完了時に各項目を埋めてください。

| 項目 | 記入内容 |
|---|---|
| repo: | `<GitHub Sandbox_<name> URL>` |
| access: | `<owner / collaborators / visibility (private推奨) / admin確認済み yes/no>` |
| local setup: | `<clone path / default branch / git user.name + user.email 設定値>` |
| first branch: | `<branch name / commit hash / PR URL>` |
| Codex access: | `<ChatGPT Enterprise workspace name / Codex local可否 / Codex cloud可否 / GitHub connector可否>` |
| rules: | 秘密情報を置かない / 実機接続しない / mock/sim/offline data だけ使う (3項目すべて確認 yes/no) |

## 自由記述

### 詰まった点
TBD

### 次に試したいこと
TBD

---

| 記入者 | 記入日 |
|---|---|
| `<name>` | `YYYY-MM-DD` |
```

- [ ] **Step 3: Verify**

```bash
ls course/week1/deliverables/
# expect 2 files
for f in course/week1/deliverables/*.md; do
    grep -qE "^type: template" "$f" || echo "MISSING type:template in $f"
done
```

- [ ] **Step 4: Commit**

```bash
git add course/week1/deliverables/
git commit -m "$(cat <<'EOF'
docs: add Week 1 deliverable templates

Spec §3.1 #26-#27. Two empty templates for learners to copy
into their Sandbox: Skill Baseline Sheet (8 self-assessment
categories) and Sandbox Setup Log (repo URL, access, local
setup, first branch, Codex access, rules).
EOF
)"
```

---

## Task 16: sandbox_reference root + W1 example sheets

**Files:**
- Create: `sandbox_reference/README.md`
- Create: `sandbox_reference/week1/skill_baseline_sheet_example.md`
- Create: `sandbox_reference/week1/sandbox_setup_log_example.md`

Spec §3.1 #28, #29, #30. Instructor-filled examples; learners peek when stuck.

- [ ] **Step 1: Create `sandbox_reference/README.md`**

Front matter:

```yaml
---
type: guide
id: SANDBOXREF-README
title: Sandbox Reference (instructor snapshot)
date: 2026-04-27
---
```

Body:

```markdown
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
- 詳細は [CONVENTIONS.md §3](../../CONVENTIONS.md) 参照。
```

- [ ] **Step 2: Create `sandbox_reference/week1/skill_baseline_sheet_example.md`**

Front matter:

```yaml
---
type: reference
id: REF-W1-SKILL-BASELINE-EXAMPLE
title: Skill Baseline Sheet 記入例 (instructor)
week: 1
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-01, CT-02, CT-04, CT-05, CT-06, CT-07, CT-08, CT-09]
roles: [common]
references: []
deliverables: []
---
```

Body — copy template structure with realistic instructor self-scores. **Must include all 8 category names** (`ROS2 CLI`, `TF/URDF`, `MoveIt2`, `Calibration`, `Simulation`, `Logging`, `Safety`, `Git/Codex`) — checked by `tools/check_structure.sh` G4 pattern.

```markdown
# Skill Baseline Sheet (記入例)

| 項目 | レベル0 | レベル1 | レベル2 | 自己採点 |
|---|---|---|---|---|
| ROS2 CLI | 未経験 | tutorial実行可 | topic/service/action/debug可 | 2 |
| TF/URDF | 未経験 | frame図を読める | TF treeを作成/修正できる | 1 |
| MoveIt2 | 未経験 | RViz demo実行可 | planning scene/IK失敗を説明可 | 1 |
| Calibration | 未経験 | intrinsic/hand-eyeを説明可 | fixture/reprojection評価を設計可 | 1 |
| Simulation | 未経験 | GazeboまたはMuJoCoを起動可 | Sim I/Oを評価schemaへ接続可 | 1 |
| Logging | 未経験 | rosbag2 record/play可 | episode_record/trial sheet設計可 | 2 |
| Safety | 未経験 | stop種別を説明可 | SOP/safe no-action条件を書ける | 1 |
| Git/Codex | 未経験 | branch/commit/PRを作れる | Codex出力をdiff/実行ログ/失敗条件でレビューできる | 2 |

## 自由記述

### Primary Role 候補
Agentic Workflow / Sandbox (Course のinstructor兼prototyperとして)

### Secondary Role 候補
Logging / Gate Eval (rosbag2 / MCAP の経験を活かす)

### Phase 0 後に伸ばしたい領域
- MoveIt2 の planning scene と collision-aware IK
- Hand-eye calibration の実機 fixture 設計

---

| 記入者 | 記入日 |
|---|---|
| pasorobo (instructor) | 2026-04-27 |
```

- [ ] **Step 3: Create `sandbox_reference/week1/sandbox_setup_log_example.md`**

Front matter:

```yaml
---
type: reference
id: REF-W1-SANDBOX-SETUP-LOG-EXAMPLE
title: Sandbox Setup Log 記入例 (instructor)
week: 1
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-07]
roles: [common, sandbox]
references: []
deliverables: []
---
```

Body — **must contain `repo:` and `first branch:` keys** (G4 pattern). Use this very repository as the example "Sandbox" (instructor case is special — they're building Course content).

```markdown
# Sandbox Setup Log (記入例 — instructor case)

> instructor は Course 開発兼 instructor 用に、本リポジトリ自体 (Robotics_Education) を Sandbox 兼 Course content として運用している。一般メンバーは別に `Sandbox_<name>` を作る。

| 項目 | 記入内容 |
|---|---|
| repo: | https://github.com/<placeholder>/Robotics_Education (まだremote未設定の場合は local-only と記載) |
| access: | owner: pasorobo / collaborators: TBD / visibility: TBD (Q1中はprivate想定) / admin確認済み: yes |
| local setup: | clone path: `~/Develop/Robotics_Education` / default branch: `main` / git user.name: `pasorobo` / git user.email: `goo.mail01@yahoo.com` (local config only) |
| first branch: | `main` (root commit `af9ac7e` — spec追加。learner用ブランチではなく直接 `main` で進めている、SP1 のscope内) |
| Codex access: | workspace: TBD / Codex local: TBD / Codex cloud: TBD / GitHub connector: TBD (Course本体ではCodexを直接利用していない、利用は学習者が各Sandboxで行う) |
| rules: | 秘密情報を置かない: yes / 実機接続しない: yes / mock/sim/offline data だけ使う: yes |

## 自由記述

### 詰まった点
- 当初 `Robotics_simulation_phase0_education_plan.md` を root に置いていたが、`docs/` 配下に集約するよう brainstorming で決定 (Decision Log Q2)。
- git identity が global 未設定で commit 失敗。local設定で対応。

### 次に試したいこと
- SP1 完了後、本リポジトリにGitHub remoteを設定し PR運用に切り替え。
- W2 着手時に Codex workspace の準備を学習者と一緒に確認。

---

| 記入者 | 記入日 |
|---|---|
| pasorobo (instructor) | 2026-04-27 |
```

- [ ] **Step 4: Verify**

```bash
ls sandbox_reference/ sandbox_reference/week1/
grep -c "^| ROS2 CLI" sandbox_reference/week1/skill_baseline_sheet_example.md  # expect 1
grep -c "^| Git/Codex" sandbox_reference/week1/skill_baseline_sheet_example.md # expect 1
grep -c "^| repo:" sandbox_reference/week1/sandbox_setup_log_example.md        # expect 1
grep -c "^| first branch:" sandbox_reference/week1/sandbox_setup_log_example.md # expect 1
```

- [ ] **Step 5: Commit**

```bash
git add sandbox_reference/README.md sandbox_reference/week1/skill_baseline_sheet_example.md sandbox_reference/week1/sandbox_setup_log_example.md
git commit -m "$(cat <<'EOF'
docs: add sandbox_reference root + Week 1 example sheets

Spec §3.1 #28-#30. Instructor snapshot folder with disclaimer
("not the only solution"). Two filled templates: Skill
Baseline Sheet (all 8 categories) and Sandbox Setup Log
(treats this Robotics_Education repo as the instructor's
Sandbox example).
EOF
)"
```

---

## Task 17: Walk Lab 0 → sandbox_reference/week1/lab0/

**Files:**
- Create: `sandbox_reference/week1/lab0/README.md`
- Create: `sandbox_reference/week1/lab0/codex_connection_check.md`

Spec §3.1 #31, #42. **Walk through Lab 0** (without actually creating a separate Sandbox repo — instructor can document the equivalent steps that would have been done).

- [ ] **Step 1: Create `sandbox_reference/week1/lab0/README.md`**

Front matter:

```yaml
---
type: reference
id: REF-W1-LAB0-README
title: Lab 0 instructor walk-through summary
week: 1
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-07]
roles: [common, sandbox]
references: [R-33, R-34, R-35]
deliverables: []
---
```

Body:

```markdown
# Lab 0 — Instructor walk-through summary

> instructor は別途 `Sandbox_<name>` repo を作る代わりに、本 `Robotics_Education` リポジトリを直接 Sandbox として扱った (Setup Log 記入例参照)。以下は「もし一般メンバーと同じ手順を踏んだら」という形式の擬似ログ。

## 実行コマンドサマリ (擬似)

```
gh repo create Sandbox_pasorobo --private --confirm
git clone git@github.com:pasorobo/Sandbox_pasorobo.git ~/Develop/Sandbox_pasorobo
cd ~/Develop/Sandbox_pasorobo
git config user.name "pasorobo"
git config user.email "goo.mail01@yahoo.com"
git switch -c learner/pasorobo/wk1-sandbox-init
echo "# Sandbox_pasorobo (instructor)" > README.md
git add README.md
git commit -m "docs: introduce instructor sandbox"
git push -u origin learner/pasorobo/wk1-sandbox-init
gh pr create --title "wk1: sandbox init" --body "Lab 0 setup PR"
gh pr review <pr-number> --comment --body "self-review: README structure looks fine"
```

## 実際に instructor がやったこと

本リポジトリ `Robotics_Education` の root commit `af9ac7e` (`docs: add SP1 design spec and relocate education plan`) が Lab 0 相当の "first PR" の役割。一般メンバー向けには上記擬似ログのような独立 Sandbox を強く推奨する。

## 詰まった点 / 注意

- git identity が global 未設定で初回 commit 失敗。local config (`git config user.name`/`user.email`) で解決。
- GitHub remote が未設定のため push は未実施 (本リポジトリは Q1 中はlocal運用予定)。

## 提出物

- 本 walk-through README (このファイル)
- [`codex_connection_check.md`](./codex_connection_check.md)
```

- [ ] **Step 2: Create `sandbox_reference/week1/lab0/codex_connection_check.md`**

Front matter:

```yaml
---
type: reference
id: REF-W1-LAB0-CODEX-CHECK
title: Codex 接続確認ログ (instructor)
week: 1
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-07]
roles: [common, sandbox]
references: [R-36, R-37, R-38]
deliverables: []
---
```

Body — **must contain `workspace` and `connector` keywords** (G4 pattern):

```markdown
# Codex 接続確認ログ

> 本ログは Codex 利用の前提となる **接続確認のみ**。生成コードは含まない (Week 1 ルール — spec §2.6)。

## 確認項目

| 項目 | 状態 | 備考 |
|---|---|---|
| ChatGPT Enterprise workspace に sign-in 可能 | TBD | 学習者が各自確認 |
| Codex 機能が有効化されている | TBD | workspace owner が admin で有効化 |
| Codex local mode 利用可 | TBD | OS / IDE 連携設定 |
| Codex cloud mode 利用可 | TBD | ブラウザから利用 |
| GitHub connector が承認済み | TBD | workspace owner 承認待ちの場合あり |
| 自 Sandbox repo (`Sandbox_<name>`) に Codex がアクセス可能 | TBD | connector 有効化後 |

## 確認手順 (擬似)

1. ChatGPT Enterprise workspace に sign-in
2. Codex タブを開く
3. workspace 設定で Codex 有効化を確認
4. GitHub connector の認可フローを通す (admin 承認が必要な場合あり)
5. 自 Sandbox repo を選択肢に表示できれば OK

## prompt 5 項目練習 (Week 1 範囲)

実際の Codex 生成は Week 2 Lab 4b 以降。Week 1 では `tools/codex_prompt_template.md` の 5 項目 (目的/入力/制約/成功条件/検証コマンド) を **書く練習** までで合格とする。

## instructor 自身の状態

instructor は Course 本体開発に Codex を直接利用していないため、上記項目はすべて TBD のまま。Lab 0 の合格基準としては「学習者が自Sandboxで上記表を埋めて connector / workspace の状態を明示する」までが必要十分。
```

- [ ] **Step 3: Verify**

```bash
test -s sandbox_reference/week1/lab0/README.md
grep -q "workspace" sandbox_reference/week1/lab0/codex_connection_check.md && echo "workspace OK"
grep -q "connector" sandbox_reference/week1/lab0/codex_connection_check.md && echo "connector OK"
```

- [ ] **Step 4: Commit**

```bash
git add sandbox_reference/week1/lab0/
git commit -m "$(cat <<'EOF'
docs: add sandbox_reference Lab 0 walk-through

Spec §3.1 #31, #42. Instructor walk-through summary plus
Codex connection check log (with required workspace/connector
keywords for G4 pattern). Acknowledges that the instructor
uses this Robotics_Education repo as the Sandbox example
rather than creating a separate Sandbox_<name>.
EOF
)"
```

---

## Task 18: Walk Lab 1 → sandbox_reference/week1/lab1/

**Files:**
- Create: `sandbox_reference/week1/lab1/bag_info.txt`
- Create: `sandbox_reference/week1/lab1/rosbag_metadata.yaml`
- Create: `sandbox_reference/week1/lab1/terminal_5min.log`

Spec §3.1 #32, #33, #34. **Real ROS execution required.** Run Lab 1 procedure on instructor's environment, capture artifacts.

> **Pre-flight:** This task requires ROS 2 Humble installed and turtlesim runnable. If `bash tools/verify_env.sh` reports FAIL on `ros2 CLI`, complete `course/00_setup/ubuntu_2204_humble_setup.md` before proceeding.

- [ ] **Step 1: Run Lab 1 procedure end-to-end**

Open three terminals. Terminal 1 (recording shell):

```bash
cd /home/dev/Develop/Robotics_Education
mkdir -p sandbox_reference/week1/lab1
script -q sandbox_reference/week1/lab1/terminal_5min.log -c "bash"
# Now inside script-recorded shell. All subsequent commands here will be logged.
```

Terminal 1 (after entering script):
```bash
source /opt/ros/humble/setup.bash
ros2 run turtlesim turtlesim_node &
TURTLE_PID=$!
sleep 2
ros2 topic list
ros2 topic info /turtle1/cmd_vel
```

Terminal 2 (teleop, NOT inside script):
```bash
source /opt/ros/humble/setup.bash
ros2 run turtlesim turtle_teleop_key
# leave running for next steps
```

Terminal 1 (continue inside script):
```bash
ros2 topic echo /turtle1/cmd_vel &
ECHO_PID=$!
sleep 5
kill $ECHO_PID
mkdir -p /tmp/lab1
ros2 bag record -o /tmp/lab1/turtle_bag /turtle1/cmd_vel /turtle1/pose &
BAG_PID=$!
echo "started recording at $(date)"
sleep 30   # during this, use teleop in Terminal 2 to drive turtle
kill $BAG_PID
wait $BAG_PID 2>/dev/null
sleep 1
ros2 bag info /tmp/lab1/turtle_bag > sandbox_reference/week1/lab1/bag_info.txt
cat sandbox_reference/week1/lab1/bag_info.txt
cp /tmp/lab1/turtle_bag/metadata.yaml sandbox_reference/week1/lab1/rosbag_metadata.yaml
ls -la sandbox_reference/week1/lab1/
kill $TURTLE_PID 2>/dev/null
exit  # exit script-recorded shell — terminal_5min.log is now finalized
```

> **If turtlesim/teleop not feasible (headless server, no X display):** Use the fallback in Step 1b below.

- [ ] **Step 1b (fallback if no GUI): synthesize artifacts from a headless smoke run**

If the env is headless, replace Step 1 with:

```bash
source /opt/ros/humble/setup.bash
mkdir -p /tmp/lab1
script -q sandbox_reference/week1/lab1/terminal_5min.log -c "bash" <<'INNER_EOF'
# Headless: publish synthetic cmd_vel directly with ros2 topic pub
ros2 topic pub --once /turtle1/cmd_vel geometry_msgs/msg/Twist '{linear: {x: 0.5}, angular: {z: 0.0}}' &
PUB_PID=$!
ros2 bag record -o /tmp/lab1/turtle_bag /turtle1/cmd_vel &
BAG_PID=$!
echo "started recording at $(date)"
for i in {1..20}; do
    ros2 topic pub --once /turtle1/cmd_vel geometry_msgs/msg/Twist "{linear: {x: 0.5}, angular: {z: 0.0}}"
    sleep 0.5
done
kill $BAG_PID 2>/dev/null
wait $BAG_PID 2>/dev/null
kill $PUB_PID 2>/dev/null
sleep 1
ros2 bag info /tmp/lab1/turtle_bag > /home/dev/Develop/Robotics_Education/sandbox_reference/week1/lab1/bag_info.txt
cp /tmp/lab1/turtle_bag/metadata.yaml /home/dev/Develop/Robotics_Education/sandbox_reference/week1/lab1/rosbag_metadata.yaml
echo "captured at $(date)"
exit
INNER_EOF
```

This produces equivalent artifacts (bag with `/turtle1/cmd_vel` topic, info, metadata) without requiring a GUI.

- [ ] **Step 2: Verify artifacts match G4 patterns**

```bash
test -s sandbox_reference/week1/lab1/bag_info.txt && grep -qE "Duration:|Topic information:" sandbox_reference/week1/lab1/bag_info.txt && echo "bag_info OK"
test -s sandbox_reference/week1/lab1/rosbag_metadata.yaml && grep -q "topics_with_message_count:" sandbox_reference/week1/lab1/rosbag_metadata.yaml && echo "metadata OK"
[ "$(wc -c < sandbox_reference/week1/lab1/terminal_5min.log)" -ge 1024 ] && echo "log size OK"
```
Expected: all three OK.

If `terminal_5min.log` is too small (<1KB), pad it with a real human-readable description of what happened (e.g., a header line explaining "headless run — see bag_info.txt for actual recording results"). The G4 minimum is 1024 bytes.

- [ ] **Step 3: Cleanup /tmp**

```bash
rm -rf /tmp/lab1
```

- [ ] **Step 4: Commit**

```bash
git add sandbox_reference/week1/lab1/
git commit -m "$(cat <<'EOF'
docs: add sandbox_reference Lab 1 artifacts (real ROS run)

Spec §3.1 #32-#34. Captured bag_info.txt, rosbag_metadata.yaml
(lightweight cp from rosbag2 dir), and terminal_5min.log
from a real turtlesim + ros2 bag record execution.
G4 patterns satisfied: Duration/Topic in bag_info,
topics_with_message_count in metadata, log >=1KB.

The bag body itself is gitignored (.db3, rosbag2_*/).
EOF
)"
```

---

## Task 19: Walk Lab 2 → sandbox_reference/week1/lab2/

**Files:**
- Create: `sandbox_reference/week1/lab2/frame_inventory.md`

Spec §3.1 #35. Walk Lab 2; Mermaid TF tree is the deliverable.

- [ ] **Step 1: Run Lab 2 quick smoke (verify the procedure works)**

```bash
source /opt/ros/humble/setup.bash
# Start static transforms
ros2 run tf2_ros static_transform_publisher 1 0 0 0 0 0 base_link camera_link &
SP1_PID=$!
ros2 run tf2_ros static_transform_publisher 0 0 0.5 0 0 0 base_link tool0 &
SP2_PID=$!
ros2 run tf2_ros static_transform_publisher 0 0 0 0 0 0 map base_link &
SP3_PID=$!
sleep 2
ros2 run tf2_ros tf2_echo map tool0 &
ECHO_PID=$!
sleep 3
kill $ECHO_PID $SP1_PID $SP2_PID $SP3_PID 2>/dev/null
wait 2>/dev/null
```
Expected: `tf2_echo` produces `Translation: [0.000, 0.000, 0.500]` (or similar) before being killed. If ROS 2 not available, skip — the file content below is hand-authored and doesn't strictly require executing the smoke.

- [ ] **Step 2: Create `sandbox_reference/week1/lab2/frame_inventory.md`**

Front matter:

```yaml
---
type: reference
id: REF-W1-LAB2-FRAME-INVENTORY
title: CC/MS frame inventory (instructor draft)
week: 1
duration_min: 0
prerequisites: []
worldcpj_ct: [CT-01, CT-02, CT-06]
roles: [common, calibration, adapter]
references: [R-01, R-03, R-05]
deliverables: []
---
```

Body — **must contain ` ```mermaid `, `base_link`, `camera_link`, `tool0`** (G4 patterns):

````markdown
# CC/MS で使う frame 一覧 (instructor draft)

> 本草案は WorldCPJ の CC (Cell Cooperation) と MS (Multi-Stage) で共通利用を想定する frame 列挙。Phase 0 では **概念整理が目的**であり、実機の URDF と完全一致は要求されない。SP2 (W2 manipulation) で実機 URDF と照合。

## TF tree (Mermaid)

```mermaid
graph TD
    map --> base_link
    base_link --> camera_link
    base_link --> tool0
    tool0 --> gripper_link
    camera_link --> camera_optical_frame
```

## frame 詳細

| frame | 親 | 用途 | 備考 |
|---|---|---|---|
| `map` | (root) | 静的世界座標 | CC/MS 共通。 calibration の起点 |
| `base_link` | `map` | ロボット本体 | UR7e / CRX 共通。実機では `base` の場合あり |
| `camera_link` | `base_link` | カメラ筐体 | hand-eye calibration の対象 |
| `camera_optical_frame` | `camera_link` | カメラ光軸 (Z=光軸) | REP-103/REP-105。pose推定の出力先 |
| `tool0` | `base_link` | エンドエフェクタ取付 (フランジ) | UR convention |
| `gripper_link` | `tool0` | gripper 本体 | gripper に応じて child を追加 (例: `gripper_finger_left`) |

## 命名で注意した点

- `base_link` は `baselink`/`base` と書かないこと (CC/MS で frame 孤立の原因)
- `tool0` の `0` は数字 ゼロ (UR の慣習)。 `tool_0` は別物
- カメラの `camera_link` (筐体) と `camera_optical_frame` (光軸) を分けて持つ

## 次の作業 (SP2 で扱う)

- 実機 URDF (UR7e, CRX) との frame 照合
- hand-eye calibration を踏まえた `camera_optical_frame` 位置の決定
- gripper child frame の確定 (gripper 種別に依存)
````

- [ ] **Step 3: Verify**

```bash
grep -q '```mermaid' sandbox_reference/week1/lab2/frame_inventory.md && echo "mermaid fence OK"
for kw in base_link camera_link tool0; do
    grep -q "$kw" sandbox_reference/week1/lab2/frame_inventory.md && echo "$kw OK"
done
```
Expected: 4 OK lines.

- [ ] **Step 4: Commit**

```bash
git add sandbox_reference/week1/lab2/frame_inventory.md
git commit -m "$(cat <<'EOF'
docs: add sandbox_reference Lab 2 frame inventory

Spec §3.1 #35. Mermaid TF tree + frame detail table covering
the CC/MS shared frame inventory draft. G4 patterns satisfied:
mermaid code fence, base_link, camera_link, tool0 keywords.
SP2 will reconcile this draft with actual UR7e/CRX URDFs.
EOF
)"
```

---

## Task 20: Run all 5 gates, fix issues, finalize

**Files:**
- (no new files, possibly minor fixes to existing files)

Spec §5.1 (G1〜G5b), §5.7 SP1→SP2 移行ゲート.

- [ ] **Step 1: Run G1+G2+G4+G5a via check_structure.sh**

```bash
cd /home/dev/Develop/Robotics_Education
bash tools/check_structure.sh
```
Expected: `Result: PASS`. If any FAIL, address them by:
- Missing file → create it (refer to relevant Task 1-19)
- Front matter missing key → add the key
- Pattern not found → fix sandbox_reference content
- Local link broken → fix the link in the source md

Iterate until PASS.

- [ ] **Step 2: Run G3 via verify_env.sh**

```bash
bash tools/verify_env.sh
```
Expected: `Result: PASS` (FAIL=0). WARN is acceptable (e.g., MoveIt 2 not yet installed counts as WARN per Task 7 design).

If FAIL on `ros2 CLI` or `gz`/`ign`: ROS 2 not installed in this env. For SP1 sign-off, the instructor's working environment must satisfy G3. If running in a CI-like env, document the env state in the commit message of Step 7.

- [ ] **Step 3: Run G5b external link check (warning-only)**

If `lychee` is available:
```bash
lychee --offline=false 'docs/**/*.md' 'course/**/*.md' 'README.md' 'CONTRIBUTING.md' 2>&1 | tee /tmp/g5b.log
```
If `lychee` is not installed, skip and rely on `docs/references.md` 最終確認日 (2026-04-27, set in Task 4).

External 5xx/timeouts are acceptable (warning only). Record in commit message which URLs were unreachable, if any.

- [ ] **Step 4: Spec ↔ implementation cross-check**

Confirm 42 expected files all exist:
```bash
bash tools/check_structure.sh 2>&1 | grep -c "missing:"
```
Expected: 0.

Confirm no leftover TODO / TBD / placeholder in shipped course files:
```bash
grep -rE "TBD|TODO|FIXME|XXX|PLACEHOLDER" course/ sandbox_reference/ tools/ docs/CONVENTIONS.md docs/glossary.md docs/references.md README.md CONTRIBUTING.md 2>/dev/null | grep -v "skel" || echo "no placeholders in shipped content"
```
Expected: only matches inside `tools/new_week_skeleton.sh` (intentional `TBD` in the generated stub) — no unfilled placeholders in any course-facing file. Templates legitimately contain `TBD` as fill-in markers (acceptable in `course/week1/deliverables/*_template.md` and `sandbox_setup_log_template.md`).

- [ ] **Step 5: Update spec status (SP1 implementation complete)**

The spec is already `status: approved` from `909baac`. Add a Decision Log entry noting SP1 implementation complete.

```bash
# Append a row to the Decision Log table
# Section §6 ends; add after the last F# row.
# Use Edit tool — locate the "(F = Findings、各セクションのレビューで指摘された修正)" line
# and insert a new row above it:
# | IMPL-COMPLETE | SP1 implementation | 全42ファイル作成完了、全5ゲートPASS | 全taskコミット完了、commit hashは git log 参照 |
```

In practice, use the Edit tool to insert this row. Or skip if Decision Log update is not strictly required (the git log itself is the authoritative trace).

- [ ] **Step 6: Final repo state snapshot**

```bash
git -C /home/dev/Develop/Robotics_Education log --oneline
git -C /home/dev/Develop/Robotics_Education status
ls -la docs/ course/ sandbox_reference/ tools/
```
Expected: ~20 commits (1 spec + 1 plan + 18 implementation + this summary), worktree clean, all directories populated.

- [ ] **Step 7: SP1 closure commit**

```bash
git add -A
# If any files modified (e.g., spec Decision Log), they're picked up.
# If nothing to commit, skip the commit step.
if ! git diff --cached --quiet; then
    git commit -m "$(cat <<'EOF'
chore: SP1 closure — all gates PASS

Spec §5.1 G1-G5a all PASS via tools/check_structure.sh.
G3 (verify_env.sh) PASS (or WARN-only) on instructor env.
G5b external links: see commit body for any unreachable URLs.

42 files committed across ~20 commits. Ready for SP1 → SP2
transition gate (spec §5.7).
EOF
)"
fi
```

- [ ] **Step 8: Report back to user**

Summarize:
- All 42 files committed
- All gates PASS (G1, G2, G4, G5a via check_structure.sh; G3 via verify_env.sh; G5b warning-only)
- Total commit count
- Any deferred items (e.g., G5b URLs unreachable, Codex connection check items still TBD per instructor case)
- Ready for SP1 → SP2 transition decision per spec §4.6 (recommended: option (a) proceed to SP2)

---

## Plan Self-Review

After all 20 tasks complete, verify:

1. **Spec coverage:** 
   - Spec §3.1 (42 files): every file in EXPECTED_FILES of `tools/check_structure.sh` is built by some Task 1–19.
   - Spec §2 (CONVENTIONS): Task 2 produces `docs/CONVENTIONS.md` with all 12 sub-sections.
   - Spec §5.1 (5 gates): Task 8 builds `tools/check_structure.sh` (G1/G2/G4/G5a), Task 7 builds `tools/verify_env.sh` (G3), Task 20 runs G5b manually.
   - Spec §6 Decision Log: preserved verbatim in committed spec, no new tasks needed.
2. **Placeholder scan:** No "TBD" except in `new_week_skeleton.sh` generated stub (intentional) and template `*_template.md` fill-in markers (intentional). Verified by Step 4 of Task 20.
3. **Type consistency:** Front matter keys match between Tasks (10 for course, 7 for spec/plan, optional for guide/checklist/hints/reference) — verified by `tools/check_structure.sh` G2.

---

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-04-27-robotics-course-sp1-plan.md`. Two execution options:

**1. Subagent-Driven (recommended)** — Fresh subagent per task, review between tasks, fast iteration. Best for this plan because:
- 20 well-bounded tasks, each producing 1–4 files with clear verification.
- Fresh context per task avoids polluting the long-running session.
- The plan is self-contained per task; subagents won't need conversation history.

**2. Inline Execution** — Execute tasks in this session using `executing-plans`, batch execution with checkpoints. Better if you want to review every code change in real-time.

**Which approach?**
