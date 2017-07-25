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

sysctl_param 'net.ipv4.ip_forward' do
  value 1
end

template '/etc/avahi/avahi-daemon.conf' do
  source 'avahi/avahi-daemon.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

['dhcp-helper', 'parprouted'].each do |default_vars_file|
  if default_vars_file == 'parprouted'
    vars = {'network_interfaces' => node['network']['interfaces'].to_hash}
    vars['network_interfaces'].delete('lo')
    unless node['lyraphase-pi']['wifi-bridge'][default_vars_file].nil?
      vars.merge!(
        node['lyraphase-pi']['wifi-bridge'][default_vars_file].to_hash
      )
    end
  end

  template "/etc/default/#{default_vars_file}" do
    owner 'root'
    group 'root'
    mode '0644'
    variables(vars) if vars
  end
end

template '/etc/network/interfaces' do
  source 'network/interfaces.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

directory '/etc/network/interfaces.d' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template '/etc/network/interfaces.d/wireless-bridge-dhcp-parprouted' do
  source 'network/interfaces.d/wireless-bridge-dhcp-parprouted.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

['wireless-bridge-setup',
 'wireless-bridge-cleanup',
 'wireless-bridge-ip-clone',
 'wpa-supplicant-event-handler',
 'parprouted-watchdog'].each do |script|
  template "/etc/network/#{script}" do
    source "network/#{script}.erb"
    owner 'root'
    group 'root'
    mode '0755'
  end
end

['parprouted.service',
 'parprouted-watchdog.service',
 'wpa-cli-event-handler.service'].each do |systemd_svc|
  if ['parprouted.service', 'wpa-cli-event-handler.service'].include?(systemd_svc)
    vars = {'network_interfaces' => node['network']['interfaces'].to_hash}
    vars['network_interfaces'].delete('lo')
  end

  template "/etc/systemd/system/#{systemd_svc}" do
    source "systemd/#{systemd_svc}"
    owner 'root'
    group 'root'
    mode '0644'
    variables(vars) if vars
    notifies :run, 'execute[systemctl daemon-reload]'
    notifies :restart, "service[#{systemd_svc.chomp('.service')}]"
  end

  service systemd_svc.chomp('.service') do
    provider Chef::Provider::Service::Systemd
    action [:enable, :start]
  end
end

execute 'systemctl daemon-reload' do
  command 'systemctl daemon-reload'
  action :nothing
  # ignore_failure true
end
