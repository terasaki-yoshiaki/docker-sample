# Dockerコンテナの起動と連携ガイド

## 📦 コンテナの個別起動

### 基本的な起動方法

要求通りのコマンドでコンテナを起動します：

```bash
# Javaバックエンドのコンテナを起動
docker run -d -p 8080:8080 --name backend-container java-backend-app

# React-Nativeフロントエンドのコンテナを起動
docker run -d -p 3000:3000 --name frontend-container react-native-frontend
```

### コマンドオプションの説明

- `docker run`: コンテナを起動するコマンド
- `-d`: デタッチモード（バックグラウンドで実行）
- `-p 8080:8080`: ポートマッピング（ホスト:コンテナ）
- `--name`: コンテナに名前を付ける

## 🔗 コンテナ間の連携

### 方法1: デフォルトブリッジネットワーク（シンプル）

```bash
# 起動スクリプトを実行
./start-containers.sh
```

フロントエンドからバックエンドへのアクセス：
```javascript
// フロントエンドのAPI呼び出し例
axios.get('http://localhost:8080/api/data')
  .then(response => {
    // データ処理
  });
```

### 方法2: カスタムネットワーク（推奨）

より安全で管理しやすい方法：

```bash
# ネットワーク付きで起動
./docker-network-setup.sh
```

この方法の利点：
- コンテナ名で通信可能（`backend-container:8080`）
- ネットワーク分離によるセキュリティ向上
- DNS解決の自動化

## 🚀 実行手順

### 1. イメージの準備

```bash
# まずイメージをビルド
cd backend
docker build -t java-backend-app .

cd ../frontend
docker build -t react-native-frontend .
```

### 2. コンテナの起動

```bash
# 方法A: シンプルな起動
docker run -d -p 8080:8080 --name backend-container java-backend-app
docker run -d -p 3000:3000 --name frontend-container react-native-frontend

# 方法B: ネットワーク連携あり（推奨）
./docker-network-setup.sh
```

### 3. 動作確認

```bash
# バックエンドの確認
curl http://localhost:8080/api/calculator/health

# フロントエンドへアクセス
# ブラウザで開く: http://localhost:3000
```

## 📝 API通信の設定

### フロントエンド側の設定（App.tsx）

```typescript
// 環境に応じてAPIのURLを切り替え
const API_URL = process.env.REACT_APP_API_URL 
  ? `${process.env.REACT_APP_API_URL}/api/calculator`
  : 'http://localhost:8080/api/calculator';

// API呼び出し例
const calculateResult = async (firstNumber: number, secondNumber: number, op: string) => {
  try {
    const response = await axios.post(`${API_URL}/calculate`, {
      firstNumber,
      secondNumber,
      operation: op
    });
    // レスポンス処理
  } catch (error) {
    console.error('API Error:', error);
  }
};
```

### 環境変数の設定

開発環境（`.env`）:
```env
REACT_APP_API_URL=http://localhost:8080
```

Docker環境（`.env.docker`）:
```env
REACT_APP_API_URL=http://backend-container:8080
```

## 🔍 トラブルシューティング

### コンテナが起動しない場合

```bash
# 既存のコンテナを確認
docker ps -a

# 既存のコンテナを削除
docker stop backend-container frontend-container
docker rm backend-container frontend-container

# 再起動
./start-containers.sh
```

### 通信ができない場合

```bash
# ネットワークを確認
docker network ls

# コンテナのIPアドレスを確認
docker inspect backend-container | grep IPAddress

# コンテナ間の疎通確認
docker exec frontend-container ping backend-container
```

### ログの確認

```bash
# バックエンドのログ
docker logs backend-container

# フロントエンドのログ
docker logs frontend-container

# リアルタイムでログを確認
docker logs -f backend-container
```

## 📊 コンテナ管理コマンド

```bash
# 実行中のコンテナ一覧
docker ps

# すべてのコンテナ（停止中も含む）
docker ps -a

# コンテナの停止
docker stop backend-container frontend-container

# コンテナの削除
docker rm backend-container frontend-container

# コンテナの再起動
docker restart backend-container

# コンテナ内でコマンド実行
docker exec -it backend-container bash
```

## 🎯 まとめ

1. **基本的な起動**: 要求通りの `docker run` コマンドで個別に起動
2. **ポートマッピング**: `-p` オプションでホストとコンテナのポートを接続
3. **API通信**: `http://localhost:8080` でバックエンドにアクセス
4. **ネットワーク連携**: より高度な設定で、コンテナ名での通信も可能

これで、WindowsのDocker環境上で、JavaバックエンドとReact-Nativeフロントエンドを完全に連携させて運用できます！