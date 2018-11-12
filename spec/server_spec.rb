describe MockCollector::Server do
  it "raises error when instantiated" do
    expect { described_class.new }.to raise_error(NotImplementedError)
  end
end
