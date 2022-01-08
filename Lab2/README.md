> NAT (NetworK Address Translation) Gateway

Steps for creating NAT gateway from scratch

- Create VPC
- Create Public Subnet
- Create Private Subnet
- Create IGW and attached to custom VPC
- Create route table (public)
- Associate public subnet to public route
- Create Elastic IP
- Create NAT Gateway and attache Elastic IP
- Create route table (private)
- Add NAT Gateway route to private route table
- Associate private subnet to private route
