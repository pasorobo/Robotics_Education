---
type: plan
id: PLAN-SP4
title: Robotics Education Course - Sub-Project 4 (Week 4 Logging / Eval / Safety + Q1 Reduced Lv1 Execution Package) 実装計画
date: 2026-04-28
status: ready
sub_project: SP4
related_spec: docs/superpowers/specs/2026-04-28-robotics-course-sp4-design.md
---

# Robotics Education Course — SP4 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build SP4 (Week 4 教材) — final state 128 files (SP3 base 100 + SP4 new 28: 26 course/sandbox + 1 spec + 1 plan), satisfying 5 verification gates (G1, G2, G3 via `--week 4`, G4 with ~90 positive + 4 must-not + 3 negative-example patterns, G5a). 28 new files + 5 modified files.

**Architecture:** Mono-repo continuation from SP3. New `course/week4/` (Lecture 2 + Lab 3 + Template 4 + README = 16 files) + `sandbox_reference/week4/` (10 files: 6 top-level examples + 3 lab walk-through README + 1 optional Codex example). Tool extensions: `tools/verify_env.sh` gains `--week 4` mode (ros2 bag + rosbag2 default storage required, MCAP plugin Stretch=WARN, MoveIt2/Gazebo/ros2_control SKIP, repo-root-based Lab 7 evidence check); `tools/check_structure.sh` adds W4 expected files + ~90 positive G4 patterns + 4 must-not patterns + 3 negative-example patterns + helpers (`check_pattern_must_strip` for inline-code-stripped must-not, `check_pattern_negative_example` wrapper). Two-axis policy continued: 全員ベースライン = template + structured fill + paper exercise、instructor sandbox_reference = 手書き fill demo (Codex 利用なし、Lab 8b は Codex 任意 example も同梱).

**Tech Stack:** Markdown (with YAML front matter), Bash 5.x, Python 3.10+ (for ros_pkg_or_deb helper invocation, no new Python source), rosbag2 (reuse SP1 W1 bag, no new recording), ros2_doctor (Q1 W1 preflight reference, not directly invoked by SP4 gates).

**Authoritative reference:** `docs/superpowers/specs/2026-04-28-robotics-course-sp4-design.md` (commit `316180e`, status approved). When in doubt, defer to spec §-numbers cited in each task.

**Pre-conditions already satisfied:**
- SP1 + SP2 + SP3 complete and merged to `main` (HEAD `316180e`, 100 tracked files at SP3 close)
- SP4 design spec written and approved (`316180e`)
- Local git identity: `pasorobo` / `goo.mail01@yahoo.com`
- ROS 2 Humble + git + python3 + bash + colcon installed (verified by SP3 G3)
- SP1 W1 Lab 1 turtlesim bag evidence present (`sandbox_reference/week1/lab1/{bag_info.txt, rosbag_metadata.yaml, terminal_5min.log}`) — Lab 7 reuses these
- `ros-humble-rosbag2-storage-default-plugins` installed in SP1 setup (no new sudo required for SP4)
- MCAP plugin (`ros-humble-rosbag2-storage-mcap`) is Stretch — verify_env --week 4 will WARN if absent, no FAIL

**Working branch:** Create `course/sp4-week4-logging-safety-q1package` from `main` at start (Task 0 below). All work in this plan happens on that branch. Merge to `main` only after Task 18 (final 5-gate validation).

**Total tasks:** 18 (numbered T1–T18) + initial Task 0 (branch setup).

---

## Conventions for Plan Execution

- **Each task ends with a commit.** Commit prefixes per CONVENTIONS.md §2.1: `feat:`, `docs:`, `lab:`, `tool:`, `resource:`, `chore:`, `fix:`, `spec:`.
- **Commit author/email** is set per-repo to `pasorobo` / `goo.mail01@yahoo.com`. Do not change.
- **No Co-Authored-By trailer.** Do not add `Co-Authored-By:` lines or any reference to AI/coding agents in commit messages (per memory file `feedback_commit_style.md`).
- **G3 expectation for SP4**: `verify_env.sh --week 4` should PASS with at most 1 WARN (MCAP plugin). MCAP is Stretch — never FAIL on its absence.
- **Documentation files** must follow CONVENTIONS.md §2 (front matter, naming). When in conflict between this plan and CONVENTIONS.md, **CONVENTIONS.md wins**.
- **Two-stage check_structure.sh activation (spec §11.1, §12.2)**:
  - T2 adds **framework only** (helpers + empty arrays/no-op extensions). Mid-tasks T5-T16 commits do NOT add SP4 expected files / G4 patterns to the active validator.
  - T17 is the **SP4 strict activation** task: populates EXPECTED_FILES with SP4 entries, COURSE_TEN_KEY_FILES with SP4 entries, and inserts ~90 `check_pattern_must` + 4 `check_pattern_must_not_strip` + 3 `check_pattern_negative_example` calls.
- **`artifact_status` placement (spec §3.3, §9.2)**: front matter is the existing 10-key (no new key added). `artifact_status: <value>` lives in the **body** (typically near the top, in a YAML-like block or as a labeled line). G4 검사 sees it via `grep`.
- **Bad example handling**: `sandbox_reference/week4/bad_q1_package_example.md` is intentionally invalid. It is excluded from positive G4 patterns (T17 wraps it), checked by 3 negative-example must-patterns, and excluded from G5a local-link checks (use plain text path placeholders, not Markdown links).
- **L8 `non-recoverable` rule (spec §5.2)**: L8 lecture body must NOT contain the literal string `non-recoverable`. The reason is recorded in spec only.

---

## Task 0: Branch setup

**Files:**
- (no file changes; git branch only)

- [ ] **Step 1: Confirm baseline state**

```bash
git rev-parse HEAD
git status --short
git ls-files | wc -l
```
Expected: HEAD = `316180e` (or descendant), no untracked, file count = `101` (SP3 close 100 + SP4 spec 1).

- [ ] **Step 2: Create and switch to working branch**

```bash
git checkout -b course/sp4-week4-logging-safety-q1package
```
Expected: switched to a new branch.

- [ ] **Step 3: Verify identity**

```bash
git config user.name
git config user.email
```
Expected: `pasorobo` and `goo.mail01@yahoo.com`. If different, do NOT change global; instead fix local: `git config user.name pasorobo && git config user.email goo.mail01@yahoo.com`.

- [ ] **Step 4: No commit yet** (branch creation alone is not committed). Move to Task 1.

---

## Task 1: docs/references.md に R-28〜R-32 追加

**Files:**
- Modify: `docs/references.md` (append 5 entries: R-28 rosbag2, R-29 MCAP plugin, R-30 UR e-stop, R-31 UR safety, R-32 ISO 10218)

Spec §13.

- [ ] **Step 1: Inspect current references.md**

```bash
tail -20 docs/references.md
grep -cE "^- R-[0-9]+|^R-[0-9]+" docs/references.md
```
Note the existing format (look at how R-1 to R-27 are formatted) so the new entries match.

- [ ] **Step 2: Append R-28〜R-32**

Append the following block at the end of `docs/references.md` (preserve existing entries; match the indentation/markup style observed in Step 1):

```markdown

## SP4 (Week 4 — Logging / Eval / Safety + Q1 Package)

- **R-28** ROS 2 Humble — `ros2 bag` CLI tutorial / package docs. Topic recording (`record`/`play`/`info`), default storage backend `sqlite3`. <https://docs.ros.org/en/humble/Tutorials/Beginner-CLI-Tools/Recording-And-Playing-Back-Data/Recording-And-Playing-Back-Data.html>
- **R-29** ROS 2 — `rosbag2_storage_mcap` storage plugin (adds MCAP file format support to rosbag2; invoked with `--storage mcap`). <https://github.com/ros-tooling/rosbag2_storage_mcap>
- **R-30** Universal Robots — Emergency Stop note. "The emergency stop is a complementary protective measure, not a safeguard. It is not designed to prevent injury." (instructional reference only). <https://www.universal-robots.com/articles/ur/safety/emergency-stop/>
- **R-31** Universal Robots — Safety overview / manual reset procedure for emergency stop (instructional reference only). <https://www.universal-robots.com/articles/ur/safety/>
- **R-32** ISO 10218-1:2025 (Robotics — Safety requirements — Part 1: Industrial robots) and ISO 10218-2:2025 (Part 2: Industrial robot applications and robot cells). Use as overview reference only; the course does not reproduce paid standard text. <https://www.iso.org/standard/73933.html>
```

- [ ] **Step 3: Verify R-28〜R-32 present**

```bash
for n in 28 29 30 31 32; do
    grep -qE "R-${n}\b" docs/references.md && echo "R-${n} OK"
done
```
Expected: 5 lines, all `OK`.

- [ ] **Step 4: Commit**

```bash
git add docs/references.md
git commit -m "$(cat <<'EOF'
docs: add R-28..R-32 references for SP4 (rosbag2, MCAP, UR safety, ISO 10218)

Spec §13. Appends the 5 references cited by SP4 lectures L7 (rosbag2,
MCAP plugin) and L8 (UR emergency stop / safety overview, ISO 10218
part 1/2 of 2025). UR references are instructional examples only;
ISO 10218 is overview-only and not reproduced in course material.
EOF
)"
```

---

## Task 2: tools/check_structure.sh — validation framework 拡張 (helpers のみ、SP4 strict mode は未起動)

**Files:**
- Modify: `tools/check_structure.sh` (add 3 new helpers: `check_pattern_must_strip` for must-not with inline-code strip, `check_pattern_negative_example` wrapper, `_strip_inline_code` filter. NO SP4 EXPECTED_FILES / COURSE_TEN_KEY_FILES / pattern calls yet — that goes to T17.)

Spec §9.4.1, §9.4.2, §11.1 risk row "T2/T3 早期有効化", §12.1 T2.

- [ ] **Step 1: Read current check_structure.sh tail**

```bash
sed -n '200,260p' tools/check_structure.sh
```
Verify existing helpers `check_pattern_must`, `check_pattern_must_not`, `check_pattern`, `check_min_size`, `check_python_syntax` are present (added in SP1-SP3).

- [ ] **Step 2: Insert `_strip_inline_code` and `check_pattern_must_strip` after the existing `check_python_syntax`**

Locate the end of the `check_python_syntax()` function (closing brace `}` followed by a blank line, before the `# ---------- G4: Sandbox content patterns ----------` header). Insert immediately before that header:

```bash
# Strip Markdown inline code (`...`) and fenced code blocks (```...```) from a file.
# Used by must-not patterns to avoid false positives where a forbidden literal is
# only mentioned inside a code span as instructional reference.
_strip_inline_code() {
    local f="$1"
    awk '
        /^```/ { inblock = !inblock; next }
        !inblock { gsub(/`[^`]*`/, ""); print }
    ' "$f"
}

# Like check_pattern_must_not, but strips inline-code / fenced code blocks first.
# Used for SP4 L8 lecture must-not patterns (e.g. "non-recoverable" used in code
# fences for educational citation must not trigger; only prose mentions fail).
check_pattern_must_not_strip() {
    local f="$1"
    local pattern="$2"
    local label="$3"
    if [[ ! -f "$f" ]]; then
        warn "missing for must-not-strip-pattern check (covered by G1): $f"
        return
    fi
    if _strip_inline_code "$f" | grep -qE "$pattern"; then
        err "$f: must-not-pattern matched after stripping inline code ($label): /$pattern/"
    else
        ok
    fi
}

# Negative-example must-pattern: same semantics as check_pattern_must, but the
# label makes it explicit this is asserting a marker required ONLY in a
# deliberately-invalid example file (e.g. bad_q1_package_example.md).
check_pattern_negative_example() {
    local f="$1"
    local pattern="$2"
    local label="$3"
    if [[ ! -f "$f" ]]; then
        warn "missing for negative-example check (covered by G1): $f"
        return
    fi
    if grep -qE "$pattern" "$f"; then
        ok
    else
        err "$f: negative-example marker not found ($label): /$pattern/"
    fi
}
```

- [ ] **Step 3: Verify the file still parses (no syntax error)**

```bash
bash -n tools/check_structure.sh
```
Expected: exit 0 (no output on success).

- [ ] **Step 4: Run check_structure.sh and confirm SP3 baseline still PASSes**

```bash
bash tools/check_structure.sh; echo "exit=$?"
```
Expected: exit 0 (the helpers are defined but not yet called for any SP4 file). All SP1-SP3 patterns continue to PASS.

- [ ] **Step 5: Commit**

```bash
git add tools/check_structure.sh
git commit -m "$(cat <<'EOF'
tool: add SP4 G4 framework helpers (strip-inline-code, negative-example)

Spec §9.4.1-§9.4.2. Adds three helpers without yet invoking them:
- _strip_inline_code: filters inline `...` spans and fenced ``` blocks
- check_pattern_must_not_strip: must-not check on stripped content (used
  for L8 lecture's "non-recoverable" rule where fenced citation must
  not trigger false positive)
- check_pattern_negative_example: must-marker check for files
  intentionally invalid (sandbox_reference/week4/bad_q1_package_example.md)

SP4 EXPECTED_FILES and pattern calls are intentionally NOT added here;
they activate in Task 17 once all referenced files exist. Until then,
mid-tasks can commit without G1/G4 false negatives.
EOF
)"
```

---

## Task 3: tools/check_structure.sh — SPEC_KEYS / PLAN_KEYS リスト確認 (SP4 spec/plan 用 entry 追加)

**Files:**
- Modify: `tools/check_structure.sh` (extend `SPEC_FILES` array to include SP4 spec; `PLAN_FILES` to include SP4 plan)

Spec §9.2.

- [ ] **Step 1: Inspect current SPEC_FILES / PLAN_FILES**

```bash
sed -n '218,240p' tools/check_structure.sh
```
Confirm presence of SP1/SP2/SP3 spec and plan entries.

- [ ] **Step 2: Add SP4 entries**

Edit the `SPEC_FILES=(...)` array to add the SP4 design spec path on a new line before the closing `)`:

```bash
    "docs/superpowers/specs/2026-04-28-robotics-course-sp4-design.md"
```

Edit the `PLAN_FILES=(...)` array to add the SP4 plan path on a new line before the closing `)`:

```bash
    "docs/superpowers/plans/2026-04-28-robotics-course-sp4-plan.md"
```

- [ ] **Step 3: Run check_structure.sh — both SP4 docs should PASS the 7-key G2 check**

```bash
bash tools/check_structure.sh 2>&1 | grep -E "(spec|plan).*sp4" -i
bash tools/check_structure.sh; echo "exit=$?"
```
Expected: SP4 spec PASSes (7-key front matter present, written in Task 14 / spec already committed). SP4 plan: at this moment the file exists (this very plan was just created). Exit 0.

- [ ] **Step 4: Commit**

```bash
git add tools/check_structure.sh
git commit -m "$(cat <<'EOF'
tool: register SP4 spec/plan in G2 7-key validation

Spec §9.2. Adds SP4 design spec and SP4 plan to SPEC_FILES /
PLAN_FILES arrays so check_structure.sh's existing 7-key
(type/id/title/date/status/sub_project/related_*) validation covers
them. Course 10-key COURSE_TEN_KEY_FILES list is NOT extended here;
SP4 course/sandbox files are added in Task 17 with the strict
activation pass.
EOF
)"
```

---

## Task 4: tools/verify_env.sh — `--week 4` mode + `has_ros_pkg_or_deb` helper

**Files:**
- Modify: `tools/verify_env.sh` (add `--week 4` branch with: `has_ros_pkg_or_deb` helper, behaviour-first checks, repo-root-based Lab 7 evidence check, MCAP Stretch=WARN, all other Gazebo/MoveIt/ros2_control SKIP)

Spec §9.3, §11.1 risk row "ros2 pkg list 空返却", §12.4.

- [ ] **Step 1: Read current verify_env.sh structure**

```bash
sed -n '1,50p' tools/verify_env.sh
sed -n '90,151p' tools/verify_env.sh
```
Note: `WEEK_MODE` argument parser already exists; existing branches handle `--week 2` and `--week 3`. Help text must be updated.

- [ ] **Step 2: Update `--help` block**

Find the `--help|-h)` case branch and the `cat <<'EOH'` heredoc inside. Add a new line for `--week 4` after the `--week 3` line, before the `--week N : reserved` line:

```
  --week 4   : SP4 mode (ros2 bag + rosbag2 default storage required, MCAP Stretch=WARN, MoveIt/Gazebo/ros2_control SKIP, Lab 7 source bag evidence required)
```

- [ ] **Step 3: Insert `has_ros_pkg_or_deb` helper near other helpers**

Find the existing helper definitions (`print_check`, `check_required`, `check_either`). Immediately after `check_either` closing brace, insert:

```bash
# Returns 0 if a ROS 2 package is registered (via `ros2 pkg list`) OR the
# corresponding apt deb is installed. Used in --week 4 mode to robustly
# detect rosbag2 storage plugins regardless of whether the user has sourced
# /opt/ros/humble/setup.bash.
has_ros_pkg_or_deb() {
    local ros_pkg="$1"
    local deb_pkg="$2"
    if command -v ros2 >/dev/null 2>&1 && ros2 pkg list 2>/dev/null | grep -q "^${ros_pkg}$"; then
        return 0
    fi
    dpkg-query -W -f='${Status}' "${deb_pkg}" 2>/dev/null | grep -q "install ok installed"
}
```

- [ ] **Step 4: Compute REPO_ROOT once, near top of script**

Find the `set -uo pipefail` line. Immediately after it (and after any leading comments / before WEEK_MODE parsing), insert:

```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
```

- [ ] **Step 5: Add `--week 4` branches to existing per-section checks**

In the `[Gazebo (Fortress)]` block (the `if [[ "$WEEK_MODE" == "2" ]]; ...` chain), add a new `elif` AFTER the existing `--week 3` branch and BEFORE the trailing `else`:

```bash
elif [[ "$WEEK_MODE" == "4" ]]; then
    print_check "gazebo CLI (week 4 mode)" "SKIP" "(SP3 で扱った)"
```

In the `[MoveIt 2]` block, similarly add after the `--week 3` branch:

```bash
elif [[ "$WEEK_MODE" == "4" ]]; then
    print_check "MoveIt 2 (week 4 mode)" "SKIP" "(SP2 で扱った)"
    print_check "ros2_control (week 4 mode)" "SKIP" "(SP2 で扱った)"
    print_check "ros2_controllers (week 4 mode)" "SKIP" "(SP2 で扱った)"
    print_check "Panda config (week 4 mode)" "SKIP" "(SP2 で扱った)"
