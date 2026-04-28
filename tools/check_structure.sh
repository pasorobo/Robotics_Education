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
    # === SP2 spec normalization (was missing in SP1 baseline、71件 baseline 確立) ===
    "docs/superpowers/specs/2026-04-27-robotics-course-sp2-design.md"
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
    # === SP3 / Week 3 (28 files) ===
    "course/week3/README.md"
    "course/week3/lectures/l5_gazebo_fortress_ros2_bridge.md"
    "course/week3/lectures/l6_simulator_landscape.md"
    "course/week3/labs/lab5_gazebo_topic_bridge/README.md"
    "course/week3/labs/lab5_gazebo_topic_bridge/CHECKLIST.md"
    "course/week3/labs/lab5_gazebo_topic_bridge/HINTS.md"
    "course/week3/labs/lab6_sim_to_worldcpj_schema/README.md"
    "course/week3/labs/lab6_sim_to_worldcpj_schema/CHECKLIST.md"
    "course/week3/labs/lab6_sim_to_worldcpj_schema/HINTS.md"
    "course/week3/labs/lab6b_codex_noop_bridge_stub/README.md"
    "course/week3/labs/lab6b_codex_noop_bridge_stub/CHECKLIST.md"
    "course/week3/labs/lab6b_codex_noop_bridge_stub/HINTS.md"
    "course/week3/deliverables/simulation_bridge_draft_template.md"
    "course/week3/deliverables/simulator_decision_table_template.md"
    "sandbox_reference/week3/simulation_bridge_draft_example.md"
    "sandbox_reference/week3/simulator_decision_table_example.md"
    "sandbox_reference/week3/lab5/README.md"
    "sandbox_reference/week3/lab5/bridge_config.yaml"
    "sandbox_reference/week3/lab5/bridge_run.log"
    "sandbox_reference/week3/lab5/bridge_topic_list.txt"
    "sandbox_reference/week3/lab6/README.md"
    "sandbox_reference/week3/lab6/scene_packet_design.md"
    "sandbox_reference/week3/lab6b/README.md"
    "sandbox_reference/week3/lab6b/codex_prompt_lab6b.md"
    "sandbox_reference/week3/lab6b/example_scene_packet.json"
    "sandbox_reference/week3/lab6b/bridge_stub.py"
    "sandbox_reference/week3/lab6b/execution_log.txt"
    "docs/superpowers/specs/2026-04-28-robotics-course-sp3-design.md"
    "docs/superpowers/plans/2026-04-28-robotics-course-sp3-plan.md"
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
    # === SP3 / Week 3 (10-key required: lecture/lab/template/week/reference) ===
    "course/week3/README.md"
    "course/week3/lectures/l5_gazebo_fortress_ros2_bridge.md"
    "course/week3/lectures/l6_simulator_landscape.md"
    "course/week3/labs/lab5_gazebo_topic_bridge/README.md"
    "course/week3/labs/lab6_sim_to_worldcpj_schema/README.md"
    "course/week3/labs/lab6b_codex_noop_bridge_stub/README.md"
    "course/week3/deliverables/simulation_bridge_draft_template.md"
    "course/week3/deliverables/simulator_decision_table_template.md"
    "sandbox_reference/week3/simulation_bridge_draft_example.md"
    "sandbox_reference/week3/simulator_decision_table_example.md"
    "sandbox_reference/week3/lab5/README.md"
    "sandbox_reference/week3/lab6/README.md"
    "sandbox_reference/week3/lab6/scene_packet_design.md"
    "sandbox_reference/week3/lab6b/README.md"
    "sandbox_reference/week3/lab6b/codex_prompt_lab6b.md"
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

SPEC_FILES=(
    "docs/superpowers/specs/2026-04-27-robotics-course-sp1-design.md"
    "docs/superpowers/specs/2026-04-27-robotics-course-sp2-design.md"
    "docs/superpowers/specs/2026-04-28-robotics-course-sp3-design.md"
    "docs/superpowers/specs/2026-04-28-robotics-course-sp4-design.md"
)
PLAN_FILES=(
    "docs/superpowers/plans/2026-04-27-robotics-course-sp1-plan.md"
    "docs/superpowers/plans/2026-04-27-robotics-course-sp2-plan.md"
    "docs/superpowers/plans/2026-04-28-robotics-course-sp3-plan.md"
    "docs/superpowers/plans/2026-04-28-robotics-course-sp4-plan.md"
)
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

