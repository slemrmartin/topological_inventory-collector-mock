module MockCollector
  module Openshift
    class Notice
      attr_accessor :object, :type

      OPERATIONS = {
        :added    => "ADDED",
        :modified => "MODIFIED",
        :deleted  => "DELETED"
      }.freeze
    end
  end
end
