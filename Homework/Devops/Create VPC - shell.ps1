#Shell

# Set your AWS region
$AWS_REGION = "us-east-1"

# Create VPC
Write-Host "Creating VPC..."
$vpc = New-EC2Vpc -CidrBlock "10.0.0.0/16" -Region $AWS_REGION
$vpc_id = $vpc.VpcId

# Create Internet Gateway
Write-Host "Creating Internet Gateway..."
$igw = New-EC2InternetGateway -Region $AWS_REGION
$igw_id = $igw.InternetGatewayId

# Attach Internet Gateway to VPC
Write-Host "Attaching Internet Gateway to VPC..."
Register-EC2InternetGateway -InternetGatewayId $igw_id -VpcId $vpc_id -Region $AWS_REGION

# Create Subnet
Write-Host "Creating Subnet..."
$subnet = New-EC2Subnet -VpcId $vpc_id -CidrBlock "10.0.0.0/24" -Region $AWS_REGION
$subnet_id = $subnet.SubnetId

# Create Route Table
Write-Host "Creating Route Table..."
$route_table = New-EC2RouteTable -VpcId $vpc_id -Region $AWS_REGION
$route_table_id = $route_table.RouteTableId

# Associate Route Table with Subnet
Write-Host "Associating Route Table with Subnet..."
Register-EC2RouteTable -RouteTableId $route_table_id -SubnetId $subnet_id -Region $AWS_REGION

# Create Route to the Internet through Internet Gateway
Write-Host "Creating Route to the Internet through Internet Gateway..."
New-EC2Route -RouteTableId $route_table_id -DestinationCidrBlock "0.0.0.0/0" -GatewayId $igw_id -Region $AWS_REGION

# Launch EC2 instance
Write-Host "Launching EC2 instance..."
$ec2_instance = New-EC2Instance -ImageId "ami-0e35da80743b7a307" -InstanceType "t2.micro" -KeyName "narek-key-1" -SubnetId $subnet_id -Region $AWS_REGION

Write-Host "Script execution completed!"
