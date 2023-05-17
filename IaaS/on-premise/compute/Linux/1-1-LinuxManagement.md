# 1. Linux

一般来说，我们常用的Linux发行版有，RHEL/CentOS/Federa，Ubuntu/Debian，SuSE。每种发行版都有一些适用的场景

## 1.1. Redhat系

RHEL/CentOS/Federa这三种发行版都是红帽系的产品，特别是在CentOS8.2之后，红帽不再改变了原来的模式，统一出了Steam，让CentOS不再自由，统一纳管到了RHEL体系。我们可以认为RHEL和CentOS都是生产级别的，而Federa是测试的。而目前企业中，敢用CentOS的还是非常多的，而用Federa来做生产系统实在是不明智。尽管目前有一些centos变种，比如AWS的Amazon Linux2，华为云的EulerOS2，但是这些系统并不通用。而社区的Rocky Linux之类又属于新起之秀，并没有太大的号召力，因此我们急需社区的力量来让我们这些使用者进行白嫖。

CentOS之所以流行是因为他有丰富的yum仓库资源。RHEL系的由于没有花钱买订阅，因此并不能使用官方的yum repo来安装软件，这就让部署服务的工作变得非常繁琐。虽然CentOS的源看起来和RHEL一样，但是还是有很多需要注意的地方，尽量不要通用。这次，已经不用考虑了，因为二者统一了，并且使用了stream源，也就是必须要花钱订阅才能使用。

而对于我们这些工程师，我们还是有办法绕过去的，但是这里不太方便说，我们代码见！

## 1.2. Ubuntu/Debian

这类的操作系统使用的是apt包管理器，包的格式是deb格式。这类的操作系统在国内并不如Redhat系的流行，但是在国外非常广泛。因为Redhat系的系统一般比较保守，内核更新速度较慢，不能满足研发的需求，所以这类系统一般用于研发，比如芯片研发，物联网之类。或者安全类的需求，比如Kali。

新版的Kubernetes也基本都是构建在Ubuntu之上，因为Ubuntu的内核都比较新，对于内核功能比较依赖的kubernetes需要比较新的内核版本来发挥全部能量。

## 1.3. SuSE

SuSE操作系统也是常用的系统之一，但是应用场景好像并没有上面多。我经常见到的就是SAP系统，vSphere的一些OVF镜像，还有rancher。因为SuSE的功能，红帽和ubuntu都可以，所以好像并没有很大的存在感。

# 2. 企业级Linux管理

## 2.1. 管理工具

对于Linux管理，我们最常用的就是ansible。ansible的使用场景如下：

+ 系统初始化：我们可以在系统初次安装之后，调用一下ansible脚本，让系统的配置统一化
+ 批量修改配置：如果有大量的被管理的机器需要同时修改某一个配置的时候，我们就可以使用ansible脚本统一推送配置，由于ansible脚本是支持逻辑判断的，所以可以根据情况做出不同的处理
+ 标准化运维：对于一些需要统一管理的配置，我们都由ansible来统一管理，防止被其他软件篡改
+ 安装服务：对于一些软件的安装，我们直接使用ansible脚本提前安排好安装的逻辑，远程运行一下ansible脚本就可以直接使用了

## 2.2. 什么应该被管理

我建议大家可以参考CIS的最佳实践来配置系统https://github.com/ansible-lockdown/，然后把下面几个配置改成我们自己的就好了。

| 配置文件         | RHEL7 | RHEL8                                 | RHEL8 |
| ---------------- | ----- | ------------------------------------- | ----- |
| /etc/chrony.conf |       | rhel8cis_time_synchronization_servers |       |
| /etc/hosts.allow |       | rhel8cis_host_allow                   |       |
|                  |       |                                       |       |

## 2.3. 什么软件应该被安装

一般来说，我们安装服务器都会遵循最小化安装的原则，但是有些工具非常常用，需要在初始化系统的时候就安装

| Tools    | RHEL      | ubuntu    | 用途 |
| -------- | --------- | --------- | ---- |
| curl     | curl      | curl      |      |
| wget     | wget      | wget      |      |
| ifconfig | net-tools | net-tools |      |
| netstat  | net-tools | net-tools |      |

# 3. 标准申请的流程

## 3.1. vCenter架构

如果我们的系统是构筑在vCenter之上的，我们需要下面的信息就可以构筑出一台虚拟机

