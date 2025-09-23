#!/usr/bin/env fish

pamixer --get-default-sink

while true
    sleep 5s
    pamixer --get-default-sink
end
