require 'vagrant-openstack-provider'

$script = <<SCRIPT
wget https://apt.puppetlabs.com/puppet5-release-trusty.deb
sudo dpkg -i puppet5-release-trusty.deb
sudo apt-get update

sudo apt-get install puppet-agent
SCRIPT

Vagrant.configure("2") do |config|
  config.ssh.username = 'ubuntu'
  config.ssh.private_key_path = ENV['OS_SSH_KEY_PATH']

  config.vm.provider :openstack do |os|
    os.openstack_auth_url = ENV['OS_AUTH_URL']
    os.username           = ENV['OS_USERNAME']
    os.password           = ENV['OS_PASSWORD']
    os.tenant_name        = ENV['OS_TENANT_NAME']
    os.flavor             = 'g1.medium'
    os.image              = 'ubuntu_14.04_x86_64'
    os.floating_ip_pool   = 'ext-net-pdx1-opdx1'
    os.networks           = ['network0']
    os.security_groups    = ['sg0']
    os.keypair_name       = ENV['OS_KEYPAIR_NAME']
    os.server_name        = 'slicejump'
  end

  config.vm.provision "shell" do |s|
    s.inline = $script
  end

  config.vm.provision "puppet" do |puppet|
    puppet.environment      = 'production'
    puppet.environment_path = 'puppet/environments'
  end

end
