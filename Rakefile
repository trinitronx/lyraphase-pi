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
  # Gets a collection of instances.
  #
  # @param regexp [String] regular expression to match against instance names.
  # @param config [Hash] configuration values for the `Kitchen::Config` class.
  # @return [Collection<Instance>] all instances.
  def kitchen_instances(regexp, config)
    instances = Kitchen::Config.new(config).instances
    return instances if regexp.nil? || regexp == 'all'
    instances.get_all(Regexp.new(regexp))
  end

  # Runs a test kitchen action against some instances.
  #
  # @param action [String] kitchen action to run (defaults to `'test'`).
  # @param regexp [String] regular expression to match against instance names.
  # @param loader_config [Hash] loader configuration options.
  # @return void
  def run_kitchen(action, regexp, loader_config={})
    action = 'test' if action.nil?
    require 'kitchen'
    Kitchen.logger = Kitchen.default_file_logger
    config = {loader: Kitchen::Loader::YAML.new(loader_config)}
    kitchen_instances(regexp, config).each { |i| i.send(action) }
  end

  desc 'Run integration tests with kitchen-vagrant'
  task :vagrant, [:regexp, :action] do |_t, args|
    run_kitchen(args.action, args.regexp)
  end

  desc 'Run integration tests with kitchen-docker'
  task :docker, [:regexp, :action] do |_t, args|
    run_kitchen(args.action, args.regexp, local_config: '.kitchen.docker.local.yml')
  end
end

desc 'Run all unit tests on Travis'
task travis: ['style', 'spec']
