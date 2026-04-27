# Lab 4 ヒント

## minimal URDF の link/joint 数を増やしたい

- 教材の URDF は `j1` 1 関節 + 2 link。複数関節にする場合は `<joint name="j2" .../>` `<link name="link2"/>` を追加し、`<ros2_control>` ブロック内にも `<joint name="j2">...</joint>` を追加。
- `controllers.yaml` の `joints:` リストにも追加が必要。

## launch 起動順 (controller_manager → spawner)

- launch 内で `RegisterEventHandler(OnProcessExit(target=jsb_spawner, on_exit=[fpc_spawner]))` で順序制御している。
- `joint_state_broadcaster` を先に spawn し、その exit (= configure 完了) 後に `forward_position_controller` を spawn。
- 順序を間違えると spawner の race condition で controller が `inactive` のまま残ることがある。

## `mock_components/GenericSystem` 設定例

- `<plugin>mock_components/GenericSystem</plugin>` がほぼ全ての mock パターンで使える。
- 各 joint に `<command_interface name="position"/>` と `<state_interface name="position"/>` を最低限定義。
- velocity / effort 制御を mock したい場合は `name="velocity"` `name="effort"` を追加。

## colcon build エラー対処

- `Could not find package 'ament_cmake'`: ROS 2 Humble が source されていない → `source /opt/ros/humble/setup.bash`
- `Project 'minimal_robot_bringup' depends on the 'xacro' package`: `sudo apt install ros-humble-xacro` (本 Lab では URDF を直接書いているので xacro 自体は使わないが package.xml の exec_depend に書いた)
- 不明エラー: `colcon build --packages-select minimal_robot_bringup --event-handlers console_direct+` で詳細出力
