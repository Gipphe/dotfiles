#!/usr/bin/env fish

brightnessctl -m -d intel_backlight | awk -F, '{print $4}' | tr -d '%'
