describe MockCollector::EventGenerator do
  let(:server) do
    allow_any_instance_of(MockCollector::Server).to receive(:collector_type).and_return(:test)
    MockCollector::Server.new
  end

  before do
    @storage = MockCollector::Storage.new(server)

    allow(@storage).to receive(:entity_types).and_return(%i(entity))
    allow_any_instance_of(MockCollector::EntityType).to receive(:entity_class).and_return(MockCollector::Entity)

    @settings = {
      :refresh_mode  => :events,
      :events        => {
        :check_interval => 0.001,
        :checks_count   => 1,
        :per_check      => {
          :add    => 1,
          :modify => 0,
          :delete => 0
        }
      },
      :uuid_strategy => :uuids
    }
    stub_settings_merge(@settings)
  end

  it "doesn't generate entities when EntityType's watch_enabled is false" do
    entity_type = make_entity_type(:watch_enabled => false)

    entities_cnt = 0
    described_class.start(entity_type, server) do |_event|
      entities_cnt += 1
    end

    expect(entities_cnt).to eq(0)
    expect(entity_type.stats[:total].value).to eq(0)
  end

  it "generates events of the correct type" do
    %i(add modify delete).each do |event_type|
      modify_settings(:add    => event_type == :add ? 3 : 0,
                      :modify => event_type == :modify ? 3 : 0,
                      :delete => event_type == :delete ? 3 : 0)

      described_class.start(make_entity_type, server) do |event|
        expect(event.object).to be_an_instance_of(MockCollector::Event)
        expect(event.type).to eq(MockCollector::Event::OPERATIONS[event_type])
      end
    end
  end

  context "on 'add' event." do
    (0..3).each do |checks_cnt|
      (0..3).each do |added_per_check|
        it "Set checks_count to: #{checks_cnt}, #{added_per_check} entities/check added" do
          entity_type = make_entity_type

          modify_settings(:checks_count => checks_cnt,
                          :add          => added_per_check)

          #
          # Start generating of events
          #
          events_cnt = 0
          described_class.start(entity_type, server) do |event|
            # entity id is equal to last index
            expect(entity_id(event)).to eq(events_cnt)
            events_cnt += 1
          end

          expect(events_cnt).to eq(checks_cnt * added_per_check)
          expect(entity_type.stats[:total].value).to eq(events_cnt)
        end
      end
    end
  end

  %i(modify delete).each do |operation|
    context "on '#{operation}' event." do
      (0..2).each do |checks_cnt|
        (0..2).each do |changed_per_check|
          [0, 1, 10].each do |initial_entities|
            it "Set checks_count to: #{checks_cnt}, #{changed_per_check} entities/per check (#{operation}). Initial entities: #{initial_entities}" do
              entity_type = make_entity_type(:initial_entities => initial_entities)

              modify_settings(:checks_count   => checks_cnt,
                              :add            => 0,
                              :"#{operation}" => changed_per_check)

              #
              # Start generating of events
              #
              events_cnt = 0
              described_class.start(entity_type, server) do |event|
                entity_id = entity_id(event)

                case operation
                #
                # deletes first undeleted entity
                #
                when :delete then expect(entity_id).to eq(events_cnt)
                #
                # modifies first <changed_per_check> undeleted entities
                # - maximally total amount of entities
                #
                when :modify then expect(entity_id).to eq([events_cnt % changed_per_check, initial_entities - 1].min)
                end

                events_cnt += 1
              end

              # Total amount of entities doesn't change
              expect(entity_type.stats[:total].value).to eq(initial_entities)

              if operation == :delete
                # there can be maximally initial amount of events deleted
                expect(events_cnt).to eq([checks_cnt * changed_per_check, initial_entities].min)
                expect(entity_type.stats[:deleted].value).to eq(events_cnt)
              end
            end
          end
        end
      end
    end
  end

  context "on multiple simultaneous events." do
    it "Modifies first undeleted entity" do
      entity_type = make_entity_type(:initial_entities => 10)
      modify_settings(:checks_count => 5,
                      :delete       => 1,
                      :modify       => 1)

      events_cnt = {
        MockCollector::Event::OPERATIONS[:modify] => 0,
        MockCollector::Event::OPERATIONS[:delete] => 0,
      }
      described_class.start(entity_type, server) do |event|
        if event.type == MockCollector::Event::OPERATIONS[:modify]
          expect(entity_id(event)).to eq(events_cnt[MockCollector::Event::OPERATIONS[:delete]])
        end

        events_cnt[event.type] += 1
      end
    end
  end

  def make_entity_type(initial_entities: 0, watch_enabled: true)
    entity_type = MockCollector::EntityType.new(:entities, @storage, 0, initial_entities)
    allow(entity_type).to receive(:watch_enabled?).and_return(watch_enabled)
    entity_type
  end

  def modify_settings(checks_count: 0, add: 0, modify: 0, delete: 0)
    new_settings = @settings.dup
    new_settings[:events][:checks_count] = checks_count
    new_settings[:events][:per_check] = { :add    => add,
                                          :modify => modify,
                                          :delete => delete }
    stub_settings_merge(new_settings)
  end

  def entity_id(event)
    event.object&.uid.to_s.split('-').last.to_i
  end
end
