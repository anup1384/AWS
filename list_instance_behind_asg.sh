#!/bin/bash
ASG_NAME=$1
AWS_REGION=$2


### command to execute
### ./list_instance_behind_asg.sh <asg-name> <region-name> 

for ID in $(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names ${ASG_NAME} --region ${AWS_REGION} --query AutoScalingGroups[].Instances[].InstanceId --output text);
do
aws ec2 describe-instances --instance-ids $ID --region ${AWS_REGION} --query Reservations[].Instances[].PrivateIpAddress --output text
done
