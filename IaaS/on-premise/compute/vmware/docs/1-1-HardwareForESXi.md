# 1. PC Server

在选购需要安装ESXi的PC服务器时，我们需要参考VMware官方网站上给我们提供的兼容性列表，https://www.vmware.com/resources/compatibility/search.php。

## 1.1. CPU

### 1.1.1. 满足vSphere的要求

CPU需要注意和VMware集群功能的兼容性。

+ 虚拟化：AMD的VX-T和AMD的AMD-V是必须要有的，不过现在都2023年了，应该很少有服务器不支持虚拟化了。
+ vMotion：vMotion功能要求CPU的频率尽量是一个系列，且频率一致，这样才能发挥出最大性能。
  + 如果频率不一样，系列一样：会按照频率最低的cpu来分配虚拟机的CPU，也就是降频。
  + 如果系列不一样：很有可能会无法开启vMotion功能。

### 1.1.2. 满足Horizon的要求

用作虚拟桌面的CPU，**尽量让CPU的单核主频高于3.0**，来保持桌面的流畅。因为不管虚拟桌面的CPU给了多少个核，都会以单核的形式体现，因此单核的CPU主频上限就会直接影响用户体验。

一般来说，服务器的CPU核数*主频=这台服务器能分出来的最大CPU GHz数量，这个总GHz数量对于同一时代的PC服务器是基本不变的。比如，2个物理CPU，每个物理cpu有24个核，单核的最大GHz是2.6，那么总的GHz就是24\*2\*2.6=124.8GHz。如果我们选用了3.0GHz主频的CPU的话，每个物理CPU的核心数量就会变成124.8/3/2=20个核。

另外，如果我们的虚拟桌面有GPU的需求，对于CPU的消耗会更大。

### 1.1.3. CPU和内存

cpu和内存是有对应关系的，一般双路的CPU，可以插满内存，如果是单路的，只能用一半。

## 1.2. 主板

### 1.2.1. 安全模块TPM

安全模块TPM可以没有，但是在新版中会有报警，如果**我们需要虚拟出windows server的时候**，虚拟机本身的功能就会不完整，导致报错，无法继续安装。

### 1.2.2. 网卡

一般来说，下面的功能会分配到单独的网卡上

+ vMotion：一但集群挂了，系统状态会通过vMotion来同步，会产生大量的信息交换，但是平时并没有那么繁忙，我们一般会把其他集群功能和vMotion放在一个网卡上。100台以下的物理host只需要一个千兆的网卡就够了。
+ vSan：会有大量的数据在不停的交换，建议使用独立的万兆光纤网卡来跑这部分的流量。
+ 业务流量：最好把业务流量和管理流量分开，让他们单独走一块网卡，千兆或者万兆要看自己的业务需求。并且这样网络架构也会非常清晰。
+ 监控流量（可选）：我们还可以把监控，备份，安全等管理类的流量单独拿出来，但是考虑到服务器上的PCI插槽并没有这么多，我们可以把vMotion的网卡变成万兆，把这部分流量和vMotion放在一起。

因此建议至少3块独立网卡，创建三个vSwitch来分别跑他们的流量，如果没有预算，那么至少需要把vSan独立出来，vMotion和业务流量跑在一起。

### 1.2.3. HBA卡

HBA卡最好是ESXi原生支持，也就是ESXi内置驱动。这样，我们在安装ESXi的界面上，就可以直接读到RAID好的硬盘信息。否则，就需要额外加载驱动。直接可以HBA有两个级别要求：

+ 支持vSphere的：也就是原生支持，不用安装驱动的
+ 支持vSan的：由于vSan对于硬盘有一些特殊要求，如果使用vSan就需要额外的一块HBA卡来跑vSan，也对这块HBA卡有额外的要求，要求vSan ready。

**需要注意的是**：一般的服务器，硬盘的槽位和HBA卡是对应的。一般来说一个HBA卡可以挂8-16块硬盘，因此一个24盘位的服务器至少需要两块HBA卡。如果我们用vSan，那么满配1+7的架构就需要HBA卡支持8个或者16个盘位。要不就会产生浪费或者分配不均的情况。

### 1.3. 硬盘

