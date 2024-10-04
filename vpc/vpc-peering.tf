provider "aws" {
  region = "us-west-2"
}

# Create the first VPC (Requester)
resource "aws_vpc" "vpc_requester" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Requester VPC"
  }
}

# Create the second VPC (Accepter)
resource "aws_vpc" "vpc_accepter" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "Accepter VPC"
  }
}

# Create the VPC peering connection from Requester to Accepter
resource "aws_vpc_peering_connection" "peer" {
  vpc_id        = aws_vpc.vpc_requester.id  # Requester VPC ID
  peer_vpc_id   = aws_vpc.vpc_accepter.id   # Accepter VPC ID
  peer_owner_id = data.aws_caller_identity.current.account_id  # Same account, so use current account ID

  tags = {
    Name = "VPC Peering Connection"
  }
}

# Accept the VPC peering request (needed even if it's in the same account)
resource "aws_vpc_peering_connection_accepter" "accepter" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true  # Automatically accept the peering connection

  tags = {
    Name = "Accepter for VPC Peering"
  }
}

# Create a route in the Requester VPC to route traffic to the Accepter VPC
resource "aws_route" "requester_route_to_accepter" {
  route_table_id         = aws_vpc.vpc_requester.main_route_table_id  # Requester's route table
  destination_cidr_block = aws_vpc.vpc_accepter.cidr_block  # Route traffic to the Accepter VPC CIDR
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

# Create a route in the Accepter VPC to route traffic to the Requester VPC
resource "aws_route" "accepter_route_to_requester" {
  route_table_id         = aws_vpc.vpc_accepter.main_route_table_id  # Accepter's route table
  destination_cidr_block = aws_vpc.vpc_requester.cidr_block  # Route traffic to the Requester VPC CIDR
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

data "aws_caller_identity" "current" {}

# Cross-Region Peering: If the VPCs are in different regions, add the peer_region argument in the aws_vpc_peering_connection resource.
# Cross-Account Peering: If the VPCs are in different AWS accounts, replace peer_owner_id with the account ID of the accepter VPC's owner.    
