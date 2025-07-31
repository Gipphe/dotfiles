#!/usr/bin/env fish

awk -F ': ' '/model name/{print $2}' /proc/cpuinfo |
    head -n 1 |
    string trim |
    string replace '(R)' '' |
    string replace '(TM)' '' |
    string replace -r '@.*' ''
