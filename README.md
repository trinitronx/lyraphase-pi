lyraphase-pi cookbook
======================
[![Build Status](http://img.shields.io/travis/trinitronx/lyraphase-pi.svg)](https://travis-ci.org/trinitronx/lyraphase-pi)
[![GitHub Release](https://img.shields.io/github/release/trinitronx/lyraphase-pi.svg)](https://github.com/trinitronx/lyraphase-pi/releases)
[![Gittip](http://img.shields.io/gittip/trinitronx.svg)](https://www.gittip.com/trinitronx)

A cookbook with various recipes for Raspberry Pi

# Requirements

 - [sysctl][1] cookbook (`>=0.7.0` for Chef `<= 12`; `>= 0.9.0` for Chef `>= 13`)

**Note:** With version mismatch of Chef & `compat_resource` cookbooks, you may get errors during provisioning such as [this one](https://gist.github.com/c681ed0b74e96d5067fc61afd840fdfa):

<details><summary><code>uninitialized constant Chef::Provider::LWRPBase::InlineResources</code> (expand to see more...)</summary><p>

```
Starting Chef Client, version 13.1.31
Creating a new client identity for wifi-bridge-debian-81 using the validator key.
resolving cookbooks for run list: ["lyraphase-pi::wifi-bridge"]
Synchronizing Cookbooks:
  - lyraphase-pi (0.3.4)
  - ohai (4.1.1)
  - sysctl (0.8.0)
  - compat_resource (12.10.6)
Installing Cookbook Gems:
Compiling Cookbooks...

================================================================================
Recipe Compile Error in /tmp/kitchen/cache/cookbooks/compat_resource/libraries/autoload.rb
================================================================================

NameError
---------
uninitialized constant Chef::Provider::LWRPBase::InlineResources

Cookbook Trace:
---------------
/tmp/kitchen/cache/cookbooks/compat_resource/files/lib/chef_compat/monkeypatches/chef/provider.rb:6:in `<class:Provider>'
/tmp/kitchen/cache/cookbooks/compat_resource/files/lib/chef_compat/monkeypatches/chef/provider.rb:4:in `<top (required)>'
/tmp/kitchen/cache/cookbooks/compat_resource/files/lib/chef_compat/monkeypatches.rb:6:in `<top (required)>'
/tmp/kitchen/cache/cookbooks/compat_resource/files/lib/chef_compat/resource.rb:1:in `<top (required)>'
/tmp/kitchen/cache/cookbooks/compat_resource/files/lib/compat_resource.rb:7:in `<top (required)>'
/tmp/kitchen/cache/cookbooks/compat_resource/libraries/autoload.rb:24:in `<top (required)>'

Relevant File Content:
----------------------
/tmp/kitchen/cache/cookbooks/compat_resource/files/lib/chef_compat/monkeypatches/chef/provider.rb:

1:  require 'chef/provider'
2:  require 'chef/provider/lwrp_base'
3:
4:  class Chef::Provider
5:    if !defined?(InlineResources)
6>>     InlineResources = Chef::Provider::LWRPBase::InlineResources
7:    end
8:    module InlineResources
9:      require 'chef/dsl/recipe'
10:      require 'chef/dsl/platform_introspection'
11:      require 'chef/dsl/data_query'
12:      require 'chef/dsl/include_recipe'
13:      include Chef::DSL::Recipe
14:      include Chef::DSL::PlatformIntrospection
15:      include Chef::DSL::DataQuery

System Info:
------------
  chef_version=13.1.31
  platform=debian
  platform_version=8.1
  ruby=ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]
  program_name=chef-client worker: ppid=91;start=18:01:33;
  executable=/opt/chef/bin/chef-client
```
</p></details>


# Usage

1. Bootstrap Chef on your Raspberry Pi with [`trinitronx/raspbian_bootstrap`][pi-bootstrap].
2. Create a role for your Raspberry Pi, and include recipes for it.


```ruby
name "raspberry_pi_wifi_bridge"
description "Role applied to Raspberry Pi to setup a ProxyARP wifi-bridge."
run_list [ "lyraphase-pi::wifi-bridge" ]
```

# Attributes

  - `node['lyraphase-pi']['wifi-bridge']['packages']`: An Array of packages to install for setting up the ProxyARP WiFi bridge.

# Recipes

## lyraphase-pi::default

Blank recipe. Future use undetermined other than blank recipe for future LWRP include.

## lyraphase-pi::wifi-bridge

Recipe to Setup a [ProxyARP][2] WiFi Client Bridge on Raspberry Pi.

  - Configures `eth0` and `wlan0` for [ProxyARP][1] as a WiFi client bridge via `/etc/network/interfaces.d/wireless-bridge-dhcp-parprouted`
  - Installs ProxyARP helper packages:
    - `dhcp-helper`
    - `parprouted`
    - `avahi-daemon`
  - Adds SystemD services for:
    - `parprouted`
    - `parprouted-watchdog`
    - `wpa-cli-event-handler`
  - Adds `ifup` helper scripts to ensure network adapter state:
    - `wireless-bridge-setup`
    - `wireless-bridge-ip-clone`
    - `wireless-bridge-cleanup`

# Known Issues

  - After a variable period of time (approx ~18 hours avg), `parprouted` begins throwing the following error:
    - `error: ioctl SIOCGIFADDR for eth0: Cannot assign requested address`
  - `parprouted` eventually crashes with error:
    - `parprouted.service: main process exited, code=killed, status=6/ABRT`
  - **FIXED!** A new `parprouted-watchdog` service has been added to check for the above error every 10 seconds, and will restart `parprouted` if detected!
  - ~~Sometimes `parprouted` takes a while (~10min) before being restarted by SystemD~~

 This recipe attempts to workaround stability issues with `parprouted` by making the WiFi bridge more fault-tolerant:

  - `Restart=always` in SystemD `.service` definition
  - `wpa-supplicant-event-handler` script ensures `parprouted.service` is restarted when WiFi comes up or is Reconnected
  - Run `setup` & `cleanup` scripts on `wlan0` `post-up` & `post-down` to ensure `eth0` IP state

# Author

Author:: James Cuzella ([@trinitronx][keybase-id])

[1]: https://supermarket.chef.io/cookbooks/sysctl
[2]: https://wiki.debian.org/BridgeNetworkConnectionsProxyArp
[pi-bootstrap]: https://github.com/trinitronx/raspbian_bootstrap
[keybase-id]: https://gist.github.com/trinitronx/aee110cbdf55e67185dc44272784e694
