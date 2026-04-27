# Robotics / Simulation Phase 0 Education Plan

目的: Robotics / Simulation専門ではないメンバーが、Q1縮小Lv1 + Phase 0を動かすための最低限の知識、語彙、実践手順を4週間で獲得する。

---

## 1. Executive Summary

この教育計画は、一般的なロボティクス講座を網羅履修するためのものではない。Projectの短期リスクである「人数はいるが、ROS2/MoveIt2、calibration、robot adapter、Simulation Bridge、logging/evaluation、safetyを同じGateに接続できる人が不足している」状態を埋めるためのPhase 0教育である。

2026年4月27日時点では、実機制御の依存関係に合わせ、共通標準を **Ubuntu 22.04 LTS + ROS 2 Humble LTS + Gazebo Fortress LTS** に置く。Humbleは2027年5月まで、Fortressは2026年9月までのLTSであり、Q1の教育・実機前検証には十分使える。Jazzy + Harmonicは新規長期基盤の移行候補としてWatchに置くが、今回の教育標準にはしない。

実践環境として、各メンバーはGitHub上に個人またはチーム管理の `Sandbox_*` repositoryを作り、会社のChatGPT Enterpriseで利用できるCodexを使って小さなPRを作成・レビューする。Codexの目的は「何でも生成させる」ことではなく、タスク分解、コード読解、検証、デバッグ切り分けを訓練することである。

4週間後の最低成果は、全員が同じ用語で会話でき、各Role担当が以下のどれかを実作業として出せる状態である。

| 領域 | Phase 0での到達線 |
|---|---|
| ROS2/TF/URDF | node/topic/service/action、TF tree、URDF、launch、rosbag2を説明し、基本コマンドで確認できる |
| Manipulation | MoveIt2のplanning scene、IK feasibility、trajectory execution、URSim/mock/realの違いを説明できる |
| Calibration | camera intrinsic、hand-eye、ArUco/fixture、reprojection errorの意味を説明できる |
| Robot Adapter | no-op、URDF+IK mock、URSim、real adapterの段階を説明し、Q1でどこまで進むか判断できる |
| Simulation Bridge | Gazebo、MuJoCo、ManiSkill、Isaacの用途差を説明し、WorldCPJのI/O schemaへ接続案を出せる |
| Logging/Evaluation | rosbag2/MCAP、episode_record、trial sheet、Gate Evalの最低セットを設計できる |
| Safety | emergency stop、safeguard/protective stop、safe no-action、operator confirmation、SOPの違いを説明できる |
| Git/Codex Sandbox | `Sandbox_*` repo、branch、commit、PR、review、verification logを作り、Codexへの依頼粒度を調整できる |
| Human Judgment | タスク分解、コード読解、デバッグ、Affordance schema、評価指標、安全境界を人間が判断できる |

想定負荷は、全員共通で24から28時間、Role Ownerは追加で8から12時間である。Git/Codex Sandbox演習は、追加講義ではなく各週のハンズオン成果物を残す器として扱う。

---

## 2. 前提と教育方針

## 2.1 WorldCPJ側の前提

本計画は以下の既存文書を前提にする。

| 参照 | 教育計画への反映 |
|---|---|
| `mission/technology_map/WorldCPJ_FY26_technology_map_v0.3.md` | Q1は縮小Lv1 + Phase 0内包。CT-01/02/07を先行し、CT-06/08/09をRole別で支える |
| `mission/analysis/WorldCPJ_FY26_software_member_activity_context_report.md` | 最大リスクはROS2/MoveIt、calibration、safety、logging、evaluation、robot adapterのOwner不在 |
| `mission/analysis/WorldCPJ_FY26_robot_equipment_status_report.md` | UR7e/CRX共通セルを最小実機基盤候補とし、周辺設備と安全は段階整備 |
| `mission/master/WorldCPJ_FY26_open_questions_prioritized.md` | Robotics/Simulation経験不足はP0/P3レベルの体制リスク |

追加の運用前提:

- 各メンバーはGitHubで `Sandbox_<name-or-theme>` repositoryを作成し、Git branch、commit、push、PR、reviewを最小1回実施する。
- Codexは会社のChatGPT Enterprise workspaceで利用する。workspace owner/adminによるCodex Local/Cloud、GitHub connector、RBAC、監査/利用ルールの設定を前提にする。
- Sandbox repositoryには秘密情報、実機認証情報、社外秘データ、未承認のロボット接続情報を置かない。
- Codexが生成したコード、設定、判断案は、必ず人間が差分、実行ログ、失敗条件、安全境界を確認する。

