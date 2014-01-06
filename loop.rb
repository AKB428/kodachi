counter = 0
while (true) do
        counter+=1
        puts counter
        system "bundle exec ruby yahoo_auction.rb"
        sleep(30*60)#60*60
end