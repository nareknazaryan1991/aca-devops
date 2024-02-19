#!/bin/bash

# Function to execute the AWS command and handle errors
aws_tools_run() {
    local cmd=$1
    local output
    output=$(eval "$cmd" 2>&1) # Redirect stderr to stdout to capture errors
    
    if [ $? -eq 0 ]; then
        echo "$output" # Command executed successfully, print output
    else
        aws_tools_handle_error "$output" # Command failed, handle error
    fi
}

# Function to handle AWS CLI errors
aws_tools_handle_error() {
    local error_message=$1
    echo "AWS Command failed with the following error:"
    echo "$error_message"
    # Add your custom error handling logic here, e.g., sending an alert, logging, etc.
}

# Example usage:
AWS_REGION="us-east-1"

# Define the AWS command to create VPC and retrieve VPC ID
aws_command="aws ec2 create-vpc --cidr-block 10.0.0.0/16 --region $AWS_REGION --output json"
vpc_id=$(aws_tools_run "$aws_command" | jq -r '.Vpc.VpcId')

echo "Created VPC with ID: $vpc_id"