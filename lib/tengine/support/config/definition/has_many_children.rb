require 'tengine/support/config/definition'

module Tengine::Support::Config::Definition::HasManyChildren

  def children
    @children ||= []
  end

  def child_by_name(__name__)
    __name__= __name__.to_sym if __name__.respond_to?(:to_sym)
    children.detect{|child| child.__name__ == __name__}
  end

  def find(name_array)
    name_array = Array(name_array)
    head = name_array.shift
    if child = child_by_name(head)
      name_array.empty? ? child : child.find(name_array)
    else
      nil
    end
  end

  def add(__name__, klass, options = {}, &block)
    result = klass.new
    result.__parent__ = self
    result.__name__ = __name__
    result.instantiate_children

    dependencies = options[:dependencies] || {}
    klass.definition_reference_names.each do |res_name|
      name_array = dependencies[res_name]
      raise "missing dependency of #{__name__.inspect} in :dependencies options to add(#{__name__.inspect}, #{klass.name}...)" unless name_array
      obj = root.find(Array(name_array))
      raise "#{name_array.inspect} not found" unless obj
      result.send("#{res_name}=", obj)
    end

    (options[:parameters] || {}).each do |param, value|
      result.send("#{param}=", value)
    end

    defaults = options[:defaults] || {}
    defaults.each do |key, value|
      child = result.child_by_name(key)
      raise "child not found for #{key.inspct} in #{result.__name__}" unless child
      child.default = value if value
    end

    children << result
    (class << self; self; end).class_eval{ define_method(__name__){ result } }
    result.instance_eval(&block) if block
    result
  end

  def group(__name__, options = {}, &block)
    result = Tengine::Support::Config::Definition::Group.new(__name__, options)
    result.__parent__ = self
    (class << self; self; end).class_eval{ define_method(__name__){ result } }
    children << result
    result.instance_eval(&block) if block
    result
  end

  def field(__name__, *args, &block)
    attrs = args.last.is_a?(Hash) ? args.pop : {}
    attrs[:description] = args.first unless args.empty?
    attrs.update({
        :__name__ => __name__,
        :__parent__ => self,
        :__block__ => block,
        :__type__ => attrs[:__type__] || :field,
      })
    if field = children.detect{|child| child.__name__ == __name__}
      new_field = field.dup
      new_field.update(attrs)
      idx = self.children.index(field)
      self.children[idx] = new_field
      field = new_field
    else
      field = Tengine::Support::Config::Definition::Field.new(attrs)
      self.children << field
    end
    (class << self; self; end).module_eval do
      attr_accessor field.__name__
    end
  end

  def action(__name__, *args, &block)
    attrs = args.last.is_a?(Hash) ? args.pop : {}
    attrs.update({
        :__name__ => __name__,
        :__parent__ => self,
        :__block__ => block,
        :__type__ => :action,
      })
    attrs[:description] = args.first unless args.empty?
    field = Tengine::Support::Config::Definition::Field.new(attrs)
    self.children << field
  end
  alias_method :__action__, :action

  def action?; false; end

  def separator(description)
    attrs = {
      :description => description,
      :__name__ => :"separator#{children.count + 1}",
      :__parent__ => self,
      :__type__ => :separator,
    }
    field = Tengine::Support::Config::Definition::Field.new(attrs)
    self.children << field
  end

  def separator?; false; end

  def load_config(name, *args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    options[:type] = :load_config
    args << options
    field(name, *args)
  end

  def to_hash
    children.inject({}) do |dest, child|
      unless child.action? || child.separator?
        value = child.to_hash
        unless value.is_a?(Hash) && value.empty?
          dest[child.__name__] = child.to_hash
        end
      end
      dest
    end
  end

  def load(hash)
    hash.each do |__name__, value|
      child = child_by_name(__name__)
      raise "child not found for #{__name__.inspect} on #{__name__}" unless child
      if child.is_a?(Tengine::Support::Config::Definition::Field)
        self.send("#{__name__}=", value)
      else
        child.load(value)
      end
    end
  end

  def accept_visitor(visitor)
    visitor.visit(self)
  end

  def name_array
    (__parent__ ? __parent__.name_array : []) + [__name__]
  end

  def get_value(obj)
    obj.is_a?(Proc) ? self.instance_eval(&obj) : obj
  end

  def [](child_name)
    child = child_by_name(child_name)
    if child.is_a?(Tengine::Support::Config::Definition::Field)
      self.send(child_name)
    else
      child
    end
  end

  def []=(child_name, value)
    child = child_by_name(child_name)
    if child.is_a?(Tengine::Support::Config::Definition::Field)
      self.send("#{child_name}=", value)
    else
      raise ArgumentError, "can't replace #{child_name.inspect}"
    end
  end

end
