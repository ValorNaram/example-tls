#!/bin/bash
# send the reload signal to the dummy to load the new certificates
echo -e "\033[1;37msending the reload signal SIGHUP to '$(cat dummy.pid)' ...\033[0;m"
kill -s SIGHUP $(cat dummy.pid)
echo -e "\033[1;37m[DONE]: sending the reload signal SIGHUP to '$(cat dummy.pid)'\033[0;m"
