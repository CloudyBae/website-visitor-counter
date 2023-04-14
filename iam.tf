resource "aws_iam_role" "cloudresume-lambda" {
    name = "cloudresume_lambda"

    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "sts:AssumeRole"
                ],
                "Principal": {
                    "Service": [
                        "lambda.amazonaws.com"
                    ]
                }
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
   role = aws_iam_role.cloudresume-lambda.name
   policy_arn = aws_iam_policy.dynamodb-lambda-policy.arn
   policy_arn = aws_iam_policy.cloudwatch-lambda-policy.arn
}
          
resource "aws_iam_policy" "dynamodb-lambda-policy" {
   name = "dynamodb-lambda"
   policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": [
                    "dynamodb:*",
                    "dax:*",
                    "application-autoscaling:DeleteScalingPolicy",
                    "application-autoscaling:DeregisterScalableTarget",
                    "application-autoscaling:DescribeScalableTargets",
                    "application-autoscaling:DescribeScalingActivities",
                    "application-autoscaling:DescribeScalingPolicies",
                    "application-autoscaling:PutScalingPolicy",
                    "application-autoscaling:RegisterScalableTarget",
                    "cloudwatch:DeleteAlarms",
                    "cloudwatch:DescribeAlarmHistory",
                    "cloudwatch:DescribeAlarms",
                    "cloudwatch:DescribeAlarmsForMetric",
                    "cloudwatch:GetMetricStatistics",
                    "cloudwatch:ListMetrics",
                    "cloudwatch:PutMetricAlarm",
                    "cloudwatch:GetMetricData",
                    "datapipeline:ActivatePipeline",
                    "datapipeline:CreatePipeline",
                    "datapipeline:DeletePipeline",
                    "datapipeline:DescribeObjects",
                    "datapipeline:DescribePipelines",
                    "datapipeline:GetPipelineDefinition",
                    "datapipeline:ListPipelines",
                    "datapipeline:PutPipelineDefinition",
                    "datapipeline:QueryObjects",
                    "ec2:DescribeVpcs",
                    "ec2:DescribeSubnets",
                    "ec2:DescribeSecurityGroups",
                    "iam:GetRole",
                    "iam:ListRoles",
                    "kms:DescribeKey",
                    "kms:ListAliases",
                    "sns:CreateTopic",
                    "sns:DeleteTopic",
                    "sns:ListSubscriptions",
                    "sns:ListSubscriptionsByTopic",
                    "sns:ListTopics",
                    "sns:Subscribe",
                    "sns:Unsubscribe",
                    "sns:SetTopicAttributes",
                    "lambda:CreateFunction",
                    "lambda:ListFunctions",
                    "lambda:ListEventSourceMappings",
                    "lambda:CreateEventSourceMapping",
                    "lambda:DeleteEventSourceMapping",
                    "lambda:GetFunctionConfiguration",
                    "lambda:DeleteFunction",
                    "resource-groups:ListGroups",
                    "resource-groups:ListGroupResources",
                    "resource-groups:GetGroup",
                    "resource-groups:GetGroupQuery",
                    "resource-groups:DeleteGroup",
                    "resource-groups:CreateGroup",
                    "tag:GetResources",
                    "kinesis:ListStreams",
                    "kinesis:DescribeStream",
                    "kinesis:DescribeStreamSummary"
                ],
                "Effect": "Allow",
                "Resource": "*"
            },
            {
                "Action": "cloudwatch:GetInsightRuleReport",
                "Effect": "Allow",
                "Resource": "arn:aws:cloudwatch:*:*:insight-rule/DynamoDBContributorInsights*"
            },
            {
                "Action": [
                    "iam:PassRole"
                ],
                "Effect": "Allow",
                "Resource": "*",
                "Condition": {
                    "StringLike": {
                        "iam:PassedToService": [
                            "application-autoscaling.amazonaws.com",
                            "application-autoscaling.amazonaws.com.cn",
                            "dax.amazonaws.com"
                        ]
                    }
                }
            },
            {
                "Effect": "Allow",
                "Action": [
                    "iam:CreateServiceLinkedRole"
                ],
                "Resource": "*",
                "Condition": {
                    "StringEquals": {
                        "iam:AWSServiceName": [
                            "replication.dynamodb.amazonaws.com",
                            "dax.amazonaws.com",
                            "dynamodb.application-autoscaling.amazonaws.com",
                            "contributorinsights.dynamodb.amazonaws.com",
                            "kinesisreplication.dynamodb.amazonaws.com"
                        ]
                    }
                }
            }
        ]
    })
}

resource "aws_iam_policy" "cloudwatch-lambda-policy" {
   name = "cloudwatch-lambda"
   policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "autoscaling:Describe*",
                    "cloudwatch:*",
                    "logs:*",
                    "sns:*",
                    "iam:GetPolicy",
                    "iam:GetPolicyVersion",
                    "iam:GetRole",
                    "oam:ListSinks"
                ],
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": "iam:CreateServiceLinkedRole",
                "Resource": "arn:aws:iam::*:role/aws-service-role/events.amazonaws.com/AWSServiceRoleForCloudWatchEvents*",
                "Condition": {
                    "StringLike": {
                        "iam:AWSServiceName": "events.amazonaws.com"
                    }
                }
            },
            {
                "Effect": "Allow",
                "Action": [
                    "oam:ListAttachedLinks"
                ],
                "Resource": "arn:aws:oam:*:*:sink/*"
            }
        ]
    })
}