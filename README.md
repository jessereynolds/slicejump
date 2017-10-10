# slice-jump

This is a fairly minimal Vagrant project for spinning up a jump host in SLICE
(OpenStack) that also has Vagrant (and the vagrant-openstack-provider plugin) installed and other useful things such as:
- mosh (mobile shell)
- tmux
- bind-utils (host, nslookup)
- mtr

```
  Mac / Vagrant ----> SLICE CentOS 7 VM / Vagrant ----> SLICE whatever project
```

## Using

There's a bunch of shell environment variables you'll need to set up first. There's an example set of them in `slice.rc`.

Creation:

```
vagrant up
```

Discover the SSH configuration (including floating IP of your new host):

```
vagrant ssh-config
```

Moshing in (alternative to ssh):
- ensure mosh is installed on your Mac or whatever your laptop / desktop is running - https://mosh.org/ (eg `brew install mosh`)
- `mosh --ssh "ssh -i ~/.ssh/slice.pem" centos@IP_ADDR_OF_VM` (replace `IP_ADDR_OF_VM` with the IP of the VM)
- start up a tmux session `tmux` (or `tmux a` to reconnect to a previous tmux session)

## Caveats

- I set up a .tmux.conf file for user centos which rebinds the tmux prefix to ctrl-a (default is ctrl-b in tmux, fuck knows why)
- I'm using the **puppet apply** provisioner and everything is done in one file at `puppet/environments/production/manifests/default.pp`
- Puppet modules have been vendored into `puppet/environments/production/modules/` for reliability, speed, and simplicity

## Why?

Using Vagrant to interact with SLICE via the vagrant-openstack-provider plugin over the VPN from Australia is woefully slow. It can take minutes to get through the intial proceedings of authenticating to OpenStack and whatever else the openstack provider does before actually spinning up vms or anything else useful. I have a theory that this is due to the network latency between Australia and Portland, OR (around 200 ms on a good day) so I've created this project to encapsulate the task of setting up a host within SLICE with which to control SLICE from for my other projects. It will probably also come in handy as a jump host to access my other SLICE hosted vms from, etc.

## How?

vagrant-openstack-provider creates a CentOS 7 vm.

Vagrant's shell provisioner then ensures that:
- epel package repos are configured
- Puppet's package repo for puppet-collections 1 is configured
- puppet-agent package is installed
- revisit vm flavour? Probably 2 cores and 2 GB RAM is overkill for what this VM does.

Vagrant's puppet provisioner then takes over configuration and installs a bunch of packages, including Vagrant, tmux, etc.

## To Do

- I manually did 'yum update' and a reboot early in the peace. Should include in the shell provisioner step?
- Add gcc, make and other build tools?
- Pass through SLICE credentials somehow

