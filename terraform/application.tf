#Security Group
resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.VPC.id
#Inbound
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["84.71.241.121/32"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["84.71.241.121/32"]
  }
#Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web"
  }
}
#Hosting server
resource "aws_instance" "webserver" {
  ami = "ami-0e80a462ede03e653"
  instance_type = "t2.micro"
  key_name = "LAB-101-KP"
  subnet_id = aws_subnet.subnet.id
  vpc_security_group_ids = [ aws_security_group.web.id ]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y httpd httpd-tools mod_ssl 
              sudo systemctl enable httpd
              echo "<html><br></br><br></br><h1><img src="https://logos-download.com/wp-content/uploads/2019/07/Checkout.com_Logo.png" width="400" hieght="400"><style> p.detail { color:Blue;font-weight:bold;font-family:"Arial Nova";font-size:50 } </style><p class="detail"> This page is hosted for technical test </p></h1></html>" > /var/www/html/index.html
              sudo systemctl start httpd
              EOF

      tags = {
        "Name" = "LDN-WEB-01"
      }
  }