## 2.2 教育の非目標

4週間では、以下を狙わない。

| 扱わないもの | 理由 |
|---|---|
| 全員をロボット制御の専門家にする | Q1で必要なのは専門家化ではなく、Gateを壊さない共通知識とRole遂行 |
| Isaac/ManiSkill/MuJoCoを全員が深く使う | Simulationが別PJ化するリスクがあるため、全員には用途差だけを教える |
| 実機で人協調・双腕・複数ロボを本格実施する | Safety、設備、ログ、評価が揃う前に広げるとQ1が破綻する |
| ベースライン再現を多数こなす | Phase 0が再現作業だけで終わるため、CC/MS各1から2本に絞る |
| Codexで設計判断を代替する | Affordance schema、評価指標、安全境界、実機投入可否はPJ側の責任判断である |
| Sandboxを本番repository化する | SandboxはGit/PR/検証訓練とmock/sim試作の場であり、Q1本番成果物はレビュー後に正本へ移す |

---

## 3. 推奨スタック

| レイヤー | 推奨 | 理由 |
|---|---|---|
| OS | Ubuntu 22.04 LTS、Windows利用者はWSL2またはDocker | 実機制御のROS2 Humble依存と合わせる |
| ROS | ROS 2 Humble Hawksbill | 実機制御依存と一致。LTSで2027年5月までサポート |
| Simulator | Gazebo Fortress | Humbleとの公式推奨組み合わせ。LTSで2026年9月までサポート |
| Manipulation | MoveIt2 + ros2_control + UR ROS2 driver | UR7e/CRX系の実機前検証とmock/URSim接続に直結 |
| Logging | rosbag2、必要に応じてMCAP | episode evidence、replay、Gate Evalの基盤 |
| Data export | LeRobotは補助 | raw truthはrosbag2。LeRobotはdataset/export用途に限定 |
| Simulation Watch | Jazzy + Harmonic、MuJoCo、ManiSkill3、Isaac Sim/Isaac Lab | Jazzy/Harmonicは将来移行候補。MuJoCo等はRole別に用途評価 |
| AI/Git practice | GitHub `Sandbox_*` repository + Codex in ChatGPT Enterprise | Git/PR/review、mock実装、検証ログ作成を低リスクに練習する |

---

## 4. 4週間カリキュラム

## 4.1 全体スケジュール

開始日を2026-04-27とした場合の4週間案である。連休や会議都合がある場合も、週ごとの成果物は固定する。

| 週 | 期間 | 主題 | 共通学習 | 実践成果物 |
|---|---|---|---|---|
| Week 1 | 2026-04-27 to 2026-05-01 | 共通知識とHumble環境 + Git/Codex Sandbox | ROS2 graph、TF、URDF、rosbag2、ロボット座標系、Git branch/commit/PR | skill baseline sheet、environment setup log、sandbox setup log |
| Week 2 | 2026-05-04 to 2026-05-08 | Manipulation / Robot Adapter | MoveIt2、IK、planning scene、URSim/mock、calibration、Codexで小さなmock PR | robot readiness mini report、sandbox PR review notes |
| Week 3 | 2026-05-11 to 2026-05-15 | Simulation Bridge | Gazebo、MuJoCo、ManiSkill、Isaac、Nav2/Kachaka用途差、bridge stub | simulation bridge draft、sandbox bridge stub |
| Week 4 | 2026-05-18 to 2026-05-22 | Logging / Evaluation / Safety統合 | rosbag2/MCAP、episode_record、trial sheet、SOP、safe no-action、AI利用レビュー | Q1 reduced Lv1 execution package、sandbox final review |

## 4.2 Week 1: 共通知識と環境

目的は、全員がROS2と座標系の最低語彙を持つことである。ここで手を抜くと、Week 2以降のMoveIt、calibration、loggingの議論がずれる。

