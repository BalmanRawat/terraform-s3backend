![terraform](https://user-images.githubusercontent.com/8892649/189290223-e9320325-213d-4228-8573-19b8a8088f02.png)

Hashicorp terraform supports multiple backends out of which S3 is one of the them. If you are an AWS customer and looking forward to stay within AWS boundary then `s3 backend` is the right choice for you. Find more [details](https://www.terraform.io/language/settings/backends/configuration)

## S3 Backend
S3Backend supports
 - `State storage` with s3 bucket
 - `History of state files` with s3 bucket versioning (recommended)
 - `State locking` with Dynamodb table(recommended)

### Setting Up Backend Infra
We just need to create a S3 bucket and a dynamodb table with the configuration defined by the [s3backend](https://www.terraform.io/language/settings/backends/s3). You can create the resources by using the below commands or manually following the steps defined below:

```shell
    git clone git@github.com:BalmanRawat/terraform-s3backend.git
    cd terraform-s3backend
    make init
    ## update the variables.tf file if necessary
    make apply
``` 

**S3 Bucket Requirements**
- Any existing bucket or new one
- Versioning enabled (recommended)
- Encryption enabled (recommended)
- IAM Policy required by terraform to make S3 bucket API calls

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::backend-bucket"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
      "Resource": "arn:aws:s3:::backend-bucket/path/to/my/key"
    }
  ]
}
```

**DynamoDB Table Requirements**
> DynamoDB table is optional but terraform will not be able to lock the state file.

- The table must have a partition key named `LockID` with type of String
- IAM Policy required by terraform to make DynamoDB API calls

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "arn:aws:dynamodb:*:*:table/backend-table"
    }
  ]
}
```

### Using the backend
To make use of the backend we need to configure `backend` in the terraform settings.

Example configuration. Find all the possible configuration [here](https://www.terraform.io/language/settings/backends/s3#s3-state-storage) 
```
terraform {
 backend "s3" {
    bucket = "<bucket-name>"
    key = "<bucket-key-for-terraform-state-file"
    region = "<aws-region>"
    dynamodb_table = "<dynamodb-table>"
  }
}
```

**OR**

make use of the examples in the repository.
```shell
    git clone git@github.com:BalmanRawat/terraform-s3backend.git
    cd terraform-s3backend/examples
    make init
    ## replace the bucket-name, key, region, dynamodb_table with your bucket
    make apply
```

Once we apply the change we should be able to see similar changes in the bucket and table as shown below:

![bucket](https://user-images.githubusercontent.com/8892649/189290617-53df9486-e159-431b-9a4d-e5e8fd0e0e8b.png)

![table](https://user-images.githubusercontent.com/8892649/189290724-9ccf8519-3df3-494e-9051-e6e519fc1ee8.png)

All done. Remember to run `terraform destory` once you are done with the experiment.

-> until next time.