```

- [ ] **Step 6: Add new `[rosbag2 / Lab 7 evidence]` block — only runs in `--week 4` mode**

Insert the following block immediately before the existing `[Tooling]` echo line:

```bash
if [[ "$WEEK_MODE" == "4" ]]; then
    echo "[rosbag2 / Lab 7 evidence]"
    # ROS 2 sourcing
    if command -v ros2 >/dev/null 2>&1; then
        print_check "ros2 CLI available" "PASS"
        PASS=$((PASS+1))
    else
        print_check "ros2 CLI available" "FAIL" "ROS 2 environment is not sourced. Try: source /opt/ros/humble/setup.bash"
        FAIL=$((FAIL+1))
    fi
    if [[ "${ROS_DISTRO:-}" == "humble" ]]; then
        print_check "ROS_DISTRO=humble" "PASS"
        PASS=$((PASS+1))
    else
        print_check "ROS_DISTRO=humble" "FAIL" "Got: '${ROS_DISTRO:-<unset>}'"
        FAIL=$((FAIL+1))
    fi
    # ros2 bag command
    if ros2 bag --help >/dev/null 2>&1; then
        print_check "ros2 bag command" "PASS"
        PASS=$((PASS+1))
    else
        print_check "ros2 bag command" "FAIL"
        FAIL=$((FAIL+1))
    fi
    # rosbag2 default storage plugin (required)
    if has_ros_pkg_or_deb rosbag2_storage_default_plugins ros-humble-rosbag2-storage-default-plugins; then
        print_check "rosbag2 default storage" "PASS"
        PASS=$((PASS+1))
    else
        print_check "rosbag2 default storage" "FAIL" "ros-humble-rosbag2-storage-default-plugins not found"
        FAIL=$((FAIL+1))
    fi
    # Python 3.10+
    if python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3,10) else 1)' 2>/dev/null; then
        print_check "Python >= 3.10" "PASS" "$(python3 --version 2>&1)"
        PASS=$((PASS+1))
    else
        print_check "Python >= 3.10" "FAIL" "$(python3 --version 2>&1)"
        FAIL=$((FAIL+1))
    fi
    # Lab 7 source evidence (repo-root-based path)
    if [[ -f "${REPO_ROOT}/sandbox_reference/week1/lab1/bag_info.txt" ]]; then
        print_check "Lab 7 source evidence" "PASS" "sandbox_reference/week1/lab1/bag_info.txt"
        PASS=$((PASS+1))
    else
        print_check "Lab 7 source evidence" "FAIL" "Lab 7 reuses SP1 W1 Lab 1 bag evidence; complete SP1 first"
        FAIL=$((FAIL+1))
    fi
    # MCAP storage plugin (Stretch — WARN only)
    if has_ros_pkg_or_deb rosbag2_storage_mcap ros-humble-rosbag2-storage-mcap; then
        print_check "rosbag2 MCAP plugin" "PASS"
        PASS=$((PASS+1))
    else
        print_check "rosbag2 MCAP plugin" "WARN" "rosbag2_storage_mcap not found; MCAP hands-on remains Stretch"
        WARN=$((WARN+1))
    fi
fi
```

- [ ] **Step 7: Verify the file still parses**

```bash
bash -n tools/verify_env.sh
```
Expected: exit 0.

- [ ] **Step 8: Run `verify_env.sh --week 4` and inspect output**

```bash
bash tools/verify_env.sh --week 4 ; echo "exit=$?"
```
Expected: PASS section header, all required PASS, MCAP either PASS or WARN. Final exit 0 (assuming SP1 W1 Lab 1 bag evidence + ROS 2 sourced + python3 ≥ 3.10).

- [ ] **Step 9: Run `verify_env.sh --week 1` to confirm regression**

```bash
bash tools/verify_env.sh --week 1 2>&1 | tail -5 ; echo "exit=$?"
bash tools/verify_env.sh --help 2>&1 | grep "week 4"
```
Expected: Week 1 mode unchanged (default behavior). `--help` shows new `--week 4` line.

- [ ] **Step 10: Commit**

```bash
git add tools/verify_env.sh
git commit -m "$(cat <<'EOF'
tool: add verify_env.sh --week 4 mode (rosbag2 + Lab 7 evidence)

Spec §9.3, §12.4. New mode validates the SP4 logging baseline:
- ros2 CLI sourced + ROS_DISTRO=humble
- ros2 bag command available
- rosbag2_storage_default_plugins (required)
- Python 3.10+
- Lab 7 source bag evidence (sandbox_reference/week1/lab1/bag_info.txt,
  resolved via repo-root from BASH_SOURCE)
- rosbag2_storage_mcap (Stretch — WARN only)

Gazebo / MoveIt / ros2_control are SKIP in --week 4 (SP4 does not
re-require them). Adds has_ros_pkg_or_deb helper that prefers
`ros2 pkg list` and falls back to dpkg-query, so the check works
whether or not /opt/ros/humble/setup.bash has been sourced.
EOF
)"
```

---

## Task 5: course/week4/README.md

**Files:**
- Create: `course/week4/README.md` (Week 4 index, `type: week`, follows W1-W3 README convention)

Spec §4.2 course/week4/, §6 (lab summaries).

- [ ] **Step 1: Inspect Week 3 README front matter for format**

```bash
head -15 course/week3/README.md
```
Note: 10-key front matter `type/id/title/week/duration_min/prerequisites/worldcpj_ct/roles/references/deliverables`.

- [ ] **Step 2: Create directory and write README.md**

```bash
mkdir -p course/week4
```

Then create `course/week4/README.md` with this exact content:

````markdown
---
type: week
id: W4-README
title: Week 4 - Logging / Evaluation / Safety + Q1 Reduced Lv1 Execution Package
week: 4
duration_min: 420
prerequisites: [W3-Lab5, W3-Lab6, W3-Lab6b]
worldcpj_ct: [CT-04, CT-05, CT-06, CT-09]
roles: [common, logging, safety, sandbox]
references: [R-28, R-29, R-30, R-31, R-32]
deliverables: [episode_record, trial_sheet, safety_checklist, q1_reduced_lv1_execution_package]
---

# Week 4 — Logging / Evaluation / Safety + Q1 Reduced Lv1 Execution Package

Phase 0 最終週。W1-W3 で作った 3 templates (sandbox_setup_log, robot_readiness_mini_report, simulation_bridge_draft) を Q1 移行 artifact として束ねる。

## 学習目標

1. **rosbag2 + episode_record の理解** — 1 task attempt の構造化記録を書ける (Lab 7)
2. **Safety SOP / safe no-action / operator confirmation の語彙獲得** — Phase 0 と Q1 の境界を理解する (L8)
3. **Q1 縮小 Lv1 Execution Package の作成能力** — W1-W3 templates を `source_artifact_path` で参照しながら、Q1 W1 開始前に必要な meta plan を書ける (Lab 8)
4. **Sandbox W1-W4 最終レビューと Q1 移行教訓の言語化** — Codex 利用は **任意** (Lab 8b)

## Lectures

- [L7 — rosbag2 / MCAP / episode_record](./lectures/l7_rosbag2_mcap_episode_record.md)
- [L8 — Safety SOP / safe no-action / Phase 0 vs Q1 boundary](./lectures/l8_safety_sop_safe_no_action.md)

## Labs

- [Lab 7 — episode_record 記入演習 (W1 turtlesim bag 再利用)](./labs/lab7_episode_record/README.md)
- [Lab 8 — Q1 Package + safety_checklist + trial_sheet skeleton 統合](./labs/lab8_q1_execution_package/README.md)
- [Lab 8b — Sandbox 最終レビュー (Codex 任意)](./labs/lab8b_sandbox_final_review/README.md)

## Templates (deliverables)

- [episode_record_template](./deliverables/episode_record_template.md) — 1 task attempt の構造化記録
- [trial_sheet_template](./deliverables/trial_sheet_template.md) — N trials 集計表 (5 objects × 3 trials)
- [safety_checklist_template](./deliverables/safety_checklist_template.md) — pre-execution safety 確認 (Phase 0 では training draft)
- [q1_reduced_lv1_execution_package_template](./deliverables/q1_reduced_lv1_execution_package_template.md) — **Q1 全体 meta package** (Phase 0 → Q1 handoff artifact 自体)

## Sandbox reference

`sandbox_reference/week4/` 以下に instructor walk-through (10 files): 6 top-level fill examples + 3 lab walk-through README + 1 optional Codex pattern extract example。

## Phase 0 完了について

本 Week 4 完了をもって Phase 0 教材は揃う。**Phase 0 完了宣言は控えめに**、Q1 移行条件 (safety review / `q1_w1_preflight` / pilot trial / `re_judge_gates` 4 件 review) を Q1 Package 上で確認すること。Formal handover ceremony / 別文書は out-of-scope — Q1 Package 自体が handoff artifact として機能する。
````

- [ ] **Step 3: Verify front matter parses**

```bash
awk '/^---$/{c++; if(c==2)exit; next} c==1' course/week4/README.md | grep -E "^(type|id|title|week|duration_min|prerequisites|worldcpj_ct|roles|references|deliverables):"
```
Expected: 10 lines printed (one per key).

- [ ] **Step 4: Commit**

```bash
git add course/week4/README.md
git commit -m "$(cat <<'EOF'
docs: add course/week4 README (Logging/Eval/Safety + Q1 Package)

Spec §4.2. type:week, 10-key front matter (W1-W3 precedent), references
R-28..R-32, deliverables = 4 SP4 templates. Includes lecture / lab /
template index, sandbox_reference pointer, and explicit note that
Phase 0 completion is gated on Q1 Package review (not a formal
ceremony).
EOF
)"
```

---

## Task 6: course/README.md + root README.md に Week 4 entry 追加

**Files:**
- Modify: `course/README.md` (append Week 4 entry to course-level index)
- Modify: `README.md` (root) — add `## SP4で何ができるか` section + update 今後の予定 table

Spec §4.3, §12.1 T6.

- [ ] **Step 1: Inspect course/README.md current Week list**

```bash
grep -nE "Week [0-9]" course/README.md
```
Find the position of the existing Week 1/2/3 entries.

- [ ] **Step 2: Append Week 4 entry to course/README.md**

In the section that lists Weeks (after Week 3 entry), add:

```markdown
- [Week 4 — Logging / Evaluation / Safety + Q1 Reduced Lv1 Execution Package](./week4/README.md)
```

If course/README.md uses a table format for weeks, add a new row matching the existing column structure: `| 4 | Logging / Eval / Safety + Q1 Package | course/week4/ |` (adapt to actual columns).

- [ ] **Step 3: Inspect root README.md SP3 section as template**

```bash
grep -nE "SP[0-9]で何ができるか|今後の予定" README.md | head -10
```

- [ ] **Step 4: Add `## SP4で何ができるか` to root README.md**

After the existing `## SP3で何ができるか` section and before the `## 今後の予定` table, insert:

```markdown
## SP4で何ができるか

Week 4 教材一式 (Phase 0 最終週):

- **rosbag2 + episode_record の理解 + 1 task attempt 構造化記録** (Lab 7) — SP1 W1 Lab 1 turtlesim bag を再利用、`q1_package_id: not_applicable` / `trial_id: training_*` / `environment_mode: mock` で Q1 trial と区別
- **Safety SOP / safe no-action / Phase 0 vs Q1 境界の語彙獲得** (L8) — UR safety references は instructional examples、ISO 10218-1/-2:2025 は overview のみ
- **Q1 Reduced Lv1 Execution Package の作成 (3 templates 統合)** (Lab 8) — Q1 Package 8 行で W1-W3 artifacts を `source_artifact_path` で参照、`q1_w1_preflight` 8 項目 + `re_judge_gates` 4 件 (`q1_w1_pre_start` / `q1_w1_exit` / `q1_mid_point` / `q1_closeout`) 必須
- **Sandbox W1-W4 最終レビュー + Q1 移行教訓** (Lab 8b) — **Codex 利用は任意**、human-found patterns 5+ + Q1 migration lessons 3+ 必須

提出物テンプレート 4 件:

- episode_record_template (1 task attempt)
- trial_sheet_template (15 planned rows skeleton)
- safety_checklist_template (Phase 0 では `training_draft_only`)
- q1_reduced_lv1_execution_package_template (**Phase 0 → Q1 handoff artifact 自体**)

Phase 0 完了宣言は控えめに。Q1 移行は Q1 Package §8 safety review + `q1_w1_preflight` 8 項目 + 1 pilot trial review が完了してから。
```

Update `## 今後の予定` table SP4 row from `W4 Logging/Eval/Safety` (planned) to:

```markdown
| SP4 | **完了 (Week 4 — Logging / Eval / Safety + Q1 Reduced Lv1 Execution Package)** |
```

- [ ] **Step 5: Verify additions**

```bash
grep -q "Week 4 — Logging" course/README.md && echo "course README W4 OK"
grep -q "SP4で何ができるか" README.md && echo "root README SP4 section OK"
grep -q "完了 (Week 4" README.md && echo "今後の予定 SP4 完了 OK"
```
Expected: 3 `OK`.

- [ ] **Step 6: Commit**

```bash
git add course/README.md README.md
git commit -m "$(cat <<'EOF'
docs: index Week 4 in course README and root README

Spec §4.3, §12.1 T6. Adds Week 4 entry to course-level index and a
new "SP4で何ができるか" section to the root README summarising the 4
deliverables (episode_record / trial_sheet / safety_checklist / Q1
Package). Updates 今後の予定 table to mark SP4 as complete.
EOF
)"
```

---

## Task 7: course/week4/lectures/l7_rosbag2_mcap_episode_record.md

**Files:**
- Create: `course/week4/lectures/l7_rosbag2_mcap_episode_record.md` (`type: lecture`, ~150 行、9 sections per spec §5.1)

Spec §5.1, §9.4.3 L7 patterns.

- [ ] **Step 1: Create directory and write lecture**

```bash
mkdir -p course/week4/lectures
```

Then write `course/week4/lectures/l7_rosbag2_mcap_episode_record.md`. Use the following structure exactly. Prose for each section should be 1-3 paragraphs in Japanese; the **G4 must-include keywords are listed beside each section** — every keyword listed must appear in the section's body.

````markdown
---
type: lecture
id: W4-L7
title: Lecture 7 — rosbag2 / MCAP / episode_record
week: 4
duration_min: 60
prerequisites: [W1-Lab1]
worldcpj_ct: [CT-04, CT-05]
roles: [common, logging]
references: [R-28, R-29]
deliverables: [episode_record]
---

# Lecture 7 — rosbag2 / MCAP / episode_record

## 目的

`rosbag2` は ROS 2 標準の record/replay tool。**MCAP** は rosbag2 の storage plugin。`episode_record` は **1 task attempt** の構造化記録。本講では bag → episode_record の mapping を学ぶ。

## 1. rosbag2 全体像

`rosbag2` は `record` / `play` / `info` の 3 コマンド構成。SP1 W1 Lab 1 で実走済 (再 install 不要)。デフォルト storage backend は `sqlite3`、MCAP は plugin として追加可能 (R-28)。

[必須 G4 keywords: `rosbag2`]

## 2. SP1 W1 Lab 1 reuse 案内

Lab 7 では新たに録画せず、`sandbox_reference/week1/lab1/{bag_info.txt, rosbag_metadata.yaml, terminal_5min.log}` を再利用する。raw bag の commit は不要。

## 3. MCAP storage plugin

`ros-humble-rosbag2-storage-mcap` を install すると `--storage mcap` が使える (R-29)。**Phase 0 では Stretch (install 任意)**。verify_env --week 4 でも MCAP 不在は WARN のみ、FAIL にはしない。

[必須 G4 keywords: `MCAP`, `Stretch` または `任意`]

## 4. episode_record の意味

1 task attempt の構造化記録。N trials の集計は `trial_sheet` が担当 (責務分離)。

[必須 G4 keywords: `episode_record`]

## 5. bag → episode_record mapping

`ros2 bag info` の出力を episode_record の field に mapping する:

- Files / Bag size / Storage id → `log_summary`
- **Duration → `duration_sec`**
- Start / End が出力に含まれる場合のみ → `start_time` / `end_time`
- Topic information → `recorded_topics`
- raw bag は commit せず、`bag_info.txt` / `rosbag_metadata.yaml` / terminal log を **`evidence_path`** に格納

[必須 G4 keywords: `duration_sec`, `evidence_path`]

## 6. failure_reason taxonomy

`failure_reason` は以下の 11 値 (10 失敗 taxonomy + `none`):

`none | perception_failure | planning_failure | control_or_execution_failure | sim_bridge_failure | environment_or_setup_failure | safety_blocked | operator_error | logging_or_data_failure | unknown`

`result` と分離。`result: success` の場合 `failure_reason: none` 必須。Phase 0 では分類不確実なら `unknown` 容認 (空欄 NG)。

[必須 G4 keywords: `failure_reason`, `taxonomy`]

## 7. Humble baseline 注記

`ros2 bag` は **topic recording** を扱う。MCAP install / MCAP recording は Stretch。**`services/actions recording` は Course baseline 範囲外** (個別検証時のみ扱う)。

[必須 G4 keywords: `services/actions recording`, `Course baseline 範囲外` または `out of scope for the Course baseline`]

## 8. よくある誤解

1. raw bag を commit する → NG。軽量証跡 (bag_info.txt, metadata.yaml) のみ commit
2. episode_record と trial_sheet を混同 → NG。1 attempt vs N trials 集計
3. MCAP を Phase 0 必須と誤認 → NG。Stretch
4. Duration から start/end を推定 → NG。Start/End が出力に含まれる場合のみ mapping

## 次のLab

→ [Lab 7 — episode_record 記入演習](../labs/lab7_episode_record/README.md)
````

- [ ] **Step 2: Verify all L7 G4 patterns**

```bash
F=course/week4/lectures/l7_rosbag2_mcap_episode_record.md
for kw in rosbag2 MCAP episode_record failure_reason taxonomy duration_sec evidence_path; do
    grep -qF "$kw" "$F" && echo "L7 must $kw OK" || echo "L7 FAIL: $kw missing"
done
grep -qF "services/actions recording" "$F" && echo "L7 must 'services/actions recording' OK"
grep -qE "(Stretch|任意)" "$F" && echo "L7 must Stretch|任意 OK"
grep -qE "(Course baseline 範囲外|out of scope for the Course baseline)" "$F" && echo "L7 must baseline OK"
```
Expected: 10 `OK`, 0 `FAIL`.

- [ ] **Step 3: Commit**

