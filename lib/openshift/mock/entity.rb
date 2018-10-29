module Openshift
  module Mock
    class Entity
      attr_reader :namespace, :name, :ref, :uid, :resourceVersion,
                  :creationTimestamp, :deletionTimestamp

      def initialize(id)
        @internal_id = id

        @namespace = "mock-namespace" #Namespace's tmp name

        @name = "Define in subclass - #{id}"
        @uid = SecureRandom.uuid

        @resourceVersion = "1"
        @creationTimestamp = Time.now.utc
        @deletionTimestamp = nil
      end

      def metadata
        self
      end

      def reference
        @uid
      end
    end
  end
end
