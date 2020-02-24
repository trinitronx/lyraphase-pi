# frozen_string_literal: true

require 'chefspec'
require 'chefspec/berkshelf'

## Wait for PR (customink/fauxhai#238) to use the Fauxhai data for ChefSpec
## Reference: https://github.com/customink/fauxhai/pull/238
RSpec.configure do |config|
  config.platform = 'raspbian'
  config.version = '8.0'

  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true
end

at_exit { ChefSpec::Coverage.report! }
