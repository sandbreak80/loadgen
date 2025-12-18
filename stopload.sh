#!/bin/bash

# First, we find all processes with the name 'chrome' and 'chromedriver'
# and then we use 'awk' to extract their process IDs (PIDs).
# Finally, we use 'xargs' to pass these PIDs to the 'kill' command.

# Kill 'chromedriver' processes
pgrep -f chromedriver | xargs -r kill

# Kill 'chrome' processes
pgrep -f chrome | xargs -r kill

echo "All 'chrome' and 'chromedriver' processes have been killed."