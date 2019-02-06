require "mock_collector/openshift/entity"

module MockCollector
  module Openshift
    class Entity::Namespace < Entity
      attr_reader :annotations, :status

      def initialize(_id, _entity_type)
        super

        # metadata
        @annotations = annotations_data
        @status = { :phase => "Active" }
      end

      def annotations_data
        {
          :"openshift.io/description"                => "description-#{@ref_id}",
          :"openshift.io/display-name"               => @name,
          :"openshift.io/requester"                  => "admin",
          :"openshift.io/sa.scc.mcs"                 => "s0:c25,c0",
          :"openshift.io/sa.scc.supplemental-groups" => "1000600000/10000",
          :"openshift.io/sa.scc.uid-range"           => "1000600000/10000"
        }
      end
    end
  end
end