硬盘上并没有太多的要求，但是如果使用vSAN，每个磁盘组都需要一块E级别的SSD卡来做缓存盘。一般来说，一个磁盘组由1块缓存盘和1-7块数据盘组成。缓存盘的大小至少是数据盘的10%，比如，一块数据盘1个T，那么七块数据盘7个T，那么缓存盘至少要0.7个T。计算公式为（单个磁盘容量 * 磁盘的个数 / 磁盘组的个数 * 10% = 缓存盘的容量）。

有时候，为了节省开支，我们还会选择HDD的盘，这个时候有两个需要注意的：

+ HDD的盘一般是3.5寸的，SSD的盘一般是2.5寸的，两种磁盘的盘位槽是不一样的，选购机器的时候需要注意是不是可以都支持，还是只能支持一种。
+ HDD的盘速度比SSD要慢很多，一般的是7200转，但是为了保证速度，建议使用10000转的那种。但是7200转也能用，但是发挥不出vSAN的全部优势

### 1.4. PCI-e

每台机器的PCI槽是有限的，为了保证速度，基本都是PCI-e。由于PCI-e槽是有限的，所以我们要计算一下额外的板卡数量。

+ 网卡：不管是千兆或是万兆，以太还是光纤，都是要插卡，占一个位置的。
+ NVME硬盘：有的时候我们用NVME硬盘来安装系统，从而节省硬盘的槽位。但是这个是要占PCI-e槽位的，而且为了保证双路，通常会占两个，来做RAID1.
+ 显卡：显卡也是要占槽位的

如果使用vSAN和虚拟桌面，一定要槽位比较多的服务器。

### 1.5. 显卡

2023年已经是NV显卡的天下了，目前主流是3090级别的，4090级别的刚出，价格上还是不太合适。

注意：在服务器上，显卡不叫3090或4090，有自己其他的名字，比如T4，H100，A100之类。服务器上的显卡是企业级的显卡，价格比市场上的家用或者商用显卡（学名叫消费级显卡）要贵很多，并且厂商一般不支持我们独立购买的3090或者4090显卡。出了问题，厂商是不负责维修的，国内厂商有一些可以这么用，或者我们干脆使用白牌机。这种玩法只适合中大型，且对于GPU有强需求的企业。

### 1.6. 配置要求

### 1.6.1. ESXi挂存储的方式

| 部件         | 配置                             | 描述                                                         |
| ------------ | -------------------------------- | ------------------------------------------------------------ |
| CPU          | 单核CPU GHz > 2.3即可 需要两个核 | 目前正处于Intel3代和4代更新的时期，虽然目前是3代主流，但是4代价格稳定后还是建议4代 |
| Mem          | 主频3200之上，单条64GB           | 一般的机器是32条，64G * 32 = 2T                              |
| SSD          | 480GB * 2                        | raid1，用来装系统，ESXi                                      |
| SSD          | 3.84T * 8                        | 数据盘                                                       |
| SSD          | 1.92T * 2                        | 缓存盘，要求E级别的盘                                        |
| RAID卡       |                                  | 装系统，vSphere认证即可                                      |
| 网卡         | 卡 * 1 + 10Gb模块 * 2            | 取决于交换机的口，如果交换机是10Gb的就需要10Gb的模块，如果是25Gb的，就需要25Gb的模块 |
| TPM          |                                  | 安全模块，ESXi没有这个会报警，但是不影响使用，如果虚拟windows 2025的服务器，没有这个跑不起来 |
| 远程管理模块 | iLO/iDrac                        | 系统默认的都是普通版本，想用监控或者高级功能可能需要额外购买许可 |
| 电源模块     | 双电                             |                                                              |

### 1.6.2. ESXi+vSAN

