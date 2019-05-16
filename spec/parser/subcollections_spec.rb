describe TopologicalInventory::MockSource::Parser do
  let(:server) { TopologicalInventory::MockSource::Server.new }

  (1..3).each do |projects_count|
    (0..6).each do |project_tags_count|
      context "with settings Projects count: #{projects_count}, Project tags count: #{project_tags_count}" do
        before do
          @amounts = {
            :container_projects     => projects_count,
            :container_project_tags => project_tags_count
          }

          init_settings
          stub_settings_merge(:refresh_mode   => :full_refresh,
                              :multithreading => :off,
                              :data           => { :amounts => @amounts })
          @storage = TopologicalInventory::MockSource::Storage.new(server)
          @storage.create_entities

          @parser = TopologicalInventory::MockSource::Parser.new
        end

        it "creates correct number of tags" do
          entity_types = @storage.class.entity_types

          (0..@amounts[:container_projects] - 1).each do |idx|
            container_project = @storage.container_projects.get_entity(idx)
            @parser.parse_entity(:container_projects,
                                 container_project,
                                 entity_types[:container_projects])
          end

          assert_tags_count(project_tags_count)
        end

        def assert_tags_count(project_tags_count)
          expect(@storage.container_project_tags.stats[:total].value).to eq(project_tags_count)
          expect(@parser.collections[:container_project_tags].data.count).to eq(project_tags_count)
        end
      end
    end
  end
end
