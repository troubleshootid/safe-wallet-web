#!/bin/bash
set -e

echo "🔧 Installing dependencies..."
yarn install --immutable

echo "🏗️ Building web application..."
yarn workspace @safe-global/web build

echo "✅ Build completed!"
