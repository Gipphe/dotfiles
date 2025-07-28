#!/usr/bin/env fish

set -l freqlist (awk '/cpu MHz/ { print $4 }' /proc/cpuinfo)
set -l maxfreq (string sub -e -3 </sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq)
if test -z "$freqlist" || test -z "$maxfreq"
    echo --
    exit
end
math \( (string join ' + ' $freqlist ) \) / (count $freqlist)
