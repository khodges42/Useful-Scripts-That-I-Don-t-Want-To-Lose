#!/bin/bash
# Curl a jenkins job to start a build.

[ -z "$JENKINS_URL" ] && echo "export $JENKINS_URL as such: http://daddyjenkins:8080" && exit 1;
[ -z "$JENKINS_JOB" ] && echo "export $JENKINS_JOB to the jobs name (as in foo, or ci-build, or whatever)" && exit 1;
[ -z "$JENKINS_JOB_TOKEN" ] && echo "export $JENKINS_JOB_TOKEN as the token set in Build Triggers > Trigger builds remotely" && exit 1;
[ -z "$JENKINS_USERNAME_TOKEN" ] && echo "export $JENKINS_USERNAME_TOKEN as user:hunter2" && exit 1;
if [ -z "$JENKINS_PARAMS" ]; then
  echo "export $JENKINS_PARAMS as a space separated list (branch=foo vi=trash liquor=yes) if you have any params."
  extraparams=""
else
  for param in $JENKINS_PARAMS
  do
    extraparams=$extraparams+" --data $param"
  done
fi



curl -X POST http://"${JENKINS_URL}"/jenkins/job/"${JENKINS_JOB}"/buildWithParameters --user "${JENKINS_USERNAME_TOKEN}" --data token="${JENKINS_JOB_TOKEN}" "${extraparams}"
