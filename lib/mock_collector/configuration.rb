module MockCollector
  class Configuration
    def self.instance
      @@instance ||= self.new
    end

    attr_reader :references_strategy
    attr_reader :uuid_strategy

    def initialize
      # how are associations spread
      @references_strategy = :modulo # :linear or :gauss
      @uuid_strategy = :human_uids # or :sequence_uuids, :random_uuids
    end
  end
end
