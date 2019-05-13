describe TopologicalInventory::MockSource::EntityType do
  let(:server) do
    allow_any_instance_of(TopologicalInventory::MockSource::Server).to receive(:collector_type).and_return(:test)
    TopologicalInventory::MockSource::Server.new
  end

  let(:storage) { TopologicalInventory::MockSource::Storage.new(server) }

  before do
    allow_any_instance_of(TopologicalInventory::MockSource::EntityType).to receive(:entity_class).and_return(TopologicalInventory::MockSource::Entity)

    stub_settings_merge(:data             => {
                          :amounts => { :entities => 1 }
                        },
                        :uuid_strategy    => :uuids,
                        :resource_version => {
                          :strategy => :timestamp
                        })

    @entity_type = described_class.new("test", storage, 0, 0)
  end

  context "generating entities" do
    it "creates entity with ID after initial value" do
      (0..2).each do |initial_amount|
        et = described_class.new("test", storage, 0, initial_amount)

        expect(et.stats[:total].value).to eq(initial_amount)

        entity = et.add_entity
        expect(entity.ref_id).to eq(initial_amount)

        expect(et.stats[:total].value).to eq(initial_amount + 1)
      end
    end

    it "creates entity with incrementing ID" do
      (0..10).each do |i|
        expect(@entity_type.stats[:total].value).to eq(i)

        entity = @entity_type.add_entity

        expect(entity.ref_id).to eq(i)
      end
    end
  end

  context "accessing entities" do
    it "can return entity with any ID" do
      [0, 10, 100].each do |i|
        expect(@entity_type.stats[:total].value).to eq(0)

        entity = @entity_type.get_entity(i)

        expect(entity.ref_id).to eq(i)
      end
    end
  end

  context "modifying entities" do
    it "can modify only 'existing' entity" do
      entity = @entity_type.modify_entity(100)
      expect(entity).to be_nil
    end

    it "changes resource_version" do
      3.times { @entity_type.add_entity }

      resource_version_before = @entity_type.get_entity(1).resource_version
      sleep(1)
      resource_version_after = @entity_type.modify_entity(1).resource_version

      expect(resource_version_before < resource_version_after).to be(true)
    end
  end

  context "archiving entities" do
    it "archives first unarchived entity" do
      10.times { @entity_type.add_entity }

      expect(@entity_type.stats[:deleted].value).to eq(0)
      3.times do |i|
        entity = @entity_type.archive_entity

        expect(entity.ref_id).to eq(i)
        expect(@entity_type.stats[:deleted].value).to eq(i + 1)
      end
    end

    it "doesn't return archived entity bigger than maximum entities" do
      @entity_type.add_entity

      expect(@entity_type.stats[:total].value).to eq(1)

      entity = @entity_type.archive_entity
      expect(entity.ref_id).to eq(0)

      entity = @entity_type.archive_entity
      expect(entity).to be_nil
      expect(@entity_type.stats[:deleted].value).to eq(1)
    end
  end

  context "pagination" do
    it "has to be prepared each round" do
      10.times { @entity_type.add_entity }

      # returns first 5 existing entities
      @entity_type.prepare_for_pagination(5, 0)
      amount = 0
      @entity_type.each do |entity|
        expect(entity.ref_id).to eq(amount)
        amount += 1
      end
      expect(amount).to eq(5)

      # returns last 5 existing entities (exceeding range)
      amount, offset = 0, 5
      @entity_type.prepare_for_pagination(10, offset)
      @entity_type.each do |entity|
        expect(entity.ref_id).to eq(amount + offset)
        amount += 1
      end
      expect(amount).to eq(5)
    end

    it "should return first entity after last call of each until last entity reached" do
      10.times { @entity_type.add_entity }

      amount, limit, offset = 0, 8, 0

      until @entity_type.last?
        @entity_type.prepare_for_pagination(limit, offset)
        @entity_type.each do |entity|
          expect(entity.ref_id).to eq(amount)
          amount += 1
        end

        expected_continue = [limit + offset, @entity_type.stats[:total].value].min
        expect(@entity_type.continue).to eq(expected_continue)
        offset = @entity_type.continue
      end

      expect(amount).to eq(10)
    end
  end
end
