#!/bin/bash

#!/bin/bash

# 追加先モデル名
MODEL_NAME="Museum"

# 追加するカラム情報をここに記述
# フォーマット: "<カラム名>:<データ型>"
COLUMNS=(
 "business_hours:text"
 "admission_fees:integer"
 "website_url:string"
 "phone_number:string"
)

# カラム情報をスペース区切りで結合
COLUMN_ARGS=$(IFS=" "; echo "${COLUMNS[*]}")

# マイグレーションを生成
echo "Generating migration for $MODEL_NAME with columns: $COLUMN_ARGS"
docker compose exec app rails g migration AddColumnsTo${MODEL_NAME} $COLUMN_ARGS


