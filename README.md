# avinetworks.avise

[![Build Status](https://travis-ci.org/avinetworks/ansible-role-avise.svg?branch=master)](https://travis-ci.org/avinetworks/ansible-role-avise)
[![Ansible Galaxy](https://img.shields.io/badge/galaxy-avinetworks.avise-blue.svg)](https://galaxy.ansible.com/avinetworks/avise/)

Using this module you are able to install the Avi Vantage Service Engine, to your system. However, minimum requirements must be met.

## Requirements

- Docker is required and can be installed using `avinetworks.docker` or manually installed.  

- `avisdk` python library is required and can be installed by:  
`pip install avisdk --upgrade`  

- Requires the `avinetworks.avisdk` role to be installed. To install these use the following command:  
  `ansible-galaxy install -f avinetworks.avisdk`  

## Role Variables

### General Variables (apply to all deployment modes)
| Variable | Required | Default | Comments |
|-----------------------|----------|-----------|---------|
| `autoregister` | No | `true` | Autoregisters the service engine to the specified controller. |
| `master_ctl_ip` | Yes | `None` | The IP address of the controller. |
| `master_ctl_username` | Yes | `None` | The username to login into controller api. <br>**Not required when `autoregister: false`** |
| `master_ctl_password` | Yes | `None` | The passowrd to login into the controller api. <br>**Not required when `autoregister: false`** |
| `cloud_name` | No | `Default-Cloud` | Name of cloud the SE should auto-register with. |
| `tenant` | No | `admin` | Name of tenant the SE should auto-register with.
| `skip_requirements` | No | `false` | Skips any requirements for disk space, ram, and cpu. |

### Default Deployment Variables (bare-metal/vm)
These variables are for default or bare-metal deployment.

| Variable | Required | Default | Comments |
|-----------------------|----------|-----------|---------|
| `package_deploy` | No | `false` | Set to true to deploy via package. |
| `package_source` | No | `se_docker.tgz` | Source location of the docker tgz |
| `package_dest` | No | `/tmp/se_docker.tgz` | Destination location on the remote server |
| `docker_repo` | No | `None` | If using a local repository please enter it here. |
| `se_version` | No | `latest` | Version of the Avi Service Engine package you want to deploy. |
| `se_image` | No | `avinetworks/se:{{ se_version }}` | Full name of the service engine image. |
| `dpdk` | No | `false` | When set to true performs dpdk installation. |
| `inband_mgmt` | No | `false` | Enables inband management interface for this Service Engine (i.e. Use Management interface for data traffic as well). |
| `se_cores` | No | `{{ ansible_processor_cores * ansible_processor_count }}` | How many cores the service engine will use. |
| `se_memory_gb` | No | `{{ ansible_memtotal_mb / 1024 }}` | How much memory the service engine will use.  |
| `destination_disk` | No | auto-detect based on `ansible_mounts` largest sized disk | The disk that the service engine data will be installed |
| `se_disk_path` | No | `{{ destination_disk }}opt/avi/se/data` | The path that the service engine data will be installed. |
| `se_disk_gb` | No | `10` | The size of the disk that will be used by service engine data. |
| `se_logs_disk_path` | No | `None` | The path that the service engine log data will be stored. |
| `se_logs_disk_gb` | No | `None` | The size of the disk that will be used by log data. |
| `fresh_install` | No | `false` | Erases any pre-existing directories associated with the service engine. |
| `mounts_extras` | No | `[]` | Extra mounting points to be used by the service engine. <br>No need to include the `-v` |
| `env_variables_extras` | No | `[]` | Extra environment variables to be used by the service engine. <br>No need to include `-e` |

### CSP Deployment Variables
These are only marked required, for when you are using CSP Deployment.

| Variable | Required | Default | Comments |
|-----------------------|----------|-----------|---------|
| `csp_deploy` | Yes | `false` | Set to true if deploying on CSP. |
| `csp_user` | Yes | `None` | Username that will be used to connect to the CSP server. |
| `csp_password` | Yes | `None` | Password required to authenticate the user. |
| `csp_se_qcow_image_file` | No | `se.qcow` | Relative or absolute location of the SE qcow. |
| `csp_se_mgmt_ip` | Yes | `None` | IP of the SE on the management network. |
| `csp_se_mgmt_mask` | Yes | `None` | Subnet mask that the SE will require. |
| `csp_se_default_gw` | Yes | `None` | Default gateway for the SE. |
| `csp_se_authtoken` | No | Auto | Token which will authenticate the SE to the controller. |
| `csp_se_tenant_uuid` | No | `None` | UUID of the Tenant the SE will use. If left as `None` will use Admin tenant. |
| `csp_se_disk_size` | No | `10` | Amount of disk space in GB for the SE. |
| `csp_se_service_name` | No | `avi-se` | Name of the service to be created on the CSP. |
| `csp_se_num_cpu` | No | `1` | Number of CPUs to be allocated to the SE. |
| `csp_se_memory` | No | `1` | Amount of memory in GB allocated to the SE. |


### Parameter Override Variables
However, you are able to provide these parameters another way. Using the following variables. This will allow the user to customize all values.  
**!!!BEWARE: USING THIS WILL ERASE DEFAULTS - USE WITH CAUTION!!!**

```

env_variables_all:
  - "CONTAINER_NAME=avise"
  - "CONTROLLERIP=10.10.27.101""
  - "NTHREADS=4"
  - "SEMEMMB=4096"
  - "DOCKERNETWORKMODE=HOST"

mounts_all:
  - "/mnt:/mnt"
  - "/dev:/dev"
  - "/etc/sysconfig/network-scripts:/etc/sysconfig/network-scripts"
  - "/:/hostroot/"
  - "/etc/hostname:/etc/host_hostname"
  - "/etc/localtime:/etc/localtime"
  - "/var/run/docker.sock:/var/run/docker.sock"
  - "/opt/avi/se/data:/vol/"
```

## Dependencies

avinetworks.avisdk

## Example Playbooks

**WARNING:**
**Before using this example please make the correct changes required for your server. For more information please visit [https://kb.avinetworks.com/sizing-service-engines/] (https://kb.avinetworks.com/sizing-service-engines/)**

**It is recommended you adjust these parameters based on the implementation desired.**
### Standard Example
```

- hosts: service_engines
  roles:
    - role: avinetworks.avise
      master_ctl_ip: 10.10.27.101
      master_ctl_username: admin
      master_ctl_password: avi123
      se_disk_gb: 60
      se_cores: 4
      se_memory_gb: 12
```

### CSP Deployment Example
```

---
- hosts: csp_devices
  gather_facts: false
  roles:
    - role: avinetworks.avise
      csp_deploy: true
      csp_user: admin
      csp_password: password
      master_ctl_ip: 10.128.2.20
      master_ctl_username: admin
      master_ctl_password: password
      csp_se_qcow_image_file: avi-se.qcow2
      csp_se_mgmt_ip: 10.128.2.20
      csp_se_mgmt_mask: 255.255.255.0
      csp_se_default_gw: 10.128.2.1
      csp_se_service_name: avi-controller
      csp_se_disk_size: 10
      csp_se_num_cpu: 2
      csp_se_memory: 4
```

### Minimum Example
```

- hosts: service_engines
  roles:
    - role: avinetworks.avise
      master_ctl_ip: 10.10.27.101
      master_ctl_username: admin
      master_ctl_password: avi123
```

## License

MIT

## Author Information

Eric Anderson  
[Avi Networks](http://avinetworks.com)
