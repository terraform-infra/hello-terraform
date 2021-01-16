provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_s3_bucket" "tf_bucket" {
  count = local.count
  bucket = data.aws_caller_identity.current.account_id + uuid()
}