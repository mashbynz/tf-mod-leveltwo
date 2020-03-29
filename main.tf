resource "azurerm_network_interface" "nic" {
  for_each = var.vm_object.nics

  name                = "${each.value.name}${var.nic_suffix}"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  dynamic "ip_configuration" {
    for_each = lookup(each.value, "ip_configuration", {}) #!= {} ? [1] : []

    content {
      name                          = lookup(ip_configuration.value, "name", null)
      subnet_id                     = var.level0_subnet[lookup(ip_configuration.value, "subnet_id", null)].id
      private_ip_address_allocation = lookup(ip_configuration.value, "private_ip_address_allocation", null)
      public_ip_address_id          = lookup(ip_configuration.value, "public_ip_address_id", null) != null ? var.level0_ip_addresses[lookup(ip_configuration.value, "public_ip_address_id", "")].id : null
    }
  }

  depends_on = [
    var.level0_vnet
  ]
}

resource "azurerm_windows_virtual_machine" "vm" {
  for_each = var.vm_object.vms

  name                  = "${each.value.name}${var.vm_suffix}"
  resource_group_name   = each.value.resource_group_name
  location              = each.value.location
  size                  = each.value.size
  admin_username        = each.value.admin_username
  admin_password        = each.value.admin_password
  network_interface_ids = [azurerm_network_interface.nic[each.value.network_interface_ids].id]
  license_type          = each.value.os_profile.license_type
  provision_vm_agent    = each.value.os_profile.provision_vm_agent

  os_disk {
    name                 = "${each.value.name}${var.os_disk_suffix}"
    caching              = each.value.storage_os_disk.caching
    storage_account_type = each.value.storage_os_disk.storage_account_type
    disk_size_gb         = each.value.storage_os_disk.disk_size_gb
  }

  source_image_reference {
    publisher = each.value.storage_image_reference.publisher
    offer     = each.value.storage_image_reference.offer
    sku       = each.value.storage_image_reference.sku
    version   = each.value.storage_image_reference.version
  }

  boot_diagnostics {
    storage_account_uri = var.governance_storage_accounts[each.value.boot_diagnostics.storage_account_uri].primary_blob_endpoint
  }

  depends_on = [
    azurerm_network_interface.nic
  ]
}
