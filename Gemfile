source 'https://rubygems.org'

plugin 'bundler-inject', '~> 1.1'
require File.join(Bundler::Plugin.index.load_paths("bundler-inject")[0], "bundler-inject") rescue nil

gem "activesupport", '~> 5.2.4.3'
gem "concurrent-ruby"
gem "config"
gem "kubeclient"
gem "more_core_extensions"
gem "optimist"
gem "recursive-open-struct"
gem "topological_inventory-ingress_api-client", :git => "https://github.com/RedHatInsights/topological_inventory-ingress_api-client-ruby", :branch => "master"
gem "topological_inventory-providers-common",   :git => "https://github.com/RedHatInsights/topological_inventory-providers-common", :branch => "master"

group :development, :test do
  gem "rspec", "~> 3.0"
  gem "rubocop",             "~> 1.0.0", :require => false
  gem "rubocop-performance", "~> 1.8",   :require => false
  gem "rubocop-rails",       "~> 2.8",   :require => false
  gem "simplecov",           "~> 0.17.1"
end
