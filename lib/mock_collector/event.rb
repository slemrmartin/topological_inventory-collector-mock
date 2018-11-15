module MockCollector
  class Event
    attr_accessor :object, :type

    OPERATIONS = {
      :added    => "ADDED",
      :modified => "MODIFIED",
      :deleted  => "DELETED"
    }.freeze
  end
end
