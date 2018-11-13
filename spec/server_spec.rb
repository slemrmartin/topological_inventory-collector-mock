describe MockCollector::Server do
  it "raises error when base class instantiated" do
    expect { described_class.new }.to raise_error(NotImplementedError)
  end

  let(:server) { MockCollector::Openshift::Server.new }

  context "#class_for" do
    it "finds openshift class when openshift server" do
      expect(server.class_for(:storage)).to eq(MockCollector::Openshift::Storage)
      expect(server.class_for(:event_generator)).to eq(MockCollector::Openshift::EventGenerator)
    end

    it "finds general class when openshift server and openshift class doesn't exists" do
      expect(server.class_for(:entity_type)).to eq(MockCollector::EntityType)
    end

    it "finds general class when unknown server type" do
      fake_server = MockCollector::Openshift::Server.new
      allow(fake_server).to receive(:collector_type).and_return(:fake_server)

      expect(fake_server.class_for(:storage)).to eq(MockCollector::Storage)
    end

    it "raises error when class not found" do
      msg = "Class nonexisting doesn't exist!"
      expect { server.class_for(:nonexisting) }.to raise_error(msg)
    end
  end

  context "#method_missing" do
    it "responds_to get_* methods" do
      %w(one two three).each do |name|
        expect { server.send("get_#{name}") }.not_to raise_error
      end
    end

    it "raises NoMethodError on non-get_* methods" do
      %w(one two three).each do |name|
        expect(server.respond_to?(name)).to eq(false)
        expect { server.send(name) }.to raise_error(NoMethodError)
      end
    end
  end
end
