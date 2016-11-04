# A dummy plugin for Barge to set hostname and network correctly at the very first `vagrant up`
module VagrantPlugins
  module GuestLinux
    class Plugin < Vagrant.plugin("2")
      guest_capability("linux", "change_host_name") { Cap::ChangeHostName }
      guest_capability("linux", "configure_networks") { Cap::ConfigureNetworks }
    end
  end
end

MESOS_MASTER_IP = "192.168.33.11"
MESOS_AGENT_IP  = "192.168.33.21"
SECRET          = "your_secret_for_credential"

Vagrant.configure("2") do |config|
  config.vm.box = "ailispaw/barge"

  config.vm.synced_folder ".", "/vagrant", id: "vagrant"

  config.vm.provider :virtualbox do |vb|
    vb.memory = 2048
  end

  config.vm.provision :docker do |d|
    d.pull_images "ailispaw/ubuntu-essential:14.04"
  end

  config.vm.define "mesos-master" do |master|
    master.vm.hostname = "mesos-master"

    ip_addr = MESOS_MASTER_IP

    master.vm.network :private_network, ip: "#{ip_addr}"

    master.vm.provision "zookeeper", type: "docker" do |d|
      d.build_image "/vagrant/zookeeper", args: "-t ailispaw/zookeeper"
      d.run "zookeeper",
        image: "ailispaw/zookeeper",
        args: [
          "-e MYID=1",
          "-e SERVERS=#{ip_addr}",
          "--net host",
          "-v /usr/bin/dumb-init:/usr/local/bin/dumb-init:ro",
          "--entrypoint=dumb-init"
        ].join(" "),
        cmd: "/entrypoint.sh zkServer.sh start-foreground"
    end

    master.vm.provision "mesos-master", type: "docker" do |d|
      d.build_image "/vagrant/mesos-master", args: "-t ailispaw/mesos-master"
      d.run "mesos-master",
        image: "ailispaw/mesos-master",
        args: [
          "-e MESOS_HOSTNAME=#{ip_addr}",
          "-e MESOS_IP=#{ip_addr}",
          "-e MESOS_QUORUM=1",
          "-e MESOS_ZK=zk://#{ip_addr}:2181/mesos",
          "-e MESOS_LOG_DIR=/var/log/mesos",
          "-e SECRET=#{SECRET}",
          "--net host",
          "-v /usr/bin/dumb-init:/usr/local/bin/dumb-init:ro",
          "--entrypoint=dumb-init"
        ].join(" "),
        cmd: "/entrypoint.sh mesos-master"
    end

    master.vm.provision "marathon", type: "docker" do |d|
      d.build_image "/vagrant/marathon", args: "-t ailispaw/marathon"
      d.run "marathon",
        image: "ailispaw/marathon",
        args: [
          "-e MARATHON_HOSTNAME=#{ip_addr}",
          "-e MARATHON_HTTPS_ADDRESS=#{ip_addr}",
          "-e MARATHON_HTTP_ADDRESS=#{ip_addr}",
          "-e MARATHON_MASTER=zk://#{ip_addr}:2181/mesos",
          "-e MARATHON_ZK=zk://#{ip_addr}:2181/marathon",
          "-e SECRET=#{SECRET}",
          "--net host",
          "-v /usr/bin/dumb-init:/usr/local/bin/dumb-init:ro",
          "--entrypoint=dumb-init"
        ].join(" "),
        cmd: "/entrypoint.sh marathon --no-logger"
    end
  end

  config.vm.define "mesos-agent" do |agent|
    agent.vm.hostname = "mesos-agent"

    ip_addr = MESOS_AGENT_IP

    agent.vm.network :private_network, ip: "#{ip_addr}"

    agent.vm.provision :shell do |sh|
      sh.inline = <<-EOT
        # We need a static binary version of Docker to share it with a mesos-agent container.
        /etc/init.d/docker restart v1.10.3
      EOT
    end

    agent.vm.provision "mesos-agent", type: "docker" do |d|
      d.build_image "/vagrant/mesos-agent", args: "-t ailispaw/mesos-agent"
      d.run "mesos-agent",
        image: "ailispaw/mesos-agent",
        args: [
          "-e MESOS_HOSTNAME=#{ip_addr}",
          "-e MESOS_IP=#{ip_addr}",
          "-e MESOS_MASTER=zk://#{MESOS_MASTER_IP}:2181/mesos",
          "-e MESOS_LOG_DIR=/var/log/mesos",
          "-e SECRET=#{SECRET}",
          "--net host --privileged",
          "-v /sys/fs/cgroup:/sys/fs/cgroup",
          "-v /opt/bin/docker:/usr/local/bin/docker:ro",
          "-v /var/run/docker.sock:/var/run/docker.sock",
          "-v /usr/bin/dumb-init:/usr/local/bin/dumb-init:ro",
          "--entrypoint=dumb-init"
        ].join(" "),
        cmd: [
          "/entrypoint.sh mesos-agent",
          "--no-docker_kill_orphans"
        ].join(" ")
    end
  end
end
