require 'tengine/support/config/definition'

class Tengine::Support::Config::Definition::Suite
  include Tengine::Support::Config::Definition::HasManyChildren

  def mapping(names_to_short)
  end

  def parent; nil; end
  def root; self; end

end
