describe MockCollector::EventGenerator do
  let(:server) do
    allow_any_instance_of(MockCollector::Server).to receive(:collector_type).and_return(:test)
    MockCollector::Server.new
  end

  before do
    entity_types = %i(entity)

    @storage = MockCollector::Storage.new(server)
    allow(@storage).to receive(:entity_types).and_return(entity_types)

    allow_any_instance_of(MockCollector::EntityType).to receive(:entity_class).and_return(MockCollector::Entity)

    @settings = {
      :refresh_mode   => :events,
      :events => {
        :check_interval => 0.001,
        :checks_count => 1,
        :per_check => {
          :add => 1,
          :modify => 0,
          :delete => 0
        }
      }
    }
    stub_settings_merge(@settings)
  end

  it "doesn't generate entities when EntityType's watch_enabled is false" do
    entity_type = MockCollector::EntityType.new(:entities, @storage, 0, 0)
    allow(entity_type).to receive(:watch_enabled?).and_return(false)

    entities_cnt = 0

    described_class.start(entity_type, server) do |_event|
      entities_cnt += 0
    end

    expect(entities_cnt).to eq(0)
    expect(entity_type.stats[:total].value).to eq(0)
  end

  # watch_enabled => false
  #
  # :multithreading => :on/:off
  # - 0 checks
  # - add
  # - - 2 checks/3 add, initial 1
  # - modify
  # - - 1 check/2 modify, initial 0
  # - - 1 check/2 modify, initial 1
  # - - 1 check/2 modify, initial 10
  # - delete
  # - - 1 check/1 delete, initial 0
  # - - 2 checks/2 deletes, initial 3
  # - - 2 checks/2 deletes, initial 10
  # - combination
  # - -
  # - indefinite check

end
