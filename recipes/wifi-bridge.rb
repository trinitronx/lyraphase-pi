#
# Cookbook Name:: lyraphase-pi
# Recipe:: default
#
# Copyright (C) 2016  James Cuzella
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

include_recipe 'sysctl::default'

node['lyraphase-pi']['wifi-bridge']['packages'].each do |pkg|
  package pkg
end

template '/etc/avahi/avahi-daemon.conf' do
  source 'avahi/avahi-daemon.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/default/dhcp-helper' do
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/network/interfaces' do
  source 'network/interfaces.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/network/interfaces.d/wireless-bridge-dhcp-parprouted' do
  source 'network/interfaces.d/wireless-bridge-dhcp-parprouted.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

['setup', 'cleanup'].each do |script|
  template "/etc/network/wireless-bridge-#{script}" do
    source "network/wireless-bridge-#{script}.erb"
    owner 'root'
    group 'root'
    mode '0755'
  end
end

sysctl_param 'net.ipv4.ip_forward' do
  value 1
end
