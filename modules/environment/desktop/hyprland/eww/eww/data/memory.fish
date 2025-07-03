awk '
    $1 == "MemTotal:" { memtotal = $2 }
    $1 == "MemAvailable:" { memavailable = $2 }
    END {
      printf("{\\"total\\": %s, \\"available\\": %s, \\"used\\": %s, \\"percent\\": %s }\\n", memtotal, memavailable, (memtotal - memavailable), ((memtotal - memavailable) / memtotal * 100))
    }
  ' /proc/meminfo
