def init_settings
  clear_settings

  path_to_config = File.expand_path("../../config", File.dirname(__FILE__))
  ::Config.load_and_set_settings(File.join(path_to_config, 'simple.yml'), File.join("#{path_to_config}/data/openshift", 'test.yml'))
end

def stub_settings_merge(hash)
  if defined?(::Settings)
    Settings.add_source!(hash)
    Settings.reload!
  end
end

def clear_settings
  ::Settings.keys.dup.each { |k| ::Settings.delete_field(k) } if defined?(::Settings)
end

init_settings
