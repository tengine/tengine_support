require 'tengine/support/config'

require 'active_support/core_ext/class/attribute'

module Tengine::Support::Config::Definition
  class << self
    def included(klass)
      klass.extend(ClassMethods)
      klass.class_eval do
        self.class_attribute :definition_fields, :instance_reader => false, :instance_writer => false
        self.definition_fields = {}
      end
    end
  end

  module ClassMethods

    def field(name, *args)
      attrs = args.last.is_a?(Hash) ? args.pop : {}
      attrs[:description] = args.first unless args.empty?
      attrs[:name] = name
      if superclass.is_a?(Tengine::Support::Config::Definition) &&
          (self.definition_fields == self.superclass.definition_fields)
        self.definition_fields = self.superclass.definition_fields.dup
      end
      if field = definition_fields[name]
        field = field.dup
        field.update(attrs)
      else
        field = Field.new(attrs)
      end
      self.definition_fields[name] = field
      (class << self; self; end).module_eval do
        define_method(field.name){ field }
      end
    end

    def parameter(name)
    end

    def depends(definition_reference_name)
    end
  end

  class Field
    attr_accessor :name, :type, :default_description, :default
    attr_writer :description
    def initialize(attrs = {})
      attrs.each{|k, v| send("#{k}=", v)}
    end

    def update(attrs)
      attrs.each{|k, v| send("#{k}=", v)}
    end

    def description
      if default_description.is_a?(Proc)
        lambda{ @description + default_description.call }
      else
        @description
      end
    end
  end


end
