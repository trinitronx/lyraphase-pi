# frozen_string_literal: true

name 'lyraphase-pi'
maintainer 'James Cuzella'
maintainer_email 'james.cuzella@lyraphase.com'
license 'GPL-3.0'
description 'Installs/Configures lyraphase-pi'
long_description 'Installs/Configures lyraphase-pi'
version '0.3.4'
chef_version '>= 12.0' if respond_to?(:chef_version)
issues_url 'https://github.com/trinitronx/lyraphase-pi/issues'
source_url 'https://github.com/trinitronx/lyraphase-pi'

supports 'debian'

require 'chef/version'
require 'chef/version_constraint'
unless respond_to?(:chef_version) && Chef::VersionConstraint.new('>= 14.0').include?(Chef::VERSION.to_s)
  depends 'sysctl', '~> 0.7' # ~FC121
end
