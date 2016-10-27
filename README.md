# avinetworks.avise

Using this module you are able to install the Avi Vantage Service Engine, to your system. However, minimum requirements must be met.

## Requirements

Requires Docker to be installed. We use `avinetworks.docker` to install Docker on a host. We also specify it in our metafile.

## Role Variables

Available variables listed below, for default values (see `defaults/main.yml`)

### Required Variables
```

master_ctl_ip: ~
master_ctl_username: ~
master_ctl_password: ~
```

### Optional Variables
```

se_version: latest
dpdk: false
se_cores: "{{ ansible_processor_count }}"
se_memory_gb: "{{ ansible_memtotal_mb // 1024 }}"
destination_disk: "{{ ansible_mounts|sort(reverse=True, attribute='size_total')|map(attribute='mount')|first}}"
se_disk_path: "{{ destination_disk }}opt/avi/se/data"
se_disk_gb: 10
se_logs_disk_path: ~
se_logs_disk_gb: ~
master_ctl_ip: ~
autoregister: false
master_ctl_username: ~
master_ctl_password: ~

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

## Example Playbook

**WARNING:**
**Before using this example please make the correct changes required for your server. For more information please visit [https://kb.avinetworks.com/sizing-service-engines/] (https://kb.avinetworks.com/sizing-service-engines/)**

**It is recommended you adjust these parameters based on the implementation desired.**

```

- hosts: service_engines
  roles:
    - role: avinetworks.avise
      master_ctl_ip: 10.10.27.101
      se_disk_gb: 60
      se_cores: 4                     # If not specified core count is 4
      se_memory_gb: 12                 # If not specified memory count is 12
```

## License

BSD

## Author Information

Eric Anderson  
[Avi Networks](http://avinetworks.com)
