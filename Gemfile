source 'https://rubygems.org'

plugin 'bundler-inject', '~> 1.1'
require File.join(Bundler::Plugin.index.load_paths("bundler-inject")[0], "bundler-inject") rescue nil

gem "activesupport"
gem "concurrent-ruby"
gem "config"
gem "kubeclient"
gem "more_core_extensions"
gem "optimist"
gem "recursive-open-struct"
gem "manageiq-loggers", "~> 0.1.1"
gem "topological_inventory-ingress_api-client", :git => "https://github.com/ManageIQ/topological_inventory-ingress_api-client-ruby", :branch => "master"

group :development, :test do
  gem "rspec", "~> 3.0"
end
