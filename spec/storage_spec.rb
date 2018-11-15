describe MockCollector::Storage do
  let(:server) do
    MockCollector::Server.any_instance.stub(:collector_type).and_return(:test)
    MockCollector::Server.new
  end

  before do
   @storage = described_class.new(server)
  end

  context "#entity types" do
    before do
      @entity_types = %i(entity1 entity2)

      allow(@storage).to receive(:entity_types).and_return(@entity_types)

      MockCollector::EntityType.any_instance.stub(:entity_class).and_return(nil)
    end

    it "creates entity types based on list" do
      @storage.create_entities

      @entity_types.each do |key|
        expect(@storage.entities).to have_key(key)
      end
    end

    it "access entity types by method missing" do
      @storage.create_entities

      expect(@storage.entity1).to be_kind_of(MockCollector::EntityType)
      expect(@storage.respond_to?(:entity3)).to eq(false)
    end
  end
end
