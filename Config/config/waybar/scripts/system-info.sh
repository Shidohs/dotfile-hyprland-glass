#!/bin/bash
cpu=$(awk '/^cpu / {usage=($2+$4)*100/($2+$4+$5)} END {print int(usage)}' /proc/stat)
mem=$(free | awk 'tolower($1) ~ /^mem/ {print int($3/$2 * 100)}')
temp=$(sensors | awk '/Package/ {gsub(/[+°C]/,"",$4); print int($4); exit}')
echo "{\"cpu\": $cpu, \"mem\": $mem, \"temp\": $temp}"


