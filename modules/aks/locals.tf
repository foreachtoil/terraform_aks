# foreachtoil
# for_each_toil --> for-each-toil

locals {
  new_name = replace(var.app_name, "_" , "-") # for_each_toil --> for-each-toil
}