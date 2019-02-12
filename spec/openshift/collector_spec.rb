describe TopologicalInventory::Collector::Mock::Openshift::Collector do
  before do
    @collector = described_class.new(nil, "test")
  end

  context "full refresh" do
    before do
      @amounts = {
        :cluster_service_classes => 2,
        :cluster_service_plans   => 5,
        :namespaces              => 2,
        :nodes                   => 5,
        :pods                    => 10,
        :service_instances       => 10,
        :templates               => 5
      }

      stub_settings_merge(:refresh_mode   => :full_refresh,
                          :multithreading => :off,
                          :amounts        => @amounts)
    end

    it "sets created entities values correctly" do
      # expect(::Settings.refresh_mode).to eq(:full_refresh)
      # allow(@collector).to receive(:save_inventory).and_return(nil)
      #
      # @collector.collect_sequential!
      #
      # @amounts.each_pair do |entity_type, cnt|
      #   entity_type = @collector.connection.send("get_#{entity_type}")
      #
      #   expect(entity_type).not_to be_nil
      #   expect(entity_type.stats[:total].value).to eq(cnt)
      #
      #   expect(@collector.parser.collections[entity_type].data.size).to eq(cnt)
      # end
    end

    it "creates inventory collection with data" do
    end
  end
end
