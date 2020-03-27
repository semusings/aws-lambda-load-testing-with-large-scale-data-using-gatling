#!/bin/sh

# Before running this, ensure you did the following:
# (1) Insert your AWS IAM secret/access key into the aws.properties file in the current directory.
# (2) Execute the downloadGatling.sh script if you have not already done this.

# Start the load test on a single EC2 instance.
#mvn -Dgatling.skip=true clean package com.ea.gatling:gatling-aws-maven-plugin:execute

#
# Same as above but runs test on 3x m3.large EC2 instances instead of just one less powerful instance.
# Keep in mind that this will result in higher EC2 costs (see https://aws.amazon.com/ec2/pricing/).
#

S3_BUCKET=load-testing-s3-bucket
EC2_KEY_PAIR=loadtest-keypair
NO_OF_INSTANCES=20
EC2_ENDPOINT=https://ec2.us-west-1.amazonaws.com
EC2_SECURITY_GROUP_ID=sg-xxxxxxx
AMI_ID=ami-0782017a917e973e7
SSH_USER=ec2-user

mvn package -Pload-testing -Dgatling.skip=true \
    -Dec2.ami.id=${AMI_ID} \
    -Dec2.instance.type=m3.large \
    -Dec2.instance.count=${NO_OF_INSTANCES} \
    -Dec2.security.group.id=${EC2_SECURITY_GROUP_ID} \
    -Dec2.end.point=${EC2_ENDPOINT} \
    -Dssh.user=${SSH_USER} \
    -Dssh.private.key=${HOME}/.ssh/${EC2_KEY_PAIR}.pem \
    -Dec2.key.pair.name=${EC2_KEY_PAIR} \
    -Ds3.upload.enabled=true \
    -Ds3.bucket=${S3_BUCKET} \
    -Ds3.subfolder=loadtest \
    com.ea.gatling:gatling-aws-maven-plugin:execute
