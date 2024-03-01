locals {
  is_universal = data.aws_caller_identity.current.account_id == "367193793898"
}
