source 'https://rubygems.org'


group :task_runners do
  gem 'thor-foodcritic', :github => 'reset/thor-foodcritic', :ref => 'e38a99d539ff39ea2dfd6f4719ecc547c51d1a08'
  gem 'rake'
end

group :lint do
  gem 'foodcritic', '~> 4.0'
#  gem 'rubocop', '~> 0.34' # Too strict & not pragmatic... Bleh!
end

group :update_fauxhai do
  gem 'fauxhai', '~> 3.0', '>= 3.6.1', :github => 'customink/fauxhai', :branch => 'raspbian-8-fix-filepath'
end

group :unit do
  gem 'berkshelf',  '~> 4.0'
  gem 'chefspec',   '~> 4.5'
  gem 'chef', '~> 12.5'
end

group :kitchen_common do
  gem 'test-kitchen', '~> 1.4'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant', '~> 0.19'
end

group :kitchen_cloud do
  gem 'kitchen-digitalocean'
  gem 'kitchen-ec2'
end

group :development do
#  gem 'ruby_gntp'
  gem 'growl'
  gem 'rb-fsevent'
  gem 'guard', '~> 2.13'
  gem 'guard-kitchen'
  gem 'guard-foodcritic', '~> 1.1.1'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'mixlib-versioning'
end