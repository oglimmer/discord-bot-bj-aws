import json
import boto3
from base64 import b64decode
from datetime import datetime
from logging import info,error

def lambda_handler(event, context):
    ecsClient = boto3.client('ecs')

    response = ecsClient.update_service(
        cluster='cluster-discord-bot',
        service='discord-bot-app',
        desiredCount=1,
        taskDefinition='task-def-discord-bot',
        deploymentConfiguration={
            'maximumPercent': 100,
            'minimumHealthyPercent': 0
        },
        networkConfiguration={
            'awsvpcConfiguration': {
                'subnets': ${jsonencode(privateSubnetIds)},
                'securityGroups': [
                    "${securityGroup}"
                ],
                'assignPublicIp': 'DISABLED'
            }
        },
        forceNewDeployment=True
    )
    info(f'Successfully updated ECS')
