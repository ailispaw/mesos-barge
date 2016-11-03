# Apache Mesos on Barge with Vagrant

It demonstrates a simple [Apache Mesos](http://mesos.apache.org/) cluster (1 master + 1 agent).

## Requirements

- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)

## Configurations

You can modify the following variables in Vagrantfile.

```
MESOS_MASTER_IP = "192.168.33.11"
MESOS_AGENT_IP  = "192.168.33.21"
SECRET          = "your_secret_for_credential"
```

## Boot up

```bash
$ vagrant up
```

That's it.

## Web UIs

- Mesos  
  http://192.168.33.11:5050/

- Marathon  
  http://192.168.33.11:8080/
