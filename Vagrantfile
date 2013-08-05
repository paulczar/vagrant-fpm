require "vagrant"

if Vagrant::VERSION < "1.2.1"
  raise "Use a newer version of Vagrant (1.2.1+)"
end

# Allows us to pick a different box by setting Environment Variables
BOX_NAME = ENV['BOX_NAME'] || "precise64"
BOX_URI = ENV['BOX_URI'] || "https://opscode-vm.s3.amazonaws.com/vagrant/boxes/opscode-ubuntu-12.04.box"

# Set your box size, Override with Environment Variables.
BOX_MEM = ENV['BOX_MEM'] || '1024'
BOX_CPU = ENV['BOX_CPU'] || '2' # higher number decrease compile times

# Chef Run List
if BOX_NAME.match( 'precise|lucid|quantal|ubuntu' ) # Ubuntu
  chef_run_list = %w[ apt git ruby build-essential ]
  OS = "ubuntu"
elsif BOX_NAME.match( 'centos|rhel' ) # RHEL/CentOS
  chef_run_list = %w[ yum::epel ]
  OS = "rhel"
else
  raise "For Automatic OS detection your BOX_NAME must contain one of the following strings: precise,lucid,quantal,ubuntu,centos,rhel"
end

Vagrant.configure("2") do |config|
  # Enable the berkshelf-vagrant plugin
  config.berkshelf.enabled = true
  # The path to the Berksfile to use with Vagrant Berkshelf
  config.berkshelf.berksfile_path = "./Berksfile"
  # per OS family cleanup
  if OS == "rhel" 
    config.vm.provision :shell, :inline => <<-SCRIPT
      yum -y install wget curl
      service iptables stop
    SCRIPT
  end    
  if OS == "ubuntu"
    config.vm.provision :shell, :inline => <<-SCRIPT
      apt-get update
      apt-get -y install wget curl
    SCRIPT
  end
  # Ensure latest Chef is installed for provisioning
  config.omnibus.chef_version = :latest

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", BOX_MEM]
    vb.customize ["modifyvm", :id, "--cpus", BOX_CPU]
  end

  config.vm.provider :lxc do |lxc|
    lxc.customize 'cgroup.memory.limit_in_bytes', "#{BOX_MEM}M"
  end

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
    if OS == "rhel" # doesn't play nice with ruby cookbook, often has iptables enabled.
      config.vm.provision :shell, :inline => <<-SCRIPT
        #yum -y install ruby-devel
      SCRIPT
    end
    config.vm.provision :shell, :inline => <<-SCRIPT
      gem install fpm --no-ri --no-rdo
    SCRIPT
  end

#Vagrant::Config.run do |config|
#  config.vm.provision :shell, :path => "scripts/install_fpm.sh"
end

