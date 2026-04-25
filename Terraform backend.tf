AWS Backend (S3 + DynamoDB locking)
## Create S3 bucket )for state)

aws s3api create-bucket \
  --bucket my-terraform-state-bucket \
  --region us-east-1

## Enable versioning 

aws S3api put-bucket-versioning \
  --bucket my-terraform-state-bucket \
  --versioning-configuration status=Enabled

## Create DynamoDB table (for locking)

aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST

Create backend.tf

terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
