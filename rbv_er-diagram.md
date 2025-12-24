---
config:
  theme: redux-color
  look: classic
title: ユーザー在庫(教材)管理ER図 (最終確定版)
---
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

    style users fill:#FFCDD2
    style stocks fill:#E1F5FE
    style memos fill:#FFF9C4
    style categories fill:#E0F2F1