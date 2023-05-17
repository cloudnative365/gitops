#===============================================================================
# VMware vSphere configuration
#===============================================================================

# vCenter IP or FQDN #
vsphere_vcenter = "192.168.1.200"

# vSphere username used to deploy the infrastructure #
vsphere_user = "administrator@vsphere.local"

# vSphere password used to deploy the infrastructure #
# vsphere_password = ""

# Skip the verification of the vCenter SSL certificate (true/false) #
vsphere_unverified_ssl = "true"

# vSphere datacenter name where the infrastructure will be deployed #
vsphere_datacenter = "bjpet01"

# vSphere cluster name where the infrastructure will be deployed #
vsphere_cluster = "bjpetc1"

#===============================================================================
# Virtual machine parameters
#===============================================================================

# The datastore name used to store the files of the virtual machine #
vm_os_datastore = "cnbjpet00003"
vm_data_datastore = "cnbjpet00003"

# The vSphere network name used by the virtual machine as management IP#
vm_mgt_network = "VM Network"

# The vSphere network name used by the virtual machine as service IP#
vm_srv_network = "VM Network"

# The netmask used to configure the network card of the virtual machine management IP (example: 24) #
vm_mgt_netmask = "24"

# The netmask used to configure the network card of the virtual machine service IP (example: 24) #
vm_srv_netmask = "24"

# The network gateway used by the virtual machine #
vm_gateway = "192.168.1.1"

# The DNS server used by the virtual machine #
vm_dns1 = "192.168.1.1"
vm_dns2 = "8.8.8.8"

# The domain name used by the virtual machine #
vm_domain = "test.terraform"

# The vSphere template the virtual machine is based on #
vm_template = "cis-rhel9"

# Use linked clone (true/false)
vm_linked_clone = "false"

# The number of vCPU allocated to the virtual machine #
vm_cpu = "1"

# The amount of RAM allocated to the virtual machine #
vm_ram = "8192"

vm_names = {
  vm_db1 = {
    name             = "db1",
    ipv4_mgt_address = "192.168.1.201",
    ipv4_srv_address = "192.168.1.211"
  },
  vm_db2 = {
    name             = "db2",
    ipv4_mgt_address = "192.168.1.202",
    ipv4_srv_address = "192.168.1.212"
  },
  vm_db3 = {
    name             = "db3",
    ipv4_mgt_address = "192.168.1.203",
    ipv4_srv_address = "192.168.1.213"
  },
  vm_mgt1 = {
    name             = "mgt1",
    ipv4_mgt_address = "192.168.1.204",
    ipv4_srv_address = "192.168.1.214"
  },
  vm_mgt2 = {
    name             = "mgt2",
    ipv4_mgt_address = "192.168.1.205",
    ipv4_srv_address = "192.168.1.215"
  },
  vm_mgt3 = {
    name             = "mgt3",
    ipv4_mgt_address = "192.168.1.206",
    ipv4_srv_address = "192.168.1.216"
  }
}