```bash
git add course/week4/lectures/l7_rosbag2_mcap_episode_record.md
git commit -m "$(cat <<'EOF'
feat: add Lecture 7 (rosbag2 / MCAP / episode_record)

Spec §5.1. 9-section lecture: rosbag2 overview, SP1 W1 reuse, MCAP
plugin (Stretch), episode_record concept, bag→episode_record mapping
(Duration→duration_sec, evidence_path for lightweight evidence),
failure_reason taxonomy with result-vs-failure_reason separation,
Humble baseline note (services/actions recording is out of scope for
the Course baseline), common misconceptions. References R-28, R-29.
EOF
)"
```

---

## Task 8: course/week4/lectures/l8_safety_sop_safe_no_action.md

**Files:**
- Create: `course/week4/lectures/l8_safety_sop_safe_no_action.md` (`type: lecture`, ~180 行、10 sections per spec §5.2). **Body must NOT contain literal `non-recoverable`.**

Spec §5.2, §9.4.3 L8 must / must-not patterns, §11.4.

- [ ] **Step 1: Write the lecture**

Create `course/week4/lectures/l8_safety_sop_safe_no_action.md` with the following structure. **G4 must-include keywords listed; G4 must-NOT (after inline-code strip) listed at end.**

````markdown
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
3. operator confirmation で safety review を代替 → NG

## 次のLab

→ [Lab 8 — Q1 Reduced Lv1 Execution Package 統合](../labs/lab8_q1_execution_package/README.md)
````

**Important must-NOT rules** (G4 strip-inline-code check, spec §11.4):
- The literal string `non-recoverable` MUST NOT appear in the prose. (It may appear inside backticks `` `non-recoverable` `` only — but for safety, avoid entirely.)
- The bare phrases `自動復帰する` / `自動復帰できる` / `auto resume allowed` / `operator confirmation で safety review を代替` MUST NOT appear in prose.

The phrase `自動復帰しない` (with `しない`) IS allowed and used in §2 above.

- [ ] **Step 2: Verify all L8 must / must-not patterns**

