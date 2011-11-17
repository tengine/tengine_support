require 'tengine/support/config/definition'
require 'tengine/support/yaml_with_erb'

class Tengine::Support::Config::Definition::Suite
  include Tengine::Support::Config::Definition::HasManyChildren

  def mapping(names_to_short)
  end

  def parent; nil; end
  def root; self; end

  def load_file(filepath)
    load(YAML.load_file(filepath))
  end

end
