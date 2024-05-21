
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

resource "aws_route" "r" {
  for_each = lookup(lookup(module.subnets_mod,"public",null),"route_table_info",null)
  route_table_id            = each.value["id"]
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id

}



output "name1" {
    value = module.subnets_mod
  
}
# output "vpc_details" {
#     value = aws_vpc.main
  
# }

# output "print_Hello" {
#     value = "hello"
  
# }