```bash
F=course/week4/lectures/l8_safety_sop_safe_no_action.md

# must (positive)
for kw in "emergency stop" "safeguard" "protective" "not_normal_stop" "not_auto_resume" "safe no-action" "operator confirmation" "training draft" "ISO 10218"; do
    grep -qF "$kw" "$F" && echo "L8 must '$kw' OK" || echo "L8 FAIL: '$kw' missing"
done
grep -qE "(Standard Operating Procedure|SOP)" "$F" && echo "L8 must SOP OK"
grep -qE "(manual_reset_required|manual reset)" "$F" && echo "L8 must manual reset OK"
grep -qE "(not an approval artifact|approval artifact ではない)" "$F" && echo "L8 must approval artifact OK"
grep -qE "(instructional examples|教材上の例)" "$F" && echo "L8 must instructional OK"

# must-not (after stripping inline code)
STRIP=$(awk '/^```/ { inblock = !inblock; next } !inblock { gsub(/`[^`]*`/, ""); print }' "$F")
echo "$STRIP" | grep -qE "non.recoverable" && echo "L8 FAIL: non-recoverable in prose" || echo "L8 must-not non-recoverable OK"
echo "$STRIP" | grep -qE "自動復帰(する|できる)" && echo "L8 FAIL: 自動復帰する/できる in prose" || echo "L8 must-not 自動復帰する/できる OK"
echo "$STRIP" | grep -qE "auto.?resume.?allowed" && echo "L8 FAIL: auto resume allowed in prose" || echo "L8 must-not auto resume allowed OK"
echo "$STRIP" | grep -qE "operator confirmation で safety review を代替" && echo "L8 FAIL: operator confirmation 代替 in prose" || echo "L8 must-not operator confirmation 代替 OK"
```
Expected: 13 must `OK`, 4 must-not `OK`, no `FAIL`.

- [ ] **Step 3: Commit**

```bash
git add course/week4/lectures/l8_safety_sop_safe_no_action.md
git commit -m "$(cat <<'EOF'
feat: add Lecture 8 (Safety SOP / safe no-action / Phase 0 vs Q1)

Spec §5.2, §11.4. 10-section lecture covering SOP role, three-stop
operational distinction (emergency = manual_reset_required /
not_normal_stop / not_auto_resume per UR R-30/R-31), safe no-action
default, operator confirmation scope (not a safety review substitute),
SOP/safety_checklist/Q1 Package relationship, Phase 0 vs Q1 safety
boundary, mandatory disclaimer (UR refs are instructional examples;
Phase 0 safety_checklist is not an approval artifact), ISO 10218-1/-2
:2025 overview (R-32). Body deliberately avoids literal
"non-recoverable" / "自動復帰する" / "auto resume allowed" / operator-
confirmation-substitutes-safety-review per spec §11.4 must-not list.
EOF
)"
```

---

## Task 9: course/week4/deliverables/episode_record_template.md

**Files:**
- Create: `course/week4/deliverables/episode_record_template.md` (`type: template`, body has 11+ required fields)

Spec §7.1, §9.4.3 episode_record_template patterns.

- [ ] **Step 1: Create directory and write template**

```bash
mkdir -p course/week4/deliverables
```

Write `course/week4/deliverables/episode_record_template.md`:

````markdown
---
type: template
id: W4-T-EPISODE-RECORD
title: episode_record template — 1 task attempt の構造化記録
week: 4
duration_min: 30
prerequisites: [W4-L7]
worldcpj_ct: [CT-04, CT-05]
roles: [common, logging]
references: [R-28, R-29]
deliverables: [episode_record]
---

# episode_record_template

> **artifact_status**: template
>
> Phase 0 受講者は本 template を Sandbox `wk4/lab7/` にコピーし、SP1 W1 Lab 1 turtlesim bag を題材に全 field を記入する (Lab 7)。

## 設計趣旨

- 1 task attempt の構造化記録。N trials の集計は `trial_sheet` (responsibility separation)
- `result: success` の場合 `failure_reason: none` を必ず入れる (空欄 NG)
- `evidence_path` は `sandbox_reference/` 内 lightweight 証跡を指す。raw bag は commit しない
- `artifact_status: sandbox_example` の場合、`q1_package_id` / `trial_sheet_id` / `trial_id` / `object_id` は `not_applicable` または `training_*` 許容
- `artifact_status: q1_draft` 以降の場合、`q1_package_id` / `trial_id` / `object_id` は concrete value 必須

## YAML body skeleton

```yaml
artifact_status: template

# Linkage keys
episode_id:           # unique id, e.g., episode_q1_obj1_attempt1_001
q1_package_id:        # unique id | not_applicable
trial_sheet_id:       # unique id | not_applicable
trial_id:             # unique id | training_* | not_applicable
object_id:            # object_1..5 | turtlesim_training_object | not_applicable
attempt_index:        # 1-3 | null

# Environment / version
environment_mode:     # mock | sim | real
adapter_version:      # mock_adapter_v0 | not_applicable | unknown
bridge_schema_version: # provisional_v1 | not_applicable | unknown

# Logs
log_path:             # external bag path | not_applicable
evidence_path:        # sandbox_reference path | not_applicable
commit_sha:           # sandbox sha | TBD

# Time
start_time:           # ISO 8601 | TBD
end_time:             # ISO 8601 | TBD
duration_sec:         # float | TBD
recorded_topics:      # list | TBD

# Outcome
result:               # success | failure | blocked | skipped | unknown
failure_reason:       # none | perception_failure | planning_failure | control_or_execution_failure | sim_bridge_failure | environment_or_setup_failure | safety_blocked | operator_error | logging_or_data_failure | unknown
review_status:        # not_reviewed | reviewed_with_conditions | approved | blocked

notes: |
  自由記述
```

## Field 説明

各 field の値域は §3.3 / §3.4 (linkage keys / taxonomies) に従う。`result` と `failure_reason` は分離 — 例: `result: success` は必ず `failure_reason: none` を伴う。Phase 0 では `failure_reason: unknown` 容認 (空欄 NG)。
````

- [ ] **Step 2: Verify all required fields present**

```bash
F=course/week4/deliverables/episode_record_template.md
for kw in "artifact_status: template" "episode_id:" "q1_package_id:" "trial_id:" "object_id:" "environment_mode:" "adapter_version:" "bridge_schema_version:" "evidence_path:" "result:" "failure_reason:" "review_status:"; do
    grep -qF "$kw" "$F" && echo "T-EPISODE must '$kw' OK" || echo "T-EPISODE FAIL: '$kw' missing"
done
```
Expected: 12 `OK`.

- [ ] **Step 3: Commit**

```bash
git add course/week4/deliverables/episode_record_template.md
git commit -m "$(cat <<'EOF'
feat: add episode_record template (W4-T-EPISODE-RECORD)

Spec §7.1. type:template, 10-key front matter. Body declares
artifact_status:template + 18 fields covering linkage (episode_id,
q1_package_id, trial_id, object_id, attempt_index), environment
(environment_mode, adapter_version, bridge_schema_version), logs
(log_path, evidence_path, commit_sha), time (start/end/duration_sec/
recorded_topics), and outcome (result, failure_reason, review_status).
Includes the success→failure_reason:none rule and the
sandbox_example vs q1_draft linkage constraints from spec §3.3.
EOF
)"
```

---

## Task 10: course/week4/deliverables/trial_sheet_template.md

**Files:**
- Create: `course/week4/deliverables/trial_sheet_template.md` (`type: template`, structural example with 1-2 rows; 15 fully-expanded rows live in sandbox example)

Spec §7.2, §9.4.3 trial_sheet_template patterns.

- [ ] **Step 1: Write template**

````markdown
---
type: template
id: W4-T-TRIAL-SHEET
title: trial_sheet template — N trials 集計表 (5 objects × 3 trials)
week: 4
duration_min: 30
prerequisites: [W4-L7]
worldcpj_ct: [CT-05]
roles: [common, logging]
references: [R-28]
deliverables: [trial_sheet]
---

# trial_sheet_template

> **artifact_status**: template
>
> Phase 0 受講者は本 template を Sandbox `wk4/lab8/` にコピーし、**15 planned rows** を `trial_status: planned` で skeleton として作成する (Lab 8)。executed rows への更新は Q1 W1 以降の作業。

## 設計趣旨

- 1 row = 1 trial。`total_planned_rows: 15` (5 objects × 3 trials = CC Gate 0-a baseline)
- planned rows は `trial_status: planned` / `result: unknown` / `failure_reason: unknown` / `episode_id: TBD`
- executed への遷移には `episode_id` / `result` / `failure_reason` の concrete fill が必要
- `trial_status: skipped` / `blocked` 使用時は `skip_or_block_reason` 空欄 NG
- W1 turtlesim training episode は混入禁止 (Lab 7 で別途 episode_record で扱う)

## YAML body skeleton

```yaml
artifact_status: template

trial_sheet_id:        # unique id
q1_package_id:         # link to Q1 Package
safety_check_id:       # link to safety_checklist
batch_description:     # "CC Gate 0-a 5 objects × 3 trials" 等
total_planned_rows: 15

rows:
  # Row example 1 (planned)
  - trial_id: trial_001
    object_id: object_1
    attempt_index: 1
    trial_status: planned         # planned | executed | skipped | blocked
    result: unknown               # success | failure | blocked | skipped | unknown
    failure_reason: unknown       # none | <taxonomy> | unknown
    episode_id: TBD               # link to episode_record, or "TBD" if planned
    kpi_grasp_success: null       # bool, or null if planned
    kpi_time_to_grasp_sec: null   # float, or null if planned
    skip_or_block_reason: ""      # required when trial_status=skipped|blocked
    notes: ""

  # Row example 2 (executed — for reference shape only)
  - trial_id: trial_002
    object_id: object_1
    attempt_index: 2
    trial_status: executed
    result: success
    failure_reason: none
    episode_id: episode_q1_obj1_attempt2_002
    kpi_grasp_success: true
    kpi_time_to_grasp_sec: 4.2
    skip_or_block_reason: ""
    notes: |
      grasp success on 1st try
```

> **Note**: template 本体は構造例 1-2 row のみ示す。**fully expanded 15 rows skeleton は `sandbox_reference/week4/trial_sheet_example.md` に置く** (T16 で作成)。

## Phase 0 用法

15 rows を planned skeleton として作成するのが Lab 8 acceptance。空欄 NG (`unknown` / `TBD` で埋める)。
````

- [ ] **Step 2: Verify required fields**

```bash
F=course/week4/deliverables/trial_sheet_template.md
for kw in "artifact_status: template" "trial_sheet_id:" "safety_check_id:" "total_planned_rows: 15" "trial_status:" "kpi_grasp_success:" "kpi_time_to_grasp_sec:" "skip_or_block_reason:"; do
    grep -qF "$kw" "$F" && echo "T-TRIAL must '$kw' OK" || echo "T-TRIAL FAIL: '$kw' missing"
done
```
Expected: 8 `OK`.

- [ ] **Step 3: Commit**

```bash
git add course/week4/deliverables/trial_sheet_template.md
git commit -m "$(cat <<'EOF'
feat: add trial_sheet template (W4-T-TRIAL-SHEET)

Spec §7.2. type:template. Body declares artifact_status:template +
trial_sheet_id, q1_package_id, safety_check_id, batch_description,
total_planned_rows:15, and a 2-row structural example showing planned
vs executed shape. Includes per-row fields trial_status (planned|
executed|skipped|blocked), result+failure_reason taxonomy, KPI fields
(kpi_grasp_success, kpi_time_to_grasp_sec), skip_or_block_reason. The
fully expanded 15-row skeleton lives in sandbox_reference/week4/
trial_sheet_example.md (T16) per spec §7.2 note.
EOF
)"
```

---

## Task 11: course/week4/deliverables/safety_checklist_template.md

**Files:**
- Create: `course/week4/deliverables/safety_checklist_template.md` (`type: template`, includes reviewer fields, stop_condition enum, forbidden_operations id+description_ja)

Spec §7.3, §9.4.3 safety_checklist_template patterns.

- [ ] **Step 1: Write template**

````markdown
---
type: template
id: W4-T-SAFETY-CHECKLIST
title: safety_checklist template — pre-execution safety 確認 (Phase 0 では training draft)
week: 4
duration_min: 45
prerequisites: [W4-L8]
worldcpj_ct: [CT-09]
roles: [common, safety]
references: [R-30, R-31, R-32]
deliverables: [safety_checklist]
---

# safety_checklist_template

> **artifact_status**: template
>
> 本 checklist は Phase 0 では **training draft** (`phase0_status: training_draft_only`)。Q1 W1 開始前に責任ある reviewer が `review_status: approved` にすること が **blocker** (`q1_blocker_if_unreviewed: true`)。Phase 0 safety_checklist は **approval artifact ではない**。

## 設計趣旨

- pre-execution safety 確認の構造化表
- `review_status: approved` は `reviewer_name` / `reviewer_role` / `reviewed_at` が埋まっている場合のみ許可 (Lab 8 CHECKLIST + bad example で検証)
- `stop_condition: other` 使用時は `other_stop_condition_detail` 空欄 NG
- `forbidden_operations[].id` は英語 snake_case、`description_ja` は日本語可 (現場 SOP との整合のため)

## YAML body skeleton

```yaml
artifact_status: template

# Identity / linkage
safety_check_id:                  # unique id
q1_package_id:                    # link to Q1 Package
session_description:              # "Q1 W1 pilot trial" 等

# Phase 0 status (default: training_draft_only)
phase0_status: training_draft_only
q1_blocker_if_unreviewed: true

# Owner / review
safety_owner: TBD                 # Q1 W1 開始前に確定
review_due: before_q1_w1_start
review_status: not_reviewed       # not_reviewed | reviewed_with_conditions | approved | blocked
reviewer_name: TBD
reviewer_role: TBD                # responsible_safety_reviewer | safety_owner | TBD
reviewed_at: TBD                  # ISO 8601 | TBD
review_notes: ""

# SOP reference
sop_reference:
  document_name: TBD
  document_path: TBD
  approval_status: not_approved   # not_approved | approved | unknown

# Operator
operator:
  present: false
  name: TBD
  qualification: TBD

# Stop conditions (named 5 + other)
stop_condition:
  - e_stop_not_verified
  - operator_not_present
  - sop_not_reviewed
  - workspace_not_cleared
  - unexpected_motion_or_command
other_stop_condition_detail: ""   # required when stop_condition includes "other"

# Forbidden operations (id English snake_case + description_ja)
forbidden_operations:
  - id: example_no_real_robot_motion_without_review
    description_ja: "責任者 review 前に実機を動作させない"

# Safe no-action conditions
safe_no_action_conditions:
  - id: example_pose_uncertainty_above_threshold
    description_ja: "pose 不確実性が閾値を超える場合は何もしない"

# Review log
review_log:
  - reviewer: TBD
    date: TBD
    decision: not_reviewed
    conditions: []

notes: ""
```

## Phase 0 必須注意文

UR safety references are used as **instructional examples**. Actual Q1 execution must follow the applicable robot model, site SOP, risk assessment, and responsible safety reviewer decision.

Phase 0 safety_checklist is **not an approval artifact**. It is a **training draft** + handoff artifact for Q1 safety review.
````

- [ ] **Step 2: Verify required fields**

```bash
F=course/week4/deliverables/safety_checklist_template.md
for kw in "artifact_status: template" "safety_check_id:" "phase0_status: training_draft_only" "q1_blocker_if_unreviewed: true" "reviewer_name:" "reviewer_role:" "reviewed_at:" "stop_condition:" "other_stop_condition_detail:" "forbidden_operations:" "safe_no_action_conditions:" "description_ja:"; do
    grep -qF "$kw" "$F" && echo "T-SAFETY must '$kw' OK" || echo "T-SAFETY FAIL: '$kw' missing"
done
```
Expected: 12 `OK`.

- [ ] **Step 3: Commit**

```bash
git add course/week4/deliverables/safety_checklist_template.md
git commit -m "$(cat <<'EOF'
feat: add safety_checklist template (W4-T-SAFETY-CHECKLIST)

Spec §7.3. type:template. Body declares artifact_status:template +
phase0_status:training_draft_only + q1_blocker_if_unreviewed:true (the
Phase 0 default) plus reviewer_name/reviewer_role/reviewed_at fields
required to gate review_status:approved. Includes named 5-element
stop_condition enum + other_stop_condition_detail, and
forbidden_operations / safe_no_action_conditions structured as
{id:english_snake_case, description_ja:日本語} per spec §3.11.
Carries the Phase 0 mandatory disclaimer (instructional examples /
not an approval artifact).
EOF
)"
```

---

## Task 12: course/week4/deliverables/q1_reduced_lv1_execution_package_template.md

**Files:**
- Create: `course/week4/deliverables/q1_reduced_lv1_execution_package_template.md` (`type: template`, 8-row meta + preflight + re_judge_gates 4 件)

Spec §7.4, §9.4.3 q1 package template patterns.

- [ ] **Step 1: Write template**

````markdown
---
type: template
id: W4-T-Q1-PACKAGE
title: Q1 Reduced Lv1 Execution Package template — Phase 0 → Q1 handoff artifact 自体
week: 4
duration_min: 90
prerequisites: [W4-L7, W4-L8, W4-T-EPISODE-RECORD, W4-T-TRIAL-SHEET, W4-T-SAFETY-CHECKLIST]
worldcpj_ct: [CT-04, CT-05, CT-06, CT-09]
roles: [common, logging, safety, sandbox]
references: [R-28, R-29, R-30, R-31, R-32]
deliverables: [q1_reduced_lv1_execution_package]
---

# q1_reduced_lv1_execution_package_template

> **artifact_status**: template
>
> 本 template は **Phase 0 → Q1 handoff artifact 自体**。Formal handover ceremony / 別文書は out-of-scope。Q1 全体 scope / gate / owner / `re_judge_gates` の meta package として、W1-W3 templates を `source_artifact_path` で参照型 traceability する (data の copy ではない)。

## 設計趣旨

- 8 行 meta + `q1_w1_preflight` + `re_judge_gates` 4 件 + handoff note 構成
- 各 row には `source_artifact_path` (W1-W3 artifact への参照) + `source_template` (元 template の id) + `review_status` (Phase 0 default `not_reviewed`)
- `re_judge_gates` は 4 件固定 (`q1_w1_pre_start` / `q1_w1_exit` / `q1_mid_point` / `q1_closeout`)
- Q1 W1 preflight 8 項目 (5 物体 × 3 trials 直行禁止、1 pilot trial 経由必須)
- Q1 W2+ detail は deferred 明示 (silent omission 禁止)、`q1_mid_point` で判断する

## YAML body skeleton

```yaml
artifact_status: template
phase0_handoff: true

# Identity / meta
q1_package_id:                    # unique id
bridge_schema_version: provisional_v1   # provisional_v1 | not_applicable | unknown
q1_execution_mode: TBD            # mock | sim | real | operator_in_the_loop | TBD
owner_role: "Q1 Reduced Lv1 planning owner"
next_decision_owner: "WorldCPJ Safety Role Owner"

# Phase 0 review pointer
phase0_review_summary_path: sandbox/wk4/lab8b/sandbox_review_summary.md
phase0_review_summary_status: not_reviewed   # self_reviewed | reviewed_with_conditions | not_reviewed
phase0_to_q1_handoff_note: |
  Formal handover ceremony/document is out of scope for Phase 0.
  This Q1 Reduced Lv1 Execution Package itself acts as the
  Phase 0 → Q1 handoff artifact.

# 8 meta rows (all reference W1-W3/W4 artifacts via source_artifact_path)
rows:
  - row: 1_scope_lv1_boundary
    content: |
      対象: CC Gate 0-a (5 objects × 3 trials) + MS Lv1 (fixed observation baseline)
      非対象: 人協調 / 双腕 / マルチロボ / ベースライン再現多数
    source_artifact_path: docs/Robotics_simulation_phase0_education_plan.md
    source_template: education_plan_section_1
    review_status: not_reviewed

  - row: 2_target_task_gate
    content: |
      CC Gate 0-a (5 物体 grasp) + MS Lv1 (fixed observation baseline) の詳細
    source_artifact_path: docs/Robotics_simulation_phase0_education_plan.md
    source_template: education_plan_section_2
    review_status: not_reviewed

  - row: 3_environment_stack
    content: |
      Ubuntu 22.04 / ROS 2 Humble / Gazebo Fortress / MoveIt 2 / ros2_control の version 固定
    source_artifact_path: course/00_setup/, sandbox_reference/week1/sandbox_setup_log_example.md
    source_template: SP1-T-SANDBOX-SETUP-LOG
    review_status: not_reviewed

  - row: 4_robot_adapter_readiness
    content: |
      mock / sim / real boundary、SP2 mock_adapter_v0 baseline
    source_artifact_path: sandbox_reference/week2/robot_readiness_mini_report_example.md
    source_template: W2-T-ROBOT-READINESS
    review_status: not_reviewed

  - row: 5_simulation_bridge_status
    content: |
      provisional schema 8 fields (input 4 + output 4)、simulator 選択 (Gazebo / MuJoCo / ManiSkill / Isaac)
    source_artifact_path: sandbox_reference/week3/simulation_bridge_draft_example.md
    source_template: W3-T-SIM-BRIDGE-DRAFT
    review_status: not_reviewed

  - row: 6_logging_episode_plan
    content: |
      1 episode evidence 仕様 (bag_info.txt, metadata.yaml, terminal log; raw bag commit 禁止)
    source_artifact_path: sandbox/wk4/lab8/episode_record.md
    source_template: W4-T-EPISODE-RECORD
    review_status: not_reviewed

  - row: 7_trial_kpi_plan
    content: |
      5 objects × 3 trials skeleton (15 planned rows)、KPI: kpi_grasp_success, kpi_time_to_grasp_sec
    trial_sheet_id: TBD
    source_artifact_path: sandbox/wk4/lab8/trial_sheet.md
    source_template: W4-T-TRIAL-SHEET
    review_status: not_reviewed

  - row: 8_safety_review_go_no_go
    content: |
      Q1 W1 開始前 blocker conditions:
      - safety_checklist review_status MUST be approved
      - SOP MUST be approved by responsible safety reviewer
      - 1 pilot trial review COMPLETED before 5×3 trials
    safety_check_id: TBD
    source_artifact_path: sandbox/wk4/lab8/safety_checklist.md
    source_template: W4-T-SAFETY-CHECKLIST
    review_status: not_reviewed

# Q1 W1 preflight (8 items)
q1_w1_preflight:
  - "tools/verify_env.sh --week 4 PASS (validates SP4 logging baseline; sim/real execution may need additional W2/W3 or Q1-specific checks)"
  - "ros2 doctor or documented equivalent environment smoke check"
  - "mock adapter no-op execution confirmed"
  - "required topics listed"
  - "rosbag2 minimal record confirmed for required topics"
  - "safety_checklist reviewed by responsible owner (review_status: approved)"
  - "1 object × 1 pilot trial executed"
  - "pilot review COMPLETED before proceeding to 5 objects × 3 trials"

# Re-judge gates (4 fixed)
re_judge_gates:
  - gate_id: q1_w1_pre_start
    purpose: "Phase 0 成果物の Q1 移行可否確認"
    decisions: ["safety review approved", "env smoke test passed", "no-action dry run completed"]
  - gate_id: q1_w1_exit
    purpose: "1 pilot trial 後の再判断"
    decisions: ["proceed from 1 pilot trial to 15 planned trials", "continue pilot", "replan"]
  - gate_id: q1_mid_point
    purpose: "W2 以降 detail の確定 (Phase 0 で prescribe しない)"
    decisions: ["update failure taxonomy", "update KPI", "update operator workflow"]
  - gate_id: q1_closeout
    purpose: "Lv1 継続可否"
    decisions: ["proceed to MS Lv1", "revise Phase 0 artifacts", "escalate"]

# Free-text section
free_text_section:
  open_questions: ""
  blockers_for_q1: ""
```
````

- [ ] **Step 2: Verify required fields**

```bash
F=course/week4/deliverables/q1_reduced_lv1_execution_package_template.md
for kw in "artifact_status: template" "phase0_handoff: true" "q1_package_id:" "bridge_schema_version:" "q1_execution_mode:" "owner_role:" "next_decision_owner:" "phase0_review_summary_path:" "phase0_to_q1_handoff_note:" "1_scope_lv1_boundary" "2_target_task_gate" "3_environment_stack" "4_robot_adapter_readiness" "5_simulation_bridge_status" "6_logging_episode_plan" "7_trial_kpi_plan" "8_safety_review_go_no_go" "source_artifact_path:" "source_template:" "q1_w1_preflight:" "re_judge_gates:" "q1_w1_pre_start" "q1_w1_exit" "q1_mid_point" "q1_closeout"; do
    grep -qF "$kw" "$F" && echo "T-Q1PKG must '$kw' OK" || echo "T-Q1PKG FAIL: '$kw' missing"
done
```
Expected: 25 `OK`.

- [ ] **Step 3: Commit**

```bash
git add course/week4/deliverables/q1_reduced_lv1_execution_package_template.md
git commit -m "$(cat <<'EOF'
feat: add Q1 Reduced Lv1 Execution Package template (W4-T-Q1-PACKAGE)

Spec §7.4. type:template. Phase 0 → Q1 handoff artifact itself; no
separate ceremony document. Body declares artifact_status:template,
phase0_handoff:true, bridge_schema_version, q1_execution_mode (TBD by
default), owner_role, next_decision_owner, phase0_review_summary_path
(points at sandbox_review_summary), phase0_to_q1_handoff_note. Body
contains 8 meta rows (scope/task/env/adapter/sim/logging/trial/safety)
each with source_artifact_path + source_template + review_status, plus
8-item q1_w1_preflight (1 pilot trial gate before 15 trials) and 4
re_judge_gates (q1_w1_pre_start / q1_w1_exit / q1_mid_point /
q1_closeout). All W1-W3/W4 references are by path, not by data copy.
EOF
)"
```

---

## Task 13: course/week4/labs/lab7_episode_record/ (README + CHECKLIST + HINTS)

**Files:**
- Create: `course/week4/labs/lab7_episode_record/README.md` (`type: lab`)
- Create: `course/week4/labs/lab7_episode_record/CHECKLIST.md` (no front matter required — G2 excludes CHECKLIST/HINTS)
- Create: `course/week4/labs/lab7_episode_record/HINTS.md` (no front matter required)

Spec §6.1, §9.4.3 Lab 7 README patterns.

- [ ] **Step 1: Create directory**

```bash
mkdir -p course/week4/labs/lab7_episode_record
```

- [ ] **Step 2: Write README.md**

````markdown
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
````

- [ ] **Step 3: Write CHECKLIST.md**

````markdown
# Lab 7 CHECKLIST

- [ ] `episode_record_template.md` を Sandbox にコピーし、全 field 記入した
- [ ] `q1_package_id` / `trial_sheet_id` / `trial_id` / `object_id` を `not_applicable` または `training_*` で記入した (Q1 trial と区別)
- [ ] `evidence_path` に `sandbox_reference/week1/lab1/bag_info.txt` を参照した
- [ ] `result: success` + `failure_reason: none` + `environment_mode: mock` を明示した
- [ ] `bridge_schema_version: not_applicable` + `adapter_version: not_applicable` を明示した (W1 turtlesim 由来)
- [ ] `failure_reason` taxonomy 内から選択した (空欄 NG、`unknown` 容認)
- [ ] raw bag を commit していない (軽量証跡 path 参照のみ)
- [ ] Phase 0 training episode であり、Q1 CC Gate 0-a trial ではないことを認識した
````

- [ ] **Step 4: Write HINTS.md**

````markdown
# Lab 7 HINTS

## SP1 bag の再利用方法

`sandbox_reference/week1/lab1/bag_info.txt` には以下の情報がある:
- Files / Bag size / Storage id → `log_summary` として要約
- Duration → `duration_sec` (秒数)
- Topic information → `recorded_topics` のリスト

新たに `ros2 bag record` する必要は **ない**。SP1 W1 Lab 1 で既に取得済。

## failure_reason taxonomy 解釈例

- `result: success` → `failure_reason: none` (固定)
- mock 環境での実行は通常 success → none となる
- もし turtlesim 起動に失敗していたら `result: failure` + `failure_reason: environment_or_setup_failure`
- 分類不能なら `unknown` 容認 (空欄 NG)

## mock 環境では result: success が多い前提

W1 turtlesim は mock 環境 (`environment_mode: mock`) かつ実機判定なし。`result: success` / `failure_reason: none` がデフォルト。

## bag commit 禁止 (軽量証跡のみ)

Course repo / Sandbox repo どちらでも raw bag (`*.db3`, `*.mcap`) を commit しない。`bag_info.txt` などの軽量証跡を `evidence_path` に格納するのみ。

## なぜ Q1-specific keys が `not_applicable` なのか

W1 turtlesim は **Phase 0 training episode** であり、Q1 縮小 Lv1 の 5 物体 × 3 trials の 1 trial ではない。Q1 trial と混同を避けるため、`q1_package_id` / `trial_sheet_id` / `object_id` は `not_applicable` または `training_*` で明示する。
````

- [ ] **Step 5: Verify Lab 7 G4 patterns**

```bash
F=course/week4/labs/lab7_episode_record/README.md
grep -qF "episode_record_template" "$F" && echo "Lab7 must template OK"
grep -qF "not_applicable" "$F" && echo "Lab7 must not_applicable OK"
grep -qE "(Phase 0 training episode|not counted as a Q1|Q1 trial として数えない)" "$F" && echo "Lab7 must Q1 区別 OK"
```
Expected: 3 `OK`.

- [ ] **Step 6: Commit**

```bash
git add course/week4/labs/lab7_episode_record/
git commit -m "$(cat <<'EOF'
lab: add Lab 7 (episode_record fill, W1 turtlesim bag reuse)

Spec §6.1. README/CHECKLIST/HINTS triplet. Reuses SP1 W1 Lab 1 bag
(sandbox_reference/week1/lab1/bag_info.txt) — no new recording. README
makes explicit this is a Phase 0 training episode, not a Q1 CC Gate
0-a trial; Q1-specific linkage keys take not_applicable or training_*
values. Recommended fill: environment_mode:mock, result:success,
failure_reason:none, bridge_schema_version:not_applicable,
adapter_version:not_applicable. Bag commit forbidden — only the
lightweight bag_info.txt is referenced via evidence_path.
EOF
)"
```

---

## Task 14: course/week4/labs/lab8_q1_execution_package/ (README + CHECKLIST + HINTS)

**Files:**
- Create: `course/week4/labs/lab8_q1_execution_package/README.md` (`type: lab`)
- Create: `course/week4/labs/lab8_q1_execution_package/CHECKLIST.md`
- Create: `course/week4/labs/lab8_q1_execution_package/HINTS.md`

Spec §6.2, §9.4.3 Lab 8 README patterns.

- [ ] **Step 1: Create directory**

```bash
mkdir -p course/week4/labs/lab8_q1_execution_package
```

- [ ] **Step 2: Write README.md**

````markdown
---
type: lab
id: W4-Lab8
title: Lab 8 — Q1 Reduced Lv1 Execution Package + safety_checklist + trial_sheet skeleton 統合
week: 4
duration_min: 120
prerequisites: [W4-L7, W4-L8, W4-T-EPISODE-RECORD, W4-T-TRIAL-SHEET, W4-T-SAFETY-CHECKLIST, W4-T-Q1-PACKAGE]
worldcpj_ct: [CT-04, CT-05, CT-06, CT-09]
roles: [common, logging, safety, sandbox]
references: [R-28, R-30, R-31, R-32]
deliverables: [q1_reduced_lv1_execution_package, safety_checklist, trial_sheet]
---

# Lab 8 — Q1 Reduced Lv1 Execution Package + safety_checklist + trial_sheet skeleton 統合

## 目的

W1-W3 で作った 3 templates (sandbox_setup_log / robot_readiness_mini_report / simulation_bridge_draft) を、Q1 移行 artifact として束ねる。

3 templates (`q1_reduced_lv1_execution_package_template` + `safety_checklist_template` + `trial_sheet_template`) を Sandbox にコピーし、参照型 traceability で fill する。

## 前提

- W1-W3 全 Labs 完了
- W4 L7 / L8 受講済
- W4 4 templates すべて読了

## 手順

### Step 1: 3 templates を Sandbox にコピー

```bash
mkdir -p ~/sandbox/wk4/lab8
cp course/week4/deliverables/q1_reduced_lv1_execution_package_template.md ~/sandbox/wk4/lab8/q1_reduced_lv1_execution_package.md
cp course/week4/deliverables/safety_checklist_template.md ~/sandbox/wk4/lab8/safety_checklist.md
cp course/week4/deliverables/trial_sheet_template.md ~/sandbox/wk4/lab8/trial_sheet.md
```

### Step 2: Q1 Package 8 行を W1-W3 templates 参照で fill

各 row に `source_artifact_path` (W1-W3 artifact への path) + `source_template` (元 template id) + `review_status: not_reviewed` を記入する。**コピーではなく参照** すること。

- Row 3 (environment_stack): `source_artifact_path: course/00_setup/, sandbox/wk1/sandbox_setup_log.md`
- Row 4 (robot_adapter_readiness): `source_artifact_path: sandbox/wk2/robot_readiness_mini_report.md`
- Row 5 (simulation_bridge_status): `source_artifact_path: sandbox/wk3/simulation_bridge_draft.md`
- Row 6 (logging_episode_plan): `source_artifact_path: sandbox/wk4/lab8/episode_record.md` (Lab 7 で書いたもの)
- Row 7 (trial_kpi_plan): `source_artifact_path: sandbox/wk4/lab8/trial_sheet.md`
- Row 8 (safety_review_go_no_go): `source_artifact_path: sandbox/wk4/lab8/safety_checklist.md`

### Step 3: safety_checklist を fill

- `phase0_status: training_draft_only`
- `q1_blocker_if_unreviewed: true`
- `safety_owner: TBD (Q1 W1 開始前に WorldCPJ Safety Role Owner と決定)`
- `review_status: not_reviewed`
- `reviewer_name: TBD` / `reviewer_role: TBD` / `reviewed_at: TBD`
- Q1 Package §8 の `safety_check_id` から本 safety_checklist を参照

### Step 4: trial_sheet を 15 planned rows skeleton として作成

5 objects × 3 trials = 15 rows、全 row:
- `trial_status: planned`
- `result: unknown`
- `failure_reason: unknown`
- `episode_id: TBD`

W1 turtlesim training episode は **混入禁止** (Lab 7 で別途扱う)。Q1 Package §7 の `trial_sheet_id` から本 trial_sheet を参照。

### Step 5: q1_w1_preflight 8 項目を Q1 Package に記入

template 既定の 8 項目を確認・記入:

1. `tools/verify_env.sh --week 4` PASS
2. ros2 doctor or documented equivalent environment smoke check
3. mock adapter no-op execution confirmed
4. required topics listed
5. rosbag2 minimal record confirmed for required topics
6. safety_checklist reviewed by responsible owner (`review_status: approved`)
7. **1 object × 1 pilot trial executed**
8. **pilot review COMPLETED before proceeding to 5 objects × 3 trials** (5×3=15 trials 直行禁止)

### Step 6: re_judge_gates 4 件を確認・記入

`q1_w1_pre_start` / `q1_w1_exit` / `q1_mid_point` / `q1_closeout` の 4 件。Q1 W2+ detail は **deferred 明示** (silent omission 禁止) — `q1_mid_point` で判断する旨を記載。

### Step 7: Sandbox commit

```bash
cd ~/sandbox && git add wk4/lab8/ && git commit -m "lab: W4 Lab 8 Q1 Package + safety_checklist + trial_sheet skeleton"
```

## 提出物

- `~/sandbox/wk4/lab8/q1_reduced_lv1_execution_package.md` (8 rows + preflight + gates fill)
- `~/sandbox/wk4/lab8/safety_checklist.md` (training_draft_only)
- `~/sandbox/wk4/lab8/trial_sheet.md` (15 planned rows skeleton)

## 次のLab

→ [Lab 8b — Sandbox 最終レビュー (Codex 任意)](../lab8b_sandbox_final_review/README.md)
````

- [ ] **Step 3: Write CHECKLIST.md**

````markdown
# Lab 8 CHECKLIST

- [ ] Q1 Package 8 行を全て記入し、各行に `source_artifact_path` + `source_template` + `review_status` を入れた
- [ ] W1-W3 templates の data を **コピーせず**、参照型 traceability で束ねた (linkage keys 使用)
- [ ] safety_checklist を fill 完了 (`review_status: not_reviewed` + `q1_blocker_if_unreviewed: true` 明示)
- [ ] **trial_sheet 15 planned rows skeleton** を作成 (`trial_status: planned` / `result: unknown` / `failure_reason: unknown` / `episode_id: TBD`)
- [ ] W1 turtlesim training episode を trial_sheet に混入させていない (Lab 7 で別途扱う)
- [ ] `q1_w1_preflight` 8 項目を記入し、**5 物体 × 3 trials を 1 pilot trial 経由せず直行禁止** を明示した (`1 pilot trial` / `pilot review` キーワード)
- [ ] `re_judge_gates` 4 件 (`q1_w1_pre_start` / `q1_w1_exit` / `q1_mid_point` / `q1_closeout`) を記入した
- [ ] Q1 W2+ detail を **deferred 明示** した (`q1_mid_point` で判断する旨記載、silent omission 禁止)
- [ ] Sandbox commit 済
````

- [ ] **Step 4: Write HINTS.md**

````markdown
# Lab 8 HINTS

## W1-W3 各 template の引き方

| Q1 Package row | source template | source_artifact_path 例 |
|---|---|---|
| 3_environment_stack | SP1-T-SANDBOX-SETUP-LOG | `sandbox/wk1/sandbox_setup_log.md` |
| 4_robot_adapter_readiness | W2-T-ROBOT-READINESS | `sandbox/wk2/robot_readiness_mini_report.md` |
| 5_simulation_bridge_status | W3-T-SIM-BRIDGE-DRAFT | `sandbox/wk3/simulation_bridge_draft.md` |
| 6_logging_episode_plan | W4-T-EPISODE-RECORD | `sandbox/wk4/lab8/episode_record.md` |
| 7_trial_kpi_plan | W4-T-TRIAL-SHEET | `sandbox/wk4/lab8/trial_sheet.md` |
| 8_safety_review_go_no_go | W4-T-SAFETY-CHECKLIST | `sandbox/wk4/lab8/safety_checklist.md` |

## コピーではなく参照する理由

- W1-W3 artifact が更新されても Q1 Package を全書き直しせずに済む
- 単一の data source per template を保つ (W2 Adapter readiness の真は W2 template、Q1 Package はそれを指す)
- handoff 後 Q1 W1 で W2/W3 artifact が修正されても Q1 Package は path 参照だけで追従

## phase0_status: training_draft_only 必須

safety_checklist は Phase 0 では **training draft**。`phase0_status: training_draft_only` を必ず明示し、`q1_blocker_if_unreviewed: true` で Q1 W1 開始前 review が blocker であることを宣言する。

## q1_w1_preflight の 5×3=15 trials 直行禁止

5 物体 × 3 trials = 15 trials を一気に流すのは禁止。必ず以下を経由する:

1. 1 物体 × 1 trial の pilot trial を実行
2. pilot trial の review が完了 (`q1_w1_exit` gate)
3. その後初めて 15 trials 計画に進む

CHECKLIST の `1 pilot trial` / `pilot review` キーワードはこの規約を表す。

## 自分の case が思いつかない時

以下のいずれかの架空 case を採用してよい:

- Course 教材開発担当 (本 Course を Q1 で更新する想定)
- Robot Adapter Role 担当 (W2 で書いた robot_readiness_mini_report の延長で Q1 を計画)
- Sim Bridge Role 担当 (W3 で書いた simulation_bridge_draft の延長で Q1 を計画)

## Q1 W2+ detail を Phase 0 で prescribe しない

`re_judge_gates` の `q1_mid_point` で「W2+ detail (failure taxonomy 改訂 / KPI / operator workflow) は本 gate で判断」と明示する。Phase 0 で W2+ scope に踏み込まない。
````

- [ ] **Step 5: Verify Lab 8 G4 patterns**

```bash
F=course/week4/labs/lab8_q1_execution_package/README.md
for kw in "q1_reduced_lv1_execution_package_template" "safety_checklist_template" "trial_sheet_template" "source_artifact_path" "source_template" "15 planned rows" "q1_w1_preflight" "re_judge_gates" "1 pilot trial" "pilot review"; do
    grep -qF "$kw" "$F" && echo "Lab8 must '$kw' OK" || echo "Lab8 FAIL: '$kw' missing"
done
grep -qE "(5 物体 × 3 trials 直行禁止|direct_15_trials_without_pilot)" "$F" && echo "Lab8 must 直行禁止 OK"
```
Expected: 11 `OK`.

- [ ] **Step 6: Commit**

```bash
git add course/week4/labs/lab8_q1_execution_package/
git commit -m "$(cat <<'EOF'
lab: add Lab 8 (Q1 Package + safety_checklist + trial_sheet integration)

Spec §6.2. README/CHECKLIST/HINTS triplet. Walks through copying 3
templates (Q1 Package + safety_checklist + trial_sheet) into sandbox/
wk4/lab8/, filling Q1 Package 8 rows by reference (source_artifact_path
+ source_template, NOT data copy), recording safety_checklist as
training_draft_only with reviewer fields TBD, building trial_sheet 15
planned rows skeleton (no W1 turtlesim mixing), and recording the
8-item q1_w1_preflight (5×3 trials forbidden without 1 pilot trial)
and 4 re_judge_gates (q1_w1_pre_start / q1_w1_exit / q1_mid_point /
q1_closeout). HINTS includes the W1-W3 template lookup table and
explicit Q1 W2+ deferral note (silent omission forbidden).
EOF
)"
```

---

## Task 15: course/week4/labs/lab8b_sandbox_final_review/ (README + CHECKLIST + HINTS)

**Files:**
- Create: `course/week4/labs/lab8b_sandbox_final_review/README.md` (`type: lab`)
- Create: `course/week4/labs/lab8b_sandbox_final_review/CHECKLIST.md`
- Create: `course/week4/labs/lab8b_sandbox_final_review/HINTS.md`

Spec §6.3, §9.4.3 Lab 8b README patterns.

- [ ] **Step 1: Create directory**

```bash
mkdir -p course/week4/labs/lab8b_sandbox_final_review
```

- [ ] **Step 2: Write README.md**

````markdown
---
type: lab
id: W4-Lab8b
title: Lab 8b — Sandbox 最終レビュー (Codex 利用は任意)
week: 4
duration_min: 60
prerequisites: [W4-Lab7, W4-Lab8]
worldcpj_ct: [CT-04, CT-05, CT-06, CT-09]
roles: [common, sandbox]
references: [R-28, R-30, R-31]
deliverables: [sandbox_review_summary]
---

# Lab 8b — Sandbox 最終レビュー (Codex 利用は任意)

## 目的

Sandbox の W1-W4 全体を自己レビューし、`sandbox_review_summary.md` に **Phase 0 振り返り 5+ patterns** + **Q1 移行教訓 3+ items** を記録する。Codex の利用は **任意**。

## Codex 利用方針

**Codex 利用は任意です** (Codex usage is optional)。Codex 利用なしでも本 Lab は合格可。

### 禁止リスト (Lab 4b / 6b 流用 + Lab 8b 固有)

- IK / KDL / URDF parsing / trajectory / controller / 安全判断自動化 (Lab 4b / 6b 同型)
- **Lab 8b 固有**: Q1 縮小 Lv1 の **scope 判断** (CC/MS どこまでやるか、人協調/双腕入れるか) を Codex に委ねない (`must not make scope decisions`)

### Codex 役割の境界

- Codex may **summarize** review notes that mention IK / KDL / URDF / trajectory / controller issues
- Codex **must not implement**, debug, scope-expand, or make execution/safety decisions for those areas in Lab 8b (`判断・実装は不可`)
- 最終 scope 判断 (`scope decision`) は **human** が行う (`scope 判断は人間`)

## 前提

- W4 Lab 7 / Lab 8 完了
- Sandbox W1-W4 全 commits 揃っている

## 手順

### Step 1: Sandbox W1-W4 全体を自己レビュー

```bash
mkdir -p ~/sandbox/wk4/lab8b
cd ~/sandbox && git log --oneline | head -50 > /tmp/sandbox_log_review.txt
```

`~/sandbox/wk4/lab8b/sandbox_review_summary.md` を作成し、以下を記載:

### Step 2: Phase 0 振り返り 5+ patterns (手書き、必須)

W1-W4 で気づいた成功 / 失敗 / 学習成果を 5 件以上、自分で見つけた pattern (**human-found patterns**) として手書きで列挙。

### Step 3: Q1 移行教訓 3+ items

Q1 W1 開始時に注意すべき点を 3 件以上 (**Q1 migration lessons**) 記載。

### Step 4: (任意 Codex 補助)

W2/W3 で書いた累積 Sandbox PR Review Notes (2-3 件) を Codex に渡し「共通 pattern を 3 行で抽出」。生成 pattern を `Codex-suggested patterns` として記録し、accepted / rejected で分離記録する。

Codex 利用なしの場合は `Codex-suggested patterns: N/A` と明示する。

## 提出物 matrix

| 項目 | Codex 使用なし | Codex 使用あり |
|---|---|---|
| Human-found patterns (5+) | 必須 | 必須 |
| Codex-suggested patterns | N/A 明示 | 必須 (3+) |
| Accepted / rejected suggestions | N/A | 必須 |
| Final review summary | 必須 | 必須 |
| Q1 migration lessons (3+) | 必須 | 必須 |
| Scope decision by human | 必須 | 必須 |

## SP4 終了

本 Lab で SP4 (Phase 0 最終週) は完了。Q1 移行は Q1 Package §8 safety review + `q1_w1_preflight` + 1 pilot trial review が完了してから。
````

- [ ] **Step 3: Write CHECKLIST.md**

````markdown
# Lab 8b CHECKLIST

- [ ] Sandbox W1-W4 全体を自己レビューした
- [ ] `sandbox_review_summary.md` を Sandbox に作成した
- [ ] **Human-found patterns** を 5 件以上手書きで列挙した (自分で見つけた pattern)
- [ ] **Q1 migration lessons** を 3 件以上記載した (Q1 移行教訓)
- [ ] Codex 利用方針 ("利用なし" / "利用あり") を冒頭に明示した
- [ ] (Codex 利用なしの場合) `Codex-suggested patterns: N/A` を明示した
- [ ] (Codex 利用ありの場合) Codex-suggested patterns を 3 件以上記録し、accepted / rejected で分離した
- [ ] Codex は **summarize は可、判断・実装は不可** の境界を守った
- [ ] Q1 縮小 Lv1 の **scope 判断は人間** が行ったことを明示した
- [ ] Sandbox commit 済
````

- [ ] **Step 4: Write HINTS.md**

````markdown
# Lab 8b HINTS

## sandbox W1-W4 自己レビューの観点例

- 環境: 何が install しにくかったか (sudo の制約 / version 衝突 / network)
- template: どの field が空欄になりがちだったか / どの field が冗長だったか
- 失敗 pattern: ros2 topic がない / Gazebo 起動失敗 / Codex 出力が禁止リストに触れた
- Q1 移行: safety_checklist の reviewer 確定 / SOP approval / pilot trial の運用

## Codex 補助 prompt 例 (累積 Notes pattern 抽出限定)

```
以下は私の Sandbox PR Review Notes (W2 + W3 計 3 件) です。
共通 pattern を 3 行で抽出してください。
- pattern 1: ...
- pattern 2: ...
- pattern 3: ...

注意: pattern 抽出のみ。implementation / scope decision / safety
judgment は出力しないでください。
```

## Codex 接続不可時は手書き完結可

「帰省中で Codex CLI にアクセスできない」「ChatGPT しか使えない」などの場合、Codex 利用なしで Lab 8b を完了してよい。`Codex-suggested patterns: N/A` を明示すれば合格。

## Q1 移行教訓の表現例

- 「safety_checklist の `safety_owner: TBD` は Q1 W1 開始前に必ず決定すること」
- 「trial_sheet の `episode_id: TBD` は executed への遷移時に concrete な episode_record を作成し参照すること」
- 「Q1 Package の `q1_execution_mode: TBD` は Q1 W1 pre-start gate で `mock` / `sim` / `real` のどれかに確定すること」
````

- [ ] **Step 5: Verify Lab 8b G4 patterns**

```bash
F=course/week4/labs/lab8b_sandbox_final_review/README.md
grep -qE "(Codex 利用は.*任意|Codex.*optional)" "$F" && echo "Lab8b must Codex 任意 OK"
grep -qF "summarize" "$F" && echo "Lab8b must summarize OK"
grep -qF "must not make scope decisions" "$F" && echo "Lab8b must scope decisions OK"
grep -qE "(must not implement|判断・実装.*不可)" "$F" && echo "Lab8b must implement 不可 OK"
grep -qE "(human-found patterns|自分で見つけた pattern)" "$F" && echo "Lab8b must human-found OK"
grep -qE "(Q1 migration lessons|Q1 移行教訓)" "$F" && echo "Lab8b must Q1 migration OK"
grep -qE "(scope decision.*human|scope.*人間|scope 判断は人間)" "$F" && echo "Lab8b must scope human OK"
```
Expected: 7 `OK`.

- [ ] **Step 6: Commit**

```bash
git add course/week4/labs/lab8b_sandbox_final_review/
git commit -m "$(cat <<'EOF'
lab: add Lab 8b (sandbox final review, Codex optional)

Spec §6.3. README/CHECKLIST/HINTS triplet. Codex usage is explicitly
optional; the no-Codex path is fully sufficient with Codex-suggested
patterns:N/A. Adds Lab 8b-specific prohibition: Codex may summarize
review notes but must not implement / scope-expand / make execution
or safety decisions, and must not make Q1 Lv1 scope decisions (CC/MS
boundary, dual-arm, human-collab). Required outputs: 5+ human-found
patterns, 3+ Q1 migration lessons, scope decision by human. HINTS
provides observation prompts and a sample Codex pattern-extract
prompt with explicit "no implementation / no scope" guard.
EOF
)"
```

---

## Task 16: sandbox_reference/week4/ — 10 files (instructor walk-through fill demos)

**Files:** (all `type: reference`, course 10-key front matter)
- Create: `sandbox_reference/week4/episode_record_example.md`
- Create: `sandbox_reference/week4/trial_sheet_example.md`
- Create: `sandbox_reference/week4/safety_checklist_example.md`
- Create: `sandbox_reference/week4/q1_reduced_lv1_execution_package_example.md`
- Create: `sandbox_reference/week4/sandbox_review_summary_example.md`
- Create: `sandbox_reference/week4/bad_q1_package_example.md` (negative example)
- Create: `sandbox_reference/week4/codex_pattern_extract_example.md` (optional Codex example)
- Create: `sandbox_reference/week4/lab7/README.md` (walk-through)
- Create: `sandbox_reference/week4/lab8/README.md` (walk-through)
- Create: `sandbox_reference/week4/lab8b/README.md` (walk-through)

Spec §8 (all sub-sections), §9.4.3 (sandbox example patterns), §9.4.10 (negative example handling).

- [ ] **Step 1: Create directories**

```bash
mkdir -p sandbox_reference/week4/lab7 sandbox_reference/week4/lab8 sandbox_reference/week4/lab8b
```

- [ ] **Step 2: Write `sandbox_reference/week4/episode_record_example.md`**

````markdown
---
type: reference
id: W4-REF-EPISODE-RECORD
title: episode_record example — SP1 W1 Lab 1 turtlesim bag (instructor fill demo)
week: 4
duration_min: 15
prerequisites: [W1-Lab1, W4-L7]
worldcpj_ct: [CT-04, CT-05]
roles: [common, logging]
references: [R-28]
deliverables: [episode_record]
---

# episode_record example (instructor fill demo)

> **artifact_status**: sandbox_example
>
> instructor case = SP1 W1 Lab 1 turtlesim bag を題材に Lab 7 を完了した想定。Q1 trial ではないため、Q1-specific linkage keys は `not_applicable` または `training_*`。

## YAML body (filled)

```yaml
artifact_status: sandbox_example

# Linkage keys (Q1 trial と区別)
episode_id: episode_w1_lab1_001
q1_package_id: not_applicable
trial_sheet_id: not_applicable
trial_id: training_trial_w1_lab1_001
object_id: turtlesim_training_object
attempt_index: 1

# Environment
environment_mode: mock
adapter_version: not_applicable
bridge_schema_version: not_applicable

# Logs
log_path: not_applicable
evidence_path: sandbox_reference/week1/lab1/bag_info.txt
commit_sha: TBD

# Time (from bag_info.txt Duration field)
start_time: TBD
end_time: TBD
duration_sec: 300.0
recorded_topics:
  - /turtle1/cmd_vel
  - /turtle1/pose
  - /rosout
  - /parameter_events

# Outcome
result: success
failure_reason: none
review_status: not_reviewed

notes: |
  W1 Lab 1 turtlesim 5 分間 bag。mock 環境かつ Q1 trial ではないため Q1-specific
  linkage keys は not_applicable / training_*。raw bag は commit せず、
  bag_info.txt を evidence_path として参照。
```
````

- [ ] **Step 3: Write `sandbox_reference/week4/trial_sheet_example.md`**

````markdown
---
type: reference
id: W4-REF-TRIAL-SHEET
title: trial_sheet example — 15 planned rows skeleton (instructor fill demo)
week: 4
duration_min: 30
prerequisites: [W4-L7, W4-Lab8]
worldcpj_ct: [CT-05]
roles: [common, logging]
references: [R-28]
deliverables: [trial_sheet]
---

# trial_sheet example (15 planned rows skeleton)

> **artifact_status**: sandbox_example
>
> Instructor case = Q1 縮小 Lv1 CC Gate 0-a の 5 物体 × 3 trials を planned skeleton として作成した想定。**executed への遷移は Q1 W1 以降**。
>
> W1 turtlesim training episode は **混入させていない**。本 trial_sheet は Q1 trial 用、turtlesim training は episode_record_example.md で別途扱う。

## YAML body (15 planned rows)

```yaml
artifact_status: sandbox_example

trial_sheet_id: trial_sheet_q1_cc_gate_0a_001
q1_package_id: q1_reduced_lv1_pkg_001
safety_check_id: safety_check_q1_w1_pilot_001
batch_description: "Q1 Reduced Lv1 — CC Gate 0-a (5 objects × 3 trials = 15 planned rows)"
total_planned_rows: 15

rows:
  - {trial_id: trial_001, object_id: object_1, attempt_index: 1, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_002, object_id: object_1, attempt_index: 2, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_003, object_id: object_1, attempt_index: 3, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_004, object_id: object_2, attempt_index: 1, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_005, object_id: object_2, attempt_index: 2, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_006, object_id: object_2, attempt_index: 3, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_007, object_id: object_3, attempt_index: 1, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_008, object_id: object_3, attempt_index: 2, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_009, object_id: object_3, attempt_index: 3, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_010, object_id: object_4, attempt_index: 1, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_011, object_id: object_4, attempt_index: 2, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_012, object_id: object_4, attempt_index: 3, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_013, object_id: object_5, attempt_index: 1, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_014, object_id: object_5, attempt_index: 2, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
  - {trial_id: trial_015, object_id: object_5, attempt_index: 3, trial_status: planned, result: unknown, failure_reason: unknown, episode_id: TBD, kpi_grasp_success: null, kpi_time_to_grasp_sec: null, skip_or_block_reason: "", notes: ""}
```

## Reference: executed row example (NOT counted as Q1 trial)

For shape reference only. The W1 turtlesim training episode is recorded in `episode_record_example.md` separately and is NOT a Q1 CC Gate 0-a row.

```yaml
# Shape reference only — do not include in the 15-row count above.
- trial_id: training_trial_w1_lab1_001
  object_id: turtlesim_training_object
  attempt_index: 1
  trial_status: executed
  result: success
  failure_reason: none
  episode_id: episode_w1_lab1_001
  kpi_grasp_success: null
  kpi_time_to_grasp_sec: null
  skip_or_block_reason: ""
  notes: "Phase 0 training, NOT a Q1 CC Gate 0-a trial."
```
````

- [ ] **Step 4: Write `sandbox_reference/week4/safety_checklist_example.md`**

````markdown
---
type: reference
id: W4-REF-SAFETY-CHECKLIST
title: safety_checklist example — Phase 0 training_draft_only (instructor fill demo)
week: 4
duration_min: 30
prerequisites: [W4-L8, W4-Lab8]
worldcpj_ct: [CT-09]
roles: [common, safety]
references: [R-30, R-31, R-32]
deliverables: [safety_checklist]
---

# safety_checklist example (Phase 0 training_draft_only)

> **artifact_status**: sandbox_example
>
> Phase 0 では `phase0_status: training_draft_only` 固定。`q1_blocker_if_unreviewed: true` で Q1 W1 開始前 review が blocker であることを明示。
>
> stop_condition の named 5 項目を enabled、`other` は未使用 (必要時のみ `other_stop_condition_detail` 付きで使用)。
>
> `forbidden_operations[].id` 英語 snake_case、`description_ja` 日本語可。

## YAML body (filled)

```yaml
artifact_status: sandbox_example

safety_check_id: safety_check_q1_w1_pilot_001
q1_package_id: q1_reduced_lv1_pkg_001
session_description: "Q1 W1 pilot trial (1 object × 1 attempt)"

phase0_status: training_draft_only
q1_blocker_if_unreviewed: true

safety_owner: TBD (Q1 W1 開始前に WorldCPJ Safety Role Owner と決定)
review_due: before_q1_w1_start
review_status: not_reviewed
reviewer_name: TBD
reviewer_role: TBD
reviewed_at: TBD
review_notes: ""

sop_reference:
  document_name: TBD (現場 SOP draft)
  document_path: TBD
  approval_status: not_approved

operator:
  present: false
  name: TBD
  qualification: TBD

stop_condition:
  - e_stop_not_verified
  - operator_not_present
  - sop_not_reviewed
  - workspace_not_cleared
  - unexpected_motion_or_command
other_stop_condition_detail: ""

forbidden_operations:
  - id: no_real_robot_motion_without_review
    description_ja: "責任者 review 前に実機を動作させない"
  - id: no_dual_arm_coordination
    description_ja: "Q1 縮小 Lv1 では双腕協調動作を扱わない"
  - id: no_human_collaboration_mode
    description_ja: "Q1 縮小 Lv1 では人協調モードを有効にしない"

safe_no_action_conditions:
  - id: pose_uncertainty_above_threshold
    description_ja: "pose 不確実性が閾値を超える場合は何もしない"
  - id: sensor_data_stale
    description_ja: "sensor data が 1 秒以上古い場合は何もしない"

review_log:
  - reviewer: TBD
    date: TBD
    decision: not_reviewed
    conditions: []

notes: |
  Phase 0 training_draft_only。Q1 W1 開始前に responsible safety
  reviewer による review が必要 (q1_blocker_if_unreviewed: true)。
```
````

- [ ] **Step 5: Write `sandbox_reference/week4/q1_reduced_lv1_execution_package_example.md`**

````markdown
---
type: reference
id: W4-REF-Q1-PACKAGE
title: Q1 Reduced Lv1 Execution Package example — instructor fill demo (Phase 0 → Q1 handoff artifact)
week: 4
duration_min: 60
prerequisites: [W4-L7, W4-L8, W4-Lab8]
worldcpj_ct: [CT-04, CT-05, CT-06, CT-09]
roles: [common, logging, safety, sandbox]
references: [R-28, R-30, R-31, R-32]
deliverables: [q1_reduced_lv1_execution_package]
---

# Q1 Reduced Lv1 Execution Package example (instructor fill demo)

> **artifact_status**: sandbox_example
>
> Instructor case = **Q1 Reduced Lv1 planning owner for Course / Robot Adapter / Sim Bridge integration**。8 行 fill、各行 W1-W3 artifacts 参照、`q1_w1_preflight` 8 項目、`re_judge_gates` 4 件、`bridge_schema_version: provisional_v1`、`q1_execution_mode: TBD` (Q1 W1 pre_start gate で確定)。

## YAML body (filled)

```yaml
artifact_status: sandbox_example
phase0_handoff: true

q1_package_id: q1_reduced_lv1_pkg_001
bridge_schema_version: provisional_v1
q1_execution_mode: TBD
owner_role: "Q1 Reduced Lv1 planning owner for Course / Robot Adapter / Sim Bridge integration"
next_decision_owner: "WorldCPJ Safety Role Owner"

phase0_review_summary_path: sandbox/wk4/lab8b/sandbox_review_summary.md
phase0_review_summary_status: self_reviewed
phase0_to_q1_handoff_note: |
  Formal handover ceremony/document is out of scope for Phase 0.
  This Q1 Reduced Lv1 Execution Package itself acts as the
  Phase 0 → Q1 handoff artifact.

rows:
  - row: 1_scope_lv1_boundary
    content: |
      対象: CC Gate 0-a (5 objects × 3 trials = 15 trials) + MS Lv1 (fixed observation baseline)
      非対象: 人協調 / 双腕 / マルチロボ / ベースライン再現多数
    source_artifact_path: docs/Robotics_simulation_phase0_education_plan.md
    source_template: education_plan_section_1
    review_status: not_reviewed

  - row: 2_target_task_gate
    content: |
      CC Gate 0-a: 5 物体 grasp success rate baseline 確立
      MS Lv1: fixed observation baseline (camera pose 固定で観察 baseline 確立)
    source_artifact_path: docs/Robotics_simulation_phase0_education_plan.md
    source_template: education_plan_section_2
    review_status: not_reviewed

  - row: 3_environment_stack
    content: |
      Ubuntu 22.04 LTS / ROS 2 Humble / Gazebo Fortress / MoveIt 2 / ros2_control / colcon
      version 固定 (SP1 setup notes 参照)
    source_artifact_path: course/00_setup/, sandbox_reference/week1/sandbox_setup_log_example.md
    source_template: SP1-T-SANDBOX-SETUP-LOG
    review_status: not_reviewed

  - row: 4_robot_adapter_readiness
    content: |
      mock_adapter_v0 baseline (W2 で実装)。sim/real は Q1 W1 pre_start gate で判断
    source_artifact_path: sandbox_reference/week2/robot_readiness_mini_report_example.md
    source_template: W2-T-ROBOT-READINESS
    review_status: not_reviewed

  - row: 5_simulation_bridge_status
    content: |
      provisional schema v1 (input 4: scene_packet/robot_state/candidate_set/action_intent
      + output 4: observation/execution_result/failure_reason/metrics)。
      simulator は Gazebo Fortress を default、MuJoCo / ManiSkill / Isaac は SP5 / 個別宿題で扱う
    source_artifact_path: sandbox_reference/week3/simulation_bridge_draft_example.md
    source_template: W3-T-SIM-BRIDGE-DRAFT
    review_status: not_reviewed

  - row: 6_logging_episode_plan
    content: |
      1 episode evidence: bag_info.txt + rosbag_metadata.yaml + terminal log。
      raw bag commit 禁止。MCAP は Stretch (ros-humble-rosbag2-storage-mcap install 任意)
    source_artifact_path: sandbox/wk4/lab7/episode_record.md
    source_template: W4-T-EPISODE-RECORD
    review_status: not_reviewed

  - row: 7_trial_kpi_plan
    content: |
      5 objects × 3 trials = 15 planned rows skeleton (Lab 8 で作成)
      KPI: kpi_grasp_success (bool), kpi_time_to_grasp_sec (float)
    trial_sheet_id: trial_sheet_q1_cc_gate_0a_001
    source_artifact_path: sandbox/wk4/lab8/trial_sheet.md
    source_template: W4-T-TRIAL-SHEET
    review_status: not_reviewed

  - row: 8_safety_review_go_no_go
    content: |
      Q1 W1 開始前 blocker conditions:
      - safety_checklist review_status MUST be approved
      - SOP MUST be approved by responsible safety reviewer
      - 1 pilot trial review COMPLETED before 5×3 trials
    safety_check_id: safety_check_q1_w1_pilot_001
    source_artifact_path: sandbox/wk4/lab8/safety_checklist.md
    source_template: W4-T-SAFETY-CHECKLIST
    review_status: not_reviewed

q1_w1_preflight:
  - "tools/verify_env.sh --week 4 PASS (validates SP4 logging baseline)"
  - "ros2 doctor or documented equivalent environment smoke check"
  - "mock adapter no-op execution confirmed"
  - "required topics listed (/joint_states, /cmd_vel, /tf, /tf_static, /clock)"
  - "rosbag2 minimal record confirmed for required topics"
  - "safety_checklist reviewed by responsible owner (review_status: approved)"
  - "1 object × 1 pilot trial executed"
  - "pilot review COMPLETED before proceeding to 5 objects × 3 trials"

re_judge_gates:
  - gate_id: q1_w1_pre_start
    purpose: "Phase 0 成果物の Q1 移行可否確認"
    decisions: ["safety review approved", "env smoke test passed", "no-action dry run completed", "q1_execution_mode を mock/sim/real のどれかに確定"]
  - gate_id: q1_w1_exit
    purpose: "1 pilot trial 後の再判断"
    decisions: ["proceed from 1 pilot trial to 15 planned trials", "continue pilot", "replan"]
  - gate_id: q1_mid_point
    purpose: "W2 以降 detail の確定 (Phase 0 で prescribe しない)"
    decisions: ["update failure taxonomy", "update KPI", "update operator workflow"]
  - gate_id: q1_closeout
    purpose: "Lv1 継続可否"
    decisions: ["proceed to MS Lv1", "revise Phase 0 artifacts", "escalate"]

free_text_section:
  open_questions: |
    - q1_execution_mode の最終確定 (mock 限定か、sim 拡張か、real まで踏むか)
    - safety_owner の人選
  blockers_for_q1: |
    - safety_checklist review_status が not_reviewed のため、Q1 W1 開始前に必ず approved にする
```
````

- [ ] **Step 6: Write `sandbox_reference/week4/sandbox_review_summary_example.md`**

````markdown
---
type: reference
id: W4-REF-SANDBOX-REVIEW-SUMMARY
title: sandbox_review_summary example — Lab 8b instructor case (Codex 利用なし)
week: 4
duration_min: 30
prerequisites: [W4-Lab8b]
worldcpj_ct: [CT-04, CT-05, CT-06, CT-09]
roles: [common, sandbox]
references: [R-28]
deliverables: [sandbox_review_summary]
---

# sandbox_review_summary example (Lab 8b instructor case)

> **artifact_status**: sandbox_example
>
> Instructor case = Codex 利用なし、自己レビュー手書き。本 example は Codex 補助 column を `N/A` で明示する。

## Codex 利用方針

**Codex 利用なし** (`Codex-suggested patterns: N/A`)

Codex CLI へのアクセスがない環境を想定 (帰省中のスマホ remote control を想定など)。

## Human-found patterns (5+ 必須、自分で見つけた pattern)

1. **環境 sourcing 抜け**: ROS 2 環境を source し忘れて `ros2 bag --help` が動かない事例が複数 (W1, W4 で発生)。verify_env.sh の `--week 4` で `ROS_DISTRO=humble` チェックを追加した
2. **template と example の責務分離**: template に 15 row 全部埋めるか、example だけ埋めるかが曖昧だった。spec §7.2 で「template は構造例 1-2 row、example が fully expanded」と確定
3. **bad example の dead link**: bad_q1_package_example.md の dead link が G5a を falseFAIL させかけた。plain text placeholder + G5A_EXCLUDE_FILES で対処
4. **Codex 出力で禁止リストに触れる**: W3 Lab 6b で Codex prompt に「KDL を試して」と書いて禁止 pattern に触れた事例。lab8b で禁止リスト + 「summarize は可、判断・実装は不可」を明示
5. **W1 turtlesim を Q1 trial と混同する誤解**: trial_sheet に W1 turtlesim を executed row で入れると Q1 CC Gate 0-a の 15 trials count を破壊。Lab 7 で `not_applicable` / `training_*` 規約を明示

## Codex-suggested patterns

N/A (Codex 利用なし)

## Q1 migration lessons (3+ 必須)

1. **safety_owner / reviewer は Q1 W1 開始前に必ず人選確定**: Phase 0 では `TBD` 許容だが、Q1 W1 pre_start gate で具体名を入れること
2. **q1_execution_mode の確定タイミング**: Phase 0 では `TBD`、Q1 W1 pre_start gate で `mock` / `sim` / `real` のどれかに確定する
3. **W1 turtlesim training と Q1 CC Gate 0-a trial の混同を避ける運用**: trial_sheet に W1 episode を入れない、`object_id: turtlesim_training_object` 等の training 専用 id を使う
4. **MCAP plugin の install 判断**: Phase 0 では Stretch だが、Q1 W1 で sim/real recording を MCAP で行うか sqlite3 で行うかを `q1_w1_preflight` 時点で判断
5. **`re_judge_gates` の `q1_mid_point` 活用**: Phase 0 で prescribe していない W2+ detail (failure taxonomy 改訂 / KPI / operator workflow) は本 gate で必ず判断する

## Final review summary

Phase 0 SP1-SP4 を通じて、template / example / sandbox の三層構造と参照型 traceability の運用が確立された。Q1 移行の handoff artifact として Q1 Package を採用、formal ceremony は不要。

## Scope decision (by human)

Q1 縮小 Lv1 の scope は CC Gate 0-a + MS Lv1 に限定する判断は **human 100%** で行った。Codex は本 review summary の作成にも一切利用していない。
````

- [ ] **Step 7: Write `sandbox_reference/week4/bad_q1_package_example.md` (negative example)**

````markdown
---
type: reference
id: W4-REF-BAD-Q1-PACKAGE
title: bad_q1_package_example — INTENTIONALLY INVALID, do not copy
week: 4
duration_min: 15
prerequisites: [W4-Lab8]
worldcpj_ct: [CT-09]
roles: [common, sandbox]
references: [R-30]
deliverables: []
---

# **不採用例 (bad example) — INTENTIONALLY INVALID, do not copy**

> **artifact_status**: intentionally_invalid_example
>
> **do_not_copy: true**
>
> 本 file は教材として **何が不採用例か** を示すために置かれている。実際に Sandbox にコピーしないこと。`source_artifact_path` には dead link / plain text placeholder のみ書かれており、Markdown link は使っていない。

## なぜ不採用か (4 件の bad pattern)

### Bad pattern 1: safety review marked done without reviewer

```yaml
review_status: approved   # ❌ NG: reviewer_name / reviewer_role / reviewed_at が未記入
reviewer_name: TBD
reviewer_role: TBD
reviewed_at: TBD
```

**理由**: `review_status: approved` は `reviewer_name` / `reviewer_role` / `reviewed_at` が埋まっている場合のみ許可。安全に直結する review が空 reviewer で承認になっている。

### Bad pattern 2: trial_sheet copies template content

```yaml
# ❌ NG: Q1 Package 内に trial_sheet の 15 rows を直接コピーしている
rows:
  - row: 7_trial_kpi_plan
    rows_inline:
      - {trial_id: trial_001, ...}
      - {trial_id: trial_002, ...}
      # ... 13 more
```

**理由**: Q1 Package は他 templates を **参照** する meta package。data を copy すると trial_sheet 更新時に Q1 Package を全書き直しする必要が出る。`source_artifact_path` で path 参照すべき。

### Bad pattern 3: Q1 W2-W3 omitted without re_judge_gates

```yaml
# ❌ NG: q1_w1_pre_start と q1_w1_exit のみ。q1_mid_point / q1_closeout が silent omission
re_judge_gates:
  - gate_id: q1_w1_pre_start
    ...
  - gate_id: q1_w1_exit
    ...
```

**理由**: Q1 W2 以降の detail (failure taxonomy 改訂 / KPI / operator workflow) を Phase 0 で prescribe しない方針だが、その判断 gate を `re_judge_gates` で **deferred 明示** する必要がある。silent omission は bad pattern。

### Bad pattern 4: Codex accepted without rationale

```yaml
# ❌ NG: Codex が出力した scope decision を rationale なしで採用
phase0_review_summary_path: missing/path/example.md  # intentionally invalid
```

(本 file の dead link は plain text placeholder で記載 — Markdown link `[]()` は使わない、G5a が dead link を検出するため)

**理由**: Lab 8b で「Codex は summarize 可、判断・実装は不可」と定めている。Q1 縮小 Lv1 の scope 判断 (CC/MS どこまで、人協調/双腕入れるか) を Codex に委ね、accepted/rejected の rationale なしに採用するのは bad pattern。

## 正しい例

→ [q1_reduced_lv1_execution_package_example.md](./q1_reduced_lv1_execution_package_example.md) を参照
````

- [ ] **Step 8: Write `sandbox_reference/week4/codex_pattern_extract_example.md` (optional Codex example)**

````markdown
---
type: reference
id: W4-REF-CODEX-PATTERN-EXTRACT
title: codex_pattern_extract example — optional Codex usage in Lab 8b
week: 4
duration_min: 15
prerequisites: [W4-Lab8b]
worldcpj_ct: [CT-04]
roles: [common, sandbox]
references: [R-28]
deliverables: []
---

# codex_pattern_extract example (Lab 8b 任意 Codex 利用)

> **artifact_status**: sandbox_example
>
> Lab 8b で **Codex を利用する場合** の擬似 example。instructor case (Codex 利用なし) では「もし Codex を使うなら」の参考として置く。

## 想定 prompt

```
以下は私の Sandbox PR Review Notes (W2 + W3 計 3 件) です。
共通 pattern を 3 行で抽出してください。

注意: pattern 抽出のみ。implementation / scope decision / safety
judgment は出力しないでください。

---
[W2 Lab 4 PR Notes 抜粋]
- mock adapter で /joint_states を publish するが topic 名 typo で他 node が subscribe できなかった
- launch file の use_sim_time false が原因で tf_static の timestamp が古いと判定された

[W3 Lab 5 PR Notes 抜粋]
- ros_gz_bridge YAML の topic 名前が gz 側と ros 側で逆だった
- Gazebo 起動時に GZ_PARTITION 未設定で複数 instance が衝突

[W3 Lab 6 PR Notes 抜粋]
- provisional schema の output 4 field のうち failure_reason が unknown のまま放置
```

## Codex-suggested patterns (3 行抽出)

```
1. topic / param 名前の typo / mismatch (W2 launch / W3 ros_gz_bridge YAML 共通)
2. environment variable や launch arg の sourcing / 設定漏れ (use_sim_time, GZ_PARTITION)
3. provisional schema の output field を unknown のまま放置せず、Phase 0 では unknown 容認 + 空欄 NG ルールを徹底
```

## Accepted / rejected 分離記録

- **Accepted**: 1, 2 — 確かに W2/W3 共通の pattern として human-found patterns に追記する価値あり
- **Rejected**: 3 — provisional schema の output field policy は spec §3.4 で既に定めており、本 review summary で再記載は冗長。reject。
````

- [ ] **Step 9: Write 3 lab walk-through README files**

`sandbox_reference/week4/lab7/README.md`:

````markdown
---
type: reference
id: W4-REF-LAB7-README
title: Lab 7 walk-through summary (instructor case)
week: 4
duration_min: 5
prerequisites: [W4-Lab7]
worldcpj_ct: [CT-04]
roles: [common, logging]
references: [R-28]
deliverables: []
---

# Lab 7 walk-through summary

instructor case = SP1 W1 Lab 1 turtlesim bag を題材に Lab 7 を完了した想定。

詳細は [`../episode_record_example.md`](../episode_record_example.md) を参照。

## 観察された挙動

- Q1-specific linkage keys (`q1_package_id` / `trial_sheet_id` / `trial_id` / `object_id`) は `not_applicable` または `training_*` に設定
- `evidence_path` で SP1 W1 Lab 1 bag_info.txt を参照、raw bag は commit せず
- mock 環境のため `result: success` / `failure_reason: none` / `bridge_schema_version: not_applicable` / `adapter_version: not_applicable`
````

`sandbox_reference/week4/lab8/README.md`:

````markdown
---
type: reference
id: W4-REF-LAB8-README
title: Lab 8 walk-through summary (instructor case)
week: 4
duration_min: 10
prerequisites: [W4-Lab8]
worldcpj_ct: [CT-04, CT-05, CT-09]
roles: [common, logging, safety]
references: [R-28, R-30]
deliverables: []
---

# Lab 8 walk-through summary

instructor case = Q1 Reduced Lv1 planning owner として 3 templates を統合した想定。

詳細は以下を参照:
- [`../q1_reduced_lv1_execution_package_example.md`](../q1_reduced_lv1_execution_package_example.md)
- [`../safety_checklist_example.md`](../safety_checklist_example.md)
- [`../trial_sheet_example.md`](../trial_sheet_example.md)

## 観察された挙動

- Q1 Package 8 行で W1-W3 templates を `source_artifact_path` で参照、data は copy せず
- safety_checklist は `phase0_status: training_draft_only` / `q1_blocker_if_unreviewed: true`
- trial_sheet は 15 planned rows skeleton (W1 turtlesim 混入なし)
- `q1_w1_preflight` 8 項目、`re_judge_gates` 4 件 (`q1_w1_pre_start` / `q1_w1_exit` / `q1_mid_point` / `q1_closeout`)
````

`sandbox_reference/week4/lab8b/README.md`:

````markdown
---
type: reference
id: W4-REF-LAB8B-README
title: Lab 8b walk-through summary (instructor case, Codex 利用なし)
week: 4
duration_min: 5
prerequisites: [W4-Lab8b]
worldcpj_ct: [CT-04]
roles: [common, sandbox]
references: [R-28]
deliverables: []
---

# Lab 8b walk-through summary

instructor case = Codex 利用なし、自己レビュー手書きで Lab 8b を完了した想定。

詳細は [`../sandbox_review_summary_example.md`](../sandbox_review_summary_example.md) を参照。Codex 利用ありの擬似 example は [`../codex_pattern_extract_example.md`](../codex_pattern_extract_example.md) を参照。

## 観察された挙動

- Human-found patterns 5 件記載
- Q1 migration lessons 5 件記載 (要件は 3 件以上)
- Codex-suggested patterns: N/A 明示
- Scope decision by human (Codex に委ねず)
````

- [ ] **Step 10: Verify all 10 sandbox files exist + 主要 G4 patterns**

```bash
# G1 — files exist
for f in episode_record_example trial_sheet_example safety_checklist_example q1_reduced_lv1_execution_package_example sandbox_review_summary_example bad_q1_package_example codex_pattern_extract_example; do
    test -f "sandbox_reference/week4/${f}.md" && echo "G1 ${f} OK"
done
for sub in lab7 lab8 lab8b; do
    test -f "sandbox_reference/week4/${sub}/README.md" && echo "G1 ${sub}/README OK"
done

# G4 — episode_record_example
F=sandbox_reference/week4/episode_record_example.md
for kw in "training_trial_w1_lab1_001" "turtlesim_training_object" "evidence_path" "result: success" "failure_reason: none" "bridge_schema_version: not_applicable" "adapter_version: not_applicable" "environment_mode: mock" "q1_package_id: not_applicable" "trial_sheet_id: not_applicable"; do
    grep -qF "$kw" "$F" && echo "ER must '$kw' OK" || echo "ER FAIL: '$kw'"
done

# G4 — q1 example
F=sandbox_reference/week4/q1_reduced_lv1_execution_package_example.md
for kw in "q1_w1_pre_start" "q1_w1_exit" "q1_mid_point" "q1_closeout" "phase0_handoff: true" "phase0_review_summary_path" "q1_execution_mode" "owner_role"; do
    grep -qF "$kw" "$F" && echo "Q1ex must '$kw' OK"
done

# G4 — sandbox_review_summary
F=sandbox_reference/week4/sandbox_review_summary_example.md
grep -qE "(human-found patterns|自分で見つけた pattern)" "$F" && echo "SR must human-found OK"
grep -qE "(Q1 migration lessons|Q1 移行教訓)" "$F" && echo "SR must Q1 migration OK"
grep -qE "Codex.*N/A" "$F" && echo "SR must Codex N/A OK"

# G4 negative-example — bad_q1_package_example
F=sandbox_reference/week4/bad_q1_package_example.md
grep -qF "artifact_status: intentionally_invalid_example" "$F" && echo "Bad ex must invalid OK"
grep -qF "do_not_copy: true" "$F" && echo "Bad ex must do_not_copy OK"
grep -qE "(不採用例|bad example)" "$F" && echo "Bad ex must marker OK"
```
Expected: ~28 `OK`, 0 `FAIL`.

- [ ] **Step 11: Commit**

```bash
git add sandbox_reference/week4/
git commit -m "$(cat <<'EOF'
docs: add sandbox_reference/week4 (10 files: 6 examples + 3 walk-throughs + 1 optional Codex)

Spec §8. Instructor walk-through fill demos for SP4:
- episode_record_example.md: SP1 W1 Lab 1 turtlesim bag, Q1-specific
  linkage keys as not_applicable / training_*
- trial_sheet_example.md: 15 planned rows skeleton, W1 turtlesim
  separated as shape-reference only (NOT counted as Q1 trial)
- safety_checklist_example.md: phase0_status:training_draft_only +
  q1_blocker_if_unreviewed:true + reviewer fields TBD
- q1_reduced_lv1_execution_package_example.md: 8 rows referencing
  W1-W3/W4 artifacts, q1_w1_preflight 8 items, re_judge_gates 4
  (q1_w1_pre_start / q1_w1_exit / q1_mid_point / q1_closeout)
- sandbox_review_summary_example.md: instructor case (Codex 利用なし),
  5+ human-found patterns + 5 Q1 migration lessons,
  Codex-suggested:N/A
- bad_q1_package_example.md: artifact_status:intentionally_invalid_
  example + do_not_copy:true + 4 bad patterns documented; dead link
  is plain text placeholder (no Markdown link, G5a-safe)
- codex_pattern_extract_example.md: optional Codex usage demo with
  prompt "summarize only, no implementation/scope/safety decisions"
- lab7/lab8/lab8b README: walk-through summaries
EOF
)"
```

---

## Task 17: tools/check_structure.sh — SP4 strict pattern activation + EXPECTED_FILES + COURSE_TEN_KEY_FILES

**Files:**
- Modify: `tools/check_structure.sh` (extend EXPECTED_FILES with all 28 SP4 files; extend COURSE_TEN_KEY_FILES with the 20 SP4 entries that need 10-key front matter — CHECKLIST/HINTS excluded; insert ~90 `check_pattern_must` + 4 `check_pattern_must_not_strip` + 3 `check_pattern_negative_example` calls)

Spec §9.1 (G1), §9.2 (G2), §9.4.3 (G4 patterns), §9.4.4 (file handling sequence).

- [ ] **Step 1: Add SP4 entries to `EXPECTED_FILES`**

Find the existing `EXPECTED_FILES=(...)` array. Add the following lines before the closing `)`:

```bash
    # === SP4 / Week 4 (Logging / Eval / Safety + Q1 Package) ===
    "course/week4/README.md"
    "course/week4/lectures/l7_rosbag2_mcap_episode_record.md"
    "course/week4/lectures/l8_safety_sop_safe_no_action.md"
    "course/week4/labs/lab7_episode_record/README.md"
    "course/week4/labs/lab7_episode_record/CHECKLIST.md"
    "course/week4/labs/lab7_episode_record/HINTS.md"
    "course/week4/labs/lab8_q1_execution_package/README.md"
    "course/week4/labs/lab8_q1_execution_package/CHECKLIST.md"
    "course/week4/labs/lab8_q1_execution_package/HINTS.md"
    "course/week4/labs/lab8b_sandbox_final_review/README.md"
    "course/week4/labs/lab8b_sandbox_final_review/CHECKLIST.md"
    "course/week4/labs/lab8b_sandbox_final_review/HINTS.md"
    "course/week4/deliverables/episode_record_template.md"
    "course/week4/deliverables/trial_sheet_template.md"
    "course/week4/deliverables/safety_checklist_template.md"
    "course/week4/deliverables/q1_reduced_lv1_execution_package_template.md"
    "sandbox_reference/week4/episode_record_example.md"
    "sandbox_reference/week4/trial_sheet_example.md"
    "sandbox_reference/week4/safety_checklist_example.md"
    "sandbox_reference/week4/q1_reduced_lv1_execution_package_example.md"
    "sandbox_reference/week4/sandbox_review_summary_example.md"
    "sandbox_reference/week4/bad_q1_package_example.md"
    "sandbox_reference/week4/codex_pattern_extract_example.md"
    "sandbox_reference/week4/lab7/README.md"
    "sandbox_reference/week4/lab8/README.md"
    "sandbox_reference/week4/lab8b/README.md"
```

- [ ] **Step 2: Add SP4 entries to `COURSE_TEN_KEY_FILES` (CHECKLIST/HINTS excluded)**

Find the `COURSE_TEN_KEY_FILES=(...)` array. Add the following lines before the closing `)`:

```bash
    # === SP4 / Week 4 (10-key required: lecture/lab/template/week/reference) ===
    "course/week4/README.md"
    "course/week4/lectures/l7_rosbag2_mcap_episode_record.md"
    "course/week4/lectures/l8_safety_sop_safe_no_action.md"
    "course/week4/labs/lab7_episode_record/README.md"
    "course/week4/labs/lab8_q1_execution_package/README.md"
    "course/week4/labs/lab8b_sandbox_final_review/README.md"
    "course/week4/deliverables/episode_record_template.md"
    "course/week4/deliverables/trial_sheet_template.md"
    "course/week4/deliverables/safety_checklist_template.md"
    "course/week4/deliverables/q1_reduced_lv1_execution_package_template.md"
    "sandbox_reference/week4/episode_record_example.md"
    "sandbox_reference/week4/trial_sheet_example.md"
    "sandbox_reference/week4/safety_checklist_example.md"
    "sandbox_reference/week4/q1_reduced_lv1_execution_package_example.md"
    "sandbox_reference/week4/sandbox_review_summary_example.md"
    "sandbox_reference/week4/bad_q1_package_example.md"
    "sandbox_reference/week4/codex_pattern_extract_example.md"
    "sandbox_reference/week4/lab7/README.md"
    "sandbox_reference/week4/lab8/README.md"
    "sandbox_reference/week4/lab8b/README.md"
```

- [ ] **Step 3: Append SP4 G4 patterns block at the END of the G4 section**

Find the existing G4 calls (the lines starting with `check_pattern "sandbox_reference/week1/...`). Locate the END of the G4 block — the very last `check_pattern` / `check_pattern_must` / `check_min_size` / `check_python_syntax` call before the script's exit logic. Insert the following block immediately after the last existing G4 call and before the exit logic:

```bash
# ---------- G4: SP4 / Week 4 patterns ----------
echo
echo "==== G4: SP4 (Week 4) content patterns ===="

# --- L7 lecture (must) ---
L7=course/week4/lectures/l7_rosbag2_mcap_episode_record.md
check_pattern_must "$L7" "rosbag2" "L7 rosbag2"
check_pattern_must "$L7" "MCAP" "L7 MCAP"
check_pattern_must "$L7" "episode_record" "L7 episode_record"
check_pattern_must "$L7" "failure_reason" "L7 failure_reason"
check_pattern_must "$L7" "taxonomy" "L7 taxonomy"
check_pattern_must "$L7" "duration_sec" "L7 duration_sec"
check_pattern_must "$L7" "evidence_path" "L7 evidence_path"
check_pattern_must "$L7" "services/actions recording" "L7 services/actions"
check_pattern_must "$L7" "(Stretch|任意)" "L7 Stretch|任意"
check_pattern_must "$L7" "(Course baseline 範囲外|out of scope for the Course baseline)" "L7 baseline out-of-scope"

# --- L8 lecture (must) ---
L8=course/week4/lectures/l8_safety_sop_safe_no_action.md
check_pattern_must "$L8" "(Standard Operating Procedure|SOP)" "L8 SOP"
check_pattern_must "$L8" "emergency stop" "L8 emergency stop"
check_pattern_must "$L8" "safeguard" "L8 safeguard"
check_pattern_must "$L8" "protective" "L8 protective"
check_pattern_must "$L8" "(manual_reset_required|manual reset)" "L8 manual reset"
check_pattern_must "$L8" "not_normal_stop" "L8 not_normal_stop"
check_pattern_must "$L8" "not_auto_resume" "L8 not_auto_resume"
check_pattern_must "$L8" "safe no-action" "L8 safe no-action"
check_pattern_must "$L8" "operator confirmation" "L8 operator confirmation"
check_pattern_must "$L8" "(not an approval artifact|approval artifact ではない)" "L8 not an approval artifact"
check_pattern_must "$L8" "training draft" "L8 training draft"
check_pattern_must "$L8" "(instructional examples|教材上の例)" "L8 instructional examples"
check_pattern_must "$L8" "ISO 10218" "L8 ISO 10218"

# --- L8 lecture (must-not, with inline-code strip) ---
check_pattern_must_not_strip "$L8" "non.recoverable" "L8 must-not non-recoverable"
check_pattern_must_not_strip "$L8" "自動復帰(する|できる)" "L8 must-not 自動復帰する/できる"
check_pattern_must_not_strip "$L8" "auto.?resume.?allowed" "L8 must-not auto resume allowed"
check_pattern_must_not_strip "$L8" "operator confirmation で safety review を代替" "L8 must-not operator confirm 代替"

# --- Lab 7 README (must) ---
LAB7R=course/week4/labs/lab7_episode_record/README.md
check_pattern_must "$LAB7R" "episode_record_template" "Lab7 template"
check_pattern_must "$LAB7R" "not_applicable" "Lab7 not_applicable"
check_pattern_must "$LAB7R" "(Phase 0 training episode|not counted as a Q1|Q1 trial として数えない)" "Lab7 Q1 区別"

# --- episode_record example (must) ---
ER=sandbox_reference/week4/episode_record_example.md
check_pattern_must "$ER" "training_trial_w1_lab1_001" "ER training_trial id"
check_pattern_must "$ER" "turtlesim_training_object" "ER turtlesim_training_object"
check_pattern_must "$ER" "evidence_path" "ER evidence_path"
check_pattern_must "$ER" "result: success" "ER result success"
check_pattern_must "$ER" "failure_reason: none" "ER failure_reason none"
check_pattern_must "$ER" "bridge_schema_version: not_applicable" "ER bridge_schema_version"
check_pattern_must "$ER" "adapter_version: not_applicable" "ER adapter_version"
check_pattern_must "$ER" "environment_mode: mock" "ER environment_mode"
check_pattern_must "$ER" "q1_package_id: not_applicable" "ER q1_package_id"
check_pattern_must "$ER" "trial_sheet_id: not_applicable" "ER trial_sheet_id"

# --- Lab 8 README (must) ---
LAB8R=course/week4/labs/lab8_q1_execution_package/README.md
check_pattern_must "$LAB8R" "q1_reduced_lv1_execution_package_template" "Lab8 q1 template"
check_pattern_must "$LAB8R" "safety_checklist_template" "Lab8 safety template"
check_pattern_must "$LAB8R" "trial_sheet_template" "Lab8 trial template"
check_pattern_must "$LAB8R" "source_artifact_path" "Lab8 source_artifact_path"
check_pattern_must "$LAB8R" "source_template" "Lab8 source_template"
check_pattern_must "$LAB8R" "15 planned rows" "Lab8 15 planned rows"
check_pattern_must "$LAB8R" "q1_w1_preflight" "Lab8 q1_w1_preflight"
check_pattern_must "$LAB8R" "re_judge_gates" "Lab8 re_judge_gates"
check_pattern_must "$LAB8R" "1 pilot trial" "Lab8 1 pilot trial"
check_pattern_must "$LAB8R" "pilot review" "Lab8 pilot review"
check_pattern_must "$LAB8R" "(5 物体 × 3 trials 直行禁止|direct_15_trials_without_pilot)" "Lab8 直行禁止"

# --- Lab 8b README (must) ---
LAB8BR=course/week4/labs/lab8b_sandbox_final_review/README.md
check_pattern_must "$LAB8BR" "(Codex 利用は.*任意|Codex.*optional)" "Lab8b Codex 任意"
check_pattern_must "$LAB8BR" "summarize" "Lab8b summarize"
check_pattern_must "$LAB8BR" "(must not implement|判断・実装.*不可)" "Lab8b implement 不可"
check_pattern_must "$LAB8BR" "must not make scope decisions" "Lab8b scope decisions 不可"
check_pattern_must "$LAB8BR" "(human-found patterns|自分で見つけた pattern)" "Lab8b human-found"
check_pattern_must "$LAB8BR" "(Q1 migration lessons|Q1 移行教訓)" "Lab8b Q1 migration"
check_pattern_must "$LAB8BR" "(scope decision.*human|scope.*人間|scope 判断は人間)" "Lab8b scope by human"

# --- 4 templates artifact_status (must) ---
check_pattern_must "course/week4/deliverables/episode_record_template.md" "artifact_status: template" "T-EPISODE artifact_status"
check_pattern_must "course/week4/deliverables/trial_sheet_template.md" "artifact_status: template" "T-TRIAL artifact_status"
check_pattern_must "course/week4/deliverables/safety_checklist_template.md" "artifact_status: template" "T-SAFETY artifact_status"
check_pattern_must "course/week4/deliverables/q1_reduced_lv1_execution_package_template.md" "artifact_status: template" "T-Q1PKG artifact_status"

# --- episode_record template (must, field-level) ---
TEPI=course/week4/deliverables/episode_record_template.md
for kw in "episode_id:" "q1_package_id:" "trial_id:" "object_id:" "environment_mode:" "adapter_version:" "bridge_schema_version:" "evidence_path:" "result:" "failure_reason:" "review_status:"; do
    check_pattern_must "$TEPI" "$kw" "T-EPISODE field $kw"
done

# --- trial_sheet template (must) ---
TTRI=course/week4/deliverables/trial_sheet_template.md
for kw in "trial_sheet_id:" "safety_check_id:" "total_planned_rows: 15" "trial_status:" "kpi_grasp_success:" "kpi_time_to_grasp_sec:" "skip_or_block_reason:"; do
    check_pattern_must "$TTRI" "$kw" "T-TRIAL field $kw"
done

# --- safety_checklist template (must) ---
TSAF=course/week4/deliverables/safety_checklist_template.md
for kw in "safety_check_id:" "phase0_status: training_draft_only" "q1_blocker_if_unreviewed: true" "reviewer_name:" "reviewer_role:" "reviewed_at:" "stop_condition:" "other_stop_condition_detail:" "forbidden_operations:" "safe_no_action_conditions:" "description_ja:"; do
    check_pattern_must "$TSAF" "$kw" "T-SAFETY field $kw"
done

# --- q1 package template (must, 8 row meta + meta keys + gate ids) ---
TQ1=course/week4/deliverables/q1_reduced_lv1_execution_package_template.md
for kw in "q1_package_id:" "phase0_handoff: true" "bridge_schema_version:" "q1_execution_mode:" "owner_role:" "next_decision_owner:" "phase0_review_summary_path:" "phase0_to_q1_handoff_note:" "1_scope_lv1_boundary" "2_target_task_gate" "3_environment_stack" "4_robot_adapter_readiness" "5_simulation_bridge_status" "6_logging_episode_plan" "7_trial_kpi_plan" "8_safety_review_go_no_go" "source_artifact_path:" "source_template:" "q1_w1_preflight:" "re_judge_gates:" "q1_w1_pre_start" "q1_w1_exit" "q1_mid_point" "q1_closeout"; do
    check_pattern_must "$TQ1" "$kw" "T-Q1PKG field $kw"
done

# --- q1 package example (must) ---
Q1EX=sandbox_reference/week4/q1_reduced_lv1_execution_package_example.md
for kw in "q1_w1_pre_start" "q1_w1_exit" "q1_mid_point" "q1_closeout" "phase0_handoff: true" "phase0_review_summary_path" "q1_execution_mode" "owner_role"; do
    check_pattern_must "$Q1EX" "$kw" "Q1ex $kw"
done

# --- sandbox_review_summary example (must) ---
SR=sandbox_reference/week4/sandbox_review_summary_example.md
check_pattern_must "$SR" "(human-found patterns|自分で見つけた pattern)" "SR human-found"
check_pattern_must "$SR" "(Q1 migration lessons|Q1 移行教訓)" "SR Q1 migration"
check_pattern_must "$SR" "Codex.*N/A" "SR Codex N/A"

# --- references.md (must) ---
for n in 28 29 30 31 32; do
    check_pattern_must "docs/references.md" "R-${n}\b" "ref R-${n}"
done

# --- check_structure.sh self-reference (must, structure markers) ---
check_pattern_must "tools/check_structure.sh" "_strip_inline_code" "self _strip_inline_code"
check_pattern_must "tools/check_structure.sh" "check_pattern_must_not_strip" "self check_pattern_must_not_strip"
check_pattern_must "tools/check_structure.sh" "check_pattern_negative_example" "self check_pattern_negative_example"

# --- verify_env.sh self-reference (must) ---
check_pattern_must "tools/verify_env.sh" "week 4" "self --week 4"
check_pattern_must "tools/verify_env.sh" "has_ros_pkg_or_deb" "self has_ros_pkg_or_deb"

# --- bad_q1_package_example (NEGATIVE — not subject to positive checks above) ---
BAD=sandbox_reference/week4/bad_q1_package_example.md
check_pattern_negative_example "$BAD" "artifact_status: intentionally_invalid_example" "BAD invalid marker"
check_pattern_negative_example "$BAD" "do_not_copy: true" "BAD do_not_copy"
check_pattern_negative_example "$BAD" "(不採用例|bad example)" "BAD marker"
```

> **Note**: positive `check_pattern_must` calls above intentionally do NOT include `bad_q1_package_example.md` as a target — that file is only checked by `check_pattern_negative_example` calls. This realises the spec §9.4 "EXCLUDE_FROM_POSITIVE" requirement at the call-site level (no separate exclude array needed because the existing helper signature takes the file as an argument).

- [ ] **Step 4: Verify the file still parses and run full check_structure.sh**

```bash
bash -n tools/check_structure.sh
bash tools/check_structure.sh; echo "exit=$?"
```
Expected: exit 0. All G1 (28 SP4 files exist) + G2 (20 SP4 files have 10-key + spec/plan 7-key) + G4 (~90 must + 4 must-not + 3 negative-example) + G5a PASS.

- [ ] **Step 5: Run all 5 gates summary**

```bash
echo "=== G1/G2/G4/G5a (check_structure.sh) ==="
bash tools/check_structure.sh; G_RESULT=$?
echo "G1+G2+G4+G5a exit=$G_RESULT"
echo ""
echo "=== G3 (verify_env.sh --week 4) ==="
bash tools/verify_env.sh --week 4; V4_RESULT=$?
echo "G3 --week 4 exit=$V4_RESULT"
echo ""
echo "=== Regression --week 1 ==="
bash tools/verify_env.sh --week 1 2>&1 | tail -3; V1_RESULT=$?
echo "regression --week 1 exit=$V1_RESULT"
```
Expected: all 3 exits = 0.

- [ ] **Step 6: Commit**

```bash
git add tools/check_structure.sh
git commit -m "$(cat <<'EOF'
tool: activate SP4 strict G1/G2/G4 patterns in check_structure.sh

Spec §9.1, §9.2, §9.4. Adds SP4 entries to EXPECTED_FILES (28 files:
16 course/week4 + 10 sandbox_reference/week4 + 1 spec already in G2 +
1 plan already in G2; sandbox sub-dir lab READMEs counted in 10) and
COURSE_TEN_KEY_FILES (20 entries — CHECKLIST/HINTS excluded per spec
§9.2). Inserts ~90 check_pattern_must calls covering L7/L8 lectures,
Lab 7/8/8b READMEs, 4 deliverable templates (episode_record /
trial_sheet / safety_checklist / Q1 Package), the 5 sandbox example
files, references R-28..R-32, and self-reference structure markers.
Adds 4 check_pattern_must_not_strip calls for L8 (non-recoverable,
自動復帰する/できる, auto resume allowed, operator confirmation で
safety review を代替) and 3 check_pattern_negative_example calls for
bad_q1_package_example.md. The bad-example file is excluded from
positive must-checks at the call-site level (never targeted by
check_pattern_must above).
EOF
)"
```

---

## Task 18: Lab 8 demo review + final 5-gate validation + push (no new committed files)

**Files:**
- (no file changes; review of `sandbox_reference/week4/` Lab 8 demo + final validation + push)

Spec §10 (Acceptance criteria), §12.5 (T18 no-new-files policy).

- [ ] **Step 1: Review Lab 8 demo acceptance**

Confirm the following without any file changes (Lab 8 demo lives in `sandbox_reference/week4/`):

```bash
# 10.3 traceability
grep -q "phase0_handoff: true" sandbox_reference/week4/q1_reduced_lv1_execution_package_example.md && echo "10.3.1 q1_pkg phase0_handoff OK"
grep -q "source_artifact_path" sandbox_reference/week4/q1_reduced_lv1_execution_package_example.md && echo "10.3.2 q1_pkg source_artifact_path OK"
for g in q1_w1_pre_start q1_w1_exit q1_mid_point q1_closeout; do
    grep -q "$g" sandbox_reference/week4/q1_reduced_lv1_execution_package_example.md && echo "10.3.3 gate $g OK"
done
grep -q "phase0_status: training_draft_only" sandbox_reference/week4/safety_checklist_example.md && echo "10.3.4 safety phase0_status OK"
grep -q "q1_blocker_if_unreviewed: true" sandbox_reference/week4/safety_checklist_example.md && echo "10.3.5 safety blocker OK"
grep -c "trial_status: planned" sandbox_reference/week4/trial_sheet_example.md
echo "Expected ≥ 15 (15 planned rows + possibly 1 in shape-reference comment)"
```
Expected: 6 explicit `OK` lines + the `trial_status: planned` count ≥ 15.

- [ ] **Step 2: Final 5-gate validation**

```bash
echo "==== FINAL: 5 gates ===="
echo "[Gate 1: G1/G2/G4/G5a] tools/check_structure.sh"
bash tools/check_structure.sh; G_RES=$?
echo ""
echo "[Gate 2: G3 --week 4] tools/verify_env.sh --week 4"
bash tools/verify_env.sh --week 4; V4_RES=$?
echo ""
echo "[Gate 3: G3 regression --week 1]"
bash tools/verify_env.sh --week 1 >/dev/null 2>&1; V1_RES=$?
echo "exit=$V1_RES"
echo ""
echo "==== SUMMARY ===="
echo "check_structure.sh exit: $G_RES (expected 0)"
echo "verify_env.sh --week 4 exit: $V4_RES (expected 0; WARN allowed)"
echo "verify_env.sh --week 1 exit: $V1_RES (expected 0)"
```
Expected: all three exits = 0.

- [ ] **Step 3: File count check**

```bash
git ls-files | wc -l
```
Expected: `128` exactly (SP3 100 + SP4 spec 1 + SP4 plan 1 + 26 SP4 course/sandbox files).

- [ ] **Step 4: No new committed files (T18 policy)**

```bash
git status --short
```
Expected: empty (no untracked / no staged changes — Lab 8 demo lives in already-committed `sandbox_reference/week4/`).

- [ ] **Step 5: Closure commit (root README + final note)**

If desired, add a brief Phase 0 closure note to root README. Otherwise skip Step 5 and proceed to Step 6.

```bash
# (optional) edit README.md to add a "## Phase 0 完了" section
```

If edited:

```bash
git add README.md
git commit -m "$(cat <<'EOF'
docs: mark Phase 0 complete (SP1-SP4 教材揃い)

Spec §15. Phase 0 完了は教材揃いの宣言にとどめる。Q1 移行は Q1
Package §8 safety review + q1_w1_preflight 8 項目 + 1 pilot trial
review 完了が条件。Q1 Package 自体が handoff artifact、formal
ceremony は不要 (out-of-scope per spec §2.2)。
EOF
)"
```

- [ ] **Step 6: Merge to main**

```bash
git checkout main
git merge --ff-only course/sp4-week4-logging-safety-q1package
git log --oneline -10
```
Expected: fast-forward merge succeeds. Recent log shows SP4 commits ahead of `316180e`.

- [ ] **Step 7: Final summary report**

Print to stdout (not committed):

```
SP4 (Phase 0 Week 4 Logging / Eval / Safety + Q1 Package) complete.

- 28 new files (26 course/sandbox + 1 spec + 1 plan)
- 5 modified files (README, course/README, verify_env.sh,
  check_structure.sh, docs/references.md)
- Total tracked files: 128

5 gates:
- G1 (file existence): PASS
- G2 (front matter): PASS — 10-key for course/sandbox, 7-key for spec/plan
- G3 (--week 4): PASS [WARN allowed for MCAP plugin]
- G4 (content patterns): PASS — ~90 must, 4 must-not, 3 negative-example
- G5a (local links): PASS — bad_q1_package_example.md excluded

Phase 0 教材揃い。Q1 移行は Q1 Package §8 safety review +
q1_w1_preflight + 1 pilot trial review 完了が条件。
```

---

## Self-Review (controller-side, before handing to subagents)

This checklist is for the plan controller (the person/agent who wrote this plan). Run these BEFORE dispatching subagents.

**1. Spec coverage:**

| Spec section | Implementing task |
|---|---|
| §3.1 4 templates 階層 | T9-T12 (templates) |
| §3.2 Phase 0 → Q1 handoff | T12 (q1 template body) |
| §3.3 共通 linkage keys | T9-T12, T16 |
| §3.4 共通 taxonomies | T9 (episode_record), T11 (safety_checklist) |
| §4.1 file count breakdown | T17 EXPECTED_FILES |
| §4.2 26 new files | T5-T16 |
| §4.3 5 modify | T1, T2-T4, T6 |
| §5.1 L7 invariants | T7 |
| §5.2 L8 invariants | T8 |
| §6.1 Lab 7 | T13 |
| §6.2 Lab 8 | T14 |
| §6.3 Lab 8b | T15 |
| §7.1-§7.4 4 templates | T9-T12 |
| §8.1-§8.8 sandbox 10 files | T16 |
| §9.1 G1 | T17 |
| §9.2 G2 | T3 (spec/plan), T17 (course 10-key) |
| §9.3 G3 --week 4 | T4 |
| §9.4 G4 | T2 (framework), T17 (activation) |
| §9.5 G5a | implicit (bad example excluded by call-site convention in T17) |
| §10 Acceptance | T18 (final validation) |
| §11 Risks | mitigated by T2/T17 split (risk row) and T18 no-new-files (risk row) |
| §12 Implementation tasks | T1-T18 (this plan) |
| §13 References | T1 |
| §14 Spec self-review | done at spec time, not part of plan |
| §15 Phase 0 → Q1 handoff | T12 + T18 closure note |

No spec gap detected.

**2. Placeholder scan:** All `TBD` in this plan are intentional and limited to:
- YAML body templates where `TBD` is the documented placeholder value (e.g., `safety_owner: TBD`, `reviewer_name: TBD`)
- Q1-future fields (e.g., `commit_sha: TBD`, `episode_id: TBD` in planned trial rows)

No `TODO` / `implement later` / `fill in details` strings outside these allowlist contexts.

**3. Type / name consistency:**

- `episode_record_template.md` (file) ↔ `W4-T-EPISODE-RECORD` (id) ↔ `episode_record_example.md` (sandbox)
- `trial_sheet_template.md` ↔ `W4-T-TRIAL-SHEET` ↔ `trial_sheet_example.md`
- `safety_checklist_template.md` ↔ `W4-T-SAFETY-CHECKLIST` ↔ `safety_checklist_example.md`
- `q1_reduced_lv1_execution_package_template.md` ↔ `W4-T-Q1-PACKAGE` ↔ `q1_reduced_lv1_execution_package_example.md`
- 4 gate ids: `q1_w1_pre_start` / `q1_w1_exit` / `q1_mid_point` / `q1_closeout` — used identically in T12 (template), T16 (example), T17 (G4 patterns), T18 (acceptance grep)
- 6 stop_condition values: `e_stop_not_verified` / `operator_not_present` / `sop_not_reviewed` / `workspace_not_cleared` / `unexpected_motion_or_command` / `other` — used identically in T11 (template) and T16 (example)
- 11-value failure_reason taxonomy used identically in spec §3.4, T7 L7 §6, T9 (template), T16 (example)

No drift detected.

---

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-04-28-robotics-course-sp4-plan.md`. Two execution options:

1. **Subagent-Driven (recommended)** — I dispatch a fresh subagent per task, two-stage review (spec compliance + code quality) between tasks, fast iteration.
2. **Inline Execution** — Execute tasks T1-T18 in this session via `superpowers:executing-plans`, batched with checkpoints.

Which approach?
