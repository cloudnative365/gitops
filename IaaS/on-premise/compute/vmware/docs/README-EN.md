# 1. ESXi+Vcenter

## 1.1. ESXi

VMware ESXi (Elastic Sky X Integrated) is an enterprise-grade virtualization platform and the core component of the VMware vSphere suite. ESXi is a type 1 hypervisor that is installed directly onto a physical server, providing resources for multiple virtual machines (VMs). The primary purpose of ESXi is to achieve resource sharing and optimize hardware usage by deploying multiple virtual machines on a single physical server.

Some key features of ESXi include:

1. Enterprise-grade performance: ESXi delivers high performance and reliability to meet the stringent demands of enterprise applications.
2. Hardware abstraction: ESXi provides an abstraction layer between physical hardware and virtual machines, allowing VMs to run on different physical hardware for increased flexibility.
3. High availability: ESXi enhances the availability of virtual machines through features such as VMware High Availability, Fault Tolerance, and others, ensuring the continuous operation of critical business processes.
4. Resource management: ESXi has advanced resource management capabilities, such as resource pools, shared storage, and live migration, enabling optimized resource allocation and improved resource utilization.
5. Security: ESXi has strict security mechanisms, including virtual machine isolation, access control, and security hardening, to protect data and applications from attacks.
6. Scalability: ESXi can be extended through other components in the vSphere suite, such as vCenter Server and vSphere Update Manager, to enable centralized management, monitoring, and automation.

In summary, VMware ESXi is a powerful, stable, and reliable virtualization solution widely used in enterprise data centers and cloud computing environments.

## 1.2. Vcenter

VMware vCenter Server is one of the core components of the VMware vSphere virtualization platform, used for centralized management and monitoring of ESXi hosts and virtual machines (VMs). vCenter Server provides a single management console, allowing administrators to easily manage large-scale virtual environments, thereby increasing efficiency and simplifying daily tasks.

Here are some key features of vCenter Server:

1. Centralized management: vCenter Server enables administrators to centrally manage and monitor the entire virtualization environment, including ESXi hosts and virtual machines, from a single interface.
2. High availability and disaster recovery: vCenter Server improves the availability and disaster recovery capabilities of the virtual environment through features such as VMware High Availability (HA) and vCenter Server Heartbeat.
3. Resource and performance optimization: vCenter Server supports Distributed Resource Scheduler (DRS) and Storage DRS, which automatically balance compute and storage resources to enhance performance and resource utilization.
4. Virtual machine migration: vCenter Server supports live migration of virtual machines and their storage without interrupting business operations through vMotion and Storage vMotion technologies, enabling dynamic resource allocation and load balancing.
5. Templates and cloning: vCenter Server allows for the creation of virtual machine templates and clones, accelerating deployment and simplifying management.
6. Update and patch management: With the vSphere Update Manager (VUM) plugin, vCenter Server can automatically manage and deploy patches and updates for ESXi hosts and virtual machines.
7. Role-based access control: vCenter Server supports role-based access control (RBAC), allowing administrators to assign different levels of permissions to different users and groups for fine-grained permission management.
8. Monitoring and reporting: vCenter Server offers extensive monitoring capabilities, including performance charts, alarms, and event logs, as well as generating detailed reports to help administrators track and optimize the performance of the virtual environment.

In summary, VMware vCenter Server is a powerful management tool that enables administrators to easily manage and monitor virtualized environments, achieving automation and optimization. With vCenter Server, enterprises can fully leverage the benefits of virtualization, improving resource utilization and business continuity.

## 1.3. way to manage esxi+vcenter cluter

There are several ways to manage a VMware vCenter Server cluster. Below are some common methods:

1. vSphere Client: The vSphere Client is a web-based management interface provided by VMware, allowing administrators to log in and manage the vCenter Server cluster through a browser. With the vSphere Client, you can view the status, resource usage, host and virtual machine configurations of the cluster, and perform various management tasks such as creating, deleting, and migrating virtual machines, and configuring networking and storage.
2. VMware vSphere PowerCLI: vSphere PowerCLI is a PowerShell-based command-line tool that enables administrators to manage the vCenter Server cluster by writing and executing scripts. PowerCLI can be used for bulk operations, automation tasks, and integration with other systems, providing great flexibility for advanced users and automation requirements.
3. REST API: vCenter Server provides a RESTful API that allows developers and administrators to interact with the vCenter Server cluster programmatically. The REST API can be used for custom integrations, monitoring, and automation, collaborating with other systems (such as CMDB, monitoring tools, or automation platforms).
4. VMware vRealize Operations: vRealize Operations is a centralized operations management platform from VMware that can be used to monitor, optimize, and automate the entire virtualization environment, including vCenter Server clusters. vRealize Operations helps administrators manage vCenter clusters more effectively by providing comprehensive performance, capacity, and configuration management capabilities.
5. Third-party management tools: There are many third-party management tools available on the market for managing vCenter Server clusters. These tools typically offer additional features such as backup and recovery, reporting, and analytics to meet specific management needs.