| 信息               | 例子                         | 是否必须 | 是否显示 | 信息提供方                 | 备注                                                         |
| ------------------ | ---------------------------- | -------- | -------- | -------------------------- | ------------------------------------------------------------ |
| vsphere_vcenter    | vcenter.prod.your-domain.com | 是       | 否       | IT部门                     |                                                              |
| vsphere_user       | username@vsphere.local       | 是       | 否       | IT部门                     |                                                              |
| vsphere_password   | password                     | 是       | 否       | IT部门                     |                                                              |
| vsphere_datacenter | bjpet01                      | 是       | 否       | IT部门                     |                                                              |
| vsphere_cluster    | bjpetc1                      | 是       | 否       | IT部门                     |                                                              |
| vm_os_datastore    | cnbjpet00003                 | 是       | 否       | IT部门                     | 操作系统                                                     |
| vm_disk_datastore  | cnbjpet00003                 | 否       | 否       | IT部门                     | 数据盘                                                       |
| vm_mgt_network     | VM Network                   | 是       | 否       | IT部门                     | 用来管理系统，比如ssh，monitor，security，backup等各种agent  |
| vm_srv_network     | VM Network                   | 是       | 否       | IT部门                     | 用来向外提供服务，主要是外部请求进来的途径，只允许80和443    |
| vm_name            | cnbjpepdb01                  | 是       | 是       | IT部门                     | 服务器名称请根据服务器命名规则提供                           |
| vm_mgt_ip          | 192.168.1.1                  | 是       | 是       | IT部门                     | 用来管理系统，比如ssh，monitor，security，backup等各种agent  |
| vm_mgt_netmask     | 24                           | 是       | 是       | IT部门                     |                                                              |
| vm_gateway         | 192.168.1.1                  | 是       | 是       | IT部门                     |                                                              |
| vm_srv_ip          | 192.168.10.1                 | 否       | 是       | IT部门                     | 用来向外提供服务，主要是外部请求进来的途径，只允许80和443    |
| vm_srv_network     | 24                           | 否       | 是       | IT部门                     |                                                              |
| vm_dns1            | 192.168.1.1                  | 是       | 是       | IT部门                     | 主DNS                                                        |
| vm_dns2            | 192.168.1.2                  | 是       | 是       | IT部门                     | 备DNS                                                        |
| vm_domain          | test.terraform               | 是       | 是       | IT部门                     | Domain对Linux并没有太多意义，主要是用来做DNS解析用，标明服务器的FQDN |
| vm_template        | rhel9                        | 是       | 否       | IT部门                     | 所有的系统在创建之后都会通过yum update升级到最新版           |
| os version         | RHEL9.2                      | 是       | 是       | 应用管理员/业务部门/供应商 | 由于Linux发行版版本更迭问题，请尽量选择EOF时间比较远的版本   |
| vm_cpu             | 2                            | 是       | 是       | 应用管理员/业务部门/供应商 | 所有的CPU都是1颗物理CPU，这里面需要填写的是每颗CPU的核心数   |
| vm_ram             | 1024                         | 是       | 是       | 应用管理员/业务部门/供应商 | MB                                                           |

## 3.2. 物理机

| 信息                 | 例子        | 是否必须 | 是否显示 | 信息提供方                 | 备注                                                     |
| -------------------- | ----------- | -------- | -------- | -------------------------- | -------------------------------------------------------- |
| cpu_numbers          | 2           | 是       | 是       | 应用管理员/业务部门/供应商 |                                                          |
| cpu_cores            | 24          | 是       | 是       | 应用管理员/业务部门/供应商 |                                                          |
| memory               | 1024        | 是       | 是       | 应用管理员/业务部门/供应商 | GB                                                       |
| GPU                  | 64          | 否       | 是       | 应用管理员/业务部门/供应商 | GHz                                                      |
| local_data_disk      | 7.68 T SSD  | 否       | 是       | 应用管理员/业务部门/供应商 | 磁盘做RAID5，因此需要3.84T * 3，可以选择SSD或者HDD       |
| storage_data_disk    | 7.68 T SSD  | 否       | 是       | 应用管理员/业务部门/供应商 |                                                          |
| service_raid_card    |             | 否       | 是       | 应用管理员/业务部门/供应商 | 如果磁盘数量太多（一般是16块）或者有高速读写的要求       |
| service_network_nic  | 10Gb/25Gb   | 否       | 是       | 应用管理员/业务部门/供应商 | 如果对外提供服务，需要通过这个网卡由外网访问，需要带模块 |
| os_disk              | 480 GB      | 是       | 是       | IT部门                     | RAID1                                                    |
| ethernet_network_nic | 1Gb         | 是       | 是       | IT部门                     | 1Gb nic * 2，做bond，用来管理机器                        |
| mgt_network_nic      |             | 是       | 是       | IT部门                     | ILO/iDrac/AMM                                            |
| mgt_network_ip       | 192.168.1.2 | 是       | 是       | IT部门                     | 管理模块的地址                                           |
| mgt_network_mask     | 24          | 是       | 是       | IT部门                     | 管理模块的掩码                                           |
| mgt_network_gateway  | 192.168.1.1 |          |          |                            |                                                          |



# 4. 命名规则

# 5. 初始化规则

## 5.1. 物理机

### 5.1.1. 分区

### 5.1.2. 时区

### 5.1.3. NTP

### 5.1.4. DNS

### 5.1.5. 用户

### 5.1.6. 服务和工具

