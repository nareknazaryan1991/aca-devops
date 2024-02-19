1. Make sure to install aws cli on your linux and configure it
$ sudo apt update
$ sudo apt install awscli
$ sudo aws configure

2. Copy the following bash files into your current directory
main.sh
aws_tools.sh

3. Give them permissions for the current user, and make them executable
$ chmod 700 main.sh
$ chmod 700 aws_tools.sh

4. Run bash script to check whether you have vpc and ec2 or no.
$ ./main.sh
