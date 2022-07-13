terraform {
  # Storing the .tfstate inside S3 compatible storage.
  # This is suitable not only for S3 buckets but for on-prem environments exposing S3 compatible APIs: Minio, TrueNAS
  backend "s3" {}
}