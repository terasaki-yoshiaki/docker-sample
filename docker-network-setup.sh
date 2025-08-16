#!/bin/bash

echo "====================================="
echo "  Docker コンテナ連携セットアップ"
echo "====================================="
echo ""

# Step 1: Dockerネットワークの作成
echo "Step 1: Dockerネットワークを作成中..."
docker network create calculator-network 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ ネットワーク 'calculator-network' を作成しました"
else
    echo "ℹ️  ネットワーク 'calculator-network' は既に存在します"
fi
echo ""

# Step 2: 既存のコンテナを停止・削除
echo "Step 2: 既存のコンテナをクリーンアップ中..."
docker stop backend-container frontend-container 2>/dev/null
docker rm backend-container frontend-container 2>/dev/null
echo "✅ クリーンアップ完了"
echo ""

# Step 3: バックエンドコンテナを起動
echo "Step 3: バックエンドコンテナを起動中..."
docker run -d \
  -p 8080:8080 \
  --name backend-container \
  --network calculator-network \
  java-backend-app

if [ $? -eq 0 ]; then
    echo "✅ バックエンドコンテナ起動成功"
    echo "   - コンテナ名: backend-container"
    echo "   - ポート: 8080"
    echo "   - ネットワーク: calculator-network"
else
    echo "❌ バックエンドコンテナの起動に失敗しました"
    exit 1
fi
echo ""

# Step 4: フロントエンドコンテナを起動
echo "Step 4: フロントエンドコンテナを起動中..."
docker run -d \
  -p 3000:3000 \
  --name frontend-container \
  --network calculator-network \
  -e REACT_APP_API_URL=http://backend-container:8080 \
  react-native-frontend

if [ $? -eq 0 ]; then
    echo "✅ フロントエンドコンテナ起動成功"
    echo "   - コンテナ名: frontend-container"
    echo "   - ポート: 3000"
    echo "   - ネットワーク: calculator-network"
    echo "   - API接続先: backend-container:8080"
else
    echo "❌ フロントエンドコンテナの起動に失敗しました"
    exit 1
fi
echo ""

# Step 5: 接続テスト
echo "Step 5: コンテナ間の接続をテスト中..."
sleep 5  # コンテナが完全に起動するまで待機

# バックエンドのヘルスチェック
echo -n "  - バックエンドヘルスチェック... "
curl -s http://localhost:8080/api/calculator/health > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ OK"
else
    echo "❌ 失敗"
fi

# フロントエンドの確認
echo -n "  - フロントエンド起動確認... "
curl -s http://localhost:3000 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ OK"
else
    echo "⚠️  起動中の可能性があります"
fi
echo ""

echo "====================================="
echo "  セットアップ完了！"
echo "====================================="
echo ""
echo "📍 アクセスURL:"
echo "  - フロントエンド: http://localhost:3000"
echo "  - バックエンドAPI: http://localhost:8080/api/calculator/health"
echo ""
echo "🔍 確認コマンド:"
echo "  - ネットワーク確認: docker network inspect calculator-network"
echo "  - コンテナ確認: docker ps"
echo "  - ログ確認: docker logs backend-container"
echo "  - 通信テスト: docker exec frontend-container ping backend-container"
echo ""