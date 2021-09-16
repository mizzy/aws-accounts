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

resource "aws_organizations_account" "sock_shop" {
  name      = "sock-shop"
  email     = "miya+aws+sock-shop@mizzy.org"
  parent_id = aws_organizations_organizational_unit.test.id
}
