require 'tengine/support/config/definition'

class Tengine::Support::Config::Definition::Group
  include Tengine::Support::Config::Definition::HasManyChildren

  attr_reader :name
  def initialize(name, options)
    @name = name
    @options = options
  end

end
