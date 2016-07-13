CHANGELOG
=========
# v0.2.1

- Major Unit & Integration Test Refactor:
  - Added Test Fixtures Upload Helper for upload to Kitchen VM
  - Added RuboCop & Configured it to be slightly less insanely OCD (based on [KentShikama/diaspora][diaspora-rubocop])
  - Fixed `kitchen-docker` integration tests for Travis CI
  - Run `kitchen-docker` containers via `privileged: true` for sysctl `/proc/sys` access to work
  - Refactor Rake tasks to take a RegExp for `test-kitchen` Instance Matching
  - Parallelize & Speed up Unit & Integration tests via ENV var Test Matrix
  - Add Integration test case for sysctl setting `net.ipv4.ip_forward=1`
  - Various Test Case Fixes
- Fix RuboCop gripes
- Fix SystemD `.service` file mode `0644`
- Create `/etc/network/interfaces.d` directory if it does not exist
- Added CHANGELOG
- Added README

[diaspora-rubocop]: https://github.com/KentShikama/diaspora/blob/8915530de12451b7b739e9122a7926b38da6514b/.rubocop.yml

# v0.2.0

- Configure `eth0` and `wlan0` for [ProxyARP][1] as WiFi client bridge in `/etc/network/interfaces.d/wireless-bridge-dhcp-parprouted`
- Install ProxyARP helper packages:
  - `dhcp-helper`
  - `parprouted`
  - `avahi-daemon`
- Added SystemD services for:
  - `parprouted`
  - `wpa-cli-event-handler`
- Added `ifup` helper scripts to ensure network adapter state:
  - `wireless-bridge-setup`
  - `wireless-bridge-ip-clone`
  - `wireless-bridge-cleanup`
- Make `parprouted` fault-tolerant via:
  - `Restart=always` in SystemD `.service` definition
  - `wpa-supplicant-event-handler` script ensures `parprouted.service` is restarted when WiFi comes up or is Reconnected
  - Run `setup` & `cleanup` scripts on `wlan0` `post-up` & `post-down` to ensure `eth0` IP state

Known Issues:
-------------

- After a variable period of time (approx ~18 hours avg), `parprouted` begins throwing the following error:
  - `error: ioctl SIOCGIFADDR for eth0: Cannot assign requested address`
- `parprouted` eventually crashes with error:
  - `parprouted.service: main process exited, code=killed, status=6/ABRT`
- Sometimes `parprouted` takes a while (~10min) before being restarted by SystemD

# v0.1.0

Initial Cookbook creation... nothing working yet except [`raspbian_bootstrap`][raspbian-bootstrap] script.

[1]: https://wiki.debian.org/BridgeNetworkConnectionsProxyArp
[raspbian-bootstrap]: https://github.com/trinitronx/raspbian_bootstrap
