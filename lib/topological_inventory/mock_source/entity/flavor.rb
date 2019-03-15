require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::Flavor < Entity
      TYPES = %i[t3_micro r5d_large].freeze

      def initialize(_id, _entity_type)
        super
        @type = TYPES.sample
      end

      def to_hash
        {
          :source_ref => @uid,
          :name       => @name,
          :cpus       => attrs_by_type[@type][:cpus],
          :disk_size  => attrs_by_type[@type][:disk_size],
          :disk_count => attrs_by_type[@type][:disk_count],
          :memory     => attrs_by_type[@type][:memory],
          :extra      => {
            :attributes => {
              :dedicatedEbsThroughput => nil,
              :physicalProcessor      => 'Intel Xeon Platinum 8175',
              :clockSpeed             => nil,
              :ecu                    => '10',
              :networkPerformance     => '10 Gigabit',
              :processorFeatures      => nil
            },
            :prices     => {
              :OnDemand => {
                :"WFMWPV2NFFRWRASD.JRTCKXETXF" => {
                  :sku             => 'WFMWPV2NFFRWRASD',
                  :efffectiveDate  => Time.new(2018, 3, 1).utc,
                  :offerTermCode   => 'JRTCKXETXF',
                  :termAttributes  => {},
                  :priceDimensions => {
                    'WFMWPV2NFFRWRASD.JRTCKXETXF.6YS6EN2CT7' => {
                      :unit         => 'Hrs',
                      :endRange     => 'Inf',
                      :rateCode     => 'WFMWPV2NFFRWRASD.JRTCKXETXF.6YS6EN2CT7',
                      :appliesTo    => %w[],
                      :beginRange   => '0',
                      :description  => '$0.144 per On Demand Linux r5d.large Instance Hour',
                      :pricePerUnit => {
                        :USD => '0.1440000000'
                      }
                    }
                  }
                }
              }
            }
          }
        }
      end

      private

      def attrs_by_type
        {
          :t3_micro  => {
            :cpus       => 2,
            :memory     => 1_073_741_824,
            :disk_count => 0,
            :disk_size  => 0,
          },
          :r5d_large => {
            :cpus       => 2,
            :memory     => 17_179_869_184,
            :disk_count => 1,
            :disk_size  => 80_530_636_800
          }
        }
      end
    end
  end
end
