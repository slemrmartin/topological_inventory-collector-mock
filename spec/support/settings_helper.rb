path_to_config = File.expand_path("../../config/openshift", File.dirname(__FILE__))
::Config.load_and_set_settings(File.join(path_to_config, "test.yml"))

def stub_settings_merge(hash)
  Settings.add_source!(hash)
  Settings.reload!
end
