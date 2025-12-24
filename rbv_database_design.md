# データベース設計 (RBV)

### テーブル詳細

#### users テーブル
- id : ユーザーID (PK)
- name : ユーザー名
- email : メールアドレス / ユニーク制約
- crypted_password : 暗号化されたパスワード
- salt : パスワードのソルト（Sorcery認証用）

#### categories テーブル
- id : カテゴリID (PK)
- name : カテゴリ名称（例：書籍、動画など）

#### stocks テーブル
- id : 在庫ID (PK)
- user_id : ユーザーID (FK / users参照)
- category_id : カテゴリID (FK / categories参照)
- title : 在庫タイトル
- purchase_price : 取得価額（コスト）
- book_value : 帳簿価額（評価減後の価値）
- fair_value : 公正価値（減損後の価値）
- status : 在庫状態（Enum管理：未着手、仕掛中、完了、減損など）
- author : 著者・製作者
- purchase_date : 購入日

#### memos テーブル
- id : 学習メモID (PK)
- user_id : ユーザーID (FK / users参照)
- stock_id : 在庫ID (FK / stocks参照)
- body : 学習メモの内容

### ER図
```mermaid
erDiagram
    direction TB

    users ||--o{ stocks : "ユーザーは0個以上の在庫を持つ"
    users ||--o{ memos : "ユーザーは0個以上のメモを書く"
    categories ||--o{ stocks : "1つのカテゴリは0個以上の在庫分類に使われる"
    stocks ||--o{ memos : "1つの在庫は0個以上のメモを持つ"

    users {
        bigint id PK "ユーザーID"
        varchar email UK "メールアドレス"
        varchar crypted_password "パスワード"
        varchar salt "パスワードソルト"
        varchar name "ユーザー名"
        timestamp created_at "作成日時"
        timestamp updated_at "更新日時"
    }

    categories {
        bigint id PK "カテゴリID"
        varchar name "カテゴリ名称"
        timestamp created_at "作成日時"
        timestamp updated_at "更新日時"
    }

    stocks {
        bigint id PK "在庫ID"
        bigint user_id FK "ユーザーID"
        bigint category_id FK "カテゴリID"
        varchar title "在庫タイトル"
        int purchase_price "取得価額"
        int book_value "帳簿価額(評価減後)"
        int fair_value "公正価値(減損後)"
        int status "ステータス"
        varchar author "在庫著者"
        date purchase_date "購入日"
        timestamp created_at "登録日時"
        timestamp updated_at "更新日時"
    }

    memos {
        bigint id PK "学習メモID"
        bigint user_id FK "ユーザーID"
        bigint stock_id FK "在庫ID"
        text body "学習メモ内容"
        timestamp created_at "作成日時"
        timestamp updated_at "更新日時"
    }