counter = 0
while (true) do
        counter+=1
        puts counter
        system "bundle exec ruby yahuoku2mongodb.rb"
        sleep(60*60)
end