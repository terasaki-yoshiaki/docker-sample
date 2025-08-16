# Calculator App

Dockerで動作する電卓アプリケーション。バックエンドはJava (Spring Boot)、フロントエンドはReact Native/TypeScriptで構築。

## プロジェクト構造

```
calculator-app/
├── backend/               # Java Spring Boot バックエンド
│   ├── src/
│   ├── pom.xml
│   └── Dockerfile
├── frontend/              # React Native フロントエンド
│   ├── App.tsx
│   ├── package.json
│   └── Dockerfile
├── docker-compose.yml     # Docker Compose設定
└── Dockerfile            # ルートDockerfile（要求通り）
```

## 機能

- 基本的な算術演算（加算、減算、乗算、除算）
- 累乗計算
- 平方根計算
- 計算履歴表示
- RESTful API経由での計算処理

## 起動方法

### Docker Composeを使用（推奨）

```bash
# すべてのサービスを起動
docker-compose up --build

# バックグラウンドで起動
docker-compose up -d --build
```

### 個別のDockerイメージをビルド

```bash
# ビルドスクリプトを使用
./build.sh

# または手動でビルド
# バックエンドのビルド
cd backend
docker build -t java-backend-app .

# フロントエンドのビルド（要求通りの名前で）
cd ../frontend
docker build -t react-native-frontend .

# ルートディレクトリのDockerfileを使用（要求通り）
cd ..
docker build -t java-backend-app .
```

## アクセス方法

- **バックエンドAPI**: http://localhost:8080
  - ヘルスチェック: http://localhost:8080/api/calculator/health
  - 計算API: POST http://localhost:8080/api/calculator/calculate

- **フロントエンド（Web）**: http://localhost:19000

## API仕様

### 計算エンドポイント

**URL**: `/api/calculator/calculate`  
**Method**: `POST`  
**Content-Type**: `application/json`

**リクエストボディ**:
```json
{
  "firstNumber": 10,
  "secondNumber": 5,
  "operation": "+"
}
```

**レスポンス**:
```json
{
  "result": 15,
  "expression": "10.00 + 5.00 = 15.00",
  "success": true
}
```

**対応する演算子**:
- `+` または `add`: 加算
- `-` または `subtract`: 減算
- `*` または `multiply`: 乗算
- `/` または `divide`: 除算
- `^` または `power`: 累乗
- `sqrt`: 平方根（firstNumberのみ使用）

## 開発環境

### バックエンド
- Java 17
- Spring Boot 3.1.0
- Maven

### フロントエンド
- React Native
- TypeScript
- Expo
- Axios

## 停止方法

```bash
# Docker Composeで起動したサービスを停止
docker-compose down

# ボリュームも含めて削除
docker-compose down -v
```