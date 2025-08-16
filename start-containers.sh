#!/bin/bash

echo "====================================="
echo "  コンテナ起動スクリプト"
echo "====================================="
echo ""

# Javaバックエンドのコンテナを起動
echo "1. Javaバックエンドコンテナを起動中..."
docker run -d -p 8080:8080 --name backend-container java-backend-app

if [ $? -eq 0 ]; then
    echo "✅ バックエンドコンテナ起動成功"
    echo "   URL: http://localhost:8080"
else
    echo "⚠️  既存のコンテナが存在する可能性があります"
    echo "   以下のコマンドで削除してから再実行してください:"
    echo "   docker stop backend-container && docker rm backend-container"
fi
echo ""

# React-Nativeフロントエンドのコンテナを起動
echo "2. React-Nativeフロントエンドコンテナを起動中..."
docker run -d -p 3000:3000 --name frontend-container react-native-frontend

if [ $? -eq 0 ]; then
    echo "✅ フロントエンドコンテナ起動成功"
    echo "   URL: http://localhost:3000"
else
    echo "⚠️  既存のコンテナが存在する可能性があります"
    echo "   以下のコマンドで削除してから再実行してください:"
    echo "   docker stop frontend-container && docker rm frontend-container"
fi
echo ""

echo "====================================="
echo "  動作確認"
echo "====================================="
echo ""
echo "ブラウザで以下のURLにアクセスしてください:"
echo "  📱 フロントエンド: http://localhost:3000"
echo "  🔧 バックエンドAPI: http://localhost:8080/api/calculator/health"
echo ""
echo "フロントエンドからバックエンドへのAPI呼び出し例:"
echo "  axios.get('http://localhost:8080/api/data')"
echo ""