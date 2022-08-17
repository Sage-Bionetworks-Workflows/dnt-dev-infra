#!/usr/bin/env bash

# This script takes in a profile string
# finds the instance id deployed by the prefect-ec2 stack
# and starts a port forwarding session using that profile and instance id
profile=$1
if [[ -z $profile ]]; then
  echo "this script requires an AWS profile name as the first parameter"
else
  set -ex
  stack=$(aws cloudformation describe-stacks --stack-name prefect-ec2)
  target=$(echo "$stack" | jq -r '.Stacks[0].Outputs | .[] | select(.OutputKey == "Ec2InstanceId").OutputValue')
  echo $target
  aws ssm start-session --profile $profile \
                      --target "${target}" \
                      --document-name AWS-StartPortForwardingSession \
                      --parameters '{"portNumber":["4200"],"localPortNumber":["4200"]}'
  set +ex
fi
