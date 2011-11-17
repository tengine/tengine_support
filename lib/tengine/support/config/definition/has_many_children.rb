require 'tengine/support/config/definition'

module Tengine::Support::Config::Definition::HasManyChildren

  def children
    @children ||= []
  end

  def child_by_name(name)
    children.detect{|child| child.name == name}
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

  def add(name, klass, options = {}, &block)
    result = klass.new
    result.parent = self
    result.name = name
    result.instantiate_children

    dependencies = options[:dependencies] || {}
    klass.definition_reference_names.each do |res_name|
      name_array = dependencies[res_name]
      raise "missing dependency of #{name.inspect} in :dependencies options to add(#{name.inspect}, #{klass.name}...)" unless name_array
      obj = root.find(Array(name_array))
      raise "#{name_array.inspect} not found" unless obj
      result.send("#{res_name}=", obj)
    end

    defaults = options[:defaults] || {}
    defaults.each do |key, value|
      child = result.child_by_name(key)
      raise "child not found for #{key.inspct} in #{result.name}" unless child
      child.default = value
    end

    children << result
    result.instance_eval(&block) if block
    result
  end

  def group(name, options = {}, &block)
    result = Tengine::Support::Config::Definition::Group.new(name, options)
    result.parent = self
    children << result
    result.instance_eval(&block) if block
    result
  end

  def field(name, *args)
    attrs = args.last.is_a?(Hash) ? args.pop : {}
    attrs[:description] = args.first unless args.empty?
    attrs[:name] = name
    attrs[:parent] = self
    if field = children.detect{|child| child.name == name}
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
      attr_accessor field.name
    end
  end

  def to_hash
    children.inject({}) do |dest, child|
      dest[child.name] = child.to_hash
      dest
    end
  end



end
