require "config"
require "topological_inventory/mock_source/collector"
require "net/http"
require "uri"
require "json"

module TopologicalInventory
  module MockSource
    class InventoryUploadWorker < TopologicalInventory::MockSource::Collector
      def initialize(source, config, data, inventory_upload_url)
        super(source, config, data)
        self.inventory_upload_uri = URI.parse(inventory_upload_url)
      end

      private

      attr_accessor :inventory_upload_uri

      BOUNDARY = "AaB03x".freeze

      def save_inventory(collections,
                         inventory_name,
                         schema,
                         refresh_state_uuid = nil,
                         refresh_state_part_uuid = nil)
        return 0 if collections.empty?

        header = {
          "Content-Type"          => "multipart/form-data;boundary=\"#{BOUNDARY}\"",
          "x-rh-insights-request" => "1",
        }.merge(identity_headers('slemrmartin'))

        file = {
          'name'        => "CloudForms",
          'schema'      => {'name' => schema_name},
          'source'      => source,
          'collections' => {}
        }

        post_body = []

        # File data
        post_body << "--#{BOUNDARY}\r\n"
        post_body << "Content-Disposition: form-data; name=\"upload\"; filename=\"mock-source.json\"\r\n"
        post_body << "Content-Type: #{content_type}\r\n\r\n"
        post_body << "#{file.to_json}\r\n"

        # Metadata
        post_body << "--#{BOUNDARY}\r\n"
        post_body << "Content-Disposition: form-data; name=\"metadata\"\r\n\r\n"
        post_body << metadata.to_json
        post_body << "\r\n--#{BOUNDARY}--\r\n"

        # Create the HTTP objects
        http = Net::HTTP.new(inventory_upload_uri.host, inventory_upload_uri.port)

        request = Net::HTTP::Post.new(inventory_upload_uri.request_uri, header)
        request.body = post_body.join

        res = http.request(request)
        puts res.body

        return 1
      rescue => err
        logger.error(err)
        raise err
      end

      def sweep_inventory(inventory_name,
                          schema,
                          refresh_state_uuid,
                          total_parts,
                          sweep_scope)
        return # if !total_parts || sweep_scope.empty?
      end

      def metadata
        {
          "schema" => {
            :name => schema_name
          }
        }
      end

      def content_type
        'application/vnd.redhat.topological-inventory.mock-source'
      end

      def identity_headers(tenant)
        {
          "x-rh-identity" => Base64.strict_encode64(
            JSON.dump({ "identity" => { "account_number" => tenant }})
          )
        }
      end
    end
  end
end
