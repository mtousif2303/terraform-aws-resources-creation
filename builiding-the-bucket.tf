provider "aws" {
    region = "us-east-1" 
    access_key = ""  
    secret_key = ""

}

resource "aws_s3_bucket" "my_s3_bucket" {
    bucket = "my-bucket-name-ex-22032026" 
    
    tags = {
        Name        = "MyS3Bucket"
        Environment = "Dev"
    }
}