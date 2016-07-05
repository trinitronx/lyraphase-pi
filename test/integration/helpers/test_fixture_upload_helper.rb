
#require 'kitchen/driver/ssh_base'
#require 'kitchen/ssh'

## Use a .kitchen.yml ERB template include for the helper... then create a class to upload fixtures?
## https://medium.com/brigade-engineering/reduce-chef-infrastructure-integration-test-times-by-75-with-test-kitchen-and-docker-bf638ab95a0a#.h3xvlenk7



#module Kitchen 
#  module TestFixtureHelpers 
#    class TestFixture < Kitchen::Driver::SSHBase 
#
#      def upload_fixtures(state)        
         ## TODO:  Use Kitchen::SSH.upload! (sync) or Kitchen::SSH.upload (async)
         ## Upload test/fixtures/
#        container_id = state[:container_id]
#        docker_command("exec #{container_id} shutdown now")
#        docker_command("wait #{container_id}") # Wait for shutdown
#        docker_command("rm #{container_id}")
#      end
#    end
#  end
#end



# Kitchen::Provisioner upload example:
# conn.upload(sandbox_dirs, config[:root_path])
# Use config[:root_path]

# Hook into Kitchen::Verifier::Busser or Kitchen::Verifier::Base on create_sandbox?
## http://www.rubydoc.info/gems/test-kitchen/1.4.0/Kitchen/Verifier/Busser 
## http://www.rubydoc.info/gems/test-kitchen/1.4.0/Kitchen/Verifier/Base#prepare_command-instance_method
# Or Hook into: transport#upload ? (Kitchen::Busser#sync_cmd is deprecated)
## http://www.rubydoc.info/gems/test-kitchen/1.4.0/Kitchen/Transport/Base/Connection#upload-instance_method
## http://www.rubydoc.info/gems/test-kitchen/1.4.0/Kitchen/Transport/Ssh/Connection#upload-instance_method
# class MyVerifier < Kitchen::Verifier::Base
#   def create_sandbox
#     super
#     # any further file copies, preparations, etc.
#   end
# end


# # File 'lib/kitchen/verifier/busser.rb', line 66
# 66 def create_sandbox
# 67   super
# 68   prepare_helpers
# 69   prepare_suites
# 70 end

# Hacked alternative: Add more file paths to helper_files
# And let Busser copy them into the VM
## Override Kitchen::Verifier::Busser#helper_files

require "kitchen/verifier/base"

require 'kitchen/logger'

Kitchen.logger.info('Included test_fixture_upload_helper')


module TestFixtureExtensions
  # (see Base#create_sandbox)
  def create_sandbox
    super
    Kitchen.logger.info('Running Kitchen::Verifier::Busser#create_sandboxe')
    prepare_helpers
    prepare_fixtures
    prepare_suites
  end

  # Returns an Array of common helper filenames currently residing on the
  # local workstation.
  #
  # @return [Array<String>] array of helper files
  # @api private
  def fixture_files
    Kitchen.logger.info('Running Kitchen::Verifier::Busser#fixture_files')
    glob = File.join(config[:kitchen_root], 'test', 'fixtures', "**/*")
    Kitchen.logger.info("Copying test helpers / fixtures: #{Dir.glob(globs).reject{ |f| File.directory?(f)}}")
    Dir.glob(glob).reject { |f| File.directory?(f) }
  end
  # Copies all common testing helper files into the suites directory in
  # the sandbox.
  #
  # @api private
  def prepare_fixtures
    Kitchen.logger.info('Running Kitchen::Verifier::Busser#prepare_fixtures')
    base = File.join(config[:test_base_path], "fixtures")

    helper_files.each do |src|
      dest = File.join(sandbox_suites_dir, src.sub("#{base}/", ""))
      FileUtils.mkdir_p(File.dirname(dest))
      FileUtils.cp(src, dest, :preserve => true)
    end
  end
end

module Kitchen
  module Verifier
    class Busser < Kitchen::Verifier::Base
      prepend TestFixtureExtensions
    end
  end
end