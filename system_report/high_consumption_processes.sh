	#!/bin/bash

echo "Processi che consumano più CPU:"
echo "--------------------------------"
ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%cpu | head -n 15

echo ""
echo "Processi che consumano più memoria:"
echo "-----------------------------------"
ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%mem | head -n 15

