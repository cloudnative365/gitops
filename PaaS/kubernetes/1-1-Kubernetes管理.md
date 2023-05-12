# 1. Kubernetes管理工具

## 1.1. 常见工具

目前DC中最流行的三种kubernetes管理工具分别是redhat的openshift，Suse的Rancher和青云的KubeSphere。之所以选择KubeSphere是有下面几个原因：

+ Openshift虽然有红帽的支持，但是架构本身非常的重，初始化安装就需要三倍于Rancher和KubeSphere的资源，并且红帽的支持力度并不大，如果有一些定制化的需求，红帽的反应是非常缓慢的。
+ Suse的Rancher也非常不错，但是和他们沟通下来感觉并不是很重视我们。
+ KubeSphere由于社区版功能已经非常完善了，对于开发者非常友好，而且在北京有公司，支持和沟通都比价顺畅。

## 1.2. kubesphere功能概览

![功能概览](https://kubesphere.io/images/docs/v3.3/zh-cn/introduction/what-is-kubesphere/kubesphere-feature-overview.jpeg)

## 1.3. kubesphere架构

![Architecture](https://pek3b.qingstor.com/kubesphere-docs/png/20190810073322.png)

# 2. 使用kk安装kubernetes集群

## 2.1. 环境准备

### 2.1.1. 操作系统

虽然支持各种系统，但是我们选择**ubuntu20.04**

| 系统                                                         | 最低要求（每个节点）             |
| :----------------------------------------------------------- | :------------------------------- |
| **Ubuntu** *16.04，18.04，20.04*                             | CPU：2 核，内存：4 G，硬盘：40 G |
| **Debian** *Buster，Stretch*                                 | CPU：2 核，内存：4 G，硬盘：40 G |
| **CentOS** *7*.x                                             | CPU：2 核，内存：4 G，硬盘：40 G |
| **Red Hat Enterprise Linux** *7*                             | CPU：2 核，内存：4 G，硬盘：40 G |
| **SUSE Linux Enterprise Server** *15* **/openSUSE Leap** *15.2* | CPU：2 核，内存：4 G，硬盘：40 G |

### 2.1.2. 节点要求

- 所有节点必须都能通过 `SSH` 访问。
- 所有节点时间同步。
- 所有节点都应使用 `sudo`/`curl`/`openssl`/`tar`。

### 2.1.2.容器运行时

虽然支持Docker和Containerd，但是我们使用**containerd**

| 支持的容器运行时              | 版本    |
| :---------------------------- | :------ |
| Docker                        | 19.3.8+ |
| containerd                    | 最新版  |
| CRI-O（试验版，未经充分测试） | 最新版  |
| iSula（试验版，未经充分测试） | 最新版  |

### 2.1.3. 依赖项要求

| 依赖项      | Kubernetes 版本 ≥ 1.18 | Kubernetes 版本 < 1.18 |
| :---------- | :--------------------- | :--------------------- |
| `socat`     | 必须                   | 可选，但建议安装       |
| `conntrack` | 必须                   | 可选，但建议安装       |
| `ebtables`  | 可选，但建议安装       | 可选，但建议安装       |
| `ipset`     | 可选，但建议安装       | 可选，但建议安装       |

可以直接使用一条命令安装所有需要的依赖

``` bash
  apt install -y containerd socat conntrack ebtables ipset
```

**注意：**如果我们使用的是ubuntu20.04，containerd的配置文件默认是没有的，如果没有这个，后面就会报错

``` bash
containerd: failed to load TOML: /etc/containerd/config.toml: open /etc/containerd/config.toml: no such file or directory: Process exited with status 1
```

我们需要手动生成

``` bash
sudo mkdir -p /etc/containerd/
containerd config default | sudo tee /etc/containerd/config.toml
```

### 2.1.4. 网络和 DNS 要求

- 请确保 `/etc/resolv.conf` 中的 DNS 地址可用，否则，可能会导致集群中的 DNS 出现问题。
- 如果您的网络配置使用防火墙规则或安全组，请务必确保基础设施组件可以通过特定端口相互通信。建议您关闭防火墙。有关更多信息，请参见#2.1.5
- 支持的 CNI 插件：Calico 和 Flannel。其他插件也适用（例如 Cilium 和 Kube-OVN 等），但请注意它们未经充分测试。

### 2.1.5. 端口要求

KubeSphere 需要某些端口用于服务之间的通信。如果您的网络配置有防火墙规则，则需要确保基础设施组件可以通过特定端口相互通信。这些端口用作某些进程或服务的通信端点。

| 服务           | 协议           | 行为  | 起始端口 | 结束端口 | 备注                      |
| :------------- | :------------- | :---- | :------- | :------- | :------------------------ |
| ssh            | TCP            | allow | 22       |          |                           |
| etcd           | TCP            | allow | 2379     | 2380     |                           |
| apiserver      | TCP            | allow | 6443     |          |                           |
| calico         | TCP            | allow | 9099     | 9100     |                           |
| bgp            | TCP            | allow | 179      |          |                           |
| nodeport       | TCP            | allow | 30000    | 32767    |                           |
| master         | TCP            | allow | 10250    | 10258    |                           |
| dns            | TCP            | allow | 53       |          |                           |
| dns            | UDP            | allow | 53       |          |                           |
| local-registry | TCP            | allow | 5000     |          | 离线环境需要              |
| local-apt      | TCP            | allow | 5080     |          | 离线环境需要              |
| rpcbind        | TCP            | allow | 111      |          | 使用 NFS 时需要           |
| ipip           | IPENCAP / IPIP | allow |          |          | Calico 需要使用 IPIP 协议 |
| metrics-server | TCP            | allow | 8443     |          |                           |

## 2.2. 负载均衡

这个负载均衡是用来给master节点来做负载均衡的。我们可以使用自己搭建的任何带有负载均衡能力的服务或者硬件

+ 软件，比如haproxy，nginx，traefik。
+ 硬件负载均衡。
+ kk脚本中是可以顺路安装一台haproxy服务器的，不过是单机的。

在生产系统上，我们必然会选择带有集群功能的负载均衡，硬件的不用说，肯定是带集群的。软件上，我们就需要一些机制来保证高可用，比如ipvs，其中比较常见的就是keepalived，简单好配置，小规模使用非常好。

因此，官方建议使用keepalived+haproxy的方式，我们这里就介绍一下这个方式



![高可用架构](https://kubesphere.io/images/docs/v3.3/zh-cn/installing-on-linux/introduction/internal-ha-configuration/internalLoadBalancer.png)

## 2.1.配置负载均衡

[Keepalived](https://www.keepalived.org/) 提供 VRRP 实现，并允许您配置 Linux 机器使负载均衡，预防单点故障。[HAProxy](http://www.haproxy.org/) 提供可靠、高性能的负载均衡，能与 Keepalived 完美配合。

由于 `lb1` 和 `lb2` 上安装了 Keepalived 和 HAproxy，如果其中一个节点故障，虚拟 IP 地址（即浮动 IP 地址）将自动与另一个节点关联，使集群仍然可以正常运行，从而实现高可用。若有需要，也可以此为目的，添加更多安装 Keepalived 和 HAproxy 的节点。

先运行以下命令安装 Keepalived 和 HAproxy。

``` bash
yum install keepalived haproxy psmisc -y
```

##  2.2. HAproxy

在两台用于负载均衡的机器上运行以下命令以配置 Proxy（两台机器的 Proxy 配置相同）：

``` bash
vi /etc/haproxy/haproxy.cfg
```

以下是示例配置，供您参考（请注意 `server` 字段。请记住 `6443` 是 `apiserver` 端口）：

``` bash
global
    log /dev/log  local0 warning
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     4000
    user        haproxy
    group       haproxy
    daemon

   stats socket /var/lib/haproxy/stats

defaults
  log global
  option  httplog
  option  dontlognull
        timeout connect 5000
        timeout client 50000
        timeout server 50000

frontend kube-apiserver
  bind *:6443
  mode tcp
  option tcplog
  default_backend kube-apiserver

backend kube-apiserver
    mode tcp
    option tcplog
    option tcp-check
    balance roundrobin
    default-server inter 10s downinter 5s rise 2 fall 2 slowstart 60s maxconn 250 maxqueue 256 weight 100
    server kube-apiserver-1 172.16.0.4:6443 check # Replace the IP address with your own.
    server kube-apiserver-2 172.16.0.5:6443 check # Replace the IP address with your own.
    server kube-apiserver-3 172.16.0.6:6443 check # Replace the IP address with your own.
```

保存文件并运行以下命令以重启 HAproxy。

``` bash
systemctl restart haproxy
```

使 HAproxy 在开机后自动运行：

``` bash
systemctl enable haproxy
```

确保您在另一台机器 (`lb2`) 上也配置了 HAproxy。

## 2.3. Keepalived

两台机器上必须都安装 Keepalived，但在配置上略有不同。

运行以下命令以配置 Keepalived。

``` bash
vi /etc/keepalived/keepalived.conf
```

以下是示例配置 (`lb1`)，供您参考：

``` bash
global_defs {
  notification_email {
  }
  router_id LVS_DEVEL
  vrrp_skip_check_adv_addr
  vrrp_garp_interval 0
  vrrp_gna_interval 0
}

vrrp_script chk_haproxy {
  script "killall -0 haproxy"
  interval 2
  weight 2
}

vrrp_instance haproxy-vip {
  state BACKUP
  priority 100
  interface eth0                       # Network card
  virtual_router_id 60
  advert_int 1
  authentication {
    auth_type PASS
    auth_pass 1111
  }
  unicast_src_ip 172.16.0.2      # The IP address of this machine
  unicast_peer {
    172.16.0.3                         # The IP address of peer machines
  }

  virtual_ipaddress {
    172.16.0.10/24                  # The VIP address
  }

  track_script {
    chk_haproxy
  }
}
```

在lb2上的配置

``` bash
global_defs {
  notification_email {
  }
  router_id LVS_DEVEL
  vrrp_skip_check_adv_addr
  vrrp_garp_interval 0
  vrrp_gna_interval 0
}

vrrp_script chk_haproxy {
  script "killall -0 haproxy"
  interval 2
  weight 2
}

vrrp_instance haproxy-vip {
  state MASTER
  priority 110
  interface eth0                       # Network card
  virtual_router_id 60
  advert_int 1
  authentication {
    auth_type PASS
    auth_pass 1111
  }
  unicast_src_ip 172.16.0.3      # The IP address of this machine
  unicast_peer {
    172.16.0.2                         # The IP address of peer machines
  }

  virtual_ipaddress {
    172.16.0.10/24                  # The VIP address
  }

  track_script {
    chk_haproxy
  }
}
```

保存文件并运行以下命令以重启 Keepalived。

``` bash
systemctl restart keepalived
```

使 Keepalived 在开机后自动运行：

``` bash
systemctl enable keepalived
```

