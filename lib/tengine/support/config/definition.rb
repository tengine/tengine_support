require 'tengine/support/config'

require 'active_support/core_ext/class/attribute'

module Tengine::Support::Config::Definition
  autoload :Field, 'tengine/support/config/definition/field'
  autoload :Group, 'tengine/support/config/definition/group'
  autoload :Suite, 'tengine/support/config/definition/suite'
  autoload :HasManyChildren, 'tengine/support/config/definition/has_many_children'

  class << self
    def included(klass)
      klass.extend(ClassMethods)
      klass.class_eval do
        self.class_attribute :children, :instance_writer => false
        self.children = {}
      end
    end
  end

  module ClassMethods
    def field(name, *args)
      attrs = args.last.is_a?(Hash) ? args.pop : {}
      attrs[:description] = args.first unless args.empty?
      attrs[:name] = name
      if superclass.is_a?(Tengine::Support::Config::Definition) &&
          (self.children == self.superclass.children)
        self.children = self.superclass.children.dup
      end
      if field = children[name]
        field = field.dup
        field.update(attrs)
      else
        field = Field.new(attrs)
      end
      self.children[name] = field
      (class << self; self; end).module_eval do
        define_method(field.name){ field }
      end
    end

    def parameter(name)
    end

    def depends(definition_reference_name)
    end
  end

  attr_accessor :name

  def skelton
    children.inject({}) do |dest, (name, child)|
      dest[name] = child.skelton
      dest
    end
  end

end
