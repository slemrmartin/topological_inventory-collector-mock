describe MockCollector::Openshift::Server do
  let (:server) { described_class.new }

  context "#class_for" do
    it "finds openshift class when openshift server" do
      expect(server.class_for(:storage)).to eq(MockCollector::Openshift::Storage)
      expect(server.class_for(:collector)).to eq(MockCollector::Openshift::Collector)
    end

    it "finds general class when openshift server and openshift class doesn't exists" do
      expect(server.class_for(:entity_type)).to eq(MockCollector::EntityType)
    end
  end
end
