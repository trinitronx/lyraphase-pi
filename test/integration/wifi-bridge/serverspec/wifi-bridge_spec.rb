require 'spec_helper'

# cookbook_name = 'lyraphase-pi'

describe 'lyraphase-pi::wifi-bridge' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  [
    'parprouted',
    'dhcp-helper',
    'avahi-daemon'
  ].each do |pkg|
    describe 'installs Proxy ARP packages' do
      describe package(pkg) do
        it { should be_installed }
      end
    end
  end

  describe 'installs Proxy ARP configuration' do
    [
      'avahi/avahi-daemon.conf',
      'default/dhcp-helper',
      'network/interfaces',
      'network/interfaces.d/wireless-bridge-dhcp-parprouted',
      'systemd/system/parprouted.service',
      'systemd/system/wpa-cli-event-handler.service'
    ].each do |etc_file_path|
      fixture_path = File.join(File.dirname(__FILE__), '..', 'test', 'fixtures', etc_file_path.split('/'))
      describe file(File.join('', 'etc', etc_file_path.split('/'))) do
        it { should be_file }
        its(:content) { should eq(File.open(fixture_path, 'r').read) }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        it { should be_mode '644' }
      end
    end
  end

  [
    'network/wireless-bridge-setup',
    'network/wireless-bridge-cleanup',
    'network/wireless-bridge-ip-clone',
    'network/wpa-supplicant-event-handler'
  ].each do |script|
    fixture_path = File.join(File.dirname(__FILE__), '..', 'test', 'fixtures', script.split('/'))
    describe "installs /etc/#{script} for ifup / ifdown" do
      describe file(File.join('', 'etc', script)) do
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        it { should be_mode '755' }
        its(:content) { should eq(File.open(fixture_path, 'r').read) }
      end
    end
  end

  describe 'Linux Kernel IPv4 Packet Forwarding' do
    describe linux_kernel_parameter('net.ipv4.ip_forward') do
      its(:value) { should eq 1 }
    end
  end
end
