resource "aws_iam_role" "terraform" {
  name               = "terraform"
  assume_role_policy = data.aws_iam_policy_document.terraform_assume_role_policy.json
}

data "aws_iam_policy_document" "terraform_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        for a in aws_organizations_organization.mizzy_org.accounts :
        "arn:aws:iam::${a.id}:root"
      ]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:PrincipalArn"
      values = flatten([
        for a in aws_organizations_organization.mizzy_org.accounts :
        [
          "arn:aws:iam::${a.id}:role/github-actions",
          "arn:aws:iam::${a.id}:role/aws-reserved/sso.amazonaws.com/us-west-2/AWSReservedSSO_AdministratorAccess_*",
        ]
      ])
    }
  }

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::887552608031:role/tfrefresh"]
    }
  }
}

data "aws_s3_bucket" "terraform_state" {
  bucket = "terraform.mizzy.org"
}

data "aws_iam_policy_document" "terraform_policy" {
  statement {
    effect  = "Allow"
    actions = ["s3:*"] # tfsec:ignore:aws-iam-no-policy-wildcards
    resources = [
      data.aws_s3_bucket.terraform_state.arn,
      "${data.aws_s3_bucket.terraform_state.arn}/*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:PutItem",
      "dynamodb:GetItem",
    ]
    resources = [aws_dynamodb_table.terraform.arn]
  }
}

resource "aws_iam_policy" "terraform_policy" {
  name   = "terraform-policy"
  policy = data.aws_iam_policy_document.terraform_policy.json
}

resource "aws_iam_role_policy_attachment" "terraform" {
  policy_arn = aws_iam_policy.terraform_policy.arn
  role       = aws_iam_role.terraform.name
}
