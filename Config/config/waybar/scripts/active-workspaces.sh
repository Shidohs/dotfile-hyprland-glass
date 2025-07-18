#!/bin/bash
hyprctl workspaces -j | jq -r '.[] | select(.windows > 0) | .id' | sort -n