check_python_syntax() {
    local f="$1"
    local label="${2:-py_compile}"
    if [[ ! -f "$f" ]]; then
        warn "missing for python syntax check (covered by G1): $f"
        return
    fi
    if python3 -m py_compile "$f" 2>/dev/null; then
        ok
    else
        local error_msg
        error_msg=$(python3 -m py_compile "$f" 2>&1)
        err "Python syntax error: $f ($label)"
        printf "         %s\n" "$error_msg"
    fi
}

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

echo
echo "==== G4 (W3): Lab 5 / 6 / 6b sandbox content patterns (53 件) ===="

# === Lab 5 (6 patterns) ===
check_pattern_must "sandbox_reference/week3/lab5/bridge_config.yaml" "ros_gz_bridge|ros_topic_name" "bridge YAML 構造"
check_pattern_must "sandbox_reference/week3/lab5/bridge_config.yaml" "/clock" "/clock mandatory bridge"
check_pattern_must "sandbox_reference/week3/lab5/bridge_config.yaml" "GZ_TO_ROS|direction" "bridge 方向指定"
check_pattern_must "sandbox_reference/week3/lab5/bridge_run.log" "ros_gz_bridge|parameter_bridge" "ros_gz_bridge 起動"
check_pattern_must "sandbox_reference/week3/lab5/bridge_run.log" "/clock" "/clock real run 証跡"
check_pattern_must "sandbox_reference/week3/lab5/bridge_topic_list.txt" "/clock" "/clock ROS 2 側到達"

# === Lab 6 (8 patterns、scene_packet_design.md 8 field 行ごと) ===
check_pattern_must "sandbox_reference/week3/lab6/scene_packet_design.md" "scene_packet" "scene_packet 行"
check_pattern_must "sandbox_reference/week3/lab6/scene_packet_design.md" "robot_state" "robot_state 行"
check_pattern_must "sandbox_reference/week3/lab6/scene_packet_design.md" "candidate_set" "candidate_set 行"
check_pattern_must "sandbox_reference/week3/lab6/scene_packet_design.md" "action_intent" "action_intent 行"
check_pattern_must "sandbox_reference/week3/lab6/scene_packet_design.md" "observation" "observation 行"
check_pattern_must "sandbox_reference/week3/lab6/scene_packet_design.md" "execution_result" "execution_result 行"
check_pattern_must "sandbox_reference/week3/lab6/scene_packet_design.md" "failure_reason" "failure_reason 行"
check_pattern_must "sandbox_reference/week3/lab6/scene_packet_design.md" "metrics" "metrics 行"

# === Lab 6b — example_scene_packet.json (4 patterns) ===
check_pattern_must "sandbox_reference/week3/lab6b/example_scene_packet.json" "scene_packet" "input field 1"
check_pattern_must "sandbox_reference/week3/lab6b/example_scene_packet.json" "robot_state" "input field 2"
check_pattern_must "sandbox_reference/week3/lab6b/example_scene_packet.json" "candidate_set" "input field 3"
check_pattern_must "sandbox_reference/week3/lab6b/example_scene_packet.json" "action_intent" "input field 4"

# === Lab 6b — bridge_stub.py (6 patterns) ===
check_pattern_must "sandbox_reference/week3/lab6b/bridge_stub.py" "json[.]load" "json.load (実コード)"
check_pattern_must "sandbox_reference/week3/lab6b/bridge_stub.py" "recv field=" "出力フォーマット固定"
check_pattern_must_not "sandbox_reference/week3/lab6b/bridge_stub.py" "subprocess" "禁止: subprocess"
check_pattern_must_not "sandbox_reference/week3/lab6b/bridge_stub.py" "os[.]system" "禁止: os.system"
check_pattern_must_not "sandbox_reference/week3/lab6b/bridge_stub.py" "KDL" "禁止: KDL"
check_pattern_must_not "sandbox_reference/week3/lab6b/bridge_stub.py" "controller_manager" "禁止: controller_manager"

# === Lab 6b — bridge_stub.py syntax (1 pattern、check_python_syntax helper) ===
check_python_syntax "sandbox_reference/week3/lab6b/bridge_stub.py" "py_compile"

