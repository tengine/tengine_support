require 'tengine/support/config/definition'

require 'tengine/support/yaml_with_erb'

class Tengine::Support::Config::Definition::Suite
  include Tengine::Support::Config::Definition::HasManyChildren

  def mapping(mapping = nil)
    @mapping = mapping if mapping
    @mapping
  end

  def parent; nil; end
  def root; self; end

  def load_file(filepath)
    load(YAML.load_file(filepath))
  end

  def banner(banner = nil)
    @banner = banner if banner
    @banner
  end

  def parse!(argv)
    v = Tengine::Support::Config::Definition::OptparseVisitor.new(self)
    self.accept_visitor(v)
    v.option_parser.parse(argv)
  end

  def name_array
    []
  end

end
