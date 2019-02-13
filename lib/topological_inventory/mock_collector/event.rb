module TopologicalInventory
  module MockCollector
    class Event
      attr_accessor :object, :type

      OPERATIONS = {
        :add    => "ADDED",
        :modify => "MODIFIED",
        :delete => "DELETED"
      }.freeze
    end
  end
end
