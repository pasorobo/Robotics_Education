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
    "sandbox_reference/week1/lab1/README.md"
    "sandbox_reference/week1/lab2/frame_inventory.md"
    "tools/verify_env.sh"
    "tools/new_week_skeleton.sh"
    "tools/codex_prompt_template.md"
    "tools/check_structure.sh"
    "docs/superpowers/specs/2026-04-27-robotics-course-sp1-design.md"
    "docs/superpowers/plans/2026-04-27-robotics-course-sp1-plan.md"
    "sandbox_reference/week1/lab0/README.md"
    # === SP2 / Week 2 (27 files) ===
    "course/week2/README.md"
    "course/week2/lectures/l3_moveit2_overview.md"
    "course/week2/lectures/l4_robot_adapter_calibration_safety.md"
    "course/week2/labs/lab3_rviz_planning/README.md"
    "course/week2/labs/lab3_rviz_planning/CHECKLIST.md"
    "course/week2/labs/lab3_rviz_planning/HINTS.md"
    "course/week2/labs/lab4_mock_hardware_adapter/README.md"
    "course/week2/labs/lab4_mock_hardware_adapter/CHECKLIST.md"
    "course/week2/labs/lab4_mock_hardware_adapter/HINTS.md"
    "course/week2/labs/lab4b_codex_noop_adapter_logger/README.md"
    "course/week2/labs/lab4b_codex_noop_adapter_logger/CHECKLIST.md"
    "course/week2/labs/lab4b_codex_noop_adapter_logger/HINTS.md"
    "course/week2/deliverables/robot_readiness_mini_report_template.md"
    "course/week2/deliverables/sandbox_pr_review_notes_template.md"
    "sandbox_reference/week2/robot_readiness_mini_report_example.md"
    "sandbox_reference/week2/sandbox_pr_review_notes_example.md"
    "sandbox_reference/week2/lab3/README.md"
    "sandbox_reference/week2/lab3/planning_evidence.md"
    "sandbox_reference/week2/lab4/README.md"
    "sandbox_reference/week2/lab4/controller_spawn.log"
    "sandbox_reference/week2/lab4/controllers_list.txt"
    "sandbox_reference/week2/lab4/joint_states_echo.log"
    "sandbox_reference/week2/lab4b/README.md"
    "sandbox_reference/week2/lab4b/codex_prompt_lab4b.md"
    "sandbox_reference/week2/lab4b/noop_logger.py"
    "sandbox_reference/week2/lab4b/execution_log.txt"
    "docs/superpowers/plans/2026-04-27-robotics-course-sp2-plan.md"
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
    "sandbox_reference/week1/skill_baseline_sheet_example.md"
    "sandbox_reference/week1/sandbox_setup_log_example.md"
    "sandbox_reference/week1/lab0/README.md"
    "sandbox_reference/week1/lab0/codex_connection_check.md"
    "sandbox_reference/week1/lab2/frame_inventory.md"
    # === SP2 / Week 2 (10-key required: lecture/lab/template/week/reference) ===
    "course/week2/README.md"
    "course/week2/lectures/l3_moveit2_overview.md"
    "course/week2/lectures/l4_robot_adapter_calibration_safety.md"
    "course/week2/labs/lab3_rviz_planning/README.md"
    "course/week2/labs/lab4_mock_hardware_adapter/README.md"
    "course/week2/labs/lab4b_codex_noop_adapter_logger/README.md"
    "course/week2/deliverables/robot_readiness_mini_report_template.md"
    "course/week2/deliverables/sandbox_pr_review_notes_template.md"
    "sandbox_reference/week2/robot_readiness_mini_report_example.md"
    "sandbox_reference/week2/sandbox_pr_review_notes_example.md"
    "sandbox_reference/week2/lab3/README.md"
    "sandbox_reference/week2/lab3/planning_evidence.md"
    "sandbox_reference/week2/lab4/README.md"
    "sandbox_reference/week2/lab4b/README.md"
    "sandbox_reference/week2/lab4b/codex_prompt_lab4b.md"
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
        if ! grep -qE "^${k}:" <<< "$fm"; then
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
        if ! grep -qE "^${k}:" <<< "$fm"; then
            err "$f: missing key '$k'"
            return
        fi
    done
    ok
}

for f in "${SPEC_FILES[@]}"; do check_special_fm "$f" "${SPEC_KEYS[@]}"; done
for f in "${PLAN_FILES[@]}"; do check_special_fm "$f" "${PLAN_KEYS[@]}"; done

check_pattern_must() {
    local f="$1"
    local pattern="$2"
    local label="$3"
    if [[ ! -f "$f" ]]; then
        warn "missing for must-pattern check (covered by G1): $f"
        return
    fi
    if grep -qE "$pattern" "$f"; then
        ok
    else
        err "$f: must-pattern not found ($label): /$pattern/"
    fi
}

check_pattern_must_not() {
    local f="$1"
    local pattern="$2"
    local label="$3"
    if [[ ! -f "$f" ]]; then
        warn "missing for must-not-pattern check (covered by G1): $f"
        return
    fi
    if grep -qE "$pattern" "$f"; then
        err "$f: must-not-pattern matched ($label): /$pattern/"
    else
        ok
    fi
}

# ---------- G4: Sandbox content patterns ----------
echo
echo "==== G4: Sandbox reference content patterns ===="

check_pattern() {
    local f="$1"; local pattern="$2"; local label="$3"
    if [[ ! -f "$f" ]]; then
        warn "missing for content check (covered by G1): $f"
        return
    fi
    if grep -qE "$pattern" "$f"; then
        ok
    else
        err "$f: pattern not found ($label)"
    fi
}

