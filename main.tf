resource "random_pet" "s3_bucket_name" {
  prefix = var.s3_bucket_name_prefix
  length = 4
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = random_pet.s3_bucket_name.id

  force_destroy = true
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}



resource "aws_s3_object" "s3_object" {
  bucket = aws_s3_bucket.s3_bucket.id

  key    = "test.txt"
  source = "test.txt"
}


resource "aws_s3_object" "s3_object_doc" {
  bucket = aws_s3_bucket.s3_bucket.id

  key    = "10-MB-Test.docx"
  source = "10-MB-Test.docx"
}

resource "aws_s3_object" "s3_object_xls" {
  bucket = aws_s3_bucket.s3_bucket.id

  key    = "10-MB-Test.xlsx"
  source = "test.xlsx"
}
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_sse" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      #kms_master_key_id = aws_kms_key.mykey.arn
      #sse_algorithm     = "aws:kms"
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_policy" "bucket_policy" {
    bucket = aws_s3_bucket.s3_bucket.id
    policy = jsonencode({
        Version = "2012-10-17"
        Id      = "JDEVS-S3-BUCKET-POLICY"
        Statement = [
            {
                Sid       = "EnforceTls"
                Effect    = "Deny"
                Principal = "*"
                Action    = "s3:*"
                Resource = [
                    "${aws_s3_bucket.s3_bucket.arn}/*",
                    "${aws_s3_bucket.s3_bucket.arn}",
                ]
                Condition = {
                    Bool = {
                        "aws:SecureTransport" = "false"
                    }
                }
            },
            {
                Sid       = "EnforceProtoVer"
                Effect    = "Deny"
                Principal = "*"
                Action    = "s3:*"
                Resource = [
                    "${aws_s3_bucket.s3_bucket.arn}/*",
                    "${aws_s3_bucket.s3_bucket.arn}",
                ]
                Condition = {
                    NumericLessThan = {
                        "s3:TlsVersion": 1.2
                    }
                }
            }
        ]
    })
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls   = true
  block_public_policy = true
}
