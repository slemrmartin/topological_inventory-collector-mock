require "manageiq/loggers"

module TopologicalInventory
  module MockSource
    class << self
      attr_writer :logger
    end

    def self.logger
      # @logger ||= ManageIQ::Loggers::Container.new
      @logger ||= Logger.new(STDOUT)
      @logger.level = Logger::DEBUG
      @logger
    end

    module Logging
      def logger
        TopologicalInventory::MockSource.logger
      end
    end
  end
end
