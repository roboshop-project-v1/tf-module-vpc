
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
  for_each = lookup(lookup(module.subnets_mod,"public",null),"name",null)
  domain   = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  for_each = lookup(lookup(module.subnets_mod,"public",null),"name",null)
  
  allocation_id = lookup(lookup(aws_eip.ngw,each.key,null),"id",null)
  subnet_id     = each.value["id"]
}

resource "aws_route" "ngw" {
  count = length(local.private_rt_ids)
  route_table_id            = element(local.private_rt_ids,count.index)
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = element(aws_nat_gateway.ngw.*.id,count.index)
}

# output "name1" {
#     value = module.subnets_mod
  
# }
# output "vpc_details" {
#     value = aws_vpc.main
  
# }

# output "print_Hello" {
#     value = "hello"
  
# }