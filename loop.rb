counter = 0
while (true) do
        counter+=1
        puts counter
        sleep(60*60)#30 min 60*30
        system("bundle exec ruby yahoo_auction.rb");
        #sleep(60*60)#30 min 60*30
end