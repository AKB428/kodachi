counter = 0
while (true) do
        counter+=1
        puts counter
        sleep_minute = ARGV.shift.to_i
        system "bundle exec ruby yahoo_auction.rb " + ARGV.join(" ")
        sleep(sleep_minute * 60)#60*60
end