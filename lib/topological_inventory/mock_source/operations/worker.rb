require "topological_inventory/mock_source/logging"
require "topological_inventory-api-client"

module TopologicalInventory
  module MockSource
    module Operations
      class Worker
        include TopologicalInventory::MockSource::Logging

        def initialize
          self.payload = {}
        end

        def run
          create_mock_source
        end

        private

        attr_accessor :payload

        def create_mock_source
          source = post_source
          post_endpoint(source)
        end

        def post_source
          source = TopologicalInventoryApiClient::Source.new(
            :name           => "Mock Source",
            :source_type_id => '1',
            :tenant_id      => '1',
            :uid            => SecureRandom.uuid,
            :version        => nil
          )

          data, status_code, headers = api_client.create_source_with_http_info(source)
          logger.info("Data: #{data.inspect}")
          logger.info("Status code: #{status_code.inspect}")
          logger.info("Headers: #{headers.inspect}")
          data
        end

        def post_endpoint(source)
          # now host and path should be mock-collector args "config" and "amounts"
          endpoint = TopologicalInventoryApiClient::Endpoint.new(
            :certificate_authority => nil,
            :default               => true,
            :host                  => 'default', # TODO: create jsonb column to store yaml config here
            :path                  => 'default',
            :port                  => nil,
            :role                  => nil,
            :scheme                => nil,
            :source_id             => source[:id].to_s,
            :tenant_id             => source[:tenant_id].to_s,
            :verify_ssl            => false
          )
          data, status_code, headers = api_client.create_endpoint_with_http_info(endpoint)
          logger.info("Data: #{data.inspect}")
          logger.info("Status code: #{status_code.inspect}")
          logger.info("Headers: #{headers.inspect}")
          data
        end

        def api_client
          @api_client ||=
            begin
              api_client = TopologicalInventoryApiClient::ApiClient.new
              api_client.default_headers.merge!(payload["identity"]) if payload["identity"].present?
              TopologicalInventoryApiClient::DefaultApi.new(api_client)
            end
        end
      end
    end
  end
end
