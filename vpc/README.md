#  VPC
[Terraform_vpc_module](https://github.com/prathapaparna/Terraform/tree/main/terraform-modules-vpc-scratch)
- A VPC is a dedicated virtual network in AWS, allowing us to isolate our resources from other virtual networks within the same AWS account. We can specify an IP range for the VPC, and within it, create subnets (a subnet is an IP range within the VPC), gateways, and security groups.

## Key Components of a VPC

**Subnets:**
- A subnet is a range of IP addresses in your VPC. You can divide your VPC into multiple subnets in different Availability Zones (AZs).
- **Public Subnet:** A subnet that is associated with an Internet Gateway (IGW), allowing instances in this subnet to connect to the internet.
- **Private Subnet:** A subnet without direct internet access. Instances in private subnets typically communicate with the internet via a NAT Gateway or NAT Instance.

**Route Tables:**
- A route table contains rules (routes) that determine where network traffic is directed. Each subnet must be associated with a route table.

**Internet Gateway (IGW):**
- An IGW is a gateway that allows communication between instances in your VPC and the internet. If you want instances in a subnet to be publicly accessible, the subnet needs an IGW.

**NAT Gateway:**
- A NAT (Network Address Translation) Gateway allows instances in a private subnet to access the internet (for software updates, for example) without exposing them to inbound connections from the internet.

**Security Groups and NACLs:**
- Security Groups are virtual firewalls that control inbound and outbound traffic to instances.
- Network Access Control Lists (NACLs) are optional, stateless firewalls for controlling traffic at the subnet level.

**VPC Peering:**
- VPC Peering allows you to connect two VPCs (in the same or different AWS regions) to enable communication between resources in different VPCs.

**VPN and Direct Connect:**
- A Virtual Private Network (VPN) or AWS Direct Connect can be used to securely connect your VPC to your on-premises network.
  
## Vpc connections
- Instances within the same VPC can communicate using their private IPs without the need for an internet gateway or NAT gateway. This can be achieved by properly configuring the security groups.
- By using a **VPC endpoint**, we can securely connect vpc to AWS services and other services without using the internet or a NAT gateway. This ensures that traffic between your VPC and the service stays entirely within the AWS network, improving security and reducing costs.
     - there are 2 types of vpc endpoints
        - **Gateway Endpoints** are used for S3 and DynamoDB, adding entries in the VPC’s route table.
        - **Interface Endpoints** are used for many other services, creating ENIs in subnets for private connectivity.
