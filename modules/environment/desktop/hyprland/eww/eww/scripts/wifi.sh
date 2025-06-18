#!/usr/bin/env bash

nmcli -g NAME,DEVICE c | awk -F':' '/wlp/ {print $1}' | head -1
