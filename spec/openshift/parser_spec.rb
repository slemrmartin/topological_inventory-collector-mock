describe TopologicalInventory::Collector::Mock::Openshift::Parser do
  let(:server) { TopologicalInventory::Collector::Mock::Openshift::Server.new }

  before do
    @amounts = {
      :cluster_service_classes => 1,
      :cluster_service_plans   => 1,
      :namespaces              => 1,
      :nodes                   => 1,
      :pods                    => 1,
      :service_instances       => 1,
      :templates               => 1,
      :images                  => 1
    }

    stub_settings_merge(:refresh_mode   => :full_refresh,
                        :multithreading => :off,
                        :amounts        => @amounts)

    @storage = TopologicalInventory::Collector::Mock::Openshift::Storage.new(server)
    @storage.create_entities

    @parser = TopologicalInventory::Collector::Mock::Openshift::Parser.new
  end

  it "parses openshift mock objects correctly" do
    namespace             = @storage.namespaces.get_entity(1)
    node                  = @storage.nodes.get_entity(1)
    pod                   = @storage.pods.get_entity(1)
    image                 = @storage.images.get_entity(1)
    template              = @storage.templates.get_entity(1)
    service_instance      = @storage.service_instances.get_entity(1)
    cluster_service_class = @storage.cluster_service_classes.get_entity(1)
    cluster_service_plan  = @storage.cluster_service_plans.get_entity(1)

    @parser.parse_namespace(namespace)
    assert_container_project(namespace, @parser.collections[:container_projects].data.first)

    @parser.parse_node(node)
    assert_container_node(node, @parser.collections[:container_nodes].data.first)

    @parser.parse_pod(pod)
    assert_container_group(pod, @parser.collections[:container_groups].data.first)
    assert_container(pod, @parser.collections[:containers].data.first)

    @parser.parse_image(image)
    assert_image(image, @parser.collections[:container_images].data.first)

    @parser.parse_template(template)
    assert_template(template, @parser.collections[:container_templates].data.first)

    @parser.parse_service_instance(service_instance)
    assert_service_instance(service_instance, @parser.collections[:service_instances].data.first)

    @parser.parse_cluster_service_class(cluster_service_class)
    assert_cluster_service_class(cluster_service_class, @parser.collections[:service_offerings].data.first)

    @parser.parse_cluster_service_plan(cluster_service_plan)
    assert_cluster_service_plan(cluster_service_plan, @parser.collections[:service_plans].data.first)
  end

  private

  def assert_container_project(mock_namespace, api_container_project)
    expect(api_container_project).to be_instance_of(::TopologicalInventoryIngressApiClient::ContainerProject)
    expect(api_container_project).to have_base_attributes(mock_namespace)
    expect(api_container_project).to have_attributes(
      :display_name => nil
    )

    assert_tag(:container_project_tags, :source_ref => mock_namespace.uid)
  end

  def assert_container_node(mock_node, api_container_node)
    expect(api_container_node).to be_instance_of(::TopologicalInventoryIngressApiClient::ContainerNode)
    expect(api_container_node).to have_base_attributes(mock_node)
    expect(api_container_node).to have_attributes(
      :cpus   => mock_node.status.capacity.cpu,
      :memory => mock_node.status.capacity.memory.to_i,
    )
    assert_lazy_object(api_container_node.lives_on, :uid_ems => mock_node.providerID.split("/").last)
    assert_tag(:container_node_tags, :source_ref => mock_node.uid)
  end

  def assert_container_group(mock_pod, api_container_group)
    expect(api_container_group).to be_instance_of(::TopologicalInventoryIngressApiClient::ContainerGroup)
    expect(api_container_group).to have_base_attributes(mock_pod)

    expect(api_container_group).to have_attributes(
      :ipaddress => mock_pod.status.podIP
    )
    assert_lazy_object(api_container_group.container_node, :name => mock_pod.spec.nodeName)
    assert_lazy_object(api_container_group.container_project, :name => mock_pod.metadata.namespace)

    assert_tag(:container_group_tags, :source_ref => mock_pod.metadata.uid)
  end

  def assert_container(mock_pod, api_container)
    mock_container = mock_pod.spec.containers.first
    expect(mock_container).not_to be_nil

    expect(api_container).to be_instance_of(::TopologicalInventoryIngressApiClient::Container)
    expect(api_container).to have_attributes(
      :name           => mock_container.name,
      :cpu_limit      => mock_container.resources.limits.cpu.to_i,
      :cpu_request    => mock_container.resources.requests.cpu.to_i,
      :memory_limit   => mock_container.resources.limits.memory.to_i,
      :memory_request => mock_container.resources.requests.memory.to_i
    )

    assert_lazy_object(api_container.container_group, :source_ref => mock_pod.metadata.uid)
    assert_lazy_object(api_container.container_image, :source_ref => mock_container.image)
  end

  def assert_image(mock_image, api_container_image)
    expect(api_container_image).to be_instance_of(::TopologicalInventoryIngressApiClient::ContainerImage)

    expect(api_container_image).to have_attributes(
      :name              => "jboss-webserver-3/webserver30-tomcat8-openshift",
      :resource_version  => mock_image.resourceVersion,
      :source_created_at => mock_image.creationTimestamp,
      :source_deleted_at => mock_image.deletionTimestamp,
      :source_ref        => mock_image.uid
    )

    assert_tag(:container_image_tags, { :source_ref => mock_image.uid }, {:tags_count => 26})
  end

  def assert_template(mock_template, api_container_template)
    expect(api_container_template).to be_instance_of(::TopologicalInventoryIngressApiClient::ContainerTemplate)

    expect(api_container_template).to have_base_attributes(mock_template)

    assert_lazy_object(api_container_template.container_project, :name => mock_template.metadata.namespace)
    assert_tag(:container_template_tags, :source_ref => mock_template.uid)
  end

  def assert_service_instance(mock_service_instance, api_service_instance)
    expect(api_service_instance).to be_instance_of(::TopologicalInventoryIngressApiClient::ServiceInstance)

    expect(api_service_instance).to have_attributes(
      :name              => mock_service_instance.spec.externalName,
      :source_ref        => mock_service_instance.spec.externalID,
      :source_created_at => mock_service_instance.metadata.creationTimestamp,
      :source_region     => nil,
      :subscription      => nil
    )

    assert_lazy_object(api_service_instance.service_offering, :source_ref => mock_service_instance.spec.clusterServiceClassRef.name)
    assert_lazy_object(api_service_instance.service_plan, :source_ref => mock_service_instance.spec.clusterServicePlanRef.name)
  end

  def assert_cluster_service_class(mock_cluster_svc_class, api_service_offering)
    expect(api_service_offering).to be_instance_of(TopologicalInventoryIngressApiClient::ServiceOffering)

    expect(api_service_offering).to have_attributes(
      :name              => mock_cluster_svc_class.spec.externalName,
      :source_ref        => mock_cluster_svc_class.spec.externalID,
      :description       => mock_cluster_svc_class.spec.description,
      :display_name      => mock_cluster_svc_class.externalMetadata.displayName,
      :documentation_url => mock_cluster_svc_class.externalMetadata.documentationUrl,
      :long_description  => mock_cluster_svc_class.externalMetadata.longDescription,
      :distributor       => mock_cluster_svc_class.externalMetadata.providerDisplayName,
      :support_url       => mock_cluster_svc_class.externalMetadata.supportUrl,
      :source_created_at => mock_cluster_svc_class.metadata.creationTimestamp,
      :source_region     => nil,
      :subscription      => nil,
    )

    assert_lazy_object(api_service_offering.service_offering_icon, :source_ref => nil)
  end

  def assert_cluster_service_plan(mock_cluster_svc_plan, api_service_plan)
    expect(api_service_plan).to be_instance_of(TopologicalInventoryIngressApiClient::ServicePlan)

    expect(api_service_plan).to have_attributes(
      :name               => mock_cluster_svc_plan.spec.externalName,
      :source_ref         => mock_cluster_svc_plan.spec.externalID,
      :description        => mock_cluster_svc_plan.spec.description,
      :resource_version   => mock_cluster_svc_plan.metadata.resourceVersion,
      :source_created_at  => mock_cluster_svc_plan.metadata.creationTimestamp,
      :create_json_schema => mock_cluster_svc_plan.spec.instanceCreateParameterSchema,
      :update_json_schema => nil,
      :source_region      => nil,
      :subscription       => nil
    )

    assert_lazy_object(api_service_plan.service_offering, :source_ref => mock_cluster_svc_plan.spec.clusterServiceClassRef.name)
  end

  def assert_tag(tag_collection_name, reference, tags_count: 1)
    api_tag = @parser.collections[tag_collection_name].data.first

    assert_tags_common(tag_collection_name, :tags_count => tags_count)

    # skip suffix to get parent collection reference name
    key_name_to_parent = tag_collection_name.to_s.gsub("_tags", "").to_sym
    assert_lazy_object(api_tag.send(key_name_to_parent), reference)
  end

  # Helpers -------------

  def have_base_attributes(mock_entity)
    have_attributes(
      :name              => mock_entity.name,
      :resource_version  => mock_entity.resourceVersion,
      :source_created_at => mock_entity.creationTimestamp,
      :source_deleted_at => mock_entity.deletionTimestamp,
      :source_ref        => mock_entity.uid
    )
  end

  def assert_tags_common(tag_collection_name, tags_count: 1)
    expect(@parser.collections[tag_collection_name].data.count).to eq(tags_count)

    # Tag class
    api_class_name = "TopologicalInventoryIngressApiClient::#{tag_collection_name.to_s.classify}"
    api_tag = @parser.collections[tag_collection_name].data[0]
    expect(api_tag.class.name).to eq(api_class_name)

    # Name/value
    assert_lazy_object(api_tag.tag, :name => :"mock/openshift")
    expect(api_tag.value).to eq("true")
  end

  def assert_lazy_object(lazy_object, reference)
    expect(lazy_object).not_to be_nil
    expect(lazy_object.reference).to eq(reference)
  end
end
