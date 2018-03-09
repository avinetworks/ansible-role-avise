# avinetworks.avise

[![Ansible Galaxy](https://img.shields.io/badge/galaxy-avinetworks.avise-blue.svg)](https://galaxy.ansible.com/avinetworks/avise/)

Using this module you are able to install the Avi Vantage Service Engine, to your system. However, minimum requirements must be met. Please visit the Avi SE Requirements webpage: https://kb.avinetworks.com/docs/latest/system-requirements-hardware/

## Requirements

- Docker is required for `se_deploy_type: docker`, and can be installed using `avinetworks.docker` or manually installed.  

- `avisdk` python library is required and can be installed by:  
`pip install avisdk --upgrade`  

## Role Dependencies

- avinetworks.avisdk
  - To install these use the following command: `ansible-galaxy install -f avinetworks.avisdk`  

## Role Variables
### Setting Deployment type
| Variable | Required | Default | Comments |
|----------|----------|---------|----------|
| `se_deploy_type` | No | `docker` | Sets the type of deployment that should be triggered. Valid options: `docker`, `csp` |

### Standard Parameters
| Variable | Required | Default | Comments |
|----------|----------|---------|----------|
| `se_skip_requirements` | No | `false` | Skips any requirements for disk space, ram, and cpu. |

### Auto-registration parameters
| Variable | Required | Default | Comments |
|----------|----------|---------|----------|
| `se_autoregister` | No | `true` | Autoregister the service engine to the specified controller. |
| `se_auth_token` | No | `None`|  If defined it will be the token used to register the service engine to the controller |
| `se_master_ctl_ip` | No | `None` | The IP address of the controller. |
| `se_master_ctl_username` | No | `None` | The username to login into controller api. <br>**Not required when `se_autoregister: false`** |
| `se_master_ctl_password` | No | `None` | The passowrd to login into the controller api. <br>**Not required when `se_autoregister: false`** |
| `se_cloud_name` | No | `Default-Cloud` | Name of cloud the SE should auto-register with. |
| `se_tenant` | No | `admin` | Name of se_tenant the SE should auto-register with. |

### Package Deploy Variables
| Variable | Required | Default | Comments |
|----------|----------|---------|----------|
| `se_package_deploy` | No | `false` | Set to true to deploy via package. |
| `se_package_source` | No | `se_docker.tgz` | Source location of the docker tgz |
| `se_package_dest` | No | `/tmp/se_docker.tgz` | Destination location on the remote server |

### Docker Hub and Docker Repo Variables
| Variable | Required | Default | Comments |
|----------|----------|---------|----------|
| `se_docker_repo` | No | `None` | If using a local repository please enter it here. |
| `se_version` | No | `latest` | Version of the Avi Service Engine package you want to deploy. |
| `se_image` | No | `avinetworks/se:{{ se_version }}` | Full name of the service engine image. |
| `se_docker_repo_user` | No | `None` | User to be used for repository authentication. |
| `se_docker_repo_password` | No | `None` | Password to be used for repository authentication. |

### Docker Deployment Variables
| Variable | Required | Default | Comments |
|-----------------------|----------|-----------|---------|
| `se_dpdk` | No | `false` | When set to true performs se_dpdk installation. |
| `se_inband_mgmt` | No | `false` | Enables inband management interface for this Service Engine (i.e. Use Management interface for data traffic as well). |
| `se_cores` | No | `{{ ansible_processor_cores * ansible_processor_count }}` | How many cores the service engine will use. |
| `se_memory_gb` | No | `{{ ansible_memtotal_mb / 1024 }}` | How much memory the service engine will use.  |
| `se_destination_disk` | No | auto-detect based on `ansible_mounts` largest sized disk | The disk that the service engine data will be installed |
| `se_disk_path` | No | `{{ se_destination_disk }}opt/avi/se/data` | The path that the service engine data will be installed. |
| `se_disk_gb` | No | `10` | The size of the disk that will be used by service engine data. |
| `se_logs_disk_path` | No | `None` | The path that the service engine log data will be stored. |
| `se_logs_disk_gb` | No | `None` | The size of the disk that will be used by log data. |
| `se_fresh_install` | No | `false` | Erases any pre-existing directories associated with the service engine. |
| `se_mounts_extras` | No | `[]` | Extra mounting points to be used by the service engine. <br>No need to include the `-v` |
| `se_env_variables_extras` | No | `[]` | Extra environment variables to be used by the service engine. <br>No need to include `-e` |

### CSP Deployment Variables
These are only marked required, for when you are using CSP Deployment.

| Variable | Required | Default | Comments |
|----------|----------|---------|----------|
| `se_csp_user` | Yes | `None` | Username that will be used to connect to the CSP server. |
| `se_csp_password` | Yes | `None` | Password required to authenticate the user. |
| `se_csp_qcow_image_file` | No | `se.qcow` | Relative or absolute location of the SE qcow. |
| `se_csp_mgmt_ip` | Yes | `None` | IP of the SE on the management network. |
| `se_csp_mgmt_mask` | Yes | `None` | Subnet mask that the SE will require. |
| `se_csp_default_gw` | Yes | `None` | Default gateway for the SE. |
| `se_csp_authtoken` | No | Auto | Token which will authenticate the SE to the controller. |
| `se_csp_tenant_uuid` | No | `None` | UUID of the Tenant the SE will use. If left as `None` will use Admin se_tenant. |
| `se_csp_disk_size` | No | `10` | Amount of disk space in GB for the SE. |
| `se_csp_disk_type` | No | `virtio` | CSP disk type. Recommended to use default type of virtio. |
| `se_csp_service_name` | No | `avi-se` | Name of the service to be created on the CSP. |
| `se_csp_num_cpu` | No | `1` | Number of CPUs to be allocated to the SE. |
| `se_csp_memory_gb` | No | `1` | Amount of memory in GB allocated to the SE. |
| `se_csp_vnics` | No | See `defaults/main.yml` | Sets the interfaces for the SE service |
| `se_csp_hsm_ip` | No | `None` | IP Address and Subnet for Dedicated HSM interface, ex. 10.160.100.221/24 |
| `se_csp_hsm_mask` | No | `None` | Netmask of the interface that will talk to HSM |
| `se_csp_hsm_static_routes` | No | `None` | Static routes for HSM, ex. 10.128.1.0/24 via 10.160.100.1 |
| `se_csp_hsm_vnic_id` | No | `None` | VNIC id, of the HSM interface configured on this interface ex. 1 |
| `se_csp_asm_ip` | No | `None` | IP Address and Subnet for Dedicated ASM interface, ex. 10.160.100.221/24|
| `se_csp_asm_mask` | No | `None` | Netmask of the interface that will talk to ASM |
| `se_csp_asm_static_routes` | No | `None` | Static routes for ASM, ex. 10.128.1.0/24 via 10.160.100.1 |
| `se_csp_asm_vnic_id` | No | `None` | VNIC id, of the ASM interface configured on this interface ex. 1 |
| `se_csp_bond_ifs` | No | `None` | The bond parameters for the service |
| `se_csp_platform` | No | `csp-2100` | CSP platform model |


### Parameter Override Variables
However, you are able to provide these parameters another way. Using the following variables. This will allow the user to customize all values.  
**!!!BEWARE: USING THIS WILL ERASE DEFAULTS - USE WITH CAUTION!!!**

```

se_env_variables_all:
  - "CONTAINER_NAME=avise"
  - "CONTROLLERIP=10.10.27.101""
  - "NTHREADS=4"
  - "SEMEMMB=4096"
  - "DOCKERNETWORKMODE=HOST"

se_mounts_all:
  - "/mnt:/mnt"
  - "/dev:/dev"
  - "/etc/sysconfig/network-scripts:/etc/sysconfig/network-scripts"
  - "/:/hostroot/"
  - "/etc/hostname:/etc/host_hostname"
  - "/etc/localtime:/etc/localtime"
  - "/var/run/docker.sock:/var/run/docker.sock"
  - "/opt/avi/se/data:/vol/"
```

## Example Playbooks

**WARNING:**
**Before using this example please make the correct changes required for your server. For more information please visit [https://kb.avinetworks.com/sizing-service-engines/] (https://kb.avinetworks.com/sizing-service-engines/)**

**It is recommended you adjust these parameters based on the implementation desired.**
### Standard Example
```

- hosts: service_engines
  roles:
    - role: avinetworks.avise
      se_master_ctl_ip: 10.10.27.101
      se_master_ctl_username: admin
      se_master_ctl_password: avi123
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
      se_deploy_type: csp
      se_csp_user: admin
      se_csp_password: password
      se_master_ctl_ip: 10.128.2.20
      se_master_ctl_username: admin
      se_master_ctl_password: password
      se_csp_qcow_image_file: avi-se.qcow2
      se_csp_mgmt_ip: 10.128.2.20
      se_csp_mgmt_mask: 255.255.255.0
      se_csp_default_gw: 10.128.2.1
      se_csp_service_name: avi-se
      se_csp_disk_size: 10
      se_csp_num_cpu: 2
      se_csp_memory_gb: 4
      se_csp_vnics:
        - nic: "0"
          type: access
          tagged: "false"
          network_name: enp1s0f0
        - nic: 1
          type: passthrough
          passthrough_mode: sriov
          vlan: 200
          network_name: enp7s0f0
        - nic: 2
          type: passthrough
          passthrough_mode: sriov
          vlan: 201
          network_name: enp7s0f1
      se_csp_bond_ifs: '1,2'
```

### Minimum Example
```

- hosts: service_engines
  roles:
    - role: avinetworks.avise
      se_master_ctl_ip: 10.10.27.101
      se_master_ctl_username: admin
      se_master_ctl_password: avi123
```

### Example without Auto-registration
```

- hosts: all
  roles:
    - role: avinetworks.docker
    - role: avinetworks.avise
      se_master_ctl_ip: 10.10.27.101
      se_auth_token: "{{ se_auth_token }}"
```

## License

BSD

## Author Information

Eric Anderson  
[Avi Networks](http://avinetworks.com)
