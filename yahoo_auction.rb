require 'net/http'
require 'uri'
require 'json'
require 'date'
require 'time'
require "pry"
require 'mongo'
require 'optparse'
require './lib/download_media'
require 'twitter'
require 'pp'

include DownloadMedia

@twitter_flag = true
@debug_flag = false
conf_file_path = './conf/conf.json'

opt = OptionParser.new
Version = "1.0.0"
opt.on('-c CONF_FILE_PATH', 'conf_file_path') {|v| conf_file_path = v }
opt.on('-n', 'not tweet') {@twitter_flag = false}
opt.on('-d', 'debug print') {@debug_flag = true}
opt.parse!(ARGV)


File.open conf_file_path do |file|
  @conf = JSON.load(file.read)
  @yahoo_conf = @conf["YahooJapan"]
  @mongo_conf = @conf["MongoDB"]
  @yahoo_auction_search = @conf["YahooAuctionSearch"]
  if @twitter_flag
    twitter_conf = @conf["Twitter"]
    @tw = Twitter::REST::Client.new(
        :consumer_key => twitter_conf["consumer_key"],
        :consumer_secret => twitter_conf["consumer_secret"],
        :oauth_token => twitter_conf["access_token"],
        :oauth_token_secret => twitter_conf["access_token_secret"]
    )
  end
end

if @mongo_conf["exec"]
  mongo_con = Mongo::Connection.new
  mongo_db = mongo_con[@mongo_conf["database"]]
  @mongo_collection = mongo_db[@mongo_conf["collection"]]
end

@yahoo_url = 'http://auctions.yahooapis.jp/AuctionWebService/V2/json/search'
@detail_url = 'http://auctions.yahooapis.jp/AuctionWebService/V2/json/auctionItem'
affiliate_id = @yahoo_conf["affiliate_id"]
@affiliate_url = 'http://atq.ck.valuecommerce.com/servlet/atq/referral?sid=2219441&pid=877510753&vcptn=' + affiliate_id.to_s  + '&vc_url='

@application_key = @yahoo_conf["application_key"]

#1回のツイートで間隔をあける秒数
@tweet_sleep_time = 10

def get_data(search_target, param, tweet_max)
  res = Net::HTTP.post_form(URI.parse(@yahoo_url), param)
  result = jsonp_decode res.body

  item_list = result["ResultSet"]["Result"]["Item"]

  #p item_list

  tweet_list = []
  item_list.each do |item|

    pp item if @debug_flag

    detail =  get_detail(item["AuctionID"])

    image1 =  detail["ResultSet"]["Result"]["Img"]["Image1"]

    title = item["Title"]
    #入札数
    bids = item["Bids"] || 0
    bids = "入札数=" + bids

    encded_auc_url = URI.escape item["AuctionItemUrl"];
    affi_url = @affiliate_url + encded_auc_url

    sokketu = "即決価格=なし"
    sokketu = sprintf( "即決価格=%d円", item["BidOrBuy"].to_i ) if item["BidOrBuy"] != nil
    #sokketu = item["BidOrBuy"].to_s

    #rfc3339形式なので変換する
    end_time = Time.parse item["EndTime"]
    format_end_time = "終了=" + end_time.strftime("%Y年%m月%d日 %H:%M:%S")

    current_price = sprintf( "現在価格=%d円", item["CurrentPrice"].to_i )

    #result = title + " " + bids +  " " + current_price + " " + affi_url + " " + sokketu + " " + format_end_time + " " + search_target["hash_tag"]
    result = title + " " + bids +  " " + current_price + " " + affi_url + format_end_time + " " + search_target["hash_tag"]
    tweet_list.push({"tweet_msg" => result, "media" => image1 ? download_image(image1, search_target["mdeia_folder"]) : nil })


    #mongoDBに挿入
    @mongo_collection.insert(item) if @mongo_conf["exec"]
  end

  tweet_list.each.with_index(1) do |tweet_data, index|
    #p index
    #p tweet_max
    #p tweet_data
    #puts "try catch start"
    #ツイート
    #binding.pry
    begin
      if @twitter_flag
        if tweet_data["media"]
          @tw.update_with_media(tweet_data["tweet_msg"], File.new(tweet_data["media"]))
        else
          @tw.update(tweet_data["tweet_msg"])
        end
        puts "tweet!!!!!"
      end
    rescue => e
      puts e.to_s
    ensure
      if @twitter_flag
        puts "sleep " + @tweet_sleep_time.to_s
        sleep @tweet_sleep_time
      end
    end
    break if index == tweet_max
  end
end

def get_detail(auction_id)
  res = Net::HTTP.post_form(URI.parse(@detail_url), {appid: @application_key, auctionID: auction_id})
  jsonp_decode res.body
end

def jsonp_decode(jsonp)
  #JSONP形式なのでJSON形式にする
  result_jsonp = jsonp.sub /^loaded\((?<json>.*)\)$/, '\k<json>'
  result = JSON.load(result_jsonp)
end


search_target = @yahoo_auction_search["search_target"]
search_params = @yahoo_auction_search["search_params"]
tweet_max = @yahoo_auction_search["tweet_max"]

search_params.each.with_index do |search_param, index|
  search_param['appid'] = @application_key
  get_data(search_target, search_param, tweet_max ? tweet_max[index] : 20)
end
