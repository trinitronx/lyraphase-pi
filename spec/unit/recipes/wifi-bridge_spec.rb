#
# Cookbook Name:: lyraphase-pi
# Spec:: wifi-bridge
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

require 'spec_helper'

describe 'lyraphase-pi::wifi-bridge' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:packages) { ['parprouted', 'dhcp-helper', 'avahi-daemon'] }

    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes sysctl cookbook for sysctl_param LWRP' do
      expect(chef_run).to include_recipe 'sysctl::default'
    end

    it 'installs Proxy ARP packages' do
      packages.each do |pkg|
        expect(chef_run).to install_package(pkg)
      end
    end

    it 'installs avahi-daemon.conf' do
      avahi_daemon_conf = '/etc/avahi/avahi-daemon.conf'
      test_fixture_filename = File.join(
        File.dirname(__FILE__), '..', '..', '..', 'test', 'fixtures', 'avahi', 'avahi-daemon.conf'
      )
      expect(chef_run).to create_template(avahi_daemon_conf)
        .with_path(avahi_daemon_conf)
        .with_owner('root')
        .with_group('root')
        .with_mode('0644')
      expect(chef_run).to render_file(avahi_daemon_conf).with_content(File.open(test_fixture_filename, 'r').read)
    end

    ['dhcp-helper', 'parprouted'].each do |default_vars_file|
      it 'installs /etc/default dhcp-helper vars' do
        default_vars_file_path = File.join('', 'etc', 'default', default_vars_file)
        test_fixture_filename = File.join(
          File.dirname(__FILE__), '..', '..', '..', 'test', 'fixtures', 'default', default_vars_file
        )
        expect(chef_run).to create_template(default_vars_file_path)
          .with_path(default_vars_file_path)
          .with_owner('root')
          .with_group('root')
          .with_mode('0644')
        expect(chef_run).to render_file(default_vars_file_path)
          .with_content(File.open(test_fixture_filename, 'r').read)
      end
    end

    it 'installs /etc/network/interfaces' do
      etc_network_interfaces = '/etc/network/interfaces'
      test_fixture_filename = File.join(
        File.dirname(__FILE__), '..', '..', '..', 'test', 'fixtures', 'network', 'interfaces'
      )
      expect(chef_run).to create_template(etc_network_interfaces)
        .with_path(etc_network_interfaces)
        .with_owner('root')
        .with_group('root')
        .with_mode('0644')
      expect(chef_run).to render_file(etc_network_interfaces)
        .with_content(File.open(test_fixture_filename, 'r').read)
    end

    it 'installs network config for dhcp' do
      etc_network_interfaces_wireless_bridge = '/etc/network/interfaces.d/wireless-bridge-dhcp-parprouted'
      test_fixture_filename = File.join(
        File.dirname(__FILE__), '..', '..', '..',
        'test', 'fixtures',
        'network', 'interfaces.d', 'wireless-bridge-dhcp-parprouted'
      )
      expect(chef_run).to create_template(etc_network_interfaces_wireless_bridge)
        .with_path(etc_network_interfaces_wireless_bridge)
        .with_owner('root')
        .with_group('root')
        .with_mode('0644')
      expect(chef_run).to render_file(etc_network_interfaces_wireless_bridge)
        .with_content(File.open(test_fixture_filename, 'r').read)
    end

    ['wireless-bridge-setup',
      'wireless-bridge-cleanup',
      'wireless-bridge-ip-clone',
      'wpa-supplicant-event-handler'
    ].each do |script|
      it "installs #{script} for ifup / ifdown" do
        script_file = "/etc/network/#{script}"
        test_fixture_filename = File.join(
          File.dirname(__FILE__), '..', '..', '..', 'test', 'fixtures', 'network', script
        )
        expect(chef_run).to create_template(script_file)
          .with_path(script_file)
          .with_owner('root')
          .with_group('root')
          .with_mode('0755')
        expect(chef_run).to render_file(script_file)
          .with_content(File.open(test_fixture_filename, 'r').read)
      end
    end

    it 'installs network config for dhcp' do
      expect(chef_run).to apply_sysctl_param('net.ipv4.ip_forward')
        .with(value: 1)
    end

    ['parprouted.service', 'wpa-cli-event-handler.service'].each do |systemd_svc|
      it "installs SystemD service: #{systemd_svc}" do
        systemd_svc_file = File.join('', 'etc', 'systemd', 'system', systemd_svc)
        test_fixture_filename = File.join(
          File.dirname(__FILE__), '..', '..', '..', 'test', 'fixtures', 'systemd', 'system', systemd_svc
        )
        expect(chef_run).to create_template(systemd_svc_file)
          .with_path(systemd_svc_file)
          .with_owner('root')
          .with_group('root')
          .with_mode('0644')
        expect(chef_run).to render_file(systemd_svc_file)
          .with_content(File.open(test_fixture_filename, 'r').read)
      end
    end
  end
end
