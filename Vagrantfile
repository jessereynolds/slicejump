require 'vagrant-openstack-provider'

$script = <<SCRIPT
rpm -q epel-release
if [[ ! $? ]] ; then
  sudo rpm -Uvh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
fi
rpm -q puppetlabs-release-pc1
if [[ ! $? ]] ; then
  sudo rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
fi
rpm -q puppet-agent
if [[ ! $? ]] ; then
  sudo yum install puppet-agent
fi

SCRIPT

Vagrant.configure("2") do |config|
  config.ssh.username = 'centos'
  config.ssh.private_key_path = ENV['OS_SSH_KEY_PATH']

  config.vm.provider :openstack do |os|
    os.openstack_auth_url = ENV['OS_AUTH_URL']
    os.username           = ENV['OS_USERNAME']
    os.password           = ENV['OS_PASSWORD']
    os.tenant_name        = ENV['OS_TENANT_NAME']
    os.flavor             = 'g1.medium'
    os.image              = 'centos_7_x86_64'
    os.floating_ip_pool   = 'ext-net-pdx1-opdx1'
    os.networks           = ['network0']
    os.security_groups    = ['sg0']
    os.keypair_name       = ENV['OS_KEYPAIR_NAME']
    os.server_name        = 'slicejump'
  end

  config.vm.provision "shell", inline: $script

  config.vm.provision "puppet" do |puppet|
    puppet.environment = 'production'
    puppet.environment_path = 'puppet/environments'
  end

end
