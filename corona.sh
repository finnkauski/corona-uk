#!/usr/bin/env bash

# Inspired by https://www.youtube.com/watch?v=cQ03v4d3QEo
# Thanks to https://github.com/sagarkarira/coronavirus-tracker-cli for showing the curl commands they use.

# Rank │ World                  │ Total Cases  │ New Cases ▲ │ Total Deaths │ New Deaths ▲ │ Recovered │ Active  │ Critical │ Cases / 1M pop
CONTENT=/tmp/.corona

update () {
	[ "$(stat -c %y $CONTENT 2>/dev/null | awk -F'[;:]' '{print $1":"$2}')" != "$(date '+%Y-%m-%d %H:%M')" ] && 
		curl -s -o $CONTENT https://corona-stats.online?source=2 > $CONTENT
}

case $1 in 
	full) 
		update
		cat $CONTENT;;
	*) 
		update 
		grep "UK" $CONTENT | 
			sed "s/\s*//gi ; s/▲//g ; s/║//g ; s/│/;/g" |
			awk -F';' '{print "🤒 " $3 " (" $4 " new) 💀 " $5 " (" $6 " new)"}'	
		;; 
esac


