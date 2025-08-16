# Docker化の完全ガイド - 電卓アプリを例に

## 📝 開発からDocker化までの流れ

### STEP 1: ローカルで開発

開発者は最初、Dockerを使わずに普通に開発します。

#### Javaバックエンドの開発
```bash
# IDEやエディタで開発
code backend/src/main/java/com/calculator/

# ローカルでテスト実行
cd backend
mvn spring-boot:run
# → http://localhost:8080 で動作確認
```

#### React Nativeフロントエンドの開発
```bash
# 開発
code frontend/App.tsx

# ローカルでテスト実行
cd frontend
npm install
npm start
# → http://localhost:3000 で動作確認
```

---

### STEP 2: Dockerfileの作成（設計図を書く）

アプリが完成したら、「どうやってコンテナを作るか」の設計図を書きます。

#### バックエンドのDockerfile解説
```dockerfile
# ベースとなるOS/実行環境を指定
FROM openjdk:17-jdk-slim

# 作業ディレクトリを設定
WORKDIR /app

# アプリケーションのファイルをコンテナにコピー
COPY target/calculator-app.jar app.jar

# コンテナ起動時に実行するコマンド
ENTRYPOINT ["java", "-jar", "app.jar"]

# このコンテナが使うポート番号を宣言
EXPOSE 8080
```

#### フロントエンドのDockerfile解説
```dockerfile
# Node.jsの実行環境を指定
FROM node:latest

# 作業ディレクトリを設定
WORKDIR /app

# 依存関係ファイルをコピー
COPY package*.json ./

# 依存関係をインストール
RUN npm install

# アプリケーションコードをコピー
COPY . .

# ビルド実行
RUN npm run build

# ポート番号を宣言
EXPOSE 3000

# コンテナ起動時の実行コマンド
CMD ["npm", "start"]
```

---

### STEP 3: イメージのビルド（テンプレート作成）

Dockerfileを元に、実行可能なイメージを作成します。

```bash
# バックエンドイメージのビルド
cd backend
docker build -t java-backend-app .

# フロントエンドイメージのビルド
cd ../frontend
docker build -t react-native-frontend .
```

#### ビルドで何が起こっているか？

1. **FROM**: ベースイメージをダウンロード
2. **WORKDIR**: コンテナ内に作業フォルダを作成
3. **COPY**: ローカルのファイルをコンテナ内にコピー
4. **RUN**: コンテナ内でコマンドを実行（依存関係のインストールなど）
5. **イメージ作成**: すべての層を重ねて1つのイメージに

---

### STEP 4: コンテナの実行（アプリを動かす）

作成したイメージからコンテナを起動します。

```bash
# バックエンドコンテナを起動
docker run -p 8080:8080 java-backend-app

# フロントエンドコンテナを起動
docker run -p 3000:3000 react-native-frontend
```

#### ポートマッピングの説明
```
-p 外部ポート:内部ポート
-p 8080:8080 
   ↑         ↑
   PC側      コンテナ内
```

---

## 🎯 実践例：電卓アプリの完全なDocker化

### 1. 開発完了の確認
```bash
# ソースコードがすべて完成していることを確認
ls -la backend/src/main/java/com/calculator/
ls -la frontend/
```

### 2. Mavenでバックエンドをビルド（JARファイル作成）
```bash
cd backend
mvn clean package
# → target/calculator-app.jar が作成される
```

### 3. Dockerイメージをビルド
```bash
# バックエンド
docker build -t java-backend-app .

# フロントエンド
cd ../frontend
docker build -t react-native-frontend .
```

### 4. 個別にコンテナを実行
```bash
# バックエンドを起動
docker run -d --name backend -p 8080:8080 java-backend-app

# フロントエンドを起動
docker run -d --name frontend -p 3000:3000 react-native-frontend
```

### 5. 動作確認
```bash
# バックエンドのヘルスチェック
curl http://localhost:8080/api/calculator/health

# フロントエンドにアクセス
# ブラウザで http://localhost:3000 を開く
```

---

## 🚀 Docker Composeで一括管理

複数のコンテナを一度に管理する場合：

```yaml
version: '3.8'

services:
  backend:
    build: ./backend
    ports:
      - "8080:8080"
  
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    depends_on:
      - backend
```

実行：
```bash
docker-compose up --build
```

---

## 📊 イメージとコンテナの確認

```bash
# 作成されたイメージの一覧
docker images

# 実行中のコンテナの一覧
docker ps

# すべてのコンテナ（停止中も含む）
docker ps -a

# コンテナのログを確認
docker logs backend
docker logs frontend
```

---

## 🔄 更新時のワークフロー

1. **ソースコードを修正**
```bash
# 例：新機能を追加
vim backend/src/main/java/com/calculator/service/CalculatorService.java
```

2. **ローカルでテスト**
```bash
mvn spring-boot:run
```

3. **JARファイルを再ビルド**
```bash
mvn clean package
```

4. **Dockerイメージを再ビルド**
```bash
docker build -t java-backend-app .
```

5. **古いコンテナを停止・削除**
```bash
docker stop backend
docker rm backend
```

6. **新しいコンテナを起動**
```bash
docker run -d --name backend -p 8080:8080 java-backend-app
```

---

## 💡 重要なポイント

### Dockerは開発ツールではない
- **開発時**: IDE、Maven、npm を直接使う
- **デプロイ時**: Dockerでパッケージング

### Dockerfileは設計図
- どの環境を使うか
- どのファイルを含めるか
- どのコマンドで起動するか

### イメージはテンプレート
- 一度作れば何度でも同じコンテナを作成可能
- 他の環境でも同じように動作

### コンテナは実行インスタンス
- イメージから作られる
- 独立した環境で動作
- 停止・削除・再作成が簡単

---

## 🎓 まとめ

```
開発（ローカル） → Dockerfile作成 → イメージビルド → コンテナ実行
     ↓                  ↓               ↓              ↓
  通常の開発        設計図を書く    テンプレート作成   本番環境で実行
```

これで、開発からDocker化、そして実行までの完全な流れが理解できます！