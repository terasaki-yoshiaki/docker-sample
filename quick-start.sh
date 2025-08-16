#!/bin/bash

echo "========================================="
echo "  電卓アプリ Docker クイックスタート"
echo "========================================="
echo ""

# Step 1: Mavenビルド
echo "Step 1: Javaアプリケーションをビルド中..."
cd backend
mvn clean package -DskipTests
if [ $? -ne 0 ]; then
    echo "❌ Mavenビルドに失敗しました"
    exit 1
fi
echo "✅ JARファイル作成完了"
echo ""

# Step 2: Dockerイメージのビルド
echo "Step 2: Dockerイメージをビルド中..."
echo "  - バックエンドイメージをビルド..."
docker build -t java-backend-app .
if [ $? -ne 0 ]; then
    echo "❌ バックエンドイメージのビルドに失敗"
    exit 1
fi

echo "  - フロントエンドイメージをビルド..."
cd ../frontend
docker build -t react-native-frontend .
if [ $? -ne 0 ]; then
    echo "❌ フロントエンドイメージのビルドに失敗"
    exit 1
fi
echo "✅ Dockerイメージ作成完了"
echo ""

# Step 3: コンテナの起動
echo "Step 3: コンテナを起動中..."
cd ..

# 既存のコンテナを停止・削除
docker stop backend frontend 2>/dev/null
docker rm backend frontend 2>/dev/null

# バックエンドコンテナを起動
docker run -d --name backend -p 8080:8080 java-backend-app
echo "✅ バックエンド起動: http://localhost:8080"

# フロントエンドコンテナを起動
docker run -d --name frontend -p 3000:3000 react-native-frontend
echo "✅ フロントエンド起動: http://localhost:3000"
echo ""

echo "========================================="
echo "  起動完了！"
echo "========================================="
echo ""
echo "📍 アクセスURL:"
echo "  - フロントエンド: http://localhost:3000"
echo "  - バックエンドAPI: http://localhost:8080/api/calculator/health"
echo ""
echo "📝 便利なコマンド:"
echo "  - ログ確認: docker logs backend"
echo "  - 停止: docker stop backend frontend"
echo "  - 削除: docker rm backend frontend"
echo "  - 状態確認: docker ps"
echo ""