require 'tengine/support/config/definition'

class Tengine::Support::Config::Definition::Group
  include Tengine::Support::Config::Definition::HasManyChildren

  attr_reader :__name__
  attr_accessor :parent

  def initialize(__name__, options)
    @__name__ = __name__
    @options = options
  end

  def root
    parent.root
  end

end
