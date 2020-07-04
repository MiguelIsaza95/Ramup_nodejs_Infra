resource "aws_iam_policy" "s3_policy" {
  name = "state_store_s3"
  path = "terraform/s3/terraform.tfstate"
  description = "Policy for s3 backend storing"

  policy = << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "${aws_s3_bucket.mai_backend.arn}"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "${aws_s3_bucket.mai_backend.arn}/terraform/mai/terraform.tfstate"
    }
  ]
}
  EOF
}