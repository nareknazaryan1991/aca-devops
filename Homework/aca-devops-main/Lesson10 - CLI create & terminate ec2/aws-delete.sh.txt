#!/bin/bash

# Get the list of all VPC IDs
all_vpcs=$(aws ec2 describe-vpcs --query 'Vpcs[].VpcId' --output text)

# Check if there are any VPCs
if [ -z "$all_vpcs" ]; then
    echo "No VPCs found."
    exit 1
fi

# Loop through each VPC and delete if it does not have the 'permanent' tag
for vpc_id in $all_vpcs; do

    # Check if the VPC has the 'permanent' tag
    has_permanent_tag=$(aws ec2 describe-vpcs --vpc-ids "$vpc_id" --query 'Vpcs[0].Tags[?Key==`permanent`]' --output text)

    if [ -z "$has_permanent_tag" ] || [ "$has_permanent_tag" == "None" ]; then
        # VPC does not have the 'permanent' tag, prepare for deleting it
        echo "Prepare for deleting VPC: $vpc_id"

        # Detach and delete Internet Gateways
        igw_id=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$vpc_id" --query 'InternetGateways[].InternetGatewayId' --output text)
        if [ -n "$igw_id" ]; then
            echo "Detaching and deleting Internet Gateway $igw_id"
            aws ec2 detach-internet-gateway --internet-gateway-id "$igw_id" --vpc-id "$vpc_id"
            aws ec2 delete-internet-gateway --internet-gateway-id "$igw_id"
        fi

        # Delete Network ACLs (except default ACLs)
        nacl_ids=$(aws ec2 describe-network-acls --filters "Name=vpc-id,Values=$vpc_id" "Name=default,false" --query 'NetworkAcls[].NetworkAclId' --output text)
        for nacl_id in $nacl_ids; do
            echo "Deleting Network ACL $nacl_id"
            aws ec2 delete-network-acl --network-acl-id "$nacl_id"
        done

        # Disassociate and delete Route Tables
        route_table_ids=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$vpc_id" --query 'RouteTables[].RouteTableId' --output text)
        for route_table_id in $route_table_ids; do
            # Disassociate route table
            association_ids=$(aws ec2 describe-route-tables --route-table-id "$route_table_id" --query 'RouteTables[0].Associations[].RouteTableAssociationId' --output text)
            for association_id in $association_ids; do
                echo "Disassociating route table $route_table_id"
                aws ec2 disassociate-route-table --association-id "$association_id"
            done

            # Delete the route table
            echo "Deleting Route Table $route_table_id"
            aws ec2 delete-route-table --route-table-id "$route_table_id"
        done

        # Revoke and delete Security Groups (except default security groups)
        security_group_ids=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$vpc_id" "Name=group-name,default,false" --query 'SecurityGroups[].GroupId' --output text)
        for security_group_id in $security_group_ids; do
            # Revoke all inbound rules
            aws ec2 revoke-security-group-ingress --group-id "$security_group_id" --protocol all --source-security-group "$security_group_id"

            # Revoke all outbound rules
            aws ec2 revoke-security-group-egress --group-id "$security_group_id" --protocol all --destination-security-group "$security_group_id"

            # Delete the security group
            echo "Deleting Security Group $security_group_id"
            aws ec2 delete-security-group --group-id "$security_group_id"
        done

        # Delete Subnets
        subnet_ids=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc_id" --query 'Subnets[].SubnetId' --output text)
        for subnet_id in $subnet_ids; do
            echo "Deleting Subnet $subnet_id"
            aws ec2 delete-subnet --subnet-id "$subnet_id"
        done

        # Delete the VPC
        echo "Deleting VPC $vpc_id"
        aws ec2 delete-vpc --vpc-id "$vpc_id"
        echo "VPC $vpc_id deleted."

    else
        echo "Skipping deletion of VPC $vpc_id as it has the 'permanent' tag."
    fi
done
