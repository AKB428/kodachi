sleep_minute = ARGV.shift.to_i
while (true) do
        system "bundle exec ruby yahoo_auction.rb " + ARGV.join(" ")
        sleep(sleep_minute * 60)#60*60
end
