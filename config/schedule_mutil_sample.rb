# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :output, "/var/log/cron.log"
every 1.hour, :at => '00:10' do
 command "source .bashrc;cd $YAHOO_ABR;bundle exe ruby yahoo_auction.rb -c private/camera.conf.json" 
end
every 1.hour, :at => '00:20' do
 command "source .bashrc;cd $YAHOO_ABR;bundle exe ruby yahoo_auction.rb -c private/lovelive.conf.json" 
end
every 1.hour, :at => '00:30' do
 command "source .bashrc;cd $YAHOO_ABR;bundle exe ruby yahoo_auction.rb -c private/comike.conf.json" 
end
every 1.hour, :at => '00:40' do
 command "source .bashrc;cd $YAHOO_ABR;bundle exe ruby yahoo_auction.rb -c private/kankore.conf.json" 
end
