#!/bin/bash
#=============================================================================
# リリース用のタグを作成する。
#
# [引数]
# SERVICE: デプロイ対象となるサービス (例: prd-a, prd-b)
#
# [動作]
# 日付ベースのバージョニング (YYYY.MM.連番) でタグを作成する。
# 連番は同じ月の最初であれば1、それ以降は最新のものに1を足す。
# 例: prd-a/v2025.08.2
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

# 最新のコードとtagを取得
git fetch --all --tags

# 現在の年月を取得（JST）
YEAR=$(TZ='Asia/Tokyo' date +%Y)
MONTH=$(TZ='Asia/Tokyo' date +%m)

# 該当月のタグの連番を計算（ドラフトは除外）
PREFIX="${SERVICE}/v${YEAR}.${MONTH}."
LATEST=$(gh release list --exclude-drafts --json tagName | \
  jq -r --arg prefix "$PREFIX" \
  '.[] | select(.tagName | startswith($prefix)) | .tagName | sub($prefix; "")' | \
  sort -n | tail -1)

if [ -z "$LATEST" ]; then
    NEXT="1"
else
    NEXT=$((LATEST + 1))
fi

# タグ名を生成
tag_name="${SERVICE}/v${YEAR}.${MONTH}.${NEXT}"

# origin/mainの先頭コミットにタグを作成
echo "create tag: ${tag_name}"
git tag -a ${tag_name} -m "${tag_name}" origin/main
# git push origin ${tag_name}
