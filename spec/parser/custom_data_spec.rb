describe TopologicalInventory::MockSource::Parser do
  let(:server) { TopologicalInventory::MockSource::Server.new }
  let(:amounts) do
    { :container_groups       => 2,
      :container_projects     => 2,
      :container_nodes        => 2,
      :service_offerings      => 2,
      :service_offering_tags  => 1,
      :service_offering_icons => 2,
      :source_regions         => 1}
  end
  let(:custom_display_name) { "Custom display name" }
  let(:custom_project_ref)  { "mock-containerproject-1"}

  let(:values) do
    {
      :service_offerings     => {
        :display_name          => custom_display_name,
        :service_offering_icon => {
          :source_ref => "custom_source_ref"
        }
      },
      :service_offering_tags => {
        :service_offering => nil
      },
      :container_groups => {
        :container_project => {
          :name => custom_project_ref
        },
        :container_node => nil
      }
    }
  end

  before do
    init_settings
    stub_settings_merge(:refresh_mode   => :full_refresh,
                        :multithreading => :off,
                        :data           => {
                          :amounts => amounts,
                          :values  => values
                        })
    @storage = TopologicalInventory::MockSource::Storage.new(server)
    @storage.create_entities

    @parser = TopologicalInventory::MockSource::Parser.new
  end

  it "changes data according to values" do
    entity_types = @storage.class.entity_types
    entities     = {}

    (amounts.keys & @storage.class.entity_types.keys).each do |entity_type|
      amounts[entity_type].times do |idx|
        entities[entity_type] = @storage.send(entity_type).get_entity(idx)
        @parser.parse_entity(entity_type,
                             entities[entity_type],
                             entity_types[entity_type])
      end
    end

    assert_counts
    assert_service_offerings
    assert_service_offering_tags
    assert_container_groups
  end

  def assert_counts
    amounts.each_pair do |name, amount|
      expect(@storage.send(name).stats[:total].value).to eq(amount)
      expect(@parser.collections[name].data.count).to eq(amount)
    end
  end

  # Container groups have lazy links specified by name
  def assert_container_groups
    amounts[:container_groups].times do |idx|
      container_group = @parser.collections[:container_groups].data[idx]
      expect(container_group.container_project.reference).to eq(:name => custom_project_ref)
      expect(container_group.container_node).to be_nil
    end
  end

  def assert_service_offerings
    amounts[:service_offerings].times do |idx|
      service_offering = @parser.collections[:service_offerings].data[idx]
      # same as Entity::ServiceOffering definition
      expect(service_offering.name).to eq("mock-serviceoffering-#{idx}")
      expect(service_offering.support_url).to eq("http://example.com/support/")
      # changed by settings
      expect(service_offering.display_name).to eq(custom_display_name)
      expect(service_offering.service_offering_icon.reference).to eq(:source_ref => "custom_source_ref")
    end
  end

  def assert_service_offering_tags
    amounts[:service_offering_tags].times do |idx|
      tag = @parser.collections[:service_offering_tags].data[idx]
      expect(tag.tag.reference).to eq(:name      => "mock-tag-#{idx}",
                                      :value     => idx.to_s,
                                      :namespace => 'mock-source')
      expect(tag.service_offering).to eq(nil)
    end
  end
end