|              | 配置                             | 描述                                                         |
| ------------ | -------------------------------- | ------------------------------------------------------------ |
| CPU          | 单核CPU GHz > 2.3即可 需要两个核 | 目前正处于Intel3代和4代更新的时期，虽然目前是3代主流，但是4代价格稳定后还是建议4代 |
| Mem          | 主频3200之上，单条64GB           | 一般的机器是32条，64G * 32 = 2T                              |
| SSD          | 480GB * 2                        | raid1，用来装系统，ESXi                                      |
| SSD          | 3.84T * 12                       | 数据盘                                                       |
| SSD          | 1.92T * 2                        | 缓存盘，要求E级别的盘                                        |
| RAID卡       |                                  | 装系统，vSphere认证即可                                      |
| RAID卡       |                                  | 跑vSAN，vSAN认证                                             |
| 网卡         | 卡 * 2 + 10Gb模块 * 2            | 取决于交换机的口，如果交换机是10Gb的就需要10Gb的模块，如果是25Gb的，就需要25Gb的模块 |
| TPM          |                                  | 安全模块，ESXi没有这个会报警，但是不影响使用，如果虚拟windows 2025的服务器，没有这个跑不起来 |
| 远程管理模块 | iLO/iDrac                        | 系统默认的都是普通版本，想用监控或者高级功能可能需要额外购买许可 |
| 电源模块     | 双电                             |                                                              |

### 1.6.3. Horizon+vSAN

|              | 配置                                          | 描述                                                         |
| ------------ | --------------------------------------------- | ------------------------------------------------------------ |
| CPU          | 单核CPU GHz > 3.0，核数不少于16个，需要两个核 | 目前正处于Intel3代和4代更新的时期，虽然目前是3代主流，但是4代价格稳定后还是建议4代 |
| Mem          | 主频3200之上，单条64GB                        | 一般的机器是32条，64G * 32 = 2T                              |
| SSD          | 480GB * 2                                     | raid1，用来装系统，ESXi                                      |
| SSD          | 3.84T * 10                                    | 数据盘                                                       |
| SSD          | 1.92T * 2                                     | 缓存盘，要求E级别的盘                                        |
| RAID卡       |                                               | 装系统，vSphere认证即可                                      |
| RAID卡       |                                               | 跑vSAN，vSAN认证                                             |
| 网卡         | 卡 * 2 + 10Gb模块 * 4                         | 取决于交换机的口，如果交换机是10Gb的就需要10Gb的模块，如果是25Gb的，就需要25Gb的模块 |
| TPM          |                                               | 安全模块，ESXi没有这个会报警，但是不影响使用，如果虚拟windows 2025的服务器，没有这个跑不起来 |
| 显卡         | 16G * 4                                       | 总共64G显存即可，licence最好让供应商购买                     |
| 远程管理模块 | iLO/iDrac                                     | 系统默认的都是普通版本，想用监控或者高级功能可能需要额外购买许可 |
| 电源模块     | 双电                                          |                                                              |
| 千兆网       | 4口                                           | 一般服务器都会自带一个网卡，带4个千兆口                      |

# 2. 首批服务器

## 2.1. 办公服务器清单

下面是HEP的清单，使用的是5132214981-02+DL380 Gen10  Plus，其实目前已经有Gen11代了，Gen11带使用的是4代的intel CPU。但是由于供应商并没有拿到Gen11的价格，并且考虑到新出的机器，价格上很贵，性价比不高，最后选择了Gen10 Plus。

