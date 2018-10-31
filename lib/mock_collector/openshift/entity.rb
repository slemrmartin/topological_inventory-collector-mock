require_relative "../entity"

module MockCollector
  class Openshift::Entity < Entity
    attr_reader :namespace

    def initialize(id, server)
      super
      @namespace = "mock-namespace-1"
    end

    def metadata
      self
    end
  end
end
