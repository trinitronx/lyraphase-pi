# frozen_string_literal: true

# Gemfile
source 'https://rubygems.org'

ruby '2.6.3'

group :test do
  gem 'rake'

  group :style do
    gem 'chef', '~> 13.1'
    gem 'foodcritic', '~> 16.2'
    gem 'rubocop', '>= 0.49.0'
  end
  group :unit do
    group :update_fauxhai do
      gem 'fauxhai-ng', '~> 7.6', github: 'customink/fauxhai'
    end
    gem 'chefspec', '~> 7.0'
  end

  group :integration do
    gem 'berkshelf', '~> 6.0'
    gem 'test-kitchen', '~> 2.3'
    group :docker do
      gem 'kitchen-docker', '~> 2.9'
    end
    # Use Aaron's Docker Ruby API patch to talk to docker running remotely
    # gem 'kitchen-docker', :github => 'adnichols/kitchen-docker', :branch => 'docker-ruby-api'
    # Not needed in Travis-CI
    gem 'kitchen-vagrant'
  end
end

group :development do
  #  gem 'ruby_gntp'
  gem 'growl'
  gem 'guard', '~> 2.16'
  gem 'guard-foodcritic', '~> 3.0'
  gem 'guard-kitchen'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rb-fsevent'
  #  gem 'mixlib-versioning'
end
