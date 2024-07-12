#!/bin/bash

interface="wlo1"
signal_info=$(iw dev $interface link)

if [ -z "$signal_info" ]; then
    echo " OFFLINE"
else
    signal_strength=$(echo "$signal_info" | grep 'signal:' | awk '{print $2}')
    if [ -z "$signal_strength" ]; then
        echo " OFFLINE"
    else
        if [ "$signal_strength" -ge -50 ]; then
            echo " 󰤨"
        elif [ "$signal_strength" -ge -70 ]; then
            echo " 󰤥"
        else
            echo " 󰤫"
        fi
    fi
fi