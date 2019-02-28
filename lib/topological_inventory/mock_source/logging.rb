require "manageiq/loggers"

module TopologicalInventory
  module MockSource
    class << self
      attr_writer :logger
    end

    def self.logger
      @logger ||= ManageIQ::Loggers::Container.new
    end

    module Logging
      def logger
        TopologicalInventory::MockSource.logger
      end
    end
  end
end
