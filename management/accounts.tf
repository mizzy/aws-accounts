resource "aws_organizations_organization" "mizzy_org" {
  aws_service_access_principals = [
    "controltower.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
    "sso.amazonaws.com",
  ]

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
  ]
}

resource "aws_organizations_organizational_unit" "test" {
  name      = "Test"
  parent_id = aws_organizations_organization.mizzy_org.roots[0].id
}

resource "aws_organizations_account" "sock_shop_cloudformation" {
  name      = "sock-shop-cloudformation"
  email     = "miya+aws+sock-shop-cloudformation@mizzy.org"
  parent_id = aws_organizations_organizational_unit.test.id
}

resource "aws_organizations_account" "sock_shop_terraform" {
  name      = "sock-shop-terraform"
  email     = "miya+aws+sock-shop-terraform@mizzy.org"
  parent_id = aws_organizations_organizational_unit.test.id
}

resource "aws_organizations_account" "sock_shop_pulumi" {
  name      = "sock-shop-pulumi"
  email     = "miya+aws+sock-shop-pulumi@mizzy.org"
  parent_id = aws_organizations_organizational_unit.test.id
}

resource "aws_organizations_account" "ecs_sample" {
  name = "ecs-sample"
  email = "miya+ecs-sample@mizzy.org"
  parent_id = aws_organizations_organizational_unit.test.id
}
