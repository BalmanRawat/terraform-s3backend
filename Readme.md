![terraform.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1662695634078/raKONz7EO.png align="left")

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

![bucket-image](https://cdn.hashnode.com/res/hashnode/image/upload/v1662704686740/OTL9fZSi8.png align="left")

![dynamodb-table](https://cdn.hashnode.com/res/hashnode/image/upload/v1662704824331/07u2t1Fph.png align="left")

All done. Remember to run `terraform destory` once you are done with the experiment.

-> until next time.
