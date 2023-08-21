#!/bin/bash
# entrypoint.sh

set -e

# データベースが開始するのを待つ
until mysqladmin ping -h"db" -P"3306" --silent; do
  echo "Waiting for database to start"
  sleep 2
done

# 既存のサーバープロセスを削除
rm -f /myapp/tmp/pids/server.pid

# コマンドを実行
exec "$@"
