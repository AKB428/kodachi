#!/bin/sh
while true; do
        echo "----------------------------------run!"
        bundle exec ruby yahoo_auction.rb
	echo "LOOP END-----------------------------"
        sleep 1800
	echo "sleep END"
done
