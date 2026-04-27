#!/usr/bin/env bash
#
# Vercel ビルド時にプレースホルダーを環境変数で置換し、dist/ に成果物を出力する。
# ローカル実行時は事前に .env.local を読み込むか、環境変数を export しておくこと。
#
set -euo pipefail

if [ -z "${SUPABASE_URL:-}" ] || [ -z "${SUPABASE_KEY:-}" ]; then
  echo "ERROR: SUPABASE_URL and SUPABASE_KEY environment variables must be set."
  echo "  Vercel: Set them in Project Settings > Environment Variables"
  echo "  Local:  cp .env.local.example .env.local && edit, then 'set -a; source .env.local; set +a'"
  exit 1
fi

OUT_DIR="dist"
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

# 静的アセットをコピー
cp index.html "$OUT_DIR/index.html"
cp -r images "$OUT_DIR/images"

# プレースホルダー置換 ( | を区切り文字に使用してURL内の / を回避 )
sed -i.bak "s|__SUPABASE_URL__|${SUPABASE_URL}|g" "$OUT_DIR/index.html"
sed -i.bak "s|__SUPABASE_KEY__|${SUPABASE_KEY}|g" "$OUT_DIR/index.html"
rm -f "$OUT_DIR/index.html.bak"

# 置換漏れチェック
if grep -q "__SUPABASE_URL__\|__SUPABASE_KEY__" "$OUT_DIR/index.html"; then
  echo "ERROR: Placeholder still present in $OUT_DIR/index.html"
  exit 1
fi

echo "Build OK -> $OUT_DIR/"
