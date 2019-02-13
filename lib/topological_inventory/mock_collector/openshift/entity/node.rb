require "topological_inventory/mock_collector/openshift/entity"

module TopologicalInventory
  module MockCollector
    module Openshift
      class Entity::Node < Entity
        attr_reader :status, :providerID, :annotations

        def self.status
          @@status ||= ::RecursiveOpenStruct.new(
            :capacity        => {
              :cpu             => "48",
              :"hugepages-1Gi" => "0",
              :"hugepages-2Mi" => "0",
              :memory          => "1317",
              :pods            => "250"
            },
            :allocatable     => {
              :cpu             => "48",
              :"hugepages-1Gi" => "0",
              :"hugepages-2Mi" => "0",
              :memory          => "1316",
              :pods            => "250"
            },
            :conditions      => [
              {:type => "OutOfDisk", :status => "False", :lastHeartbeatTime => "2019-01-22T11:32:05Z", :lastTransitionTime => "2018-11-27T15:56:34Z", :reason => "KubeletHasSufficientDisk", :message => "kubelet has sufficient disk space available"},
              {:type => "MemoryPressure", :status => "False", :lastHeartbeatTime => "2019-01-22T11:32:05Z", :lastTransitionTime => "2018-11-27T15:56:34Z", :reason => "KubeletHasSufficientMemory", :message => "kubelet has sufficient memory available"},
              {:type => "DiskPressure", :status => "False", :lastHeartbeatTime => "2019-01-22T11:32:05Z", :lastTransitionTime => "2018-12-31T12:08:42Z", :reason => "KubeletHasNoDiskPressure", :message => "kubelet has no disk pressure"},
              {:type => "PIDPressure", :status => "False", :lastHeartbeatTime => "2019-01-22T11:32:05Z", :lastTransitionTime => "2018-11-27T15:56:34Z", :reason => "KubeletHasSufficientPID", :message => "kubelet has sufficient PID available"},
              {:type => "Ready", :status => "True", :lastHeartbeatTime => "2019-01-22T11:32:05Z", :lastTransitionTime => "2018-11-27T20:14:59Z", :reason => "KubeletReady", :message => "kubelet is posting ready status"}
            ],
            :addresses       => [{:type => "InternalIP", :address => "10.8.96.54"},
                                 {:type => "Hostname", :address => "dell-r430-19.cloudforms.lab.eng.rdu2.redhat.com"}],
            :daemonEndpoints => {
              :kubeletEndpoint => {
                :Port => 10250
              }
            },
            :nodeInfo        => {
              :machineID               => "989443811df645019dae54d5edd8ebe9",
              :systemUUID              => "4C4C4544-0037-3210-805A-C2C04F5A4C32",
              :bootID                  => "0b76cfe5-2da0-4138-a560-803774a11144",
              :kernelVersion           => "3.10.0-957.el7.x86_64",
              :osImage                 => "3scale",
              :containerRuntimeVersion => "docker://1.13.1",
              :kubeletVersion          => "v1.11.0+d4cacc0",
              :kubeProxyVersion        => "v1.11.0+d4cacc0",
              :operatingSystem         => "linux",
              :architecture            => "amd64"
            },
            :images          => [{
                                   :names     => ["docker.io/manageiq/manageiq-ui-worker@sha256:2073c9606b048d53b7855589dfa860330d1c5c0402fe20c216fc484242ad9f43", "docker.io/manageiq/manageiq-ui-worker:latest"],
                                   :sizeBytes => 3178161349
                                 }]
          )
        end

        def initialize(_id, _entity_type)
          super

          @status     = self.class.status
          @providerID = "aws:///us-west-2b/i-02ca66d00f6485e3e"
        end

        def spec
          self
        end
      end
    end
  end
end
