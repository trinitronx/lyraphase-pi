# frozen_string_literal: true

#
# Cookbook Name:: lyraphase-pi
# Spec:: default
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

describe 'lyraphase-pi::avahi-utils' do
  # See spec/spec_helper.rb for platform, platform_version setting
  context 'When all attributes are default, on an Raspbian 8.0' do
    let(:packages) { ['avahi-discover', 'avahi-utils'] }

    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'installs Avahi Utils packages' do
      packages.each do |pkg|
        expect(chef_run).to install_package(pkg)
      end
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
