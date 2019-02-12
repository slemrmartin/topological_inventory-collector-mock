require "topological_inventory/collector/mock/openshift/entity"

module TopologicalInventory
  module Collector
    module Mock
      module Openshift
        class Entity::Image < Entity
          attr_reader :selfLink,
                      :dockerImageReference,
                      :dockerImageMetadata,
                      :dockerImageMetadataVersion,
                      :dockerImageLayers,
                      :dockerImageManifestMediaType

          def initialize(_id, _entity_type)
            super

            # metadata
            @selfLink                     = "/oapi/v1/images/sha256%3A0089883f8e4387618946cd24378a447b8cf7e5dfaa146b94acab27fc5e170a14"
            @annotations                  = {
              :"image.openshift.io/dockerLayersOrder" => "ascending"
            }
            @dockerImageReference         = "registry.redhat.io/jboss-webserver-3/webserver30-tomcat8-openshift@sha256:0089883f8e4387618946cd24378a447b8cf7e5dfaa146b94acab27fc5e170a14"
            @dockerImageMetadata          = docker_image_metadata
            @dockerImageMetadataVersion   = "1.0"
            @dockerImageLayers            = docker_image_layers
            @dockerImageManifestMediaType = "application/vnd.docker.distribution.manifest.v1+json"
          end

          def docker_image_metadata
            RecursiveOpenStruct.new(
              :kind            => "DockerImage",
              :apiVersion      => "1.0",
              :Id              => "decb6b8b6affa31f7d8f89a6a90046179fbc8e148961b509490efa640f012f08",
              :Parent          => "0c74ac4727ef46fa57d9e5ed91189ba3d4f81004cdcc146c3a5011e2d4e0bad5",
              :Created         => "2017-10-23T13:49:54Z",
              :ContainerConfig => {
                :Hostname     => "d40e837f250b",
                :User         => "185",
                :ExposedPorts => {
                  :"8080/tcp" => {},
                  :"8443/tcp" => {},
                  :"8778/tcp" => {}
                },
                :Env          => ["PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin", "container=oci",
                                  "JBOSS_IMAGE_NAME=jboss-webserver-3/webserver30-tomcat8-openshift", "JBOSS_IMAGE_VERSION=1.3",
                                  "HOME=/home/jboss", "JAVA_TOOL_OPTIONS=-Duser.home=/home/jboss -Duser.name=jboss", "JAVA_HOME=/usr/lib/jvm/java-1.8.0",
                                  "JAVA_VENDOR=openjdk", "JAVA_VERSION=1.8.0", "JBOSS_PRODUCT=webserver", "JBOSS_WEBSERVER_VERSION=3.0.3",
                                  "PRODUCT_VERSION=3.0.3", "TOMCAT_VERSION=8.0.18", "JWS_HOME=/opt/webserver",
                                  "CATALINA_OPTS=-Djava.security.egd=file:/dev/./urandom", "JPDA_ADDRESS=8000", "STI_BUILDER=jee",
                                  "AB_JOLOKIA_PASSWORD_RANDOM=true", "AB_JOLOKIA_AUTH_OPENSHIFT=true", "AB_JOLOKIA_HTTPS=true"],
                :Cmd          => ["/bin/sh", "-c", "#(nop) ", "USER [185]"],
                :Image        => "sha256:5585e63ee21f2f0cc27111d71ee65ab350fcfdf5f70626c4edf4c9f963bb4d62",
                :WorkingDir   => "/home/jboss",
                :Labels       => {
                  :architecture                   => "x86_64",
                  :"authoritative-source-url"     => "registry.access.redhat.com",
                  :"build-date"                   => "2017-10-23T13:43:33.689484",
                  :"com.redhat.build-host"        => "ip-10-29-120-186.ec2.internal",
                  :"com.redhat.component"         => "jboss-webserver-3-webserver30-tomcat8-openshift-docker",
                  :"com.redhat.deployments-dir"   => "/opt/webserver/webapps",
                  :"com.redhat.dev-mode"          => "DEBUG:true",
                  :"com.redhat.dev-mode.port"     => "JPDA_ADDRESS:8000",
                  :description                    => "Platform for building and running web applications on JBoss Web Server 3.0 - Tomcat v8",
                  :"distribution-scope"           => "public",
                  :"io.k8s.description"           => "Platform for building and running web applications on JBoss Web Server 3.0 - Tomcat v8",
                  :"io.k8s.display-name"          => "JBoss Web Server 3.0",
                  :"io.openshift.expose-services" => "8080:http",
                  :"io.openshift.s2i.scripts-url" => "image:///usr/local/s2i",
                  :"io.openshift.tags"            => "builder,java,tomcat8",
                  :maintainer                     => "Cloud Enablement Feedback <cloud-enablement-feedback@redhat.com>",
                  :name                           => "jboss-webserver-3/webserver30-tomcat8-openshift",
                  :"org.jboss.deployments-dir"    => "/opt/webserver/webapps",
                  :release                        => "15",
                  :summary                        => "Red Hat JBoss Web Server 3.0 Tomcat 8 container image",
                  :url                            => "https://access.redhat.com/containers/#/registry.access.redhat.com/jboss-webserver-3/webserver30-tomcat8-openshift/images/1.3-15",
                  :"vcs-ref"                      => "6bfd90eb5fa98ca5b716832757a8089735f253de",
                  :"vcs-type"                     => "git",
                  :vendor                         => "Red Hat, Inc.",
                  :version                        => "1.3"
                }
              },
              :DockerVersion   => "1.12.6",
              :Config          => {
                :Hostname     => "d40e837f250b",
                :User         => "185",
                :ExposedPorts => {
                  :"8080/tcp" => {},
                  :"8443/tcp" => {},
                  :"8778/tcp" => {}
                },
                :Env          => ["PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin", "container=oci",
                                  "JBOSS_IMAGE_NAME=jboss-webserver-3/webserver30-tomcat8-openshift", "JBOSS_IMAGE_VERSION=1.3", "HOME=/home/jboss",
                                  "JAVA_TOOL_OPTIONS=-Duser.home=/home/jboss -Duser.name=jboss", "JAVA_HOME=/usr/lib/jvm/java-1.8.0",
                                  "JAVA_VENDOR=openjdk", "JAVA_VERSION=1.8.0", "JBOSS_PRODUCT=webserver", "JBOSS_WEBSERVER_VERSION=3.0.3",
                                  "PRODUCT_VERSION=3.0.3", "TOMCAT_VERSION=8.0.18", "JWS_HOME=/opt/webserver",
                                  "CATALINA_OPTS=-Djava.security.egd=file:/dev/./urandom", "JPDA_ADDRESS=8000", "STI_BUILDER=jee",
                                  "AB_JOLOKIA_PASSWORD_RANDOM=true", "AB_JOLOKIA_AUTH_OPENSHIFT=true", "AB_JOLOKIA_HTTPS=true"],
                :Cmd          => ["/opt/webserver/bin/launch.sh"],
                :Image        => "13acb68974f9a9e236d1c206ff4e88dcd3ebf3f3c5bfd89918e8a9568abb0cdf",
                :WorkingDir   => "/home/jboss",
                :Labels       => {
                  :architecture                   => "x86_64",
                  :"authoritative-source-url"     => "registry.access.redhat.com",
                  :"build-date"                   => "2017-10-23T13:43:33.689484",
                  :"com.redhat.build-host"        => "ip-10-29-120-186.ec2.internal",
                  :"com.redhat.component"         => "jboss-webserver-3-webserver30-tomcat8-openshift-docker",
                  :"com.redhat.deployments-dir"   => "/opt/webserver/webapps",
                  :"com.redhat.dev-mode"          => "DEBUG:true",
                  :"com.redhat.dev-mode.port"     => "JPDA_ADDRESS:8000",
                  :description                    => "Platform for building and running web applications on JBoss Web Server 3.0 - Tomcat v8",
                  :"distribution-scope"           => "public",
                  :"io.k8s.description"           => "Platform for building and running web applications on JBoss Web Server 3.0 - Tomcat v8",
                  :"io.k8s.display-name"          => "JBoss Web Server 3.0",
                  :"io.openshift.expose-services" => "8080:http",
                  :"io.openshift.s2i.scripts-url" => "image:///usr/local/s2i",
                  :"io.openshift.tags"            => "builder,java,tomcat8",
                  :maintainer                     => "Cloud Enablement Feedback <cloud-enablement-feedback@redhat.com>",
                  :name                           => "jboss-webserver-3/webserver30-tomcat8-openshift",
                  :"org.jboss.deployments-dir"    => "/opt/webserver/webapps",
                  :release                        => "15",
                  :summary                        => "Red Hat JBoss Web Server 3.0 Tomcat 8 container image",
                  :url                            => "https://access.redhat.com/containers/#/registry.access.redhat.com/jboss-webserver-3/webserver30-tomcat8-openshift/images/1.3-15",
                  :"vcs-ref"                      => "6bfd90eb5fa98ca5b716832757a8089735f253de",
                  :"vcs-type"                     => "git", :vendor => "Red Hat, Inc.", :version => "1.3"
                }
              },
              :Architecture    => "amd64",
              :Size            => 195722350
            )
          end

          def docker_image_layers
            [
              {:name => "sha256:26e5ed6899dbf4b1e93e0898255e8aaf43465cecd3a24910f26edb5d43dafa3c", :size => 74865036, :mediaType => "application/vnd.docker.container.image.rootfs.diff+x-gtar"},
              {:name => "sha256:66dbe984a319ca6d40dc10c2c561821128a0bd8967e0cbd8cc2a302736041ffb", :size => 1238, :mediaType => "application/vnd.docker.container.image.rootfs.diff+x-gtar"},
              {:name => "sha256:78f9ea175a0a36eeccd5399d82c03146149c4d6ad6afa134cb314c7d3be7dab9", :size => 3639500, :mediaType => "application/vnd.docker.container.image.rootfs.diff+x-gtar"},
              {:name => "sha256:39fe8b1d3a9cb13a361204c23cf4e342d53184b4440492fa724f4aeb4eb1d64f", :size => 70072211, :mediaType => "application/vnd.:docker.container.image.rootfs.diff+x-gtar"},
              {:name => "sha256:f591071b502f5c9eda5bff0f5d5adff911075d3be7081c86aa3b3690879ccb20", :size => 12731825, :mediaType => "application/vnd.docker.container.image.rootfs.diff+x-gtar"},
              {:name => "sha256:5d448162298455ec38635223e668573d6f0c1a5f4b46ae5dd54e1e0b30de83ab", :size => 34412540, :mediaType => "application/vnd.docker.container.image.rootfs.diff+x-gtar"}
            ]
          end
        end
      end
    end
  end
end
