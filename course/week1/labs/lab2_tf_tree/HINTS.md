# Lab 2 ヒント

## TF time stamp 問題

- static transform は古い (`builtin_interfaces.msg.Time` の epoch 0) として publish される。`tf2_echo` で表示されるが、`tf2_listener` で動的に lookup する場合は static の取り扱いに注意。
- 本 Lab では static のみなので問題は起きない。

## parent/child 命名 typo

- `base_link` を `baselink` と書く、`tool0` を `tool_0` と書く等の typo は ROS では普通に通ってしまい、frame が孤立する。`view_frames` の PDF で parent が想定通りか目視確認すること。

## view_frames が止まる

- `view_frames` は5秒間 TF を listen してから PDF を生成する。途中で Ctrl-C すると PDF が空になる。5秒待つこと。

## Mermaid が GitHub で表示されない

- ` ```mermaid ` (バッククォート3つ + mermaid) のコードフェンスが必須。それ以外 (`mermaid` だけ書いた html-style block 等) は GitHub レンダリング対象外。
- VS Code でプレビューする場合は Mermaid 拡張をインストールすること。

## camera_link を base_link の child にしたが、本物の robot ではどう違うか

- 多くの URDF では `<robot>/<link name="camera_optical_frame"/>` を `camera_link` の child に置き、Z 軸を光軸方向にする (REP-103/REP-105)。CC/MS の calibration 議論で出てくる話。本 Lab では一般化して `camera_link` まで扱う。
