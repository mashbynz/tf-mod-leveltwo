output "nics" {
  description = "Returns the full set of NIC objects created"
  depends_on  = [azurerm_network_interface.nic]

  value = azurerm_network_interface.nic
}
