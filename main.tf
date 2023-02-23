# Define policy
resource "azurerm_policy_definition" "vm_no_owner_tag" {
  name         = "audit-vms-without-owner-tag"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Audit virtual machines without technical-owner tag"
  description  = "This policy audits virtual machines that don't have an technical-owner tag."

  policy_rule = <<POLICY_RULE
    {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Compute/virtualMachines"
          },
          {
            "field": "tags['technical-owner']",
            "exists": "false"
          }
        ]
      },
      "then": {
        "effect": "audit"
      }
    }
  POLICY_RULE
}

# Assign policy to a scope
resource "azurerm_policy_assignment" "vm_no_owner_tag_assignment" {
  name                 = "audit-vms-without-owner-tag"
  scope                = "/subscriptions/${var.subscription_id}"
  policy_definition_id = "${azurerm_policy_definition.vm_no_owner_tag.id}"
}