| セッション | 内容 | 推奨リソース | 出力 |
|---|---|---|---|
| Lecture 0 | Git/GitHub最小語彙、branch、commit、remote、PR、review、Codexに頼む粒度 | GitHub Docs、Codex Docs | Git/Codex用語メモ |
| Lab 0 | 各自の `Sandbox_*` repoを作成し、README、環境メモ、最初のPRを作る | GitHub fork/PR docs、Codex web setup | sandbox setup log、first PR URL |
| Lecture 1 | ROS2 node/topic/service/action、launch、QoSの最低限 | ROS 2 Humble Tutorials | 用語ミニテスト |
| Lab 1 | `turtlesim`、`ros2 topic list/echo/info`、`ros2 bag record/play/info` | ROS 2 recording tutorial | 5分の操作ログとbag info |
| Lecture 2 | TF、URDF、robot_state_publisher、frame naming | ROS 2 tf2、URDF tutorials、Modern Robotics Ch.2-3 | TF treeメモ |
| Lab 2 | static transform、TF lookup、frame diagram作成 | tf2 tutorials | CC/MSで使うframe一覧案 |

Week 1の合格条件:

- `node/topic/service/action` を一文で説明できる。
- `ros2 topic echo` と `ros2 bag record/play/info` を使える。
- `map`、`odom`、`base_link`、`camera_link`、`tool0` の違いを説明できる。
- ROS2のログは動画の代替ではなく、評価証跡であると説明できる。
- 自分の `Sandbox_*` repoでbranch、commit、push、PR作成、reviewコメントへの応答を1回実施している。
- Codexに頼む前に、目的、入力、制約、成功条件、検証コマンドを書く必要があると説明できる。

## 4.3 Week 2: Manipulation / Robot Adapter

目的は、実機を触る前に、MoveIt2、IK feasibility、URSim/mock、calibration、安全境界の意味を揃えることである。

| セッション | 内容 | 推奨リソース | 出力 |
|---|---|---|---|
| Lecture 3 | MoveIt2の全体像、planning scene、collision、IK、trajectory | MoveIt Getting Started、MoveIt Quickstart | MoveIt概念メモ |
| Lab 3 | RVizで計画、collision-aware IK、trajectory introspection | MoveIt Quickstart in RViz | plan成功/失敗スクリーンショットと短評 |
| Lecture 4 | Robot Adapter Minimum Set、no-op、URDF+IK mock、URSim、real | UR ROS2 driver docs、ros2_control docs | adapter段階表 |
| Lab 4 | URSimまたはmock hardwareの起動手順を読み、UR7e readiness項目へ写像 | UR driver usage、External Control URCapX | robot readiness mini report |
| Lab 4b | Codexにno-opまたはURDF+IK mock adapterの小変更を依頼し、差分を人間が読む | Codex prompting/common workflows、GitHub PR review | sandbox PR review notes |

Week 2の合格条件:

- MoveIt2は「ロボットを直接動かす魔法」ではなく、planning scene、IK、trajectory、controller/driverと接続する層だと説明できる。
- Python adapterは制御本体ではなく、orchestration/bridgeに留めるべきだと説明できる。
- `no-op -> URDF+IK mock -> URSim -> real` の段階と、各段階で評価できることを説明できる。
- camera intrinsic、hand-eye、fixture、reprojection errorの最低意味を説明できる。
- Codexが出したadapter/mockコードについて、入力、出力、失敗時の挙動、ログの有無を自分でレビューできる。

## 4.4 Week 3: Simulation Bridge

目的は、Simulationを「候補比較」で終わらせず、WorldCPJのschema、logging、Gate Evalへ接続することである。

| セッション | 内容 | 推奨リソース | 出力 |
|---|---|---|---|
| Lecture 5 | Gazebo Fortress + ROS2 bridge、Sim I/O、topic bridge | Gazebo ROS2 integration | Sim I/O候補表 |
| Lab 5 | Gazebo topic bridgeのYAMLを読み、WorldCPJ schemaへ写像 | Gazebo ros_gz_bridge docs | bridge config skeleton |
| Lecture 6 | MuJoCo、ManiSkill、Isaacの用途差 | MuJoCo docs、ManiSkill docs、Isaac Sim learning docs | simulator decision table |
| Lab 6 | MS Lv1またはCC Gate 0-aに対し、Simで返すべき観測/結果を定義 | WorldCPJ technology map CT-08 | simulation bridge draft |
| Lab 6b | Sandboxでbridge stubまたはschema mappingを小さく作り、Codex出力をPRで検証 | Codex common workflows、GitHub PR docs | sandbox bridge stub、verification log |

Week 3の合格条件:

