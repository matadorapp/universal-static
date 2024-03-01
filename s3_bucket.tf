locals {
  bucket_name = local.is_universal ? "mtdr-universal" : module.s3_bucket[0].bucket_id
}

# tfsec:ignore:aws-s3-block-public-acls This bucket is public on purpose
# tfsec:ignore:aws-s3-block-public-policy This bucket is public on purpose
# tfsec:ignore:aws-s3-enable-bucket-logging  This bucket has frequent access via cloudfront, avoiding for cost
# tfsec:ignore:aws-s3-no-public-buckets This bucket is public on purpose
# tfsec:ignore:aws-s3-ignore-public-acls This bucket is public on purpose
# tfsec:ignore:aws-s3-ignore-public-acls This bucket is public on purpose
module "s3_bucket" {
  count                   = local.is_universal ? 0 : 1
  source                  = "prod-terraform-registry.323970663242.hellopublic.com/matadorapp/s3/aws"
  version                 = "2.0.1"
  bucket_name_prefix      = "universal-static"
  block_public_acls       = false
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = false
  object_ownership        = "BucketOwnerPreferred"
  logging_enabled         = false
  logging_bucket          = "" # This is via cloudfront so we don't need access logging
  tags = {
    Cost = "universal-static"
  }
}

resource "aws_s3_bucket_acl" "s3_bucket" {
  count  = local.is_universal ? 0 : 1
  bucket = local.bucket_name
  acl    = "public-read"
}
