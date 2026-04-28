---
type: guide
id: DOCS-REFERENCES
title: External Resource Ledger (R-01〜R-39 + future)
date: 2026-04-27
---

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
| R-02 | ROS 2 Humble Ubuntu install | https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html | 公式Docs | 1 | common | 2026-04-27 |
| R-03 | ROS 2 Humble tf2 Tutorials | https://docs.ros.org/en/humble/Tutorials/Intermediate/Tf2/Tf2-Main.html | 公式Tutorial | 1 | common | 2026-04-27 |
| R-04 | ROS 2 Humble recording and playing back data | https://docs.ros.org/en/humble/Tutorials/Beginner-CLI-Tools/Recording-And-Playing-Back-Data/Recording-And-Playing-Back-Data.html | 公式Tutorial | 1 | common | 2026-04-27 |
| R-05 | Modern Robotics, Lynch and Park | https://hades.mech.northwestern.edu/index.php/Modern_Robotics | Open Course/PDF/動画 | 1 | common | 2026-04-27 |
| R-06 | MIT Robotic Manipulation | https://manipulation.csail.mit.edu/ | Open Course/HTML/PDF | 1 | common | 2026-04-27 |
| R-07 | QUT Robot Academy | https://petercorke.com/resources/robot-academy/ | Open Course/動画 | 1 | common | 2026-04-27 |

## Manipulation / Robot Adapter (R-08〜R-14)

| ID | タイトル | URL | 種別 | 対応Week | 対応Role | 最終確認日 |
|---|---|---|---|---|---|---|
| R-08 | MoveIt2 Getting Started | https://moveit.picknik.ai/main/doc/tutorials/getting_started/getting_started.html | 公式Tutorial | 2 | adapter, common | 2026-04-27 |
| R-09 | MoveIt Quickstart in RViz | https://moveit.picknik.ai/main/doc/tutorials/quickstart_in_rviz/quickstart_in_rviz_tutorial.html | 公式Tutorial | 2 | adapter, common | 2026-04-27 |
| R-10 | MoveIt Motion Planning Python API | https://moveit.picknik.ai/main/doc/examples/motion_planning_python_api/motion_planning_python_api_tutorial.html | 公式Tutorial | 2 | adapter, common | 2026-04-27 |
| R-11 | ros2_control Humble docs | https://control.ros.org/humble/ | 公式Docs | 2 | adapter, common | 2026-04-27 |
| R-12 | ros2_controllers Humble | https://control.ros.org/humble/doc/ros2_controllers/doc/controllers_index.html | 公式Docs | 2 | adapter, common | 2026-04-27 |
| R-13 | Universal Robots ROS2 Driver Usage | https://docs.universal-robots.com/Universal_Robots_ROS_Documentation/rolling/doc/ur_robot_driver/ur_robot_driver/doc/usage/toc.html | 公式Docs | 2 | adapter, common | 2026-04-27 |
| R-14 | Universal Robots External Control URCapX | https://github.com/UniversalRobots/Universal_Robots_ExternalControl_URCapX | 公式GitHub | 2 | adapter | 2026-04-27 |

## Calibration / Perception (R-15〜R-17)

| ID | タイトル | URL | 種別 | 対応Week | 対応Role | 最終確認日 |
|---|---|---|---|---|---|---|
| R-15 | ROS2 camera_calibration package | https://index.ros.org/p/camera_calibration/#humble | ROS Index | 2 | calibration, common | 2026-04-27 |
| R-16 | ROS2 image_pipeline overview | https://docs.ros.org/en/ros2_packages/rolling/api/image_pipeline/ | 公式Docs | 2 | calibration, common | 2026-04-27 |
| R-17 | MoveIt Hand-Eye Calibration tutorial | https://moveit.github.io/moveit_tutorials/doc/hand_eye_calibration/hand_eye_calibration_tutorial.html | 公式Tutorial | 2 | calibration | 2026-04-27 |

## Simulation / Navigation (R-18〜R-27)

