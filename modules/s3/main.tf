resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name
  tags = {
    Name = "trio-s3-bucket"
  }
}
