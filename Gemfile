# Gemfile
source 'https://rubygems.org'

group :test do
  group :style do
    gem 'foodcritic', '~> 6.1'
    gem 'rubocop', '~> 0.37'
    # gem 'chef', '~> 12.5'
  end
  group :unit do
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
