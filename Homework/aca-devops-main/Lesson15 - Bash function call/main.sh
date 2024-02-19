#!/bin/bash

source aws_tools.sh

vpc_command="aws ec2 describe-vpcs --query 'Vpcs[].VpcId' --output text"
isEmpty vpc "$vpc_command"


ec2_command="aws ec2 describe-instances --filters 'Name=instance-state-name,Values=running' --query 'Reservations[].Instances[].InstanceId' --output text"
isEmpty ec2 "$ec2_command"