| 产品编码       | 描述                                      | 数量 | 备注                             |
| -------------- | ----------------------------------------- | ---- | -------------------------------- |
| P05173-B21     | HPE  DL380 Gen10+ 24SFF NC CTO Svr        | 1    | 服务器型号                       |
| P05173-B21#AKM | China  - English localization             | 1    |                                  |
| P36925-B21     | INT  Xeon-G 5320 CPU for HPE              | 1    | CPU型号                          |
| P36925-B21#0D1 | Factory  integrated                       | 2    |                                  |
| P06035-B21     | HPE  64GB 2Rx4 PC4-3200AA-R Smart Kit     | 16   | 内存                             |
| P06035-B21#0D1 | Factory  integrated                       | 16   |                                  |
| P40497-B21     | HPE  480GB SATA RI SFF BC MV SSD          | 2    | 两块SSD做raid1，装ESXi           |
| P40497-B21#0D1 | Factory  integrated                       | 2    |                                  |
| P40500-B21     | HPE  3.84TB SATA RI SFF BC MV SSD         | 6    | SSD数据盘                        |
| P40500-B21#0D1 | Factory  integrated                       | 6    |                                  |
| P40504-B21     | HPE  1.92TB SATA MU SFF BC MV SSD         | 2    | 磁盘组的缓存盘，E级别的SSD盘     |
| P40504-B21#0D1 | Factory  integrated                       | 2    |                                  |
| P37038-B21     | HPE  DL380 Gen10+ x8/x16/x8 Prim FIO Kit  | 1    | PCI扩展槽                        |
| P06367-B21     | Broadcom  MR416i-p Cntrl for HPE Gen10+   | 1    | 给vSAN用的HBA卡，vsan ready      |
| P06367-B21#0D1 | Factory  integrated                       | 1    |                                  |
| P28787-B21     | INT  X710 10Gb 2p SFP+ Adptr              | 1    | 网卡                             |
| P28787-B21#0D1 | Factory  integrated                       | 1    |                                  |
| P01366-B21     | HPE  96W Smart Storage Battery 145mm Cbl  | 1    | 存储电池组                       |
| P01366-B21#0D1 | Factory  integrated                       | 1    |                                  |
| P26279-B21     | Broadcom  MR416i-a Cntrl for HPE Gen10+   | 1    | 用来装系统的HBA卡，vsphere ready |
| P26279-B21#0D1 | Factory  integrated                       | 1    |                                  |
| P28778-B21     | INT  X710 10GbE 2p SFP+ OCP3 Adptr        | 1    | 网卡                             |
| P28778-B21#0D1 | Factory  integrated                       | 1    |                                  |
| 455883-B21     | HP  BLc 10G SFP+ SR Transceiver           | 4    | 4个模块                          |
| 455883-B21#0D1 | Factory  integrated                       | 4    |                                  |
| P38995-B21     | HPE  800W FS Plat Ht Plg LH PS Kit        | 2    | 电源                             |
| P38995-B21#0D1 | Factory  integrated                       | 2    |                                  |
| BD505A         | HPE  iLO Adv incl 3yr TSU 1-Svr Lic       | 1    | ilo的advance版                   |
| BD505A#0D1     | Factory  integrated                       | 1    |                                  |
| P55467-B21     | HPE  DL38x 8SFF SAS/SATA TM Cbl Kit       | 3    | sata控制器                       |
| P55467-B21#0D1 | Factory  integrated                       | 3    |                                  |
| P13771-B21     | HPE  TPM 2.0 Gen10+ Black Rivets Kit      | 1    | TPM安全模块                      |
| P13771-B21#0D1 | Factory  integrated                       | 1    |                                  |
| P22018-B21     | HPE  DL38X Gen10+ 2U SFF EI Rail Kit      | 1    | 导轨                             |
| P22018-B21#0D1 | Factory  integrated                       | 1    |                                  |
| P27095-B21     | HPE  DL380 Gen10+ High Perf Heat Sink Kit | 2    | 热感模块                         |
| P27095-B21#0D1 | Factory  integrated                       | 1    |                                  |

## 2.2. 网卡规划

| IP                            | 用途        | 来源                |
| ----------------------------- | ----------- | ------------------- |
| 10.10.10.10/24 NW: 10.10.10.1 | iLO远程管理 | ILO                 |
| 10.10.20.10/24 NW: 10.10.20.1 | ESXi/VM管理 | 千兆口前两个        |
| 10.10.20.11/24 NW: 10.10.20.1 | vMotion     | 千兆口后两个        |
| 10.10.30.10/24 NW: 10.10.30.1 | vSAN流量    | 第一个万兆PCI光纤卡 |
| 10.10.40.10/24 NW: 10.10.40.1 | 业务流量    | 第二个万兆PCI光纤卡 |

## 2.3. 存储规划

| 容量                | 用途    | RAID   |
| ------------------- | ------- | ------ |
| 480GB * 2           | 系统盘  | RAID 1 |
| 3.84 * 3 + 1.92 * 1 | 磁盘组1 | RAID 1 |
| 3.84 * 3 + 1.92 * 1 | 磁盘组2 | RAID 1 |

# 3. 第二批服务器清单

第二批的机器给上海使用，也是用HPE的机器，原计划是使用和第一批机器一模一样的配置再来一套，但是总结前面的经验，我重新设计了一下

