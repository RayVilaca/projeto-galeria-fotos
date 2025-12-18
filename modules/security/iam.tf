resource "aws_iam_role" "ec2_role" {
  name               = "galeria-server-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_role_assume_policy.json

  inline_policy {
    name = "ec2_service_role"
    policy = templatefile("${path.module}/policies/ec2_service_role.json", {
      galeria_bucket_name = var.buckets["galeria-fotos-womakerscode"].bucket
    })
  }
}

data "aws_iam_policy_document" "ec2_role_assume_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}
