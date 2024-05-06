#!/bin/bash

# Script to restart Waybar service
pgrep -x waybar && pkill -x waybar                       
waybar &


