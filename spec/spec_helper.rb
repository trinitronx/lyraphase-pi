require 'chefspec'
require 'chefspec/berkshelf'

## Wait for PR (customink/fauxhai#238) to use the Fauxhai data for ChefSpec
## Reference: https://github.com/customink/fauxhai/pull/238
#RSpec.configure do |config|
#  config.platform = 'raspbian'
#  config.version = '8.0'
#end

at_exit { ChefSpec::Coverage.report! }
