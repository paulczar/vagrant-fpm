require "vagrant"

if Vagrant::VERSION < "1.2.1"
  raise "Use a newer version of Vagrant (1.2.1+)"
end

# Allows us to pick a different box by setting Environment Variables
BOX_NAME = ENV['BOX_NAME'] || "precise64"
BOX_URI  = ENV['BOX_URI'] || "https://opscode-vm.s3.amazonaws.com/vagrant/boxes/opscode-ubuntu-12.04.box"
BOX_OS   = ENV['BOX_OS'] || 'ubuntu'

# Set your box size, Override with Environment Variables.
BOX_MEM = ENV['BOX_MEM'] || '1024'
BOX_CPU = ENV['BOX_CPU'] || '2' # higher number decrease compile times

# OS Specific Chef Run List
if BOX_OS.match( 'precise|lucid|quantal|ubuntu' )
  chef_run_list = %w[ apt git build-essential ruby ]
elsif BOX_OS.match('rhel')
  chef_run_list = %w[ git build-essential ]
else
  raise "For Automatic OS detection your BOX_OS must contain one of the following strings: precise,lucid,quantal,ubuntu,rhel,rhel5,rhel6"
end

Vagrant.configure("2") do |config|
  # Enable the berkshelf-vagrant plugin
  config.berkshelf.enabled = true
  # The path to the Berksfile to use with Vagrant Berkshelf
  config.berkshelf.berksfile_path = "./Berksfile-vagrant"
  # Ensure latest Chef is installed for provisioning
  config.omnibus.chef_version = :latest

  config.vm.define :fpm do |config|
    config.vm.hostname = "fpm"
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
    config.ssh.max_tries = 40
    config.ssh.timeout = 120
    config.ssh.forward_agent = true
    # bootstrap all nodes with general apps.
    config.vm.provision :chef_solo do |chef|
      chef.json = {
            "languages" => {
              "ruby" => {
                "default_version" => "1.9.1"
              }
          }
       }
      chef.run_list = chef_run_list
    end
    if BOX_OS.match( 'rhel' )
      config.vm.provision :shell, :inline => <<-SCRIPT
        yum -y install rpm-build
        [[ -e /etc/init.d/iptables ]] && service iptables stop || sleep 0
        # monkey patch fpm into chef 11's omnibus ruby install.
        config.vm.provision :shell, :inline => <<-SCRIPT
        echo 'PATH=$PATH:/opt/chef/embedded/bin' > /etc/bashrc
        /opt/chef/embedded/bin/gem install fpm --no-ri --no-rdo
      SCRIPT
    else
      config.vm.provision :shell, :inline => <<-SCRIPT
        gem install fpm --no-ri --no-rdo
      SCRIPT
    end
  end

  # size the VMs
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", BOX_MEM]
    vb.customize ["modifyvm", :id, "--cpus", BOX_CPU]
  end
  config.vm.provider :lxc do |lxc|
    lxc.customize 'cgroup.memory.limit_in_bytes', "#{BOX_MEM}M"
  end
end

