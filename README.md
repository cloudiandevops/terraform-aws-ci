# terraform-aws-ci


### Count for aws_s3_bucket ###

###   count = length(data.aws_s3_bucket.existing_bucket.id) == 0 ? 1 : 0  ###

Conditional Creation (count):
The count determines whether the S3 bucket is created. It checks if the existing_bucket data source has a bucket ID:

length(data.aws_s3_bucket.existing_bucket.id) == 0 ? 1 : 0
If the bucket does not exist (length == 0), the count is 1 (create the bucket).
If it exists, the count is 0 (do not create the bucket).

Instead of checking for an empty tuple using id != "", we now check whether the bucket exists by using the length function. If the bucket does not exist, count will be 1 (create the bucket); if it exists, count will be 0 (do not create the bucket).

Count for aws_s3_bucket_versioning:

We use length(aws_s3_bucket.terraform_state) to check if the bucket exists. If the bucket was created (count = 1), versioning will be enabled. Otherwise, it will not run.
How it works:
If the bucket does not exist, aws_s3_bucket will be created, and versioning will be enabled.
If the bucket already exists, aws_s3_bucket will not be created, and versioning will not be applied.

### VPC, Subnets, RTW and SG creation ###

cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)

* This line is used to dynamically generate the CIDR block for the subnet.
* cidrsubnet is a function that creates subnets from a given CIDR block:
    aws_vpc.main.cidr_block: The CIDR block of the VPC (e.g., 10.0.0.0/16).
    8: This specifies how much to divide the original CIDR block by. The number 8 indicates you are creating subnets with a size of /24 (since /16 → /24).
* count.index: The count.index value refers to the index of the current iteration (0 or 1 in this  
  case, because count = 2). This ensures each subnet gets a unique CIDR block. For example, the first subnet might get 10.0.0.0/24, and the second subnet would get 10.0.1.0/24.

### GITHUB Actions  ###
If the workflow is triggered by a push to the main branch, github.ref will be refs/heads/main.

- name: Terraform Apply
  if: github.ref == 'refs/heads/main'
  working-directory: ${{ env.TF_WORKING_DIR }}
  run: terraform apply -auto-approve tfplan
