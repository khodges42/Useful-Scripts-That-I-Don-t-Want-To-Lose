#!/bin/bash

# Start jupyter notebook in docker and open a browser to it.
# The sudo stuff and general weirdness is because xdg-open doesn't posix

sudo docker run -d -p 8888:8888 jupyter/minimal-notebook
sleep 1
xdg-open $(sudo docker logs $(sudo docker ps | grep jupyter/minimal-notebook | cut -d' ' -f1) 2>&1 | grep -A2 "?token=" | sed -e 's/([^()]*)/127.0.0.1/g' |sed -e 's/\[[^][]*\]//g'|head -1)
