#!/usr/bin/env bash

# This script takes in a profile string
# finds the instance id deployed by the airflow-ec2 stack
# and starts a port forwarding session using that profile and instance id
profile=$1
if [[ -z $profile ]]; then
  echo "this script requires an AWS profile name as the first parameter"
else
  set -ex
  stack=$(aws cloudformation describe-stacks --stack-name airflow-ec2)
  target=$(echo "$stack" | jq -r '.Stacks[0].Outputs | .[] | select(.OutputKey == "Ec2InstanceId").OutputValue')
  echo $target
  aws ssm start-session --profile $profile \
                      --target "${target}" \
                      --document-name AWS-StartPortForwardingSession \
                      --parameters '{"portNumber":["8080"],"localPortNumber":["8080"]}'
  set +ex
fi
