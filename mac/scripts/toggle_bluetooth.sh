#!/bin/bash

bluetooth=$(/opt/homebrew/bin/blueutil -p)
echo $bluetooth

if [[ "$bluetooth" == 1 ]];
then
  /opt/homebrew/bin/blueutil -p 0
else
  /opt/homebrew/bin/blueutil -p 1
  /opt/homebrew/bin/blueutil --connect "14-3f-a6-89-50-c5"
fi
