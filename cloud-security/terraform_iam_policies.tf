# Terraform IAM Policies

# Define an IAM policy for least privilege access
resource "aws_iam_policy" "least_privilege" {
  name        = "least_privilege_policy"
  description = "IAM policy enforcing least privilege access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:ListBucket", "s3:GetObject"],
        Resource = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]
      }
    ]
  })
}

# Define an IAM role for EC2 instance profile
resource "aws_iam_role" "ec2_role" {
  name               = "ec2_instance_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the least privilege policy to the EC2 role
resource "aws_iam_role_policy_attachment" "ec2_role_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.least_privilege.arn
}

# Define IAM policy for administrator access
resource "aws_iam_policy" "admin_access" {
  name        = "admin_access_policy"
  description = "IAM policy for full administrative access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "*",
        Resource = "*"
      }
    ]
  })
}

# Create an IAM group for administrators and attach admin policy
resource "aws_iam_group" "admin_group" {
  name = "administrators"
}

resource "aws_iam_group_policy_attachment" "admin_group_attachment" {
  group      = aws_iam_group.admin_group.name
  policy_arn = aws_iam_policy.admin_access.arn
}
