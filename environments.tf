locals {
  all_environments = { environments = concat(local.staging_environments, local.prod_environments, local.dev_environments) }
  dev_environments = [
    for account in data.aws_organizations_organizational_unit_child_accounts.dev_accounts.accounts :
    {
      Name        = title(trimsuffix(data.aws_organizations_resource_tags.dev_accounts[account.id].tags["user_email_address"], "@public.com"))
      urlPostFix  = "${account.id}.hellopublic.com"
      environment = "dev"
    }
  ]
  staging_environments = [
    {
      Name        = "Staging"
      urlPostFix  = "018019535749.hellopublic.com"
      environment = "staging"
    }
  ]
  prod_environments = [
    {
      Name        = "Prod"
      urlPostFix  = "154310543964.hellopublic.com"
      environment = "prod"
    }
  ]
}

resource "aws_s3_object" "environments" {
  bucket       = local.bucket_name
  key          = "environments.json"
  content      = jsonencode(local.all_environments)
  content_type = "application/json"
  acl          = "public-read"
}
