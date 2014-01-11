##############################################
# Simple Yahoo Auction(JP) Data to MongoDB
# 
# 
###############################################

require 'net/http'
require 'uri'
require 'json'
require 'date'
require 'time'
require "pry"
require 'mongo'

File.open './conf/conf.json' do |file|
   @conf = JSON.load(file.read)
   @yahoo_conf = @conf["YahooJapan"]
   @mongo_conf = @conf["MongoDB"]
end

if @mongo_conf["exec"]
  mongo_con = Mongo::Connection.new
  mongo_db = mongo_con[@mongo_conf["database"]]
  @main_collection = mongo_db[@mongo_conf["main_collection"]]
  @data_collection = mongo_db[@mongo_conf["collection"]]
end

@yahoo_url = 'http://auctions.yahooapis.jp/AuctionWebService/V2/json/search'
affiliate_id = @yahoo_conf["affiliate_id"]
@affiliate_url = 'http://atq.ck.valuecommerce.com/servlet/atq/referral?sid=2219441&pid=877510753&vcptn=' + affiliate_id.to_s  + '&vc_url='

application_key = @yahoo_conf["application_key"]

search_param = {appid: application_key, query: "一眼" , sort: "bids", order: "a", page: "1"} 


def get_data(param)
  result_count_save_flag = false
  
  res = Net::HTTP.post_form(URI.parse(@yahoo_url), param)
  result = jsonp_decode res.body
  
  #"totalResultsAvailable：該当件数の総個数です。
  #"totalResultsReturned：返された値の個数です。
  #"firstResultPosition：最初のデータが何個目に当たるかです。
  #/ResultSet/Result/UnitsWord  関連検索ワードです。（最大5件）
  unless result_count_save_flag
    main_obj = {
      "timestamp" => Time.now, 
      "attributes" => result["ResultSet"]['@attributes'],
      "UnitsWord" => result["ResultSet"]["Result"]["UnitsWord"],
    }
    @main_collection.insert(main_obj)
    result_count_save_flag = true
  end
  
  item_list = result["ResultSet"]["Result"]["Item"]
   
  item_list.each do |item|
     #mongoDBに挿入
     @data_collection.insert(item) if @mongo_conf["exec"]
  end
end

def jsonp_decode(jsonp)
  #JSONP形式なのでJSON形式にする
  result_jsonp = jsonp.sub /^loaded\((?<json>.*)\)$/, '\k<json>'
  result = JSON.load(result_jsonp)
end

get_data(search_param)