#!/bin/bash
# Hyprland Performance Monitor

echo "=== Hyprland Performance Report ==="
echo "Generated: $(date)"
echo

echo "--- System Resources ---"
echo "Memory usage:"
ps aux --sort=-%mem | grep -E "(hypr|waybar|rofi)" | head -10

echo -e "\nCPU usage:"
ps aux --sort=-%cpu | grep -E "(hypr|waybar|rofi)" | head -10

echo -e "\n--- Hyprland Status ---"
if pgrep -x "Hyprland" > /dev/null; then
    echo "✅ Hyprland is running"
    echo "Version: $(hyprctl version | head -1)"
    echo "Workspaces: $(hyprctl workspaces | grep -c "workspace ID")"
    echo "Windows: $(hyprctl clients | grep -c "Window")"
else
    echo "❌ Hyprland is not running"
fi

echo -e "\n--- Component Status ---"
for component in waybar rofi dunst hypridle; do
    if pgrep -x "$component" > /dev/null; then
        echo "✅ $component is running"
    else
        echo "❌ $component is not running"
    fi
done
