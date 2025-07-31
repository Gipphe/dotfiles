#!/usr/bin/env fish

nmcli -t -f ACTIVE,SSID,SIGNAL d wifi | awk -F':' '
BEGIN { ORS=""; print "[" }
length($2) > 0 {
  active = $1 == "yes" ? "true" : "false";
  printf "%s{ \\"active\\": %s, \\"ssid\\": \\"%s\\", \\"signal\\": %s }", separator, active, $2, $3
  separator = ",";
}
END { print "]" }
'
