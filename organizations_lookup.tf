data "aws_organizations_organization" "org" {
  provider = aws.root
}

data "aws_organizations_organizational_unit" "dev" {
  provider  = aws.root
  parent_id = data.aws_organizations_organization.org.roots[0].id
  name      = "Dev"
}

data "aws_organizations_organizational_unit_child_accounts" "dev_accounts" {
  provider  = aws.root
  parent_id = data.aws_organizations_organizational_unit.dev.id
}

data "aws_organizations_resource_tags" "dev_accounts" {
  provider    = aws.root
  for_each    = toset(data.aws_organizations_organizational_unit_child_accounts.dev_accounts.accounts[*].id)
  resource_id = each.value
}
