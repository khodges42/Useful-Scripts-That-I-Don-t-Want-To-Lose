#!/bin/bash

# Stand up a quick jenkins dev container.

for dep in "docker python"
do
  command -v $dep >/dev/null 2>&1 || { echo "I require $dep but it's not installed.  Aborting." >&2; exit 1; }
done

docker run -u root --rm -d -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkinsci/blueocean
sudo docker logs $(sudo docker ps | grep jenkinsci/blueocean | cut -d' ' -f1) 2>&1 | grep -A2 "Please use the following" | tail -1
python -m webbrowser http://localhost:8080
