#Yahoo Auction Bot with Twitter (Ruby)

## 概要
Yahooオークションから指定した商品を検索しTwitterにBotとして流すツールです

Yahoo APIとTwitter APIを使用します。


## 事前準備
 - Yahoo Developer アカウント取得
 - Twitter アプリケーション登録

## 環境設定
 - RubyとBundlerをインストール
 - bundle install
 - conf/conf.sample.json を conf/conf.jsonにコピーして適切な設定を記述

## 起動

単発起動: ヤフオクの検索結果1ページ分（20件をツイートする) 

```
 bundle exec ruby yahoo_auction.rb
```

単発起動: 設定ファイルを指定

```
 bundle exec ruby yahoo_auction.rb -c conf/conf_kankore.json
```

バッチとしてループする: cronせずプログラムでとりあえずループする場合 (第一引数に起動間隔を60分で指定)

```
 bundle exec ruby loop.rb 60
```

バッチとしてループする: 設定ファイルを指定　(起動は30分間隔)

```
 bundle exec ruby loop.rb 30 -c conf/conf_kankore.json
```

（テスト用）:ツイッターにツイートしない

```
bundle exec ruby yahoo_auction.rb -nt
```

## 注意点

Twitterは1日1000ツイート程度の制限(レートリミット)があるので1時間40ツイートが目安になります。

