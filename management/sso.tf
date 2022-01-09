data "aws_ssoadmin_instances" "mizzy_org" {
  provider = aws.oregon
}

resource "aws_ssoadmin_permission_set" "administrator_access" {
  provider         = aws.oregon
  name             = "AdministratorAccess"
  instance_arn     = tolist(data.aws_ssoadmin_instances.mizzy_org.arns)[0]
  session_duration = "PT6H"
}

resource "aws_ssoadmin_managed_policy_attachment" "main" {
  provider           = aws.oregon
  instance_arn       = tolist(data.aws_ssoadmin_instances.mizzy_org.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.administrator_access.arn
}

data "aws_identitystore_group" "administrators" {
  provider          = aws.oregon
  identity_store_id = tolist(data.aws_ssoadmin_instances.mizzy_org.identity_store_ids)[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "Administrators"
  }
}

resource "aws_ssoadmin_account_assignment" "administrators" {
  provider = aws.oregon
  for_each = toset([for a in aws_organizations_organization.mizzy_org.accounts: a.id])

  instance_arn       = tolist(data.aws_ssoadmin_instances.mizzy_org.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.administrator_access.arn

  principal_id   = data.aws_identitystore_group.administrators.id
  principal_type = "GROUP"

  target_id   = each.value
  target_type = "AWS_ACCOUNT"
}
