require "mock_collector/server"
require "mock_collector/openshift/storage"

module MockCollector
  class Openshift::Server < Server
    # Collector type for deriving class names
    def collector_type
      :openshift
    end
  end
end
