resource "google_gkeonprem_bare_metal_node_pool" "gkeonprem_bare_metal_node_pools" {
  for_each = var.gkeonprem_bare_metal_node_pools

  bare_metal_cluster = each.value.bare_metal_cluster
  location           = each.value.location
  name               = each.value.name
  annotations        = each.value.annotations
  deletion_policy    = each.value.deletion_policy
  display_name       = each.value.display_name
  project            = each.value.project

  node_pool_config {
    labels = each.value.node_pool_config.labels
    dynamic "node_configs" {
      for_each = each.value.node_pool_config.node_configs
      content {
        labels  = node_configs.value.labels
        node_ip = node_configs.value.node_ip
      }
    }
    operating_system = each.value.node_pool_config.operating_system
    dynamic "taints" {
      for_each = each.value.node_pool_config.taints != null ? each.value.node_pool_config.taints : []
      content {
        effect = taints.value.effect
        key    = taints.value.key
        value  = taints.value.value
      }
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

