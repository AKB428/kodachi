require 'net/http'
require 'uri'
require 'json'

File.open './conf/conf.json' do |file|
   @conf = JSON.load(file.read)
   @yahoo_conf = @conf["YahooJapan"]
end

@yahoo_url = 'http://auctions.yahooapis.jp/AuctionWebService/V2/json/search'
affiliate_id = @yahoo_conf["affiliate_id"]
affiliate_url = 'http://atq.ck.valuecommerce.com/servlet/atq/referral?sid=2219441&pid=877510753&vcptn=' + affiliate_id.to_s  + '&vc_url='

application_key = @yahoo_conf["application_key"]

max = 10
#1回のツイートで間隔をあける秒数
tweet_sleep_time = 10

search_target = {word: "一眼", hash_tag: "#一眼レフ"}
search_param1 = {appid: application_key, query: "一眼" , sort: "bits", order: "a", page: "1"} 
search_param2 = {appid: application_key, query: "一眼" , order: "a", page: "1"} 

def get_data(conf, search_target, param)
  p param
  res = Net::HTTP.post_form(URI.parse(@yahoo_url), param)
  result = jsonp_decode res.body
  item_list = result["ResultSet"]["Result"]["Item"]
  p item_list
end

def jsonp_decode(jsonp)
  #JSONP形式なのでJSON形式にする
  result_jsonp = jsonp.sub /^loaded\((?<json>.*)\)$/, '\k<json>'
  result = JSON.load(result_jsonp)
end


get_data(@yahoo_conf, search_target, search_param1)






#puts result_jsonp
#get_data(@yahoo_conf, search_target, search_param2)
