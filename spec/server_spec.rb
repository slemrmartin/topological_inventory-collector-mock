describe TopologicalInventory::MockSource::Server do
  it "raises error when base class instantiated" do
    expect { described_class.new }.to raise_error(NotImplementedError)
  end

  let(:server) do
    allow_any_instance_of(TopologicalInventory::MockSource::Server).to receive(:collector_type).and_return(:test)
    described_class.new
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
