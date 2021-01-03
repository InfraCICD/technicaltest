#VPC
resource "aws_vpc" "VPC" {
    cidr_block = "10.200.200.0/22"
    instance_tenancy = "default"

    tags = {
      "Name" = "LDN-VPC-01"
    }
}
#Internet Gateway
resource "aws_internet_gateway" "Internet_Gateway" {
    vpc_id = aws_vpc.VPC.id

    tags = {
      "Name" = "LDN-GW"
    }
  
}  

#Routing table
resource "aws_default_route_table" "route" {
  default_route_table_id = aws_vpc.VPC.default_route_table_id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.Internet_Gateway.id
    }

    tags = {
      "Name" = "default table"
    }
}
#Subnet
resource "aws_subnet" "subnet" {
   vpc_id = aws_vpc.VPC.id
   cidr_block = "10.200.201.0/24"
   map_public_ip_on_launch = true

   tags = {
     "Name" = "LDN-Public"
   }
}
#Route table association
resource "aws_route_table_association" "route-table-assoc" {
  subnet_id = aws_subnet.subnet.id
  route_table_id = aws_default_route_table.route.id
}