# Node.jsの実行環境として最新のバージョンを使用
FROM node:latest

# コンテナ内の作業ディレクトリを設定
WORKDIR /app

# package.jsonとpackage-lock.jsonをコンテナにコピー
COPY package*.json ./

# 依存関係をインストール
RUN npm install

# アプリケーションのソースコードをコピー
COPY . .

# アプリケーションをビルド
RUN npm run build

# コンテナがリッスンするポートを指定
EXPOSE 3000

# コンテナ起動時にアプリケーションを起動
CMD ["npm", "start"]