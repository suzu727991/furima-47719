# FURIMA ER図

```mermaid
erDiagram
  USERS ||--o{ ITEMS : "出品する"
  USERS ||--o{ ORDERS : "購入する"
  ITEMS ||--o| ORDERS : "購入される"
  ORDERS ||--|| ADDRESSES : "配送先を持つ"

  USERS {
    bigint id PK
    string nickname
    string email UK
    string encrypted_password
    string first_name
    string last_name
    string first_name_kana
    string last_name_kana
    date birth_date
    datetime created_at
    datetime updated_at
  }

  ITEMS {
    bigint id PK
    bigint user_id FK
    string name
    text info
    integer category_id
    integer sales_status_id
    integer shipping_fee_status_id
    integer prefecture_id
    integer scheduled_delivery_id
    integer price
    datetime created_at
    datetime updated_at
  }

  ORDERS {
    bigint id PK
    bigint user_id FK
    bigint item_id FK UK
    datetime created_at
    datetime updated_at
  }

  ADDRESSES {
    bigint id PK
    bigint order_id FK UK
    string postal_code
    integer prefecture_id
    string city
    string addresses
    string building
    string phone_number
    datetime created_at
    datetime updated_at
  }
```

この図はGitHub上でMermaidとして表示されます。ER図はIssue #3のコードレビュー用に使用します。
