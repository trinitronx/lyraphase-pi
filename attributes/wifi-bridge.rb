# frozen_string_literal: true

default['lyraphase-pi']['wifi-bridge']['packages'] = ['wpasupplicant', 'parprouted', 'dhcp-helper', 'avahi-daemon']
default['lyraphase-pi']['wifi-bridge']['parprouted']['skip_wireless_ip_clone'] = false
