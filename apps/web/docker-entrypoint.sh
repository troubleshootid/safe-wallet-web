#!/bin/sh
set -e

echo "========================================="
echo "Safe Wallet Web - Starting..."
echo "========================================="

# Check if build is needed
if [ ! -d "out" ] || [ -z "$(ls -A out)" ]; then
    echo "📦 Building application with current environment variables..."
    echo "NEXT_PUBLIC_BRAND_NAME=$NEXT_PUBLIC_BRAND_NAME"
    echo "NEXT_PUBLIC_IS_OFFICIAL_HOST=$NEXT_PUBLIC_IS_OFFICIAL_HOST"
    echo "========================================="

    yarn build

    echo "✅ Build completed successfully"
else
    echo "✅ Using existing build"
fi

echo "🚀 Starting server on port ${REVERSE_PROXY_UI_PORT:-10000}..."
exec yarn serve