check_min_size() {
    local f="$1"; local min_bytes="$2"
    if [[ ! -f "$f" ]]; then
        warn "missing for size check (covered by G1): $f"
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

echo
echo "==== G4 (W2): Lab 3 / 4 / 4b sandbox content patterns ===="

# Lab 3 (3 patterns)
check_pattern_must "sandbox_reference/week2/lab3/planning_evidence.md" '```mermaid' "mermaid fence"
check_pattern_must "sandbox_reference/week2/lab3/planning_evidence.md" "[Pp]lan" "Plan言及"
check_pattern_must "sandbox_reference/week2/lab3/planning_evidence.md" "[Ff]ail|FAIL|失敗" "Plan失敗例"

# Lab 4 (4 patterns)
check_pattern_must "sandbox_reference/week2/lab4/controller_spawn.log" "controller_manager" "ros2_control起動"
check_pattern_must "sandbox_reference/week2/lab4/controllers_list.txt" "joint_state_broadcaster|forward_position_controller" "controller名"
check_pattern_must "sandbox_reference/week2/lab4/controllers_list.txt" "active" "controller active 状態確認"
check_pattern_must "sandbox_reference/week2/lab4/joint_states_echo.log" "position:|name:" "/joint_states 実受信"

# Lab 4b (7 patterns)
check_pattern_must "sandbox_reference/week2/lab4b/noop_logger.py" "rclpy" "rclpy import"
check_pattern_must "sandbox_reference/week2/lab4b/noop_logger.py" "/joint_states" "joint_states subscribe"
check_pattern_must_not "sandbox_reference/week2/lab4b/noop_logger.py" "KDL" "禁止: KDL実コード"
check_pattern_must_not "sandbox_reference/week2/lab4b/noop_logger.py" "controller_manager" "禁止: controller_manager"
check_pattern_must "sandbox_reference/week2/lab4b/execution_log.txt" "noop_logger" "noop_logger 起動確認"
check_pattern_must "sandbox_reference/week2/lab4b/execution_log.txt" "recv name=|pos=" "joint_states 実受信証跡"
check_min_size    "sandbox_reference/week2/lab4b/execution_log.txt" 200 "実行ログ最小サイズ 200 bytes"

# codex_prompt_lab4b.md (6 patterns)
check_pattern_must "sandbox_reference/week2/lab4b/codex_prompt_lab4b.md" "目的" "prompt5項目: 目的"
check_pattern_must "sandbox_reference/week2/lab4b/codex_prompt_lab4b.md" "入力" "prompt5項目: 入力"
check_pattern_must "sandbox_reference/week2/lab4b/codex_prompt_lab4b.md" "制約" "prompt5項目: 制約"
check_pattern_must "sandbox_reference/week2/lab4b/codex_prompt_lab4b.md" "成功条件" "prompt5項目: 成功条件"
check_pattern_must "sandbox_reference/week2/lab4b/codex_prompt_lab4b.md" "検証コマンド" "prompt5項目: 検証コマンド"
check_pattern_must "sandbox_reference/week2/lab4b/codex_prompt_lab4b.md" "禁止" "禁止リスト言及"

# Robot Readiness Mini Report example (7 patterns、行ごと個別)
check_pattern_must "sandbox_reference/week2/robot_readiness_mini_report_example.md" "robot_id" "robot_id 行"
check_pattern_must "sandbox_reference/week2/robot_readiness_mini_report_example.md" "adapter stage" "adapter stage 行"
check_pattern_must "sandbox_reference/week2/robot_readiness_mini_report_example.md" "ROS interface" "ROS interface 行"
check_pattern_must "sandbox_reference/week2/robot_readiness_mini_report_example.md" "calibration state" "calibration state 行"
check_pattern_must "sandbox_reference/week2/robot_readiness_mini_report_example.md" "safety state" "safety state 行"
check_pattern_must "sandbox_reference/week2/robot_readiness_mini_report_example.md" "logging state" "logging state 行"
check_pattern_must "sandbox_reference/week2/robot_readiness_mini_report_example.md" "next gate" "next gate 行"

# Sandbox PR Review Notes example (6 patterns、行ごと個別)
check_pattern_must "sandbox_reference/week2/sandbox_pr_review_notes_example.md" "task split" "task split 行"
check_pattern_must "sandbox_reference/week2/sandbox_pr_review_notes_example.md" "Codex prompt" "Codex prompt 行"
check_pattern_must "sandbox_reference/week2/sandbox_pr_review_notes_example.md" "diff summary" "diff summary 行"
check_pattern_must "sandbox_reference/week2/sandbox_pr_review_notes_example.md" "human review" "human review 行"
check_pattern_must "sandbox_reference/week2/sandbox_pr_review_notes_example.md" "debug evidence" "debug evidence 行"
check_pattern_must "sandbox_reference/week2/sandbox_pr_review_notes_example.md" "judgment boundary" "judgment boundary 行"

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
    done < <(sed 's/`[^`]*`//g' "$mdfile" | grep -oE '\]\([^)]+\)' | sed 's/^](//;s/)$//')
done < <(find . -name "*.md" -not -path "./.git/*" -not -path "./build/*" -not -path "./install/*" -not -path "./docs/superpowers/*")

[[ $local_link_failures -eq 0 ]] && ok

# ---------- bash -n on all *.sh ----------
echo
echo "==== bash -n syntax check on tools/*.sh and course/00_setup/*.sh ===="

while IFS= read -r sh; do
    if output=$(bash -n "$sh" 2>&1); then
        ok
    else
        err "syntax error: $sh"
        if [[ -n "$output" ]]; then
            printf "         %s\n" "$output"
        fi
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
