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
depends 'sysctl', '~> 0.7'
