class YahooAuction.rb
  
  def initialize
    
  end
  
  def get_data (config, options)
          ua = LWP::UserAgent->new;
  
          req = POST yahoo_url,
           [
                  appid => application_key,
                  query => options->{query},
                  sort => options->{sort},
                  order => options->{order},
                  page => options->{page}
           ];
  
          result_jsonp = ua->request(req)->content;
  
          #JSONP形式なのでJSON形式にする
          result_jsonp =~ s/^loaded\((.*)\)/1/;
  
          result = decode_json result_jsonp;
  
          att = result->{'ResultSet'}->{'@attributes'};
  
          for var ( keys %att ) {
                  say var. " = " . att->{var};
          }
  
          #アイテムリスト出力
          item_ref = result->{ResultSet}->{Result}->{Item};
  
      #ツイート文
      my @tweets;
  
          if ( result->{'ResultSet'}->{'@attributes'}->{totalResultsReturned} == 1 )
          {
                  line = item_output(item_ref);
                  push(@tweets,line);
          }
          else {
                  counter = 0;
                  foreach var (@item_ref) {
                          counter++;
                          line = item_output(var);
                          #say line;
              push(@tweets,line);
                          last if max == counter;
  
                  }
  
          }
  
          tweet(@tweets);
end
  
  def item_output(var) 
  
          #入札数
          bids = var->{Bids} || 0;
  
          title = utf_conversion( var->{Title} );
  
          encded_auc_url = uri_escape( var->{AuctionItemUrl} );
          affi_url = affiliate_url . encded_auc_url;
  
  
      sokketu;
          if ( var->{BidOrBuy} ) {
                  sokketu=sprintf( "即決価格=%d円 ", var->{BidOrBuy} );
          }
          else {
           sokketu="即決価格=なし ";
          }
  
          #終了時間 RFC3339形式なので変換する
          t = HTTP::Date::str2time( var->{EndTime} );
          endate = HTTP::Date::time2iso(t);
  
      endate = "終了時間=".endate;
  
      cprice = sprintf( " 現在価格=%d円 ", var->{CurrentPrice} );
  
      return_st = title." 入札数=".bids.cprice.sokketu.endate. " " . affi_url . " #艦これ";
      end
end