provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "frontend" {
  ami           = "ami-085386e29e44dacd7"
  instance_type = "t2.micro"
  key_name      = "load"

  tags = {
    Name = "c8.local"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y python37
              EOF

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ../ansible/frontend_ip.txt"
  }
}

resource "aws_instance" "backend" {
  ami           = "ami-0f9de6e2d2f067fca"
  instance_type = "t2.micro"
  key_name      = "load"

  tags = {
    Name = "u21.local"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt-get install -y python3.12
              EOF

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ../ansible/backend_ip.txt"
  }
}
