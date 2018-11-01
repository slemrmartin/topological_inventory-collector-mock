module MockCollector
  class Configuration
    def self.instance
      @@instance ||= self.new
    end

    attr_reader :references_strategy
    attr_reader :uuid_strategy

    def initialize
      # how are associations spread
      @references_strategy = :linear # or :gauss
      @uuid_strategy = :sequence_uuids # or :random_uuids
    end
  end
end