| 产品编码       | 描述                                      | 数量 | 备注                             |
| -------------- | ----------------------------------------- | ---- | -------------------------------- |
| P05173-B21     | HPE  DL380 Gen10+ 24SFF NC CTO Svr        | 1    | 服务器型号                       |
| P05173-B21#AKM | China  - English localization             | 1    |                                  |
| P36925-B21     | INT  Xeon-G 5320 CPU for HPE              | 2    | CPU型号                          |
| P36925-B21#0D1 | Factory  integrated                       | 1    |                                  |
| P06035-B21     | HPE  64GB 2Rx4 PC4-3200AA-R Smart Kit     | 32   | 内存                             |
| P06035-B21#0D1 | Factory  integrated                       | 32   |                                  |
| P40497-B21     | HPE  480GB SATA RI SFF BC MV SSD          | 2    | 两块SSD做raid1，装ESXi           |
| P40497-B21#0D1 | Factory  integrated                       | 2    |                                  |
| P40500-B21     | HPE  3.84TB SATA RI SFF BC MV SSD         | 12   | SSD数据盘                        |
| P40500-B21#0D1 | Factory  integrated                       | 12   |                                  |
| P40504-B21     | HPE  1.92TB SATA MU SFF BC MV SSD         | 2    | 磁盘组的缓存盘，E级别的SSD盘     |
| P40504-B21#0D1 | Factory  integrated                       | 2    |                                  |
| P37038-B21     | HPE  DL380 Gen10+ x8/x16/x8 Prim FIO Kit  | 1    | PCI扩展槽                        |
| P06367-B21     | Broadcom  MR416i-p Cntrl for HPE Gen10+   | 1    | 给vSAN用的HBA卡，vsan ready      |
| P06367-B21#0D1 | Factory  integrated                       | 1    |                                  |
| P28787-B21     | INT  X710 10Gb 2p SFP+ Adptr              | 1    | 光纤卡                           |
| P28787-B21#0D1 | Factory  integrated                       | 1    |                                  |
| P01366-B21     | HPE  96W Smart Storage Battery 145mm Cbl  | 1    | 存储电池组                       |
| P01366-B21#0D1 | Factory  integrated                       | 1    |                                  |
| P26279-B21     | Broadcom  MR416i-a Cntrl for HPE Gen10+   | 1    | 用来装系统的HBA卡，vsphere ready |
| P26279-B21#0D1 | Factory  integrated                       | 1    |                                  |
| P28778-B21     | INT  X710 10GbE 2p SFP+ OCP3 Adptr        | 1    | 光纤卡                           |
| P28778-B21#0D1 | Factory  integrated                       | 1    |                                  |
| 455883-B21     | HP  BLc 10G SFP+ SR Transceiver           | 4    | 4个光纤模块                      |
| 455883-B21#0D1 | Factory  integrated                       | 4    |                                  |
| P38995-B21     | HPE  800W FS Plat Ht Plg LH PS Kit        | 2    | 电源                             |
| P38995-B21#0D1 | Factory  integrated                       | 2    |                                  |
| BD505A         | HPE  iLO Adv incl 3yr TSU 1-Svr Lic       | 1    | ilo的advance版                   |
| BD505A#0D1     | Factory  integrated                       | 1    |                                  |
| P55467-B21     | HPE  DL38x 8SFF SAS/SATA TM Cbl Kit       | 3    | sata控制器                       |
| P55467-B21#0D1 | Factory  integrated                       | 3    |                                  |
| P13771-B21     | HPE  TPM 2.0 Gen10+ Black Rivets Kit      | 1    | TPM安全模块                      |
| P13771-B21#0D1 | Factory  integrated                       | 1    |                                  |
| P22018-B21     | HPE  DL38X Gen10+ 2U SFF EI Rail Kit      | 1    | 导轨                             |
| P22018-B21#0D1 | Factory  integrated                       | 1    |                                  |
| P27095-B21     | HPE  DL380 Gen10+ High Perf Heat Sink Kit | 2    | 热感模块                         |
| P27095-B21#0D1 | Factory  integrated                       | 2    |                                  |

# 4. VDI的机器

## 4.1. HPE

