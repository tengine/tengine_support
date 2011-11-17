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
        self.class_attribute :children, :instance_writer => false, :instance_reader => false
        self.children = []

        self.class_attribute :definition_reference_names, :instance_writer => false
        self.definition_reference_names = []
      end
    end
  end

  module ClassMethods
    def field(name, *args)
      attrs = args.last.is_a?(Hash) ? args.pop : {}
      attrs[:description] = args.first unless args.empty?
      attrs[:name] = name
      attrs[:parent] = self

      if (superclass < Tengine::Support::Config::Definition) &&
          (self.children == self.superclass.children)
        self.children = self.superclass.children.dup
      end
      if field = children.detect{|child| child.name == name}
        new_field = field.dup
        new_field.update(attrs)
        idx = self.children.index(field)
        self.children[idx] = new_field
        field = new_field
      else
        field = Field.new(attrs)
        self.children << field
      end
      (class << self; self; end).module_eval do
        define_method(field.name){ field }
      end
      self.class_eval do
        attr_accessor field.name
      end
    end

    def parameter(name)
    end

    def depends(*definition_reference_names)
      if superclass.is_a?(Tengine::Support::Config::Definition) &&
          (self.definition_reference_names == self.superclass.definition_reference_names)
        self.definition_reference_names = self.superclass.definition_reference_names.dup
      end
      self.class_eval do
        definition_reference_names.each do |ref_name|
          attr_accessor ref_name
        end
      end
      self.definition_reference_names += definition_reference_names
    end
  end

  attr_accessor :name, :parent, :children

  def instantiate_children
    @children = self.class.children.map do |class_child|
      child = class_child.dup
      child.parent = self
      child
    end
  end

  def child_by_name(name)
    children.detect{|child| child.name == name}
  end

  def to_hash
    children.inject({}) do |dest, child|
      dest[child.name] = child.to_hash
      dest
    end
  end

end
