#!/usr/bin/env bash

# Inspired by https://www.youtube.com/watch?v=cQ03v4d3QEo
# Thanks to https://github.com/sagarkarira/coronavirus-tracker-cli for showing the curl commands they use.

# Rank │ World                  │ Total Cases  │ New Cases ▲ │ Total Deaths │ New Deaths ▲ │ Recovered │ Active  │ Critical │ Cases / 1M pop
CONTENT=$HOME/.corona-stats

update () {
	[ "$(stat -c %y $CONTENT 2>/dev/null | awk -F'[;:]' '{print $1":"$2}')" != "$(date '+%Y-%m-%d %H:%M')" ] && 
		curl -s -o $CONTENT https://corona-stats.online?source=2 > $CONTENT
}

get () {
	update 
	grep $1 $CONTENT | 
		sed "s/\s*//g ; s/▲//g ; s/║//g ; s/│/;/g" |
		awk -F';' '{print "🤒 " $3 " (" $4 " new) 💀 " $5 " (" $6 " new)"}'	
}

help () {
	cat << EOF
written by finnkauski

corona 
	full   - shows full country table
	search - greps country name and finds the stats (case sensative)
	help   - prints help
	*      - shows stats for UK

EOF
}


case $1 in 
	full) 
		update
		cat $CONTENT;;
	search)
		get $2;;
	help) 
		help;;
	*) 
		get "UK";; 
esac


