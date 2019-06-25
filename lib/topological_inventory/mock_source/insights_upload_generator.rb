require "config"
require "topological_inventory/mock_source/collector"
require "net/http"
require "uri"
require "json"
require "minitar"
require "tempfile"

module TopologicalInventory
  module MockSource
    class InsightsUploadGenerator < TopologicalInventory::MockSource::Collector
      def initialize(source, config, data, insights_upload_url, tenant)
        super(source, config, data)
        # We want one big file
        self.limits              = Hash.new(100_000_000_000)
        self.insights_upload_uri = URI.parse(insights_upload_url)
        self.tenant              = tenant
      end

      private

      attr_accessor :insights_upload_uri, :tenant

      BOUNDARY = "AaB03x".freeze
      SOURCE_TYPE = "mock-source".freeze

      def save_inventory(collections,
                         inventory_name,
                         schema,
                         refresh_state_uuid = nil,
                         refresh_state_part_uuid = nil)
        return 0 if collections.empty?

        header = {
          "Content-Type"          => "multipart/form-data;boundary=\"#{BOUNDARY}\"",
          "x-rh-insights-request" => "1",
        }.merge(identity_headers(tenant))


        inventory = TopologicalInventoryIngressApiClient::Inventory.new(
          :name                    => "CloudForms",
          :schema                  => TopologicalInventoryIngressApiClient::Schema.new(:name => schema_name),
          :source_type             => SOURCE_TYPE,
          :source                  => source,
          :collections             => collections,
          :refresh_state_uuid      => refresh_state_uuid,
          :refresh_state_part_uuid => refresh_state_part_uuid
        )

        data = JSON.generate(inventory.to_hash)

        tempfile = create_tempfile(data, source)
        file = StringIO.new(String.new)
        sgz = ::Zlib::GzipWriter.new(file)
        tar = ::Minitar::Output.new(sgz)
        ::Minitar.pack_file(tempfile.path, tar)
        tar.close

        post_body = []

        # File data
        post_body << "--#{BOUNDARY}\r\n"
        post_body << "Content-Disposition: form-data; name=\"upload\"; filename=\"mock-source.json\"\r\n"
        post_body << "Content-Type: #{content_type}\r\n\r\n"
        post_body << "#{file.string}\r\n"

        # Metadata
        post_body << "--#{BOUNDARY}\r\n"
        post_body << "Content-Disposition: form-data; name=\"metadata\"\r\n\r\n"
        post_body << metadata.to_json
        post_body << "\r\n--#{BOUNDARY}--\r\n"


        # Create the HTTP objects
        http = Net::HTTP.new(insights_upload_uri.host, insights_upload_uri.port)

        request = Net::HTTP::Post.new(insights_upload_uri.request_uri, header)
        request.body = post_body.join

        res = http.request(request)
        puts res.body

        return 1
      rescue => err
        logger.error(err)
        raise err
      ensure
        tempfile.close if tempfile.present?
        tar.close if tar.present?
      end

      def sweep_inventory(inventory_name,
                          schema,
                          refresh_state_uuid,
                          total_parts,
                          sweep_scope)
      end

      def metadata
        {
          "schema" => {
            :name => schema_name
          }
        }
      end

      def content_type
        'application/vnd.redhat.topological-inventory.mock-source'.freeze
      end

      def identity_headers(tenant)
        {
          "x-rh-identity" => Base64.strict_encode64(
            JSON.dump({ "identity" => { "account_number" => tenant }, "internal" => { "org_id" => "12345" }})
          )
        }
      end

      def create_tempfile(json_data, source)
        file = Tempfile.new(source)
        file.write(json_data)
        file.rewind
        file
      end
    end
  end
end
