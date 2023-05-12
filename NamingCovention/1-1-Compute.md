# 1. Server/Virtual Machine/Instance

机器的名字应该可以反应这个机器的一般状态，并且是比较通用的信息应该反应在机器的名字上面。

一个完整的机器名字应该包括下面的信息

| Lenth | Information | Description                              |
| ----- | ----------- | ---------------------------------------- |
| 2     | Country     | 这个设备所在的国家                       |
| 2     | City        | 这个设备所在的城市                       |
| 1     | Datacenter  | 数据中心的级别                           |
| 1     | Platform    | 设备的类型，是虚拟化，物理机或公有云实例 |
| 1     | Environment | 环境，是否是生产系统                     |
| 2     | Application | 应用的类型                               |
| 5     | Number      | 增长的数列                               |

比如下面的例子：bjpttap0001

| Code  | Content      |
| ----- | ------------ |
| cn    | 中国         |
| bj    | 北京         |
| p     | 主数据中心   |
| v     | 虚拟机       |
| t     | 测试环境     |
| ap    | 应用服务器   |
| 00001 | 第一个服务器 |



## 1.1. 国家

国家一般以国家的缩写来表示

| Country | Description  |      |
| ------- | ------------ | ---- |
| cn      | China        |      |
| us      | United State |      |
| en      | English      |      |



## 1.2. 地区

地区一般以城市的缩写来表示

| Region | Description |      |
| ------ | ----------- | ---- |
| bj     | Beijing     |      |
| sh     | Shanghai    |      |



## 1.3. 数据中心

数据中心

| Datacenter | Description       |      |
| ---------- | ----------------- | ---- |
| p          | Primary           |      |
| s          | Secondary         |      |
| d          | Disaster recovery |      |



## 1.4. 平台

平台用来表示用什么平台来承载了操作系统

| Platform | Description                 |      |
| -------- | --------------------------- | ---- |
| p        | Physical                    |      |
| v        | Virtual Machine(on-premise) |      |
| i        | Instance(public cloud)      |      |



## 1.5.环境

环境用来表示环境的信息

| Evironment | Description |      |
| ---------- | ----------- | ---- |
| p          | Production  |      |
| u          | UAT         |      |
| t          | Test        |      |
| d          | Development |      |



## 1.6. 应用

应用用来区分平台上面承载的系统

| Application | Description    |      |
| ----------- | -------------- | ---- |
| db          | Database       |      |
| ks          | Kubernetes     |      |
| ap          | Application    |      |
| st          | Storage Device |      |
| tp          | Tape           |      |
| bk          | Backup         |      |
| nw          | Network        |      |
| vc          | vCenter        |      |



## 1.7. 增长数列



| ID    | Description |
| ----- | ----------- |
| 00001 | 自增的数列  |



# 2. Tags for Server/Virtual Machine/Instance
