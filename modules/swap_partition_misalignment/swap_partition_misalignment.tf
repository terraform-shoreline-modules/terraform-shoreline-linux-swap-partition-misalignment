resource "shoreline_notebook" "swap_partition_misalignment" {
  name       = "swap_partition_misalignment"
  data       = file("${path.module}/data/swap_partition_misalignment.json")
  depends_on = [shoreline_action.invoke_update_partition_table,shoreline_action.invoke_increase_swap_partition_size]
}

resource "shoreline_file" "update_partition_table" {
  name             = "update_partition_table"
  input_file       = "${path.module}/data/update_partition_table.sh"
  md5              = filemd5("${path.module}/data/update_partition_table.sh")
  description      = "Realigning swap partitions manually: This can be done by calculating the correct offset value for the swap partition and then using a tool like "
  destination_path = "/tmp/update_partition_table.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "increase_swap_partition_size" {
  name             = "increase_swap_partition_size"
  input_file       = "${path.module}/data/increase_swap_partition_size.sh"
  md5              = filemd5("${path.module}/data/increase_swap_partition_size.sh")
  description      = "Increasing swap partition size: If the misalignment issue is caused by running out of space on the swap partition, simply increasing"
  destination_path = "/tmp/increase_swap_partition_size.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_partition_table" {
  name        = "invoke_update_partition_table"
  description = "Realigning swap partitions manually: This can be done by calculating the correct offset value for the swap partition and then using a tool like "
  command     = "`chmod +x /tmp/update_partition_table.sh && /tmp/update_partition_table.sh`"
  params      = ["SECTOR_SIZE","SWAP_START_SECTOR","PARTITION_DEVICE","SWAP_PARTITION_NUMBER"]
  file_deps   = ["update_partition_table"]
  enabled     = true
  depends_on  = [shoreline_file.update_partition_table]
}

resource "shoreline_action" "invoke_increase_swap_partition_size" {
  name        = "invoke_increase_swap_partition_size"
  description = "Increasing swap partition size: If the misalignment issue is caused by running out of space on the swap partition, simply increasing"
  command     = "`chmod +x /tmp/increase_swap_partition_size.sh && /tmp/increase_swap_partition_size.sh`"
  params      = ["SWAP_PARTITION","NEW_SIZE_IN_MB"]
  file_deps   = ["increase_swap_partition_size"]
  enabled     = true
  depends_on  = [shoreline_file.increase_swap_partition_size]
}

