---
type: setup
id: SETUP-UBUNTU-HUMBLE
title: Ubuntu 22.04 + ROS 2 Humble セットアップ
week: 0
duration_min: 30
prerequisites: []
worldcpj_ct: []
roles: [common]
references: [R-01, R-02]
deliverables: []
---

# Ubuntu 22.04 + ROS 2 Humble セットアップ

## 前提

- Ubuntu 22.04.x (Jammy Jellyfish) のクリーンインストール済み環境
- `sudo` 権限を持つユーザーアカウント
- インターネット接続

## 手順

公式インストール手順 (R-02) に基づきます。

### 1. ロケール設定 (UTF-8)

```bash
sudo apt update && sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
```

設定を確認:

```bash
locale
```

### 2. apt の更新と必要ツールのインストール

```bash
sudo apt update && sudo apt install -y curl gnupg2 lsb-release
```

### 3. ROS 2 GPG キーの追加

```bash
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
  -o /usr/share/keyrings/ros-archive-keyring.gpg
```

### 4. apt ソースの追加

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
  https://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" \
  | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
```

### 5. ROS 2 Humble のインストール

```bash
sudo apt update
sudo apt install -y ros-humble-desktop ros-dev-tools
```

`ros-humble-desktop` にはコア・RViz・デモが含まれます。

### 6. 環境の自動読み込み設定

```bash
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
source ~/.bashrc
```

### 7. 動作確認

新しいターミナルを開いて以下を実行:

```bash
ros2 doctor
```

警告があっても `/1 packages had issues` 程度なら通常問題ありません。エラーが出る場合はトラブルシュートセクションを参照してください。

## 検証

```bash
which ros2
ros2 --help | head -5
ros2 doctor
```

- `which ros2` が `/opt/ros/humble/bin/ros2` を返すこと
- `ros2 doctor` がエラーなく完了すること

## トラブルシュート

### locale エラー

```
Error: the following packages have unmet dependencies
```

対処:

```bash
sudo locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales
```

### GPG キーエラー

```
GPG error: https://packages.ros.org ...
```

対処: R-02 (公式インストールページ) の最新手順でキー登録コマンドを確認してください。キーサーバーのURLが変更されている場合があります。

```bash
# キーが正しく登録されているか確認
ls /usr/share/keyrings/ros-archive-keyring.gpg
```

### apt update で 404 エラー

Ubuntu バージョンが `jammy` (22.04) であることを確認:

```bash
lsb_release -cs
# 期待値: jammy
```

## 参照

- [R-01] ROS 2 Humble Documentation — https://docs.ros.org/en/humble/
- [R-02] ROS 2 Humble Ubuntu install — https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html
