#Yahoo Auction Bot with Twitter (Ruby)

## 概要
Yahooオークションから指定した商品を検索しTwitterにBotとして流すツールです

Yahoo APIとTwitter APIを使用します。


## 事前準備
 - Yahoo Developer アカウント
 - Twitter アプリケーション登録

## 環境設定
 - RubyとBundlerをインストール
 - bundle install
 - conf/conf.json.sample を conf/conf.sampleにコピーして適切な設定を記述
 - conf/search_param.json.sample を conf/search_param.json にコピーして適切な設定を記述
 

## 起動

単発起動: ヤフオクの検索結果1ページ分（20件をツイートする) 

```
 bundle exec ruby yahoo_auction.rb
```

バッチとしてループする: cronせずプログラムでとりあえずループする場合

```
 bundle exec ruby loop.rb
```


## 注意点

Twitterは1日1000ツイート程度の制限(レートリミット)があるので1時間40ツイートが目安になります。

