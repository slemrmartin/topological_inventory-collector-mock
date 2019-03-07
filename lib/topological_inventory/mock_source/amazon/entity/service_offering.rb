require "topological_inventory/mock_source/amazon/entity"

module TopologicalInventory
  module MockSource
    module Amazon
      class Entity::ServiceOffering < Entity
        def to_hash
          {
            :source_ref               => @uid,
            :name                     => @name,
            :description              => @name,
            :display_name             => "Sample Service Offering #{@ref_id}",
            :source_created_at        => @creationTimestamp,
            :source_region_source_ref => link_to(:source_regions),
            :extra                    => {
              :status               => "CREATED",
              :product_arn          => "arn:aws:catalog:us-east-1:200278856672:product/prod-4v6rc4hwaiiha",
              :product_view_summary => {
                :id                => "prodview-mojlvmp5xax74",
                :name              => "EmsRefreshSpecProductWithNoPortfolio",
                :type              => "CLOUD_FORMATION_TEMPLATE",
                :owner             => "EmsRefreshSpecProductWithNoPortfolioOwner",
                :product_id        => "prod-4v6rc4hwaiiha",
                :distributor       => "",
                :has_default_path  => false,
                :short_description => "EmsRefreshSpecProductWithNoPortfolio desc"
              }
            }
          }
        end
      end
    end
  end
end
