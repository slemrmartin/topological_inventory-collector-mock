describe MockCollector::Server do
  it "raises error when base class instantiated" do
    expect { described_class.new }.to raise_error(NotImplementedError)
  end

  let(:server) do
    described_class.any_instance.stub(:collector_type).and_return(:test)
    described_class.new
  end

  context "#class_for" do
    it "finds general class when unknown server type" do
      expect(server.class_for(:storage)).to eq(MockCollector::Storage)
    end

    it "raises error when class not found" do
      msg = "Class nonexisting doesn't exist!"
      expect { server.class_for(:nonexisting) }.to raise_error(msg)
    end
  end

  context "#watch" do
    it "can watch only allowed entity types" do
      expect(server.watch(:nonexisting)).to be_nil
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