# === Lab 6b — execution_log.txt (6 patterns、input 4 field 個別 + 起動 + min_size) ===
check_pattern_must "sandbox_reference/week3/lab6b/execution_log.txt" "recv field=scene_packet" "input 1: scene_packet log"
check_pattern_must "sandbox_reference/week3/lab6b/execution_log.txt" "recv field=robot_state" "input 2: robot_state log"
check_pattern_must "sandbox_reference/week3/lab6b/execution_log.txt" "recv field=candidate_set" "input 3: candidate_set log"
check_pattern_must "sandbox_reference/week3/lab6b/execution_log.txt" "recv field=action_intent" "input 4: action_intent log"
check_pattern_must "sandbox_reference/week3/lab6b/execution_log.txt" "bridge_stub" "起動確認"
check_min_size    "sandbox_reference/week3/lab6b/execution_log.txt" 200 "実行ログ最小サイズ"

# === Lab 6b — codex_prompt_lab6b.md (6 patterns、Lab 4b 同型) ===
check_pattern_must "sandbox_reference/week3/lab6b/codex_prompt_lab6b.md" "目的" "prompt5項目: 目的"
check_pattern_must "sandbox_reference/week3/lab6b/codex_prompt_lab6b.md" "入力" "prompt5項目: 入力"
check_pattern_must "sandbox_reference/week3/lab6b/codex_prompt_lab6b.md" "制約" "prompt5項目: 制約"
check_pattern_must "sandbox_reference/week3/lab6b/codex_prompt_lab6b.md" "成功条件" "prompt5項目: 成功条件"
check_pattern_must "sandbox_reference/week3/lab6b/codex_prompt_lab6b.md" "検証コマンド" "prompt5項目: 検証コマンド"
check_pattern_must "sandbox_reference/week3/lab6b/codex_prompt_lab6b.md" "禁止" "禁止リスト言及"

# === simulation_bridge_draft_example.md (8 patterns、8 field 行ごと) ===
check_pattern_must "sandbox_reference/week3/simulation_bridge_draft_example.md" "scene_packet" "input field 1"
check_pattern_must "sandbox_reference/week3/simulation_bridge_draft_example.md" "robot_state" "input field 2"
check_pattern_must "sandbox_reference/week3/simulation_bridge_draft_example.md" "candidate_set" "input field 3"
check_pattern_must "sandbox_reference/week3/simulation_bridge_draft_example.md" "action_intent" "input field 4"
check_pattern_must "sandbox_reference/week3/simulation_bridge_draft_example.md" "observation" "output field 1"
check_pattern_must "sandbox_reference/week3/simulation_bridge_draft_example.md" "execution_result" "output field 2"
check_pattern_must "sandbox_reference/week3/simulation_bridge_draft_example.md" "failure_reason" "output field 3"
check_pattern_must "sandbox_reference/week3/simulation_bridge_draft_example.md" "metrics" "output field 4"

# === simulator_decision_table_example.md (8 patterns、4 simulator + 4 軸 行ごと) ===
check_pattern_must "sandbox_reference/week3/simulator_decision_table_example.md" "Gazebo" "simulator 1: Gazebo"
check_pattern_must "sandbox_reference/week3/simulator_decision_table_example.md" "MuJoCo" "simulator 2: MuJoCo"
check_pattern_must "sandbox_reference/week3/simulator_decision_table_example.md" "ManiSkill" "simulator 3: ManiSkill"
check_pattern_must "sandbox_reference/week3/simulator_decision_table_example.md" "Isaac" "simulator 4: Isaac"
check_pattern_must "sandbox_reference/week3/simulator_decision_table_example.md" "rendering" "軸 1: rendering"
check_pattern_must "sandbox_reference/week3/simulator_decision_table_example.md" "contact" "軸 2: contact"
check_pattern_must "sandbox_reference/week3/simulator_decision_table_example.md" "parallel data" "軸 3: parallel data"
check_pattern_must "sandbox_reference/week3/simulator_decision_table_example.md" "ROS 2 統合" "軸 4: ROS 2 統合"

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

echo
echo "==== Python syntax check on sandbox_reference/**/*.py (W2 + W3) ===="
while IFS= read -r py; do
    check_python_syntax "$py" "py_compile"
done < <(find sandbox_reference -name "*.py" 2>/dev/null)

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
