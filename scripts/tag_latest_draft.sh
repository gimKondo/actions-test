#!/bin/bash
#=============================================================================
# リリース用のタグを作成する。
#
# [引数]
# SERVICE: デプロイ対象となるサービス
#
# [動作]
# GitHub上のSERVICEに対応するリリースのうち、最新のバージョンに対応するタグを付けてpushする。
# Draftであり、まだタグが関連付けられていないリリースが対象になることを想定している。
# (Draftだけ絞る方法がないのですべて取得している)
#
# タグは最新のorigin/mainのヘッドに付与する。
#=============================================================================

# 引数の数をチェック
if [ "$#" -ne 1 ]; then
    echo "Error: SERVICE as arguments required."
    echo "Usage: $0 <SERVICE>"
    exit 1
fi

SERVICE=$1
TAG_PREFIX="${SERVICE}/v"

# 最新のコードとtagを取得
git fetch --all --tags

# 最新のタグを取得
tag_name=$(gh release list --json tagName | jq -r --arg prefix "$TAG_PREFIX" '.[] | select(.tagName | startswith($prefix)) | .tagName ' | sort -n | tail -1)

# origin/mainの先頭コミットにタグを作成
echo "create tag: ${tag_name}"
git tag -a ${tag_name} -m "${tag_name}" origin/main
# git push origin ${tag_name}
