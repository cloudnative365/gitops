#===============================================================================
# terraform configuration
#===============================================================================

terraform {
  backend "local" {
  }
 
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.3.1"
    }
  } 
}

#===============================================================================
# vSphere Provider
#===============================================================================

provider "vsphere" {
  vsphere_server = "${var.vsphere_vcenter}"
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"

  allow_unverified_ssl = "${var.vsphere_unverified_ssl}"
}

#===============================================================================
# vSphere Data
#===============================================================================

data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.vsphere_cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "os_datastore" {
  name          = "${var.vm_os_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "data_datastore" {
  name          = "${var.vm_data_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "mgt_network" {
  name          = "${var.vm_mgt_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "srv_network" {
  name          = "${var.vm_srv_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.vm_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

#===============================================================================
# vSphere Resources
#===============================================================================

resource "vsphere_virtual_machine" "standalone" {
  name             = "${var.vm_name}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.os_datastore.id}"

  num_cores_per_socket = 2
  num_cpus = "${var.vm_cpu}"
  memory   = "${var.vm_ram}"
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  firmware = "efi"

  tags = ["IT Service"]

  network_interface {
    network_id   = "${data.vsphere_network.mgt_network.id}"
    adapter_type = "vmxnet3"
  }

  network_interface {
    network_id   = "${data.vsphere_network.srv_network.id}"
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "${var.vm_name}.vmdk"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
    unit_number = 0
  }

  disk {
    label            = "${var.vm_name}-data.vmdk"
    size             = 20
    thin_provisioned = true
    unit_number      = 1
    datastore_id     = "${data.vsphere_datastore.data_datastore.id}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    linked_clone  = "${var.vm_linked_clone}"

    customize {
      timeout = "20"

      linux_options {
        host_name = "${var.vm_name}"
        domain    = "${var.vm_domain}"
      }

      network_interface {
        ipv4_address = "${var.vm_mgt_ip}"
        ipv4_netmask = "${var.vm_mgt_netmask}"
      }

      network_interface {
        ipv4_address = "${var.vm_srv_ip}"
        ipv4_netmask = "${var.vm_srv_netmask}"
      }

      ipv4_gateway    = "${var.vm_gateway}"
      dns_server_list = ["${var.vm_dns1}","${var.vm_dns2}",]
    }
  }
}
