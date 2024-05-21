
resource "aws_vpc" "main" {
  cidr_block = var.cidr
}


module "subnets_mod" {
    source = "./local"
    for_each = var.subnets
    vpc_id = aws_vpc.main.id
    subnets_list = each.value
 
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}


# output "subetus_info" {
#   value = module.subnets_mod
  
# }

resource "aws_route" "igw" {
  for_each = lookup(lookup(module.subnets_mod,"public",null),"route_table_info",null)
  route_table_id            = each.value["id"]
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id

}


resource "aws_eip" "ngw" {
  count = length(local.public_subnet_ids)
  domain   = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  count = length(local.public_subnet_ids)
  
  allocation_id = element(aws_eip.ngw.*.id,count.index)
  subnet_id     = element(local.public_subnet_ids,count.index)
}

resource "aws_route" "ngw" {
  count = length(local.private_rt_ids)
  route_table_id            = element(local.private_rt_ids,count.index)
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = element(aws_nat_gateway.ngw.*.id,count.index)
}



resource "aws_vpc_peering_connection" "peering" {
  peer_vpc_id   = aws_vpc.main.id
  vpc_id        = var.default_vpc_id
  auto_accept   = true
}

resource "aws_route" "peer" {
  count = length(local.private_rt_ids)
  route_table_id            = element(local.private_rt_ids,count.index)
  destination_cidr_block    = var.default_vpc_cidr
  gateway_id = aws_vpc_peering_connection.peering.id
}


resource "aws_route" "default" {
  route_table_id            = var.default_vpc_rt
  destination_cidr_block    = aws_vpc.main.cidr_block
  gateway_id = aws_vpc_peering_connection.peering.id
}





# output "nat_gateway_info1" {
#   value = element(element(aws_nat_gateway.ngw,count.index),
  
# }


# output "name1" {
#     value = module.subnets_mod
  
# }
# output "vpc_details" {
#     value = aws_vpc.main
  
# }

# output "print_Hello" {
#     value = "hello"
  
# }