#!/bin/bash
#=============================================================================
# 本番リリース用のタグを作成する。
#
# [引数]
# (1) LEVEL: バージョンアップするレベル(patch, minor, majorのいずれか)
# (2) SERVICE: デプロイ対象となるサービス
#
# [動作]
# 最新のバージョンタグからLEVELに応じたバージョンを算出し、
# 最新のorigin/mainのヘッドに本番リリース用のタグを付与する。
# 例えば、LEVELがminor、SERVICEがappで既存の最新タグ app/v1.2.3の場合、
# app/v1.3.0をorigin/mainのヘッドに付与する。
#=============================================================================

# 引数の数をチェック
if [ "$#" -ne 2 ]; then
    echo "Error: LEVEL and SERVICE as arguments required."
    echo "Usage: $0 <level> <SERVICE>"
    exit 1
fi

LEVEL=$1
SERVICE=$2
PREFIX="${SERVICE}-v"

# 引数 LEVEL のチェック
if [[ ! "$LEVEL" =~ ^(patch|minor|major)$ ]]; then
    echo "Error: LEVEL must be 'patch', 'minor', or 'major'."
    exit 1
fi

# 最新のコードとtagを取得
git fetch --all --tags

# 最新のタグを取得
latest_tag=$(git tag -l "${PREFIX}*" | sort -Vr | head -n 1)

# まだタグが無い場合はLEVELに応じて初期タグを作成
if [ -z "$latest_tag" ]; then
    case $LEVEL in
        patch)
            initial_tag="${PREFIX}0.0.1"
            ;;
        minor)
            initial_tag="${PREFIX}0.1.0"
            ;;
        major)
            initial_tag="${PREFIX}1.0.0"
            ;;
    esac
    echo "No existing tags. Setting initial tag: ${initial_tag}"
    git tag -a ${initial_tag} -m "${SERVICE}: ${initial_tag#${PREFIX}}" origin/main
    exit 0
fi

# 既存のタグがある場合は次のバージョンのタグを作成
version_numbers=${latest_tag#${PREFIX}}
IFS='.' read -r major minor patch <<< "$version_numbers"

# 次のバージョンを算出
case $LEVEL in
    major)
        next_major=$((major + 1))
        next_minor=0
        next_patch=0
        ;;
    minor)
        next_major=$major
        next_minor=$((minor + 1))
        next_patch=0
        ;;
    patch)
        next_major=$major
        next_minor=$minor
        next_patch=$((patch + 1))
        ;;
esac

# origin/mainの先頭コミットにタグを作成
version_numbers=${next_major}.${next_minor}.${next_patch}
next_tag=${PREFIX}${version_numbers}
echo "create next $LEVEL tag: ${next_tag}"
echo "${SERVICE}: v${version_numbers}"
git tag -a ${next_tag} -m "${SERVICE}: v${version_numbers}" origin/main
