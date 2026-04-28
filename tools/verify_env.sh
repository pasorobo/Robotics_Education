#!/usr/bin/env bash
# tools/verify_env.sh
# Verify that the SP1 development environment is in place.
# Spec G3 (§5.1).
# Exit codes:
#   0 - all required checks PASS
#   1 - at least one required check FAILED

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# --- Argument parsing (SP2 added) ---
WEEK_MODE="default"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --week)
            shift
            WEEK_MODE="${1:-default}"
            shift
            ;;
        --help|-h)
            cat <<'EOH'
Usage: verify_env.sh [--week N]
  (no arg)   : SP1-compatible mode (Gazebo required, MoveIt 2 WARN if absent)
  --week 2   : SP2 mode (MoveIt 2 + ros2_control + ros2_controllers + colcon required, Gazebo SKIP)
  --week 3   : SP3 mode (gz CLI + ros-humble-ros-gz + ros_gz_bridge binary + colcon required, MoveIt 2 / ros2_control SKIP)
  --week 4   : SP4 mode (ros2 bag + rosbag2 default storage required, MCAP Stretch=WARN, MoveIt/Gazebo/ros2_control SKIP, Lab 7 source bag evidence required)
  --week N   : reserved for future SP4+ modes
EOH
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            echo "Run 'verify_env.sh --help' for usage" >&2
            exit 2
            ;;
    esac
done

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
if [[ "$WEEK_MODE" == "2" ]]; then
    print_check "gazebo CLI (week 2 mode)" "SKIP" "(SP3 で復活予定)"
elif [[ "$WEEK_MODE" == "3" ]]; then
    # SP3 mode: gz CLI + ros_gz_bridge binary + colcon required;
    # MoveIt 2 / ros2_control / Panda config are SKIP (handled in SP2)
    check_either "gazebo CLI" gz ign
    check_required "ros-humble-ros-gz pkg" \
        bash -c 'dpkg -l | grep -q "ros-humble-ros-gz "'
    check_required "ros_gz_bridge binary" \
        bash -c 'ros2 pkg prefix ros_gz_bridge >/dev/null 2>&1'
    check_required "colcon CLI" command -v colcon
elif [[ "$WEEK_MODE" == "4" ]]; then
    print_check "gazebo CLI (week 4 mode)" "SKIP" "(SP3 で扱った)"
else
    check_either "gazebo CLI" gz ign
fi

echo "[MoveIt 2]"
if [[ "$WEEK_MODE" == "2" ]]; then
    check_required "ros-humble-moveit pkg" bash -c 'dpkg -l | grep -q "ros-humble-moveit "'
    check_required "ros-humble-moveit-resources-panda-moveit-config pkg" \
        bash -c 'dpkg -l | grep -q "ros-humble-moveit-resources-panda-moveit-config "'
    check_required "ros-humble-ros2-control pkg" bash -c 'dpkg -l | grep -q "ros-humble-ros2-control "'
    check_required "ros-humble-ros2-controllers pkg" bash -c 'dpkg -l | grep -q "ros-humble-ros2-controllers "'
    check_required "colcon CLI" command -v colcon
elif [[ "$WEEK_MODE" == "3" ]]; then
    print_check "MoveIt 2 (week 3 mode)" "SKIP" "(SP2 で扱った)"
    print_check "ros2_control (week 3 mode)" "SKIP" "(SP2 で扱った)"
    print_check "ros2_controllers (week 3 mode)" "SKIP" "(SP2 で扱った)"
    print_check "Panda config (week 3 mode)" "SKIP" "(SP2 で扱った)"
elif [[ "$WEEK_MODE" == "4" ]]; then
    print_check "MoveIt 2 (week 4 mode)" "SKIP" "(SP2 で扱った)"
    print_check "ros2_control (week 4 mode)" "SKIP" "(SP2 で扱った)"
    print_check "ros2_controllers (week 4 mode)" "SKIP" "(SP2 で扱った)"
    print_check "Panda config (week 4 mode)" "SKIP" "(SP2 で扱った)"
else
    if dpkg -l 2>/dev/null | grep -q "ros-humble-moveit "; then
        print_check "ros-humble-moveit pkg" "PASS"
        PASS=$((PASS+1))
    else
        print_check "ros-humble-moveit pkg" "WARN" "(SP1 only needs demo install; SP2 requires full)"
        WARN=$((WARN+1))
    fi
fi

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
