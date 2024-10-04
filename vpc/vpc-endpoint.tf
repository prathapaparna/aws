resource "aws_vpc_endpoint" "ec2_interface" {
  vpc_id            = aws_vpc.example.id
  service_name      = "com.amazonaws.us-west-2.ec2"  # Endpoint for EC2
  vpc_endpoint_type = "Interface"  # Interface type endpoint
  subnet_ids        = [aws_subnet.example.id]  # Attach to the subnet
  security_group_ids = [aws_security_group.example.id]

  private_dns_enabled = true  # Use AWS Private DNS for service

  tags = {
    Name = "EC2 Interface Endpoint"
  }
}
###############################################
resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id       = aws_vpc.example.id
  service_name = "com.amazonaws.us-west-2.s3"  # Endpoint for S3
    vpc_endpoint_type = "Gateway" 
  route_table_ids = [aws_route_table.example.id]  # Attach to route table

  tags = {
    Name = "S3 Gateway Endpoint"
  }
}    
    
