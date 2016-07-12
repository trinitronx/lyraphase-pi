#!/usr/bin/env rake

require 'bundler/setup'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
# http://acrmp.github.com/foodcritic/
require 'foodcritic'

task default: %i(style spec)
task test: [:default]

# Style tests. Knife, Rubocop and Foodcritic
namespace :style do
  # http://wiki.opscode.com/display/chef/Managing+Cookbooks+With+Knife#ManagingCookbooksWithKnife-test
  desc 'Test cookbooks via knife'
  task :knife do
    cookbook_path = ENV['TRAVIS_BUILD_DIR'] ? ENV['TRAVIS_BUILD_DIR'] + '/../' : '.././'
    sh "knife cookbook test -c test/.chef/knife.rb -o #{cookbook_path} -a"
  end

  desc 'Run RuboCop style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {fail_tags: ['correctness'], tags: ['~FC023'], context: true}
  end
end

desc 'Run all style checks'
task style: ['style:knife', 'style:chef', 'style:ruby']

# http://berkshelf.com/
desc 'Install Berkshelf to local cookbooks path'
task :berks do
  sh %(berks vendor cookbooks)
end

# https://github.com/acrmp/chefspec
# Rspec and ChefSpec
desc 'Run ChefSpec Unit Tests'
RSpec::Core::RakeTask.new(:spec)
# Alias for rake spec
task chefspec: %i(spec)

# Integration tests. Kitchen.ci
namespace :integration do
  desc 'Run Test Kitchen integration tests with Vagrant'
  task :vagrant do
    require 'kitchen'
    Kitchen.logger = Kitchen.default_file_logger
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end
  desc 'Run Test Kitchen integration tests with kitchen-docker'
  task :docker do
    require 'kitchen'
    Kitchen.logger = Kitchen.default_file_logger
    @loader = Kitchen::Loader::YAML.new(local_config: '.kitchen.docker.yml')
    Kitchen::Config.new(loader: @loader).instances.each do |instance|
      instance.test(:always)
    end
  end
end

desc 'Run all tests on Travis'
task travis: ['style', 'spec', 'integration:docker']