- GazeboはROS2連携とrobot model/bridge検証に使う、と説明できる。
- MuJoCoは軽量な接触・制御・学習実験、ManiSkillはmanipulation benchmark/parallel data、Isaacは高忠実度rendering/synthetic data/large simulationに向く、と用途差を説明できる。
- Simulationの出力を `episode_record`、`trial sheet`、`Gate Eval` に渡すI/Oとして書ける。
- Simulator比較だけではWorldCPJ成果にならない、と説明できる。
- AIが提案したschemaやmetricsを採用する前に、WorldCPJのAffordance schema、評価指標、安全境界と照合できる。

## 4.5 Week 4: Logging / Evaluation / Safety統合

目的は、Q1縮小Lv1の実行パッケージを作ることである。動画や口頭報告ではなく、再現可能なログ、評価表、安全ルールに落とす。

| セッション | 内容 | 推奨リソース | 出力 |
|---|---|---|---|
| Lecture 7 | rosbag2/MCAP、episode_record、trial sheet、Gate Eval | ROS 2 rosbag2 tutorial、MCAP storage docs | trial sheet template |
| Lab 7 | 1 episodeの記録、bag info、metadata、failure reason分類 | rosbag2、LeRobot docsは補助 | sample episode record |
| Lecture 8 | Safety/SOP、emergency stop、safeguard/protective stop、safe no-action | UR Safety FAQ、UR manuals、ISO 10218概要 | safety checklist |
| Lab 8 | Q1 reduced Lv1 execution packageを作る | WorldCPJ CT-01/02/06/07/08/09 | Q1 package draft |
| Lab 8b | Sandbox PRを最終レビューし、Codexに任せた部分、人間が判断した部分、検証証跡を分けて記録 | Codex Enterprise/admin docs、GitHub PR docs | sandbox final review |

Week 4の合格条件:

- 1 episodeを `perception -> candidate -> 3D/actionability -> result -> failure_reason` として記録できる。
- `rosbag2`、`episode_record`、`trial sheet` の役割を分けて説明できる。
- emergency stopを通常停止や実験制御に使わない理由を説明できる。
- 実機に進む前のsafe no-action条件を3つ以上挙げられる。
- Codex出力をそのまま正本へ入れず、PR diff、実行ログ、失敗ケース、安全境界のレビューを経て採否を決められる。

---

## 5. Role別トラック

全員がWeek 1からWeek 4の共通部分を受ける。そのうえで、各人は1つのPrimary Role、必要なら1つのSecondary Roleを持つ。

| Role | 対応CT | 必修リソース | 4週間後の成果物 |
|---|---|---|---|
| Affordance / Calibration | CT-01/02 | ROS2 topics、tf2、camera_calibration、MoveIt IK、Modern Robotics Ch.3/5/6 | candidate_setから3D/actionabilityへ渡すmini spec |
| Robot Adapter / Safety | CT-06/09 | UR ROS2 driver、ros2_control、UR safety docs、MoveIt Quickstart | no-op/IK mock/URSim/real readiness manifest |
| Logging / Gate Eval | CT-07 | rosbag2、MCAP、ROS2 testing、LeRobot dataset docs | episode_record template、trial sheet、bag naming rule |
| Simulation Bridge | CT-08 | Gazebo Fortress、ros_gz_bridge、MuJoCo、ManiSkill、Isaac overview | Sim input/output schema、simulator decision table |
| MS Belief / Navigation | CT-04/05/08 | Nav2 tutorials、Kachaka API、MS Lv1 task spec、Gazebo | fixed observation baseline、L0 ROI belief output案 |
| CC Gate 0-a | CT-01/02/06/07 | MoveIt、tf2、calibration、rosbag2 | 5物体 x 3 trialの評価準備表 |
| Agentic Workflow / Sandbox | 全CT横断 | GitHub branch/PR docs、Codex docs、WorldCPJ review rule | `Sandbox_*` repo、PR review notes、verification log |

Role Ownerは、毎週30分のOffice Hourを持ち、担当RoleのFAQと失敗例を更新する。

---

## 6. 厳選リソース一覧

調査日は2026-04-27。原則として、公式ドキュメント、大学/研究機関の公開講義、ダウンロード可能なPDF、実務チュートリアルを優先した。

## 6.1 全員必修

