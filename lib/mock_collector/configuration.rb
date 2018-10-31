module MockCollector
  class Configuration
    # @@instance = self.new

    def self.instance
      @@instance ||= self.new
    end

    # protected_class_method :new

    attr_reader :references_strategy
    attr_reader :uuid_strategy

    def initialize
      # how are associations spread
      @references_strategy = :linear # or :gauss
      @uuid_strategy = :sequence_uuids # or :random_uuids
    end
  end
end
