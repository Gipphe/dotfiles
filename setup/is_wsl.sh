#!/bin/sh

grep -qE 'microsoft|WSL' /proc/sys/kernel/osrelease 2>/dev/null
exit $?
