# Gemfile
source 'https://rubygems.org'

ruby '2.2.3'

group :test do
  gem 'rake'

  group :style do
    gem 'foodcritic', '~> 6.1'
    gem 'rubocop', '~> 0.37'
    # gem 'chef', '~> 12.5'
  end
  group :unit do
    group :update_fauxhai do
      gem 'fauxhai', '~> 3.0', github: 'customink/fauxhai', ref: 'df2cdcac2e7fd4371e85859de4815f3fcc17399c'
    end
    gem 'chefspec', '~> 4.6'
  end

  group :integration do
    gem 'berkshelf', '~> 4.3'
    gem 'test-kitchen', '~> 1.4'
    group :docker do
      gem 'kitchen-docker', '~> 2.3'
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
  gem 'rb-fsevent'
  gem 'guard', '~> 2.14'
  gem 'guard-kitchen'
  gem 'guard-foodcritic', '~> 2.1'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  #  gem 'mixlib-versioning'
end
