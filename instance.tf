resource "aws_instance" "test-1" {
  ami = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"
  key_name = "Testkey"
#  provisioner "local-exec" {
#  command = "aws ec2 stop-instances --instance-ids i-0bced2b87171e4489"
#  }
  tags = {
    "Name" = "Test-1"
  }
}

resource "aws_instance" "test-2" {
  ami = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"
  key_name = "Testkey"
    tags = {
    "Name" = "Test-2"
  }
}

resource "aws_instance" "test-3" {
  ami = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"
  key_name = "Testkey"

    tags = {
    "Name" = "Test-3"
  }
}
