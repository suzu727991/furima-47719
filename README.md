# FURIMA

## アプリケーション概要

フリーマーケットサイト「FURIMA」を再現するアプリケーションです。
ユーザー登録、商品の出品、商品情報の閲覧、商品の購入を実装します。

## データベース設計

必須機能に必要なテーブルは、以下の4つです。

- users：ユーザー情報
- items：商品情報
- orders：購入記録
- addresses：購入時点の配送先情報

### ER図

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

ER図の元データは[docs/erd.md](docs/erd.md)に分離して管理しています。

### usersテーブル

ユーザー登録・ログインに必要な情報と、購入・出品者を特定する情報を保存します。

| カラム | 型 | オプション・用途 |
| --- | --- | --- |
| nickname | string | null: false、ニックネーム |
| email | string | null: false、unique: true、DeviseのログインID |
| encrypted_password | string | null: false、Deviseがパスワードを暗号化して保存 |
| first_name | string | null: false、氏名の姓 |
| last_name | string | null: false、氏名の名 |
| first_name_kana | string | null: false、氏名の姓のカナ |
| last_name_kana | string | null: false、氏名の名のカナ |
| birth_date | date | null: false、生年月日 |

`password`と`password_confirmation`はデータベースには保存せず、Deviseが`encrypted_password`として管理します。

### itemsテーブル

出品された商品の情報を保存します。`user_id`で出品者のusersレコードと関連付けます。

| カラム | 型 | オプション・用途 |
| --- | --- | --- |
| user | references | null: false、foreign_key: true、出品者 |
| name | string | null: false、商品名 |
| info | text | null: false、商品説明 |
| category_id | integer | null: false、ActiveHashのカテゴリーID |
| sales_status_id | integer | null: false、ActiveHashの商品の状態ID |
| shipping_fee_status_id | integer | null: false、ActiveHashの配送料負担ID |
| prefecture_id | integer | null: false、ActiveHashの発送元地域ID |
| scheduled_delivery_id | integer | null: false、ActiveHashの発送までの日数ID |
| price | integer | null: false、300〜9,999,999円 |

商品画像はitemsテーブルに画像カラムを追加せず、商品出品機能の実装時にActive Storageで管理します。

### ordersテーブル

購入者と購入された商品を関連付ける購入記録を保存します。

| カラム | 型 | オプション・用途 |
| --- | --- | --- |
| user | references | null: false、foreign_key: true、購入者 |
| item | references | null: false、foreign_key: true、unique: true、購入商品 |

`item_id`を一意にすることで、1つの商品が複数回購入されることを防ぎます。商品にordersレコードが存在する場合、その商品は売却済みとして扱います。

クレジットカード番号・有効期限・セキュリティコードは保存しません。購入機能の実装時にPAY.JPなどの決済サービスを利用します。

### addressesテーブル

購入時点の配送先を保存します。ユーザー情報とは分離し、注文時の配送先を履歴として保持します。

| カラム | 型 | オプション・用途 |
| --- | --- | --- |
| order | references | null: false、foreign_key: true、unique: true、購入記録 |
| postal_code | string | null: false、3桁-4桁の郵便番号 |
| prefecture_id | integer | null: false、ActiveHashの都道府県ID |
| city | string | null: false、市区町村 |
| addresses | string | null: false、番地 |
| building | string | 建物名（任意） |
| phone_number | string | null: false、10〜11桁の電話番号 |

### アソシエーション

```text
User
  has_many :items
  has_many :orders

Item
  belongs_to :user
  has_one :order
  has_one_attached :image

Order
  belongs_to :user
  belongs_to :item
  has_one :address

Address
  belongs_to :order
```

### 設計上の補足

- カテゴリー、商品の状態、配送料負担、都道府県、発送までの日数は、固定選択肢のためActiveHashで管理します。
- 商品画像はActive Storageで管理します。
- クレジットカード情報はセキュリティ上データベースに保存しません。
- お気に入り、コメント、ブランド、通報機能などは今回の必須機能に含めず、必要になった時点で追加設計します。
- テーブルは、そのテーブルを必要とする機能の実装時に作成します。今回のブランチではER図とREADMEのみを更新します。

## 開発環境

- Ruby 3.2.2
- Rails 7.1.6
- MySQL 9.6.0

## セットアップ

```bash
bundle install
bin/rails db:create
bin/rails server
```
