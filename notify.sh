#!/bin/bash

#My dummy script to check Humanode services

#Default message text
message="!!! ATTENTION !!! You must renew your authentification token in Humanode"

humanode=$(ps aux | grep humanode)
ngrok=$(ps aux | grep ngrok)

#Check if we missed a "consensus" word in log
alert=$(journalctl -u humanode -S "$(date -d "-10 minutes" +%Y"-"%m"-"%d" "%T)" | grep consensus)

if [ -z "$alert" ]
then
  systemctl restart humanode && \
  
  #Wait for humanode startup
  sleep 10  && \
  
  #Get auth url from log
  link=$(journalctl -u humanode -S "$(date -d "-10 seconds" +%Y"-"%m"-"%d" "%T)" | grep -o 'https://[^"]*')
  telegram-send "$message Please visit $link"
fi

#Check if humanode service is working
if [ -z "$humanode" ]
then
  telegram-send "!!! Humanode daemon is not running !!!"
fi

#Check if ngrok service is working
if [ -z "$ngrok" ]
then
  telegram-send "!!! Ngrok daemon is not running !!!"
fi
