#!/bin/bash

source aws_tools.sh

# Function to check if the AWS command output is empty
isEmpty() {
    entity_name=$1
    aws_command=$2

    output=$(eval $aws_command 2>&1)

    if [ -z "$output" ]; then
        echo "Error: No $entity_name found."
        exit 1
    else
        echo "$entity_name is not empty."
        echo "Output: $output"
    fi
}

# AWS CLI command to describe VPCs
vpc_command="aws ec2 describe-vpcs --query 'Vpcs[].VpcId' --output text"
isEmpty "VPC" "$vpc_command"

# AWS CLI command to describe running EC2 instances
ec2_command="aws ec2 describe-instances --filters 'Name=instance-state-name,Values=running' --query 'Reservations[].Instances[].InstanceId' --output text"
isEmpty "EC2 instances" "$ec2_command"