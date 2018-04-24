#!/bin/bash

pcount=$#
if (($pcount==0)); then
  echo 'Usage: x-command.sh <your_command>';
  exit;
fi
echo '------localhost-------'
$@
for ((host=1;host<=2;host++)) do
  echo '-------slave'$host'--------'
  ssh hadoop@slave$host $@;
done
