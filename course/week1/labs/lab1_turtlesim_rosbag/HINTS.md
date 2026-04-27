# Lab 1 ヒント

## bag が空になる

- record 開始前に topic が立っていないと record しても何も入らない。turtlesim 起動 → teleop 起動 → record 開始の順を守る。
- record 中に teleop で実際にキーを押して publish を起こす必要がある。

## metadata.yaml の場所

- `/tmp/turtle_bag/` の直下に `metadata.yaml` がある。bag 全体ではなくこの YAML だけをコピーする。

## script コマンド互換性

- 古い Ubuntu や非 GNU の環境では `script -c "..." -q file.log` の引数順が異なる。本 Lab では `script -q LOGFILE -c "bash"` を採用。
- もし上記が動かない場合: `script -q -c bash LOGFILE` を試す、それでも動かなければ手動でコマンド出力を別ファイルに `tee` する。

## bag を別シェルで record しているのに terminal_5min.log に含まれない

- script 内のシェルで `ros2 bag record` を実行する場合は問題ない。別 terminal で record した場合は record 開始/停止の事実だけを script シェルに `echo "started recording at $(date)"` などで残す。

## /tmp が消える

- システム再起動で /tmp は消える。本 Lab は短時間内に完結する想定なので問題ない。長期保管したい場合は `~/Develop/.../bags/` に保存し、`.gitignore` で repo に含めない。
