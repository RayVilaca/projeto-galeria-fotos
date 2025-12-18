locals {
  buckets_to_create = toset(
    [
      "galeria-fotos-womakerscode"
    ]
  )
}

resource "aws_s3_bucket" "buckets" {
  for_each = local.buckets_to_create
  bucket   = each.key

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_account_public_access_block" "buckets" {
  for_each = local.buckets_to_create

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "upload_static_images" {
  for_each = fileset("${path.module}/static/", "*")
  bucket   = aws_s3_bucket.buckets["galeria-fotos-womakerscode"].id
  key      = each.value
  source   = "${path.module}/static/${each.value}"
  etag     = filemd5("${path.module}/static/${each.value}")
}