HPE的机器只能使用3块HBA卡

| 产品编码       | 描述                                      | 数量 | 备注 |
| -------------- | ----------------------------------------- | ---- | ---- |
| P05173-B21     | HPE DL380  Gen10+ 24SFF NC CTO Svr        | 1    |      |
| P05173-B21#AKM | China  - English localization             | 1    |      |
| P36935-B21     | INT  Xeon-G 6354 CPU for HPE              | 2    |      |
| P36935-B21#0D1 | Factory  integrated                       | 2    |      |
| P06035-B21     | HPE  64GB 2Rx4 PC4-3200AA-R Smart Kit     | 32   |      |
| P06035-B21#0D1 | Factory  integrated                       | 32   |      |
| P40497-B21     | HPE  480GB SATA RI SFF BC MV SSD          | 2    |      |
| P40497-B21#0D1 | Factory  integrated                       | 2    |      |
| P40500-B21     | HPE  3.84TB SATA RI SFF BC MV SSD         | 12   |      |
| P40500-B21#0D1 | Factory  integrated                       | 12   |      |
| P40504-B21     | HPE  1.92TB SATA MU SFF BC MV SSD         | 2    |      |
| P40504-B21#0D1 | Factory  integrated                       | 2    |      |
| P14581-B21     | HPE  DL38X Gen10+ 2x8 Tertiary Riser Kit  | 1    |      |
| P14581-B21#0D1 | Factory  integrated                       | 1    |      |
| R0W29C         | HPE  NVIDIA Tesla T4 16GB Module          | 3    |      |
| R0W29C#0D1     | Factory  integrated                       | 3    |      |
| P14587-B21     | HPE  DL G10 Plus x8x16x8 3x16 Sec Rsr Kit | 1    |      |
| P14587-B21#0D1 | Factory  integrated                       | 1    |      |
| P37038-B21     | HPE  DL380 Gen10+ x8/x16/x8 Prim FIO Kit  | 1    |      |
| P06367-B21     | Broadcom  MR416i-p Cntrl for HPE Gen10+   | 1    |      |
| P06367-B21#0D1 | Factory  integrated                       | 1    |      |
| P28787-B21     | INT  X710 10Gb 2p SFP+ Adptr              | 1    |      |
| P28787-B21#0D1 | Factory  integrated                       | 1    |      |
| P01366-B21     | HPE  96W Smart Storage Battery 145mm Cbl  | 1    |      |
| P01366-B21#0D1 | Factory  integrated                       | 1    |      |
| P26279-B21     | Broadcom  MR416i-a Cntrl for HPE Gen10+   | 1    |      |
| P26279-B21#0D1 | Factory  integrated                       | 1    |      |
| P28778-B21     | INT  X710 10GbE 2p SFP+ OCP3 Adptr        | 1    |      |
| P28778-B21#0D1 | Factory  integrated                       | 1    |      |
| 455883-B21     | HP  BLc 10G SFP+ SR Transceiver           | 4    |      |
| 455883-B21#0D1 | Factory  integrated                       | 4    |      |
| P38997-B21     | HPE  1600W FS Plat Ht Plg LH PS Kit       | 2    |      |
| P38997-B21#0D1 | Factory  integrated                       | 2    |      |
| BD505A         | HPE  iLO Adv incl 3yr TSU 1-Svr Lic       | 1    |      |
| BD505A#0D1     | Factory  integrated                       | 1    |      |
| P55467-B21     | HPE  DL38x 8SFF SAS/SATA TM Cbl Kit       | 3    |      |
| P55467-B21#0D1 | Factory  integrated                       | 3    |      |
| P13771-B21     | HPE  TPM 2.0 Gen10+ Black Rivets Kit      | 1    |      |
| P13771-B21#0D1 | Factory  integrated                       | 1    |      |
| P22018-B21     | HPE  DL38X Gen10+ 2U SFF EI Rail Kit      | 1    |      |
| P22018-B21#0D1 | Factory  integrated                       | 1    |      |
| P27095-B21     | HPE  DL380 Gen10+ High Perf Heat Sink Kit | 2    |      |
| P27095-B21#0D1 | Factory  integrated                       | 2    |      |