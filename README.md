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

| Variable | Required | Default | Comments |
|-----------------------|----------|-----------|---------|
| `master_ctl_ip` | Yes | `None` | The IP address of the controller. |
| `master_ctl_username` | Yes | `None` | The username to login into controller api. <br>**Not required when `autoregister: false`** |
| `master_ctl_password` | Yes | `None` | The passowrd to login into the controller api. <br>**Not required when `autoregister: false`** |
| `autoregister` | No | `true` | Autoregisters the service engine to the specified controller. |
| `package_deploy` | No | `false` | Set to true to deploy via package   |
| `package_source` | No | `se_docker.tgz` | Source location of the docker tgz |
| `package_dest` | No | `/tmp/se_docker.tgz` | Destination location on the remote server |
| `docker_repo` | No | `None` | If using a local repository please enter it here. |
| `se_version` | No | `latest` | Version of the Avi Service Engine package you want to deploy. |
| `se_image` | No | `avinetworks/se:{{ se_version }}` | Full name of the service engine image. |
| `dpdk` | No | false | When set to true performs dpdk installation. |
| `se_cores` | No | `{{ ansible_processor_cores * ansible_processor_count }}` | How many cores the service engine will use. |
| `se_memory_gb` | No | `{{ ansible_memtotal_mb / 1024 }}` | How much memory the service engine will use.  |
| `destination_disk` | No | auto-detect based on `ansible_mounts` largest sized disk | The disk that the service engine data will be installed |
| `se_disk_path` | No | `{{ destination_disk }}opt/avi/se/data` | The path that the service engine data will be installed. |
| `se_disk_gb` | No | `10` | The size of the disk that will be used by service engine data. |
| `se_logs_disk_path` | No | `None` | The path that the service engine log data will be stored. |
| `se_logs_disk_gb` | No | `None` | The size of the disk that will be used by log data. |
| `mounts_extras` | No | `[]` | Extra mounting points to be used by the service engine. <br>No need to include the `-v` |
| `env_variables_extras` | No | `[]` | Extra environment variables to be used by the service engine. <br>No need to include `-e` |

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
