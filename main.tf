
resource "aws_vpc" "main" {
  cidr_block = var.cidr
}


module "subnets_mod" {
    source = "./local"
    for_each = var.subnets
    vpc_id = aws_vpc.main.id
    subnets_list = each.value
 
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