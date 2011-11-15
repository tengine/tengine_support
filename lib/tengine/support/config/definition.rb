require 'tengine/support/config'

module Tengine::Support::Config::Definition
  class << self
    def included(klass)
      klass.extend(ClassMethods)
    end
  end

  module ClassMethods
    def fields
      @fields ||= {}
    end

    def field(name, *args)
      attrs = args.last.is_a?(Hash) ? args.pop : {}
      if field = fields[name]
        field.update(attrs)
      else
        attrs[:description] = args.first
        attrs[:name] = name
        field = Field.new(attrs)
        fields[name] = field
        (class << self; self; end).module_eval do
          define_method(field.name){ field }
        end
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
