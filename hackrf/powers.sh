#!/bin/bash
set -eo pipefail
filename=edges-$(date +%Y%m%d%H%M%S).json
exit_script() {
  echo '{ "final":true } ] }' >> $filename
  trap - SIGINT SIGTERM # clear the trap
  kill -- -$$ # Sends SIGTERM to child/sub processes
}
trap exit_script SIGINT SIGTERM
(
  echo '{ "edges": ['
  first=true
  while true ; do
     if $first ; then
       echo "  {"
       first=false
     else
       echo ","
       echo "  {"
     fi
     echo -n '    "powers":'
     hackrf_sweep -1 -f1:7250 -w 100000 -l32 -g8 2>/dev/null | grep 2018 | ./sorter.pl
     echo ","
     echo -n '    "location":'
     curl -sL http://localhost:3000 | jq .
     echo -n "  }"
  done
) | tee $filename
