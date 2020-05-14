<img width="200" alt="TigerMask" src="https://user-images.githubusercontent.com/62415847/81903865-5dbaa900-95fd-11ea-9919-c12cf4f43fa7.png">

## アプリ名
### Tiger Mask

## 概要
### 売り上げの10%を日本の医療研究に寄付できるマスクの通販サイト

## 本番環境
### デプロイ先：http://52.69.200.191/
### テストアカウント:メールアドレス aaa@aaa 、 パスワード aaaaaa (aを6文字)

## 制作背景(意図)
・アニメ「タイガーマスク」の主人公は孤児院出身で、稼いだお金を出身の孤児院に寄付していた。  
・タイガーマスクの生き様をアイコンにし、「寄付＝かっこいい」と思えるようなマスク通販サイトを作りたかった。

### 社会的背景
・日本の社会では個人の寄付の文化が薄い。（日本の最高学府である東京大学の基金では2018年度の寄付額の約94%が法人である。）  
・日本の医療研究の未来には、個人の寄付を促進できるような仕組みが必要だと考えられる。

### マスク市場の背景
・殆どのマスク製品の売りは機能。ユーザーが愛着を感じる製品が無い。  
  社会貢献に繋がる製品があれば、ユーザーがブランドに愛着を感じるという仮説が生まれた。  
・マスク製品にはブランドのアイコンが特に存在しない。  
  アイコンのイメージを根付かせれば、ゆるキャラやアニメ文化が発達している日本では有利だと考えた。  

## DEMO
https://gyazo.com/912fcd57d64e3516075082cee6dc1a75

## 工夫したポイント
・トップページのインパクト  
・直感的に操作しやすいユーザーインターフェース  
・オリジナルメソッドで記述したカート機能  

## 使用技術(開発環境)
Ruby, Ruby on rails, haml, sass, javascript, jquery

## 今後実装したい機能
・トップページの画像が一定時間で切り替わるように設定する。  
・在庫管理機能を実装する。  
・PAY.JPによる決済機能を実装する。  
・管理者用のページを作成し、DONATION LOGを更新できるようにする。  

## DB設計
### masksテーブル => 商品情報
|Column|Type|Options|
|------|----|-------|
|name|string||
|image|string||
|infomation|text||
|stock|integer||
|price|integer||
|detail|text||
  
Association
- has_many :cart_items
- has_many :carts, through: :cart_items

### cart_itemsテーブル => 中間テーブル
|Column|Type|Options|
|------|----|-------|
|quantity|integer||
|mask_id|references|foreign_key: true|
|cart_id|references|foreign_key: true|
|user_id|integer||
  
Association
- belongs_to :mask
- belongs_to :cart
- belongs_to :user

### cartsテーブル
Association
- has_many :cart_items
- has_many :masks, through: :cart_items

### usersテーブル
|Column|Type|Options|
|------|----|-------|
|email|string|null: false|
|encrypted_password|string|null: false|
|gender|integer||
|birth_date|date||
  
Association
- has_many :cart_items