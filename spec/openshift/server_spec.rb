describe TopologicalInventory::MockSource::Openshift::Server do
  let (:server) { described_class.new }

  context "#class_for" do
    it "finds openshift class when openshift server" do
      expect(server.class_for(:storage)).to eq(TopologicalInventory::MockSource::Openshift::Storage)
      expect(server.class_for(:collector)).to eq(TopologicalInventory::MockSource::Openshift::Collector)
    end

    it "finds general class when openshift server and openshift class doesn't exists" do
      expect(server.class_for(:entity_type)).to eq(TopologicalInventory::MockSource::EntityType)
    end
  end
end
