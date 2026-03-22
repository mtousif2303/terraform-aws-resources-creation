provider "aws" {
    region = "us-east-1" 
    access_key = ""  
    secret_key = ""

}

resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-02dfbd4ff395f2a1b" 
  instance_type = "t2.nano" 

  tags = {
    Name = "MyEC2Instance"
  }
}