| ID | タイトル | URL | 種別 | 対応Week | 対応Role | 最終確認日 |
|---|---|---|---|---|---|---|
| R-18 | Gazebo Fortress ROS installation | https://gazebosim.org/docs/fortress/ros_installation/ | 公式Docs | 3 | sim, common | 2026-04-27 |
| R-19 | Gazebo Fortress ROS2 integration | https://gazebosim.org/docs/fortress/ros2_integration/ | 公式Tutorial | 3 | sim, common | 2026-04-27 |
| R-20 | MuJoCo Documentation | https://mujoco.readthedocs.io/en/stable/overview.html | 公式Docs | 3 | sim | 2026-04-27 |
| R-21 | MuJoCo Python | https://mujoco.readthedocs.io/en/stable/python.html | 公式Docs | 3 | sim | 2026-04-27 |
| R-22 | ManiSkill Documentation | https://maniskill.readthedocs.io/en/latest/ | 公式Docs | 3 | sim | 2026-04-27 |
| R-23 | ManiSkill Quickstart | https://maniskill.readthedocs.io/en/latest/user_guide/getting_started/quickstart.html | 公式Tutorial | 3 | sim | 2026-04-27 |
| R-24 | NVIDIA Isaac Sim learning docs | https://docs.nvidia.com/learning/physical-ai/getting-started-with-isaac-sim/latest/index.html | 公式Tutorial | 3 | sim, common | 2026-04-27 |
| R-25 | Isaac Lab tutorials | https://docs.isaacsim.omniverse.nvidia.com/5.1.0/isaac_lab_tutorials/index.html | 公式Docs | 3 | sim | 2026-04-27 |
| R-26 | Nav2 Tutorials | https://docs.nav2.org/tutorials/index.html | 公式Tutorial | 3 | nav | 2026-04-27 |
| R-27 | Kachaka API | https://kachaka.zendesk.com/hc/en-us/articles/7660222791183-Kachaka-API | 公式Support/GitHub導線 | 3 | nav | 2026-04-27 |

## Logging / Dataset / Safety (R-28〜R-32)

| ID | タイトル | URL | 種別 | 対応Week | 対応Role | 最終確認日 |
|---|---|---|---|---|---|---|
| R-28 | ROS 2 Humble — ros2 bag CLI tutorial (record/play/info、storage backend default = sqlite3) | https://docs.ros.org/en/humble/Tutorials/Beginner-CLI-Tools/Recording-And-Playing-Back-Data/Recording-And-Playing-Back-Data.html | 公式Tutorial | 4 | logging, common | 2026-04-28 |
| R-29 | rosbag2_storage_mcap — MCAP file format storage plugin for rosbag2 (`--storage mcap`) | https://github.com/ros-tooling/rosbag2_storage_mcap | 公式GitHub | 4 | logging, common | 2026-04-28 |
| R-30 | Universal Robots — Emergency Stop note ("complementary protective measure, not a safeguard; not designed to prevent injury") (instructional reference only) | https://www.universal-robots.com/articles/ur/safety/emergency-stop/ | 公式Docs | 4 | safety, adapter | 2026-04-28 |
| R-31 | Universal Robots — Safety overview / manual reset procedure for emergency stop (instructional reference only) | https://www.universal-robots.com/articles/ur/safety/ | 公式Docs | 4 | safety, adapter | 2026-04-28 |
| R-32 | ISO 10218-1:2025 (Robotics — Safety requirements — Part 1: Industrial robots) and ISO 10218-2:2025 (Part 2: Industrial robot applications and robot cells). Use as overview reference only; the course does not reproduce paid standard text. | https://www.iso.org/standard/73933.html | 標準概要 | 4 | safety, adapter | 2026-04-28 |

## Git / Codex Sandbox / AI協働 (R-33〜R-39)

| ID | タイトル | URL | 種別 | 対応Week | 対応Role | 最終確認日 |
|---|---|---|---|---|---|---|
| R-33 | Git Book | https://git-scm.com/book/en/v2 | 公式Book | 1 | sandbox, common | 2026-04-27 |
| R-34 | GitHub Docs: Working with forks | https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks | 公式Docs | 1 | sandbox, common | 2026-04-27 |
| R-35 | GitHub Docs: Fork a repository | https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo | 公式Tutorial | 1 | sandbox, common | 2026-04-27 |
| R-36 | Codex web docs | https://developers.openai.com/codex/cloud | OpenAI公式Docs | 1 | sandbox, common | 2026-04-27 |
| R-37 | Using Codex with your ChatGPT plan | https://help.openai.com/en/articles/11369540 | OpenAI Help | 1 | sandbox, common | 2026-04-27 |
| R-38 | Codex Enterprise Admin Setup | https://developers.openai.com/codex/enterprise/admin-setup | OpenAI公式Docs | 1 | sandbox, common | 2026-04-27 |
| R-39 | OpenAI Codex CLI getting started | https://help.openai.com/en/articles/11096431-openai-codex-ci-getting-started | OpenAI Help | 1 | sandbox, common | 2026-04-27 |
