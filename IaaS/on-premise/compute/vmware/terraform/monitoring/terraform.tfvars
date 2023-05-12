#===============================================================================
# VMware vSphere configuration
#===============================================================================

# vCenter IP or FQDN #
vsphere_vcenter = "192.168.1.200"

# vSphere username used to deploy the infrastructure #
vsphere_user = "terraform@vsphere.local"

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
vm_template = "rhel9"

# Use linked clone (true/false)
vm_linked_clone = "false"

# The number of vCPU allocated to the virtual machine #
vm_cpu = "1"

# The amount of RAM allocated to the virtual machine #
vm_ram = "8192"

vm_names = {
  vm_promethues1 = {
    name             = "prometheus1",
    ipv4_mgt_address = "192.168.1.221",
    ipv4_srv_address = "192.168.1.231"
  },
  vm_prometheus2 = {
    name             = "prometheus2",
    ipv4_mgt_address = "192.168.1.222",
    ipv4_srv_address = "192.168.1.232"
  },
  vm_grafana1 = {
    name             = "grafana1",
    ipv4_mgt_address = "192.168.1.223",
    ipv4_srv_address = "192.168.1.223"
  },
  vm_grafana2 = {
    name             = "grafana2",
    ipv4_mgt_address = "192.168.1.224",
    ipv4_srv_address = "192.168.1.224"
  },
  vm_es1 = {
    name             = "es1",
    ipv4_mgt_address = "192.168.1.225",
    ipv4_srv_address = "192.168.1.225"
  },
  vm_es2 = {
    name             = "es2",
    ipv4_mgt_address = "192.168.1.226",
    ipv4_srv_address = "192.168.1.226"
  },
  vm_es3 = {
    name             = "es3",
    ipv4_mgt_address = "192.168.1.227",
    ipv4_srv_address = "192.168.1.227"
  }
}
