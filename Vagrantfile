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
  chef_run_list = %w[ apt git ruby build-essential ]
elsif BOX_OS == 'rhel6'
  chef_run_list = %w[ yum::epel git build-essential ]
elsif BOX_OS == 'rhel5'
  # do nothing
else
  raise "For Automatic OS detection your BOX_OS must contain one of the following strings: precise,lucid,quantal,ubuntu,rhel5,rhel6"
end

Vagrant.configure("2") do |config|
  if BOX_OS == "rhel5"
    # Enable the berkshelf-vagrant plugin
    config.berkshelf.enabled = false
  else
    # Enable the berkshelf-vagrant plugin
    config.berkshelf.enabled = true
    # The path to the Berksfile to use with Vagrant Berkshelf
    config.berkshelf.berksfile_path = "./Berksfile-vagrant"
    # Ensure latest Chef is installed for provisioning
    config.omnibus.chef_version = :latest
  end
  config.vm.define :fpm do |config|
    config.vm.hostname = "fpm"
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
    config.ssh.max_tries = 40
    config.ssh.timeout = 120
    config.ssh.forward_agent = true
    unless BOX_OS == "rhel5"
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
      if BOX_OS == 'rhel6'
        config.vm.provision :shell, :inline => <<-SCRIPT
          yum -y --quiet install ruby-devel rpm-build
          [[ -e /etc/init.d/iptables ]] && service iptables stop
        SCRIPT
      end    
    else
      config.vm.provision :shell, :inline => <<-SCRIPT
        rpm -e $(rpm -qa --qf="%{n}-%{v}-%{r}.%{arch}\n" | grep "ruby*\|puppet*\|facter*")
        wget -O /etc/yum.repos.d/aegisco.repo http://rpm.aegisco.com/aegisco/el5/aegisco.repo
        yum -y -q install git build-essential
        yum -y -q install ruby-devel.x86_64 ruby-shadow ruby-augeas puppet ruby ruby-irb ruby-rdoc facter rubygems ruby-libs.x86_64 libselinux-ruby
      SCRIPT
    end

    config.vm.provision :shell, :inline => <<-SCRIPT
      gem install fpm --no-ri --no-rdo
    SCRIPT
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

