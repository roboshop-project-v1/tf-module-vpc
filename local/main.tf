
resource "aws_subnet" "main" {
  for_each = var.subnets_list
  vpc_id     = var.vpc_id
  cidr_block = each.value["cidr"]
  availability_zone = each.value["az"]
}


resource "aws_route_table" "main" {
  for_each = var.subnets_list
  vpc_id = var.vpc_id

  tags = {
    name = each.key
  }

}

resource "aws_route_table_association" "main" {
  for_each = var.subnets_list
  subnet_id      = lookup(lookup(aws_subnet.main,each.key,null),"id",null)
  route_table_id = lookup(lookup(aws_route_table.main,each.key,null),"id",null)
}

