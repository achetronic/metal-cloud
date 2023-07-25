terraform {
  # Storing the .tfstate locally.
  # This is suitable only for testing purposes. Store it on S3 compatible backend for reliability
  backend "local" {}
}