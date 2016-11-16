# avinetworks.avise

[![Build Status](https://travis-ci.org/avinetworks/ansible-role-avise.svg?branch=master)](https://travis-ci.org/avinetworks/ansible-role-avise)
[![Ansible Galaxy](https://img.shields.io/badge/galaxy-avinetworks.avise-blue.svg)](https://galaxy.ansible.com/avinetworks/avise/)


Using this module you are able to install the Avi Vantage Service Engine, to your system. However, minimum requirements must be met.

## Requirements

Requires Docker to be installed. We have created `avinetworks.docker` to install Docker on a host. Please run that role first, or manually install Docker.

## Role Variables

Available variables listed below, for default values (see `defaults/main.yml`)

### Required Variables
```

master_ctl_ip: ~
# By default these are required. If `autoregister: false` these are not needed.
master_ctl_username: ~
master_ctl_password: ~
```

### Optional Variables
```
# parameters for use when deploying as package
package_deploy: false
package_source: controller_docker.tgz
package_dest: /tmp/controller_docker.tgz

# parameters for use when pulling from docker hub or docker repo
docker_repo: ~
se_version: latest
se_image: "avinetworks/se:{{ se_version }}"

# standard parameters
dpdk: false
se_cores: "{{ ansible_processor_count }}"
se_memory_gb: "{{ ansible_memtotal_mb // 1024 }}"
destination_disk: # By default this disk will be the largest disk determined by Ansible
se_disk_path: "{{ destination_disk }}opt/avi/se/data"
se_disk_gb: 10
se_logs_disk_path: ~
se_logs_disk_gb: ~
autoregister: true

# Use these to add parameters manually if desired. These do not overwrite the defaults.
mounts_extras: [] # Do NOT need to include -v in each string
env_variables_extras: [] # Do NOT need to include -e in each string
```

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

avinetworks.docker
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
