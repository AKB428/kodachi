counter = 0
while (true) do
        counter+=1
        puts counter
        system("bundle exec ruby yahoo_auction.rb");
        sleep(60*30)#30 min 60*30
end