| ID | リソース | 種別 | 使い方 |
|---|---|---|---|
| R-01 | [ROS 2 Humble Documentation](https://docs.ros.org/en/humble/) | 公式Docs | Week 1の入口。Tutorials、Concepts、CLIを中心に読む |
| R-02 | [ROS 2 Humble Ubuntu install](https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html) | 公式Docs | Ubuntu 22.04 + Humbleの標準installを確認する |
| R-03 | [ROS 2 Humble tf2 Tutorials](https://docs.ros.org/en/humble/Tutorials/Intermediate/Tf2/Tf2-Main.html) | 公式Tutorial | frame、static transform、listener、debugを学ぶ |
| R-04 | [ROS 2 Humble recording and playing back data](https://docs.ros.org/en/humble/Tutorials/Beginner-CLI-Tools/Recording-And-Playing-Back-Data/Recording-And-Playing-Back-Data.html) | 公式Tutorial | rosbag2の最小操作。全員が実行する |
| R-05 | [Modern Robotics, Lynch and Park](https://hades.mech.northwestern.edu/index.php/Modern_Robotics) | Open Course/PDF/動画 | Ch.2、Ch.3、Ch.4、Ch.5、Ch.6、Ch.10、Ch.12を辞書的に使う |
| R-06 | [MIT Robotic Manipulation](https://manipulation.csail.mit.edu/) | Open Course/HTML/PDF | Manipulationの考え方、perception/planning/control接続を読む |
| R-07 | [QUT Robot Academy](https://petercorke.com/resources/robot-academy/) | Open Course/動画 | 短い動画でkinematics、vision、robot basicsを補習する |

## 6.2 Manipulation / Robot Adapter

| ID | リソース | 種別 | 使い方 |
|---|---|---|---|
| R-08 | [MoveIt2 Getting Started](https://moveit.picknik.ai/main/doc/tutorials/getting_started/getting_started.html) | 公式Tutorial | Humble環境では実機側package/READMEとversion差分を確認して使う |
| R-09 | [MoveIt Quickstart in RViz](https://moveit.picknik.ai/main/doc/tutorials/quickstart_in_rviz/quickstart_in_rviz_tutorial.html) | 公式Tutorial | planning scene、IK、trajectoryを体験する |
| R-10 | [MoveIt Motion Planning Python API](https://moveit.picknik.ai/main/doc/examples/motion_planning_python_api/motion_planning_python_api_tutorial.html) | 公式Tutorial | Python側からのplanning APIを理解する |
| R-11 | [ros2_control Humble docs](https://control.ros.org/humble/) | 公式Docs | controller、hardware interface、mock/real境界を理解する |
| R-12 | [ros2_controllers Humble](https://control.ros.org/humble/doc/ros2_controllers/doc/controllers_index.html) | 公式Docs | joint trajectory、gripper、diff drive等の標準controllerを確認 |
| R-13 | [Universal Robots ROS2 Driver Usage](https://docs.universal-robots.com/Universal_Robots_ROS_Documentation/rolling/doc/ur_robot_driver/ur_robot_driver/doc/usage/toc.html) | 公式Docs | URSim/mock/real、External Control、controller接続を学ぶ |
| R-14 | [Universal Robots External Control URCapX](https://github.com/UniversalRobots/Universal_Robots_ExternalControl_URCapX) | 公式GitHub | PolyScopeX/URSim/URCap接続を理解する |

## 6.3 Calibration / Perception

| ID | リソース | 種別 | 使い方 |
|---|---|---|---|
| R-15 | [ROS2 camera_calibration package](https://index.ros.org/p/camera_calibration/#humble) | ROS Index | Humble版packageとcheckerboard calibrationの入口を確認し、intrinsic calibrationとcamera_infoの意味を学ぶ |
| R-16 | [ROS2 image_pipeline overview](https://docs.ros.org/en/ros2_packages/rolling/api/image_pipeline/) | 公式Docs | rectification、depth、point cloudへの接続を確認 |
| R-17 | [MoveIt Hand-Eye Calibration tutorial](https://moveit.github.io/moveit_tutorials/doc/hand_eye_calibration/hand_eye_calibration_tutorial.html) | 公式Tutorial | hand-eyeの概念理解に使う。ROS1系Tutorialなので実行教材ではなく概念教材 |

## 6.4 Simulation / Navigation

| ID | リソース | 種別 | 使い方 |
|---|---|---|---|
| R-18 | [Gazebo Fortress ROS installation](https://gazebosim.org/docs/fortress/ros_installation/) | 公式Docs | Humble + Fortressの推奨組み合わせを確認 |
| R-19 | [Gazebo Fortress ROS2 integration](https://gazebosim.org/docs/fortress/ros2_integration/) | 公式Tutorial | ros_gz_bridgeとtopic mappingを学ぶ |
| R-20 | [MuJoCo Documentation](https://mujoco.readthedocs.io/en/stable/overview.html) | 公式Docs | 接触・制御・軽量simulationの候補として理解 |
| R-21 | [MuJoCo Python](https://mujoco.readthedocs.io/en/stable/python.html) | 公式Docs | Pythonから小さく動かす場合の入口 |
| R-22 | [ManiSkill Documentation](https://maniskill.readthedocs.io/en/latest/) | 公式Docs | manipulation benchmark/parallel data用途を理解 |
| R-23 | [ManiSkill Quickstart](https://maniskill.readthedocs.io/en/latest/user_guide/getting_started/quickstart.html) | 公式Tutorial | PickCube等でAPI感を確認。全員必修ではない |
| R-24 | [NVIDIA Isaac Sim learning docs](https://docs.nvidia.com/learning/physical-ai/getting-started-with-isaac-sim/latest/index.html) | 公式Tutorial | 高忠実度simulation、synthetic data、ROS2連携の概観 |
| R-25 | [Isaac Lab tutorials](https://docs.isaacsim.omniverse.nvidia.com/5.1.0/isaac_lab_tutorials/index.html) | 公式Docs | robot learning担当のWatch教材 |
| R-26 | [Nav2 Tutorials](https://docs.nav2.org/tutorials/index.html) | 公式Tutorial | mobile navigation、docking、collision monitor、keepout等の概観 |
| R-27 | [Kachaka API](https://kachaka.zendesk.com/hc/en-us/articles/7660222791183-Kachaka-API) | 公式Support/GitHub導線 | Kachaka-style endpointやROS2 bridgeの入口 |

## 6.5 Logging / Dataset / Safety

| ID | リソース | 種別 | 使い方 |
|---|---|---|---|
| R-28 | [rosbag2 MCAP storage plugin](https://docs.ros.org/en/ros2_packages/rolling/api/rosbag2_storage_mcap/index.html) | 公式Docs | MCAPでのrecord/play/info、compression、fastwriteを理解 |
| R-29 | [LeRobot real-world robot tutorial](https://huggingface.co/docs/lerobot/main/en/getting_started_real_world_robot) | 公式Tutorial | dataset/export/replayの補助教材。raw truthはrosbag2を優先 |
| R-30 | [Universal Robots Safety FAQ](https://www.universal-robots.com/articles/ur/safety/safety-faq/) | 公式FAQ | emergency stop、safeguard stop、protective stopの語彙を確認 |
| R-31 | [Universal Robots safety manual page](https://www.universal-robots.com/manuals/EN/HTML/SW10_12/Content/prod-usr-man/complianceUR10e/H_g5_sections/safety_g5/safety_intro.htm) | 公式Manual | collaborative applicationで必要な安全機能の入口 |
| R-32 | [ISO 10218-1:2025 overview](https://www.iso.org/standard/73933.html) | 標準概要 | 原文規格は購入前提。教育では範囲理解に留める |

## 6.6 Git / Codex Sandbox / AI協働

| ID | リソース | 種別 | 使い方 |
|---|---|---|---|
| R-33 | [Git Book](https://git-scm.com/book/en/v2) | 公式Book | branch、remote、merge、conflictの辞書として使う |
| R-34 | [GitHub Docs: Working with forks](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks) | 公式Docs | fork、upstream、syncの概念を理解する |
| R-35 | [GitHub Docs: Fork a repository](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo) | 公式Tutorial | repo作成、clone、upstream設定、PRの入口 |
| R-36 | [Codex web docs](https://developers.openai.com/codex/cloud) | OpenAI公式Docs | Codex cloudがrepoを読み、sandbox環境で編集/実行/PR化する流れを確認 |
| R-37 | [Using Codex with your ChatGPT plan](https://help.openai.com/en/articles/11369540) | OpenAI Help | Enterprise/Edu含む利用、GitHub接続、データ利用方針、制限を確認 |
| R-38 | [Codex Enterprise Admin Setup](https://developers.openai.com/codex/enterprise/admin-setup) | OpenAI公式Docs | workspace owner/adminがCodex local/cloud、GitHub connector、RBAC、Team Configを確認 |
| R-39 | [OpenAI Codex CLI getting started](https://help.openai.com/en/articles/11096431-openai-codex-ci-getting-started) | OpenAI Help | ローカルで読解、変更、実行を試す場合の入口。全員必須ではない |

---

## 7. 推薦しない、またはWatchに置く教材

| リソース/領域 | 判断 | 理由 |
|---|---|---|
| ROS 2 Rolling / Kilted / Jazzyを全員標準にする | 推薦しない | Q1教育は実機制御依存との整合を優先し、Humble LTSを標準にする |
| Gazebo HarmonicをHumble標準として全員に入れる | 推薦しない | Humble + Harmonicは可能だが注意扱い。教育では公式推奨ペアのFortressを使う |
| Isaac Sim/Isaac Labを全員ハンズオンにする | 推薦しない | GPU、asset、version、起動コストが大きい。Simulation OwnerのWatchに限定 |
| Full Nav2 bring-upをWeek 1から全員で行う | 推薦しない | mobile robot実機/センサ/地図が必要で、CC Gate 0-aの短期成果から外れやすい |
| Stanford CS223Aを主教材にする | Watch | 良い講義だが、4週間のPhase 0には範囲が広い。必要箇所だけ参照 |
| MIT Underactuated Roboticsを主教材にする | Watch | 制御基礎として有用だが、Q1 reduced Lv1の即効性は低い |
| SafetyをBlogだけで済ませる | 推薦しない | 実機安全は公式マニュアル、現場SOP、責任者レビューを優先する |
| PDF配布サイト由来の教材 | 推薦しない | 権利状態が不明なものは教育計画に入れない |
| 何でもCodexに任せる | 推薦しない | AIは実装補助、読解補助、検証補助に使う。タスク分解、設計判断、安全境界、採否判断は人間が持つ |
| Enterprise外の個人workspaceへ社内コードを持ち出す | 推薦しない | 会社のChatGPT Enterprise workspace、GitHub権限、社内ポリシーに従う |

---

## 8. ハンズオン成果物テンプレート

## 8.1 Skill Baseline Sheet

各メンバーはWeek 1で以下を自己申告する。

| 項目 | レベル0 | レベル1 | レベル2 |
|---|---|---|---|
| ROS2 CLI | 未経験 | tutorial実行可 | topic/service/action/debug可 |
| TF/URDF | 未経験 | frame図を読める | TF treeを作成/修正できる |
| MoveIt2 | 未経験 | RViz demo実行可 | planning scene/IK失敗を説明できる |
| Calibration | 未経験 | intrinsic/hand-eyeを説明可 | fixture/reprojection評価を設計可 |
| Simulation | 未経験 | GazeboまたはMuJoCoを起動可 | Sim I/Oを評価schemaへ接続可 |
| Logging | 未経験 | rosbag2 record/play可 | episode_record/trial sheet設計可 |
| Safety | 未経験 | stop種別を説明可 | SOP/safe no-action条件を書ける |
| Git/Codex | 未経験 | branch/commit/PRを作れる | Codex出力をdiff/実行ログ/失敗条件でレビューできる |

## 8.2 Robot Readiness Mini Report

Week 2で実機/adapter担当が作る。

| 項目 | 記入内容 |
|---|---|
| robot_id | UR7e/CRX/CobotMagic/Kachaka等 |
| adapter stage | no-op / URDF+IK mock / URSim / real |
| ROS interface | driver、controller、topic/action/service |
| calibration state | intrinsic、extrinsic、hand-eye、fixture |
| safety state | E-stop、safeguard/protective stop、operator confirmation |
| logging state | rosbag2 topics、episode_record、trial sheet |
| next gate | G1 offline/sim evidence、G2 minimal real-robot trial |

## 8.3 Simulation Bridge Draft

Week 3でSimulation担当が作る。

| 項目 | 記入内容 |
|---|---|
| target task | CC Gate 0-a / MS Lv1 / other |
| simulator | Gazebo / MuJoCo / ManiSkill / Isaac |
| input | scene_packet、robot state、candidate_set、action intent |
| output | observation、execution_result、failure_reason、metrics |
| logging | bag topic、metadata、trial sheet mapping |
| limitation | sim-onlyで主張できること、実機が必要なこと |

## 8.4 Q1 Reduced Lv1 Execution Package

Week 4の最終成果物である。

| 要素 | 最低内容 |
|---|---|
| scope | Q1で実施するCC/MSの縮小Lv1範囲 |
| owner | CT-01/02/06/07/08/09のOwnerとbackup |
| environment | OS、ROS、sim、robot、camera、fixture |
| protocol | trial数、対象物/scene、success/failure、safe no-action |
| logging | topics、bag naming、metadata、episode_record |
| evaluation | trial sheet、KPI、fallback rule |
| safety | SOP、operator、stop condition、禁止操作 |
| AI review | Codexに依頼した作業、人間が判断した項目、verification evidence |

## 8.5 Sandbox Setup Log

Week 1で各メンバーが作る。

| 項目 | 記入内容 |
|---|---|
| repo | GitHub `Sandbox_*` repository URL |
| access | owner、collaborators、visibility、admin確認 |
| local setup | clone path、default branch、Git user/email設定 |
| first branch | branch name、commit hash、PR URL |
| Codex access | ChatGPT Enterprise workspace、Codex local/cloud可否、GitHub connector可否 |
| rules | 秘密情報を置かない、実機接続しない、mock/sim/offline dataだけ使う |

## 8.6 Sandbox PR Review Notes

Week 2からWeek 4で、各メンバーが1つ以上のPRに対して作る。

| 項目 | 記入内容 |
|---|---|
| task split | 人間が定義した目的、入力、制約、成功条件、検証コマンド |
| Codex prompt | Codexに依頼した範囲。設計判断を委ねていないことを確認 |
| diff summary | 変更ファイル、責務、主要ロジック |
| human review | 動く根拠、壊れうる条件、採用しない提案、追加修正 |
| debug evidence | 失敗ログ、最小再現、修正前後のコマンド結果 |
| judgment boundary | 人間が決めたAffordance schema、評価指標、安全境界、実機投入可否 |

---

## 9. 運用ルール

| ルール | 内容 |
|---|---|
| 共通環境を固定する | 全員の標準はUbuntu 22.04 + Humble + Fortress。例外はRole Ownerが理由を明記する |
| EOLを意識する | Fortressは2026年9月EOLのため、Q1後にHarmonic/Jazzyまたは次期標準への移行レビューを行う |
| 実機前にmock/simで証跡を作る | G1 offline/sim evidenceなしでG2 real trialへ進まない |
| 動画だけを成果にしない | すべての実験にbag、episode_record、trial sheetを残す |
| Safetyを後付けしない | 実機作業前にSOP、operator、stop condition、safe no-actionを確認する |
| Role Ownerを先に置く | 人数ではなく、CTごとのOwner/backupで進める |
| Simulatorを増やしすぎない | Q1ではGazeboを標準、MuJoCo/ManiSkill/Isaacは用途別に限定する |
| 読むだけで終えない | 各週で必ずWorldCPJ成果物へ接続する |
| Codex前に人間がタスクを切る | Codex promptには目的、入力、制約、成功条件、検証コマンドを書く |
| Codex後に人間がdiffを読む | PRでは動作確認、失敗条件、安全境界、採否理由を残す |
| Sandboxを隔離する | `Sandbox_*` repoには秘密情報、実機認証情報、本番ロボット接続を置かない |

---

## 10. 週次レビュー

| タイミング | レビュー内容 | 判断 |
|---|---|---|
| Week 1末 | skill baseline、environment setup、rosbag2操作 | Role割当を調整 |
| Week 2末 | MoveIt/URSim/mock理解、readiness mini report | G1/G2境界を判断 |
| Week 3末 | Simulation Bridge draft | Simを主軸、補助、Watchのどれに置くか判断 |
| Week 4末 | Q1 reduced Lv1 execution package | Q1実行へ移す成果物を凍結 |
| 各週末 | sandbox PR、review notes、verification log | AI利用が人間判断を侵食していないか確認 |

---

## 11. 最初の実行順

1. CC/MS全メンバーにSkill Baseline Sheetを配布する。
2. Workspace owner/adminがChatGPT Enterprise上のCodex local/cloud、GitHub connector、RBAC、利用ルールを確認する。
3. 各メンバーがGitHub `Sandbox_*` repositoryを作り、Sandbox Setup Logを埋める。
4. 共通環境をUbuntu 22.04 + ROS 2 Humble + Gazebo Fortressに固定し、例外環境をRole Ownerが管理する。
5. Week 1 Lecture/Labを実施し、rosbag2操作まで全員に通す。
6. Week 2開始前にPrimary Roleを割り当てる。
7. Week 2からRole Ownerが成果物テンプレートを埋め、各メンバーは少なくとも1つのSandbox PR Review Notesを作る。
8. Week 4末にQ1 reduced Lv1 execution packageをレビューし、Q1タスクへ接続する。

この教育計画の成否は、読了量ではなく、Q1縮小Lv1の実行証跡を作れるかで判断する。
