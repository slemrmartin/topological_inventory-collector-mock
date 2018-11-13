require "bundler/setup"
require "mock_collector/openshift/collector"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

path_to_config = File.expand_path("../config/openshift", File.dirname(__FILE__))
::Config.load_and_set_settings(File.join(path_to_config, "test.yml"))
