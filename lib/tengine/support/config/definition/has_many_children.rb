require 'tengine/support/config/definition'

module Tengine::Support::Config::Definition::HasManyChildren

  def children
    @children ||= []
  end

  def child_by_name(name)
    children.detect{|child| child.name == name}
  end

  def add(name, klass, options = {}, &block)
    result = klass.new
    result.name = name
    children << result
    result.instance_eval(&block) if block
    result
  end

  def group(name, options = {}, &block)
    result = Tengine::Support::Config::Definition::Group.new(name, options)
    children << result
    result.instance_eval(&block) if block
    result
  end

end
