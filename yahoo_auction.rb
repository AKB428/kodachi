require 'net/http'
require 'uri'
require 'json'
require 'date'
require 'time'

File.open './conf/conf.json' do |file|
   @conf = JSON.load(file.read)
   @yahoo_conf = @conf["YahooJapan"]
end

@yahoo_url = 'http://auctions.yahooapis.jp/AuctionWebService/V2/json/search'
affiliate_id = @yahoo_conf["affiliate_id"]
@affiliate_url = 'http://atq.ck.valuecommerce.com/servlet/atq/referral?sid=2219441&pid=877510753&vcptn=' + affiliate_id.to_s  + '&vc_url='

application_key = @yahoo_conf["application_key"]

max = 10
#1回のツイートで間隔をあける秒数
tweet_sleep_time = 10

search_target = {word: "一眼", hash_tag: "#一眼レフ"}
search_param1 = {appid: application_key, query: "一眼" , sort: "bids", order: "a", page: "1"} 
search_param2 = {appid: application_key, query: "一眼" , order: "a", page: "1"} 

def get_data(conf, search_target, param)
  p param
  res = Net::HTTP.post_form(URI.parse(@yahoo_url), param)
  result = jsonp_decode res.body
  item_list = result["ResultSet"]["Result"]["Item"]
  #p item_list
    
  tweet_list = []  
  item_list.each do |item|
     title = item["Title"]
     #入札数
     bids = item["Bids"] || 0
     bids = "入札数=" + bids  
       
     encded_auc_url = URI.escape item["AuctionItemUrl"];
     affi_url = @affiliate_url + encded_auc_url
     
     #rfc3339形式なので変換する
     end_time = Time.parse item["EndTime"]
     format_end_time = end_time.strftime("%Y年%m月%d日 %H:%M:%S")
     result = title + bids + affi_url + " " + format_end_time
     tweet_list.push result
  end
  
  p tweet_list
end

def jsonp_decode(jsonp)
  #JSONP形式なのでJSON形式にする
  result_jsonp = jsonp.sub /^loaded\((?<json>.*)\)$/, '\k<json>'
  result = JSON.load(result_jsonp)
end


get_data(@yahoo_conf, search_target, search_param1)






#puts result_jsonp
#get_data(@yahoo_conf, search_target, search_param2)
