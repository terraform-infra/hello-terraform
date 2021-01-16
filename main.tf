# terraform block is optional but it's a best practice to have it
terraform {
  # required_version is the terraform version which we want to apply
  required_version = ">=0.14.0"
  /*
    backend "s3" {
        # bucket should already exist
        bucket = "my-terraform-backend"
        key = "sagar-terraform-resources"
        region = "ap-northeast-1"
        # dynamo db table also should already exist
        dynamodb_table = "sagar-terraform-lock"
      }
  */

  /*
    backend "remote" {
      hostname = "app.terraform.io"
      organization = "beBit"
      workspace = {
        name = "hello-terraform"
      }
    }
  */

}

# Which cloud provider you want to use
provider "aws" {
  # region is required
  region = "ap-northeast-1"

  # Since I am putting this file in GitHub I do not EVER put my AWS credentials here.
  # Instead I use the environment variable or terraform cloud or the ~/.aws/credentials file
  #access_keys = "my-access-key"
  #access_secret = "my-secret-key"
}

/*

# Resource
resource "aws_s3_bucket" "terraform-bucket-2021" {
  bucket = "terraform-bucket-2021"
}

# Data
data "aws_availability_zones" "available" {
  state = "available"
}

# Outputs
output "bucket_info" {
  value = aws_s3_bucket.terraform-bucket-2021
}

output "aws_availability_zones" {
  value = data.aws_availability_zones.available
}

# Interpolation
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "bucket2" {
  bucket = "${data.aws_caller_identity.current.account_id}-bucket2"
}

# ======= Dependencies =========

resource "aws_s3_bucket" "bucket3" {
  bucket = "${data.aws_caller_identity.current.account_id}-bucket3"
  # Implicit dependency
  tags = {
    dependency = aws_s3_bucket.bucket2.arn
  }
}

resource "aws_s3_bucket" "bucket4" {
  bucket = "${data.aws_caller_identity.current.account_id}-bucket4"
  # Explicit
  depends_on = [
    aws_s3_bucket.bucket3
  ]
}

# ====== Variables =========
variable "bucket_name" {
  type = string

  # `default` is optional. If default is omitted, then value must be supplied
  # default = "My_Bucket1234"
}

resource "aws_s3_bucket" "bucket5" {
  bucket = var.bucket_name
}

# ======= Locals =========
locals {
  aws_account = "${data.aws_caller_identity.current.account_id}-${lower(data.aws_caller_identity.current.user_id)}"
}

resource "aws_s3_bucket" "bucket6" {
  bucket = "${local.aws_account}-bucket6"
}

# ====== Count ========
resource "aws_s3_bucket" "bucketX" {
  count  = 2
  bucket = "${local.aws_account}-bucket${count.index + 7}"
}


# ========= For each =========
locals {
  buckets = {
    bucket101 = "mybucket101"
    bucket102 = "mybucket102"
  }
}

resource "aws_s3_bucket" "bucketIterator" {
  for_each = local.buckets
  bucket   = "${local.aws_account}-${each.value}"
}

# === local can be list as well
locals {
  buckets = [
    "mybucket101",
    "mybucket102"
  ]
}

resource "aws_s3_bucket" "bucketIterator" {
  for_each = toset(local.buckets)
  bucket   = "${local.aws_account}-${each.key}"
}

output "bucketIterator" {
  value = aws_s3_bucket.bucketIterator
}


# ===== data types =====
locals {
  a_string  = "This is a String"
  a_number  = 3.1415
  a_boolean = true
  a_list = [
    "element1",
    true,
    [1, 2, 3]
  ]
  a_map = {
    key       = "value"
    nums      = [10, 20, 30]
    is_active = true
    configs = {
      instance_type = "t2.micro"
      vpc_enabled   = true
    }
  }

  # Operators
  operators = (3 + 3) - (3 * 3 / 3)

  # Logical
  t = true && true
  f = true || false

  # Comparison
  gt  = 3 > 2
  lt  = 4 < 9
  eq  = 4 == 4
  neq = 4 != 5
}

variable "bucket_count" {
  type = number
}

// data "aws_caller_identity" "current" {}

locals {
  min_bucket_count = 5
  num_buckets      = var.bucket_count > 5 ? local.min_bucket_count : var.bucket_count
  aws_account      = "${data.aws_caller_identity.current.account_id}-${lower(data.aws_caller_identity.current.user_id)}"
}

resource "aws_s3_bucket" "buckets" {
  count  = local.num_buckets
  bucket = "${local.aws_account}-buckets${count.index + 7}"
}

# ==== Functions ====

locals {
  ts            = timestamp()
  current_month = formatdate("MMMM", local.ts)
  tomorrow      = formatdate("MMMM", timeadd(local.ts, "24h"))
  upper         = upper("lowercase")
  lower         = lower("UPPERCASE")
}

output "func" {
  value = "${local.ts} ${local.current_month} ${local.tomorrow} ${local.upper} ${local.lower}"
}


# Iterations
locals {
  my_list    = ["one", "two", "three"]
  upper_list = [for item in local.my_list : upper(item)]
  upper_map  = { for item in local.my_list : item => upper(item) }

  # Filtering
  n     = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  evens = [for i in local.n : i if i % 2 == 0]
}

output "my_list" {
  value = local.my_list
}
output "upper_list" {
  value = local.upper_list
}

output "upper_map" {
  value = local.upper_map
}

output "evens" {
  value = local.evens
}

locals {
  count = 0
  nums  = [1, 2, 3]
}
output "heredocs" {
  # EOT means EOF
  value = <<-EOT
    This is the `heredoc`.
    This is multiline String.
    Used for writing documentations.
  EOT
  # Dont forget EOT at the end
}

output "directive" {
  value = <<-EOT
    We can use directive in heredoc.
    %{if local.count == 0}
    The count is 0, destroying everything...
    %{else}
    The count is ${local.count}
    %{endif}
  EOT
}

output "iterated-directive" {
  value = <<-EOT
    Directive can also be iterated.
    %{for num in local.nums}
    ${num}
    %{endfor}
  EOT
}

*/