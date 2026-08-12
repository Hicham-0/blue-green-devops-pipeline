
# Data sources 
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


#  ECS Execution Role

resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.project}-${var.environment}-ecs-execution-role"


  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.project}-${var.environment}-ecs-execution-role"
    Project     = var.project
    Environment = var.environment
  }
}

# ECR pull + CloudWatch logs
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Role


resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project}-${var.environment}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.project}-${var.environment}-ecs-task-role"
    Project     = var.project
    Environment = var.environment
  }
}

# Politique custom pour le Task Role
resource "aws_iam_role_policy" "ecs_task_role_policy" {
  name = "${var.project}-${var.environment}-ecs-task-policy"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = ["${var.ecs_log_group_arn}:*"]
      }
    ]
  })
}



# CodeBuild Role

resource "aws_iam_role" "codebuild_role" {
  name = "${var.project}-${var.environment}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "codebuild.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.project}-${var.environment}-codebuild-role"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "${var.project}-${var.environment}-codebuild-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # ECR Auth
      {
        Sid      = "ECRAuth"
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      # ECR Push/Pull 
      {
        Sid    = "ECRPush"
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Resource = [var.ecr_repository_arn]
      },
      # CloudWatch Logs 
      {
        Sid    = "CloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = [
          "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.project}-${var.environment}*"
        ]
      },
      # S3 
      {
        Sid    = "S3Artifacts"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:GetObjectVersion"
        ]
        Resource = [
          "${var.pipeline_artifact_bucket_arn}/*"
        ]
      }
    ]
  })
}

# CodePipeline Role 
resource "aws_iam_role" "codepipeline_role" {
  name = "${var.project}-${var.environment}-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "codepipeline.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.project}-${var.environment}-codepipeline-role"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${var.project}-${var.environment}-codepipeline-policy"
  role = aws_iam_role.codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "CodeBuildAccess"
        Effect   = "Allow"
        Action   = ["codebuild:BatchGetBuilds", "codebuild:StartBuild"]
        Resource = [var.codebuild_project_arn]
      },
      {
        # ecs:DescribeTaskDefinition et ecs:RegisterTaskDefinition n'acceptent pas
        # de restriction par ARN — limitation documentée par AWS, Resource = "*" obligatoire
        Sid      = "TaskDefinitionPermissions"
        Effect   = "Allow"
        Action   = ["ecs:DescribeTaskDefinition", "ecs:RegisterTaskDefinition"]
        Resource = ["*"]
      },
      {
        Sid    = "ECSServicePermissions"
        Effect = "Allow"
        Action = ["ecs:DescribeServices", "ecs:UpdateService"]
        Resource = [
          "arn:aws:ecs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:service/${var.ecs_cluster_name}/*"
        ]
      },
      {
        Sid    = "ECSTaskSetPermissions"
        Effect = "Allow"
        Action = ["ecs:CreateTaskSet", "ecs:DeleteTaskSet", "ecs:UpdateServicePrimaryTaskSet"]
        Resource = [
          "arn:aws:ecs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:task-set/${var.ecs_cluster_name}/*"
        ]
      },
      {
        Sid    = "ECSTagResource"
        Effect = "Allow"
        Action = ["ecs:TagResource"]
        Resource = [
          "arn:aws:ecs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:task-definition/${var.ecs_task_family}:*"
        ]
        Condition = {
          StringEquals = { "ecs:CreateAction" = ["RegisterTaskDefinition"] }
        }
      },
      {
        Sid      = "IamPassRolePermissions"
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = [aws_iam_role.ecs_execution_role.arn, aws_iam_role.ecs_task_role.arn]
        Condition = {
          StringEquals = { "iam:PassedToService" = ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"] }
        }
      },
      {
        Sid      = "S3Artifacts"
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:GetObjectVersion", "s3:GetBucketVersioning"]
        Resource = [var.pipeline_artifact_bucket_arn, "${var.pipeline_artifact_bucket_arn}/*"]
      },
      {
        Sid      = "CodeStarConnection"
        Effect   = "Allow"
        Action   = ["codestar-connections:UseConnection"]
        Resource = [var.codestar_connection_arn]
      },
      {
        Sid      = "ELBWeightedRouting"
        Effect   = "Allow"
        Action   = ["elasticloadbalancing:ModifyListener", "elasticloadbalancing:ModifyRule"]
        Resource = [var.alb_listener_arn, var.alb_listener_rule_arn]
      },
      {
        # Les actions Describe* n'acceptent généralement pas de restriction par ARN
        Sid      = "ELBDescribe"
        Effect   = "Allow"
        Action   = ["elasticloadbalancing:DescribeListeners", "elasticloadbalancing:DescribeRules", "elasticloadbalancing:DescribeTargetGroups"]
        Resource = ["*"]
      }
    ]
  })
}

# ECS Blue/Green Infrastructure Role

resource "aws_iam_role" "ecs_bluegreen_role" {
  name = "${var.project}-${var.environment}-ecs-bluegreen-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ecs.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.project}-${var.environment}-ecs-bluegreen-role"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "ecs_bluegreen_role_policy" {
  role       = aws_iam_role.ecs_bluegreen_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECSInfrastructureRolePolicyForLoadBalancers"
}


# SNS Topic Policy

resource "aws_sns_topic_policy" "allow_eventbridge" {
  arn = var.sns_topic_arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowEventBridgePublish"
        Effect    = "Allow"
        Principal = { Service = "events.amazonaws.com" }
        Action    = "SNS:Publish"
        Resource  = var.sns_topic_arn
      }
    ]
  })
}