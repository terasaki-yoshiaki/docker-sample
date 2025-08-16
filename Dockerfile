# Javaの実行環境としてOpenJDK 17を使用
FROM openjdk:17-jdk-slim

# アプリケーションのJARファイルを追加
COPY target/your-app.jar app.jar

# コンテナが起動したときに実行するコマンド
ENTRYPOINT ["java", "-jar", "/app.jar"]

# コンテナがリッスンするポートを指定
EXPOSE 8080