Depending on your requirements, skills, and organizational policies, you can choose one or multiple management methods to manage the vCenter Server cluster. Ensure proper training and support are provided to administrators to effectively manage and monitor the virtualization environment.

# 2. Manage ESXi

## 2.1.  Way to manage ESXi

There are several ways to manage ESXi, and below are some suggestions and commonly used methods:

1. Using vSphere Client: With the vSphere Client, you can connect to a vCenter Server or an individual ESXi host for management. After logging in, you can view and manage resources such as virtual machines, networks, and storage on the host. To connect to an ESXi host, enter the host's IP address or hostname, and then log in with the host's root credentials.
2. Using the ESXi Embedded Host Client: The ESXi Embedded Host Client is a web-based interface that allows you to manage individual ESXi hosts directly. To access the Embedded Host Client, open a browser and enter https://<ESXi-Host-IP-or-Hostname>/ui, then log in with the host's root credentials.
3. Using VMware vSphere PowerCLI: vSphere PowerCLI is a PowerShell-based command-line tool that allows you to write and execute scripts to manage ESXi hosts. PowerCLI is very useful for bulk operations and automation tasks. To manage ESXi using PowerCLI, you need to first install the VMware.PowerCLI module, and then use the Connect-VIServer command to connect to the ESXi host.
4. Using ESXi Shell and SSH: You can access the command-line interface of an ESXi host through the ESXi Shell (local console) or SSH (remote connection). In the command-line interface, you can use various ESXCLI and other commands to manage the host. Note that by default, SSH is disabled, and you need to enable it in the host's security profile.
5. Using VMware vRealize Operations: vRealize Operations is a centralized operations management platform from VMware that can be used to monitor, optimize, and automate the entire virtualization environment, including ESXi hosts. With vRealize Operations, you can view performance, capacity, and configuration information for hosts and perform some management operations.
6. Using REST API: ESXi 6.5 and higher versions support RESTful APIs, allowing you to interact with ESXi hosts programmatically. Although the functionality of the REST API is relatively limited, it can still be used to obtain host information, manage virtual machines, and perform other simple tasks.
7. Using third-party management tools: There are many third-party management tools available on the market for managing ESXi hosts, including backup and recovery, monitoring, and reporting. These tools typically interact with ESXi hosts through the vSphere API, providing additional features and integrations.

Depending on your needs, skills, and organizational policies, you can choose one or multiple methods to manage ESXi hosts. When using these tools, ensure you follow best practices and security guidelines to maintain the stability and security of your environment.

## 2.2. manage ESXi by vShere Client（WEB）

To manage an ESXi host using the vSphere Client, follow these steps:

1. Access the vSphere Client: Open a web browser and enter the URL for the vCenter Server (usually https://<vCenter-Server-IP-or-Hostname>/ui) or the ESXi host (https://<ESXi-Host-IP-or-Hostname>/ui). Log in with your vCenter Server or ESXi host credentials.
2. Navigate the interface: After logging in, you will see the main interface of the vSphere Client. In the left navigation pane, you can see your data centers, clusters, ESXi hosts, and virtual machines. Click on these objects to view details and related actions.
3. Connect to the ESXi host: If you logged into vCenter Server, you would need to navigate to the ESXi host you want to manage. Click on the data center or cluster containing the host, and then click on the desired host in the list. If you logged into the ESXi host directly, you will automatically see the host's details.
4. View host summary and monitor performance: Select the ESXi host, and click on the "Summary" tab to see an overview of the host's hardware, resources, and configuration. To monitor the host's performance, click on the "Monitor" tab to view various charts, tasks, events, and alarms.
5. Manage virtual machines: To manage the virtual machines running on the ESXi host, click on the "Virtual Machines" tab. You can perform actions such as creating a new virtual machine, powering on or off existing virtual machines, editing settings, taking snapshots, and migrating virtual machines.
6. Configure host networking: Click on the "Configure" tab and then click on "Networking" to manage the host's virtual switches, port groups, and physical adapters. Here, you can create new virtual switches, modify port group settings, and configure VMkernel adapters for services such as vMotion and iSCSI.
7. Configure host storage: In the "Configure" tab, click on "Storage" to manage the host's datastores and storage adapters. You can create new datastores, expand existing ones, or unmount them. Additionally, you can configure iSCSI or Fibre Channel storage adapters and manage storage paths.
8. Manage host settings: Under the "Configure" tab, you can also manage various host settings such as the NTP server, security profile (firewall settings and services), and advanced system settings (kernel options and hardware configurations).
9. Update and patch the ESXi host: To update or patch the ESXi host, click on "Update Manager" under the "Configure" tab. Here, you can attach a baseline containing the required patches or updates, scan the host for compliance, and remediate non-compliant hosts.

These are the basic steps for managing an ESXi host using the vSphere Client. The vSphere Client provides a user-friendly and powerful interface to manage and monitor your ESXi hosts and their resources effectively.

# 3. Manage vCenter

## 3.1. Way to manage vCenter

There are several ways to manage a VMware vCenter Server cluster. Below are some common methods:

1. vSphere Client: The vSphere Client is a web-based management interface provided by VMware, allowing administrators to log in and manage the vCenter Server cluster through a browser. With the vSphere Client, you can view the status, resource usage, host and virtual machine configurations of the cluster, and perform various management tasks such as creating, deleting, and migrating virtual machines, and configuring networking and storage.
2. VMware vSphere PowerCLI: vSphere PowerCLI is a PowerShell-based command-line tool that enables administrators to manage the vCenter Server cluster by writing and executing scripts. PowerCLI can be used for bulk operations, automation tasks, and integration with other systems, providing great flexibility for advanced users and automation requirements.
3. REST API: vCenter Server provides a RESTful API that allows developers and administrators to interact with the vCenter Server cluster programmatically. The REST API can be used for custom integrations, monitoring, and automation, collaborating with other systems (such as CMDB, monitoring tools, or automation platforms).
4. VMware vRealize Operations: vRealize Operations is a centralized operations management platform from VMware that can be used to monitor, optimize, and automate the entire virtualization environment, including vCenter Server clusters. vRealize Operations helps administrators manage vCenter clusters more effectively by providing comprehensive performance, capacity, and configuration management capabilities.
5. Third-party management tools: There are many third-party management tools available on the market for managing vCenter Server clusters. These tools typically offer additional features such as backup and recovery, reporting, and analytics to meet specific management needs.

Depending on your requirements, skills, and organizational policies, you can choose one or multiple management methods to manage the vCenter Server cluster. Ensure proper training and support are provided to administrators to effectively manage and monitor the virtualization environment.

## 3.2. Manage vCenter by vShere Client

Managing a VMware cluster using the vSphere Client is relatively intuitive. Here are some basic steps for managing a VMware cluster with the vSphere Client:

1. Log in to the vSphere Client: Open a browser, enter the URL of the vCenter Server (usually https://<vCenter-Server-IP-or-Hostname>/ui), and then log in with your username and password.
2. Browse the interface: After logging in, you will see the main interface of the vSphere Client. In the left navigation pane, you can see your data centers, clusters, ESXi hosts, and virtual machines. Click on these objects to view details and related actions.
3. Create and configure a cluster: Right-click on a data center and select "New Cluster." In the pop-up dialog, enter a cluster name, select the desired features (such as DRS, HA, etc.), and click "OK." After the cluster is created, you can add ESXi hosts to the cluster and configure them.
4. Configure cluster settings: Select the cluster, and under the "Configure" tab, you can configure settings for the cluster, such as DRS, HA, EVC, etc. Adjust them according to your needs.
5. Create a virtual machine: Right-click on the cluster and select "New Virtual Machine." Follow the wizard's prompts to choose a name, operating system, CPU, memory, hard disk, and other configurations for the virtual machine. Once created, the virtual machine will appear in the virtual machine list within the cluster.
6. Manage virtual machines: Select a virtual machine in the cluster, right-click, and perform various actions, such as power on, power off, restart, suspend, snapshot management, edit settings, etc.
7. Monitor and manage resources: On the cluster, host, or virtual machine, you can view performance charts, tasks, events, and alarms under the "Monitor" tab. You can use this information to monitor resource usage, diagnose issues, and optimize performance.
8. Migrate virtual machines: Right-click on a virtual machine and select "Migrate." You can choose to change the host, datastore, or both. Follow the wizard's prompts to complete the migration.

These are just some basic operations for managing a VMware cluster using the vSphere Client. In reality, the vSphere Client offers many more advanced features, such as setting up resource pools, configuring networking and storage, managing templates and clones, etc. Familiarizing yourself with these features will help you manage your VMware cluster more effectively.

## 3.3. Manage Network

To manage networking in a vSphere environment, you'll need to work with virtual switches (vSwitches), port groups, and VMkernel adapters. Here are the basic steps for managing networking in vSphere:

1. Log in to vSphere Client: Access the vCenter Server URL using a web browser (usually https://<vCenter-Server-IP-or-Hostname>/ui) and log in with your vCenter Server credentials.
2. Locate the ESXi host or cluster: In the left navigation pane, click on the datacenter or cluster, and then select the ESXi host for which you want to manage networking. To manage networking across an entire cluster, locate and select the appropriate cluster.
3. Manage virtual switches:
   - Create a virtual switch: On the ESXi host or cluster, select the "Configure" tab, and then click on "Networking". Click "Add Networking" to create a new standard virtual switch (vSwitch) or distributed virtual switch (dvSwitch, which requires an Enterprise license).
   - Modify virtual switch settings: In the list of networks, select the virtual switch you want to modify and click the "Edit" button. Here you can change the MTU size, security policies, and other settings.
4. Manage port groups:
   - Create a port group: When creating a virtual switch, you will be asked to create at least one port group. Port groups are used to connect virtual machines to the virtual switch. You can also create a new port group by clicking "Add Networking".
   - Modify port group settings: In the list of networks, select the port group you want to modify, and then click the "Edit" button. Here you can change the VLAN ID, security policies, traffic shaping settings, and other options.
5. Manage VMkernel adapters:
   - Create a VMkernel adapter: VMkernel adapters are used to connect various services on the ESXi host, such as vMotion, iSCSI, and vSphere Replication. Click "Add Networking", choose VMkernel Network Adapter, and configure the relevant settings.
   - Modify VMkernel adapter settings: In the list of networks, select the VMkernel adapter you want to modify, and then click the "Edit" button. You can change the IP address, subnet mask, VLAN ID, and enable or disable various services.
6. Manage physical network adapters: Under the "Configure" tab of the ESXi host or cluster, click on "Physical Network Adapters" to view the connected physical NICs. You can assign physical NICs to virtual switches to provide network connectivity for virtual machines and VMkernel adapters.

By following these steps, you can manage networking in vSphere and configure network settings as needed. vSphere offers powerful networking management capabilities to ensure virtual machines and services have reliable and secure network connections.

## 3.4.  Manage storage

To manage datastores in vSphere, follow these steps:

1. Log in to vSphere Client: Access the vCenter Server URL using a web browser (usually https://<vCenter-Server-IP-or-Hostname>/ui) and log in with your vCenter Server credentials.
2. Locate the ESXi host or cluster: In the left navigation pane, click on the datacenter or cluster, and then select the ESXi host or cluster for which you want to manage storage.
3. Access the storage configuration: On the ESXi host or cluster, select the "Configure" tab, and then click on "Datastores".
4. Manage datastores:
   - Create a datastore: Click "Add Datastore" to create a new datastore using either VMFS (for block storage) or NFS (for file-based storage). Follow the wizard to configure the datastore properties, such as the datastore name, storage device, and capacity.
   - Expand a datastore: In the list of datastores, select the datastore you want to expand and click the "Increase Datastore Capacity" button. Follow the wizard to allocate more disk space to the datastore.
   - Rename a datastore: Select the datastore you want to rename, click the "Actions" menu, and then click "Rename Datastore". Enter the new name and click "OK".
   - Remove a datastore: In the list of datastores, select the datastore you want to remove, click the "Actions" menu, and then click "Unmount Datastore" or "Delete Datastore". Please note that before removing a datastore, ensure that it doesn't contain running virtual machines or important data.
   - Browse datastore: To view the contents of a datastore, select the datastore, click the "Actions" menu, and then click "Browse Files". You can upload or download files, create folders, and manage virtual machine files (such as VMX and VMDK files) in the datastore browser.
5. Monitor datastore performance and capacity: In the "Monitor" tab of the ESXi host or cluster, you can view datastore performance charts, usage, and other statistics. This helps you keep track of storage utilization and plan for future capacity needs.

By following these steps, you can effectively manage datastores in vSphere, ensuring that your virtual machines have adequate storage resources and that storage is utilized efficiently.