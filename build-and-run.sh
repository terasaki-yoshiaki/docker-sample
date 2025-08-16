#!/bin/bash

echo "========================================"
echo "  Docker イメージビルド & 実行スクリプト"
echo "========================================"
echo ""

# 色付き出力用の設定
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: 現在のディレクトリを確認
echo -e "${YELLOW}Step 1: プロジェクトディレクトリを確認${NC}"
cd /mnt/c/Users/terar/calculator-app
pwd
echo ""

# Step 2: バックエンドイメージのビルド
echo -e "${YELLOW}Step 2: Javaバックエンドイメージをビルド中...${NC}"
echo "ディレクトリ: backend/"
cd backend

echo "Dockerfileの内容を確認:"
head -n 5 Dockerfile
echo ""

echo "ビルド開始..."
docker build -t java-backend-app . 2>&1 | tail -20

if docker images | grep -q "java-backend-app"; then
    echo -e "${GREEN}✅ バックエンドイメージのビルド成功${NC}"
else
    echo -e "${RED}❌ バックエンドイメージのビルドに失敗${NC}"
    echo "手動でビルドしてください:"
    echo "  cd /mnt/c/Users/terar/calculator-app/backend"
    echo "  docker build -t java-backend-app ."
fi
echo ""

# Step 3: フロントエンドイメージのビルド
echo -e "${YELLOW}Step 3: React Nativeフロントエンドイメージをビルド中...${NC}"
cd ../frontend

echo "Dockerfileの内容を確認:"
head -n 5 Dockerfile
echo ""

echo "ビルド開始..."
docker build -t react-native-frontend . 2>&1 | tail -20

if docker images | grep -q "react-native-frontend"; then
    echo -e "${GREEN}✅ フロントエンドイメージのビルド成功${NC}"
else
    echo -e "${RED}❌ フロントエンドイメージのビルドに失敗${NC}"
    echo "手動でビルドしてください:"
    echo "  cd /mnt/c/Users/terar/calculator-app/frontend"
    echo "  docker build -t react-native-frontend ."
fi
echo ""

# Step 4: イメージの確認
echo -e "${YELLOW}Step 4: 作成されたイメージを確認${NC}"
docker images | grep -E "(REPOSITORY|java-backend-app|react-native-frontend)"
echo ""

# Step 5: コンテナの起動
echo -e "${YELLOW}Step 5: コンテナを起動${NC}"

# 既存のコンテナを停止・削除
docker stop backend-container frontend-container 2>/dev/null
docker rm backend-container frontend-container 2>/dev/null

# バックエンドコンテナを起動
if docker images | grep -q "java-backend-app"; then
    echo "バックエンドコンテナを起動中..."
    docker run -d -p 8080:8080 --name backend-container java-backend-app
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ バックエンドコンテナ起動成功${NC}"
        echo "  URL: http://localhost:8080"
    fi
fi

# フロントエンドコンテナを起動
if docker images | grep -q "react-native-frontend"; then
    echo "フロントエンドコンテナを起動中..."
    docker run -d -p 3000:3000 --name frontend-container react-native-frontend
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ フロントエンドコンテナ起動成功${NC}"
        echo "  URL: http://localhost:3000"
    fi
fi
echo ""

echo "========================================"
echo -e "${GREEN}  セットアップ手順${NC}"
echo "========================================"
echo ""
echo "現在のステータス:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""
echo "次のステップ:"
echo "1. イメージがビルドされていない場合:"
echo "   cd /mnt/c/Users/terar/calculator-app/backend"
echo "   docker build -t java-backend-app ."
echo ""
echo "2. コンテナを起動:"
echo "   docker run -d -p 8080:8080 --name backend-container java-backend-app"
echo "   docker run -d -p 3000:3000 --name frontend-container react-native-frontend"
echo ""
echo "3. アクセス:"
echo "   - フロントエンド: http://localhost:3000"
echo "   - バックエンドAPI: http://localhost:8080/api/calculator/health"
echo ""