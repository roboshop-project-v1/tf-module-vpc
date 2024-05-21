locals {
  
  public_subnet_ids = [for k,v in lookup(lookup(module.subnets_mod,"public",null),"name",null): v.id]
  app_subnet_ids = [for k,v in lookup(lookup(module.subnets_mod,"app",null),"name",null): v.id]
  db_subnet_ids = [for k,v in lookup(lookup(module.subnets_mod,"db",null),"name",null): v.id]
  private_subnet_ids = concat(local.app_subnet_ids,local.db_subnet_ids)
  all_subnet_ids = concat(local.private_subnet_ids,local.public_subnet_ids)

  #RT
  public_rt_ids = [for k,v in lookup(lookup(module.subnets_mod,"public",null),"route_table_info",null): v.id]
  app_rt_ids = [for k,v in lookup(lookup(module.subnets_mod,"app",null),"route_table_info",null): v.id]
  db_rt_ids = [for k,v in lookup(lookup(module.subnets_mod,"db",null),"route_table_info",null): v.id]
  private_rt_ids =  concat(local.app_rt_ids,local.db_rt_ids)
  all_rt_ids = concat(local.private_rt_ids,local.public_rt_ids)
  

}