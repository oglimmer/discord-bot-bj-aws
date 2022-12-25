# AWS setup

## Overview diagram

 ![Overview diagram](overview.jpg)

## Used services

Using: ECS (Fargate), CloudWatch, VPC, SG, Subnets, NAT-Gateway, Elastic IP

## Prerequisites

* Root user or IAM user with proper API permissions
* Setup AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY (e.g. aws configure)

## How to

* Change into terraform and exec `./genesis.sh all` to set up everything

