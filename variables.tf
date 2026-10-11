variable "gkeonprem_bare_metal_node_pools" {
  description = <<EOT
Map of gkeonprem_bare_metal_node_pools, attributes below
Required:
    - bare_metal_cluster
    - location
    - name
    - node_pool_config (block):
        - labels (optional)
        - node_configs (required, block):
            - labels (optional)
            - node_ip (optional)
        - operating_system (optional)
        - taints (optional, block):
            - effect (optional)
            - key (optional)
            - value (optional)
Optional:
    - annotations
    - deletion_policy
    - display_name
    - project
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    bare_metal_cluster = string
    location           = string
    name               = string
    annotations        = optional(map(string))
    deletion_policy    = optional(string)
    display_name       = optional(string)
    project            = optional(string)
    node_pool_config = object({
      labels = optional(map(string))
      node_configs = list(object({
        labels  = optional(map(string))
        node_ip = optional(string)
      }))
      operating_system = optional(string)
      taints = optional(list(object({
        effect = optional(string)
        key    = optional(string)
        value  = optional(string)
      })))
    })
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.gkeonprem_bare_metal_node_pools : (
        length(v.node_pool_config.node_configs) >= 1
      )
    ])
    error_message = "Each node_configs list must contain at least 1 items"
  }
  # Note: 1 additional provider-side validator is enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

