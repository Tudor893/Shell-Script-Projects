#!/bin/bash
echo -e "year\tmonth\tday\thour\tobs_temp\tfc_temp" > report.log
today=$(date +%Y%m%d)
weather_report=raw_data_$today
curl wttr.in/bucuresti --output $weather_report
grep °C $weather_report | sed 's/\x1b\[[0-9;]*m//g' > temperatures.txt
obs_temp=$(head -1 temperatures.txt | tr -s " " | xargs | rev | cut -d " " -f2 | rev)
fc_temp=$(head -3 temperatures.txt | tail -1 | tr -s " " | xargs | cut -d "C" -f2 | rev | cut -d " " -f2 | rev)
hour=$(TZ='Europe/Bucharest' date +%T)
day=$(TZ='Europe/Bucharest' date +%d)
month=$(TZ='Europe/Bucharest' date +%m)
year=$(TZ='Europe/Bucharest' date +%Y)
echo -e "$year\t$month\t$day\t$hour\t$obs_temp\t$fc_temp" >> report.log
