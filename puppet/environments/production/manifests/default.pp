
$packages = [
  'wget',
  'mosh',
  'bind-utils',
  'tmux',
  'git',
]

package {$packages:
  ensure => present,
}

$tmux_conf = 'setw -g mode-keys vi

# remap prefix to Control + a
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# force a reload of the config file
unbind r
bind r source-file ~/.tmux.conf

# quick pane cycling
unbind ^A
bind ^A select-pane -t :.+'

file {'/root/.tmux.conf':
  ensure  => file,
  content => $tmux_conf,
}

include vagrant

$vagrant_plugins = [
  'vagrant-openstack-provider',
  'oscar',
]

vagrant::plugin { $vagrant_plugins:
  user => 'centos'
}

