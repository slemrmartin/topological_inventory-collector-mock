describe MockCollector::EventGenerator do
  let(:server) do
    MockCollector::Server.any_instance.stub(:collector_type).and_return(:test)
    MockCollector::Server.new
  end

  before do
    entity_types = %i(entity)

    @storage = MockCollector::Storage.new(server)
    allow(@storage).to receive(:entity_types).and_return(entity_types)

    MockCollector::EntityType.any_instance.stub(:entity_class).and_return(MockCollector::Entity)

    stub_settings_merge(:refresh_mode   => :events,
                        :multithreading => :off)
  end

  it "doesn't generate entities when EntityType's watch_enabled is false" do
    entity_type = MockCollector::EntityType.new(:entities, @storage, 0, 0)
    allow(entity_type).to receive(:watch_enabled?).and_return(false)

    stub_settings_merge(:events => {
      :check_interval => 0.1,
      :per_check => {
        :added => 1,
        :modified => 0,
        :deleted => 0
      }
    })
    entities_cnt = 0

    described_class.start(entity_type, server) do |_event|
      entities_cnt += 1
    end

    expect(entities_cnt).to eq(0)
    expect(entity_type.stats[:total].value).to eq(0)
  end
end
