# Calculator Backend - Java Spring Boot

## 開発環境のセットアップ

### 必要なソフトウェア
- Java 17以上
- Maven 3.6以上
- IDE（IntelliJ IDEA、Eclipse、VS Code など）

## ローカル開発

### 1. IDEで開発する場合

#### IntelliJ IDEA
1. File → Open → backendフォルダを選択
2. Mavenプロジェクトとして認識される
3. `CalculatorApplication.java`を右クリック → Run

#### VS Code
1. Java Extension Packをインストール
2. backendフォルダを開く
3. `CalculatorApplication.java`のmainメソッドの上にある「Run」をクリック

### 2. コマンドラインで実行

```bash
# backendディレクトリに移動
cd backend

# 依存関係をインストール
mvn clean install

# アプリケーションを実行
mvn spring-boot:run

# または、JARファイルをビルドして実行
mvn clean package
java -jar target/calculator-app.jar
```

## ソースコードの編集方法

### 新しいエンドポイントを追加する例

1. **コントローラーに新しいメソッドを追加**

```java
// CalculatorController.java に追加
@GetMapping("/history")
public ResponseEntity<List<String>> getHistory() {
    // 計算履歴を返す
    return ResponseEntity.ok(calculatorService.getHistory());
}
```

2. **サービスクラスにビジネスロジックを追加**

```java
// CalculatorService.java に追加
private List<String> history = new ArrayList<>();

public List<String> getHistory() {
    return new ArrayList<>(history);
}
```

3. **新しい演算を追加する例**

```java
// CalculatorService.java の calculate メソッドに追加
case "mod":
case "%":
    result = firstNumber % secondNumber;
    expression = String.format("%.2f %% %.2f = %.2f", firstNumber, secondNumber, result);
    break;
```

## テスト方法

### APIテスト（curl）

```bash
# ヘルスチェック
curl http://localhost:8080/api/calculator/health

# 計算実行
curl -X POST http://localhost:8080/api/calculator/calculate \
  -H "Content-Type: application/json" \
  -d '{
    "firstNumber": 10,
    "secondNumber": 5,
    "operation": "+"
  }'
```

### Postmanでテスト

1. Postmanを開く
2. 新しいリクエストを作成
3. メソッド: POST
4. URL: `http://localhost:8080/api/calculator/calculate`
5. Body → raw → JSON
6. リクエストボディ:
```json
{
  "firstNumber": 100,
  "secondNumber": 25,
  "operation": "/"
}
```

## Dockerでの実行

```bash
# Dockerイメージをビルド
docker build -t java-backend-app .

# コンテナを実行
docker run -p 8080:8080 java-backend-app

# docker-composeで実行
docker-compose up backend
```

## プロジェクト構造

```
backend/
├── src/main/java/com/calculator/
│   ├── CalculatorApplication.java      # Spring Bootメインクラス
│   ├── controller/
│   │   └── CalculatorController.java   # REST APIコントローラー
│   ├── service/
│   │   └── CalculatorService.java      # ビジネスロジック
│   ├── model/
│   │   ├── CalculationRequest.java     # リクエストDTO
│   │   └── CalculationResponse.java    # レスポンスDTO
│   └── config/
│       └── WebConfig.java              # CORS設定
├── src/main/resources/
│   └── application.properties          # アプリケーション設定
├── pom.xml                             # Maven設定
└── Dockerfile                          # Docker設定
```

## デバッグ方法

### VS Codeでデバッグ

1. ブレークポイントを設定（行番号の左をクリック）
2. F5キーまたはRun → Start Debuggingを選択
3. リクエストを送信してデバッグ

### ログを追加

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class CalculatorService {
    private static final Logger logger = LoggerFactory.getLogger(CalculatorService.class);
    
    public CalculationResponse calculate(CalculationRequest request) {
        logger.info("Calculating: {} {} {}", 
            request.getFirstNumber(), 
            request.getOperation(), 
            request.getSecondNumber());
        // ...
    }
}
```

## よくある変更例

### ポート番号を変更
```properties
# application.properties
server.port=9090
```

### CORS設定を変更
```java
// WebConfig.java
@Override
public void addCorsMappings(CorsRegistry registry) {
    registry.addMapping("/api/**")
            .allowedOrigins("http://localhost:3000")  // 特定のオリジンのみ許可
            .allowedMethods("GET", "POST")
            .allowedHeaders("*");
}
```

### バリデーションを追加
```java
// CalculationRequest.java
@Min(value = 0, message = "Number must be positive")
private Double firstNumber;
```