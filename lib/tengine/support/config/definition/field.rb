require 'tengine/support/config/definition'

class Tengine::Support::Config::Definition::Field
  attr_accessor :__name__, :__parent__, :__block__
  attr_accessor :type, :default_description, :default, :description
  def initialize(attrs = {})
    attrs.each{|k, v| send("#{k}=", v)}
  end

  def update(attrs)
    attrs.each{|k, v| send("#{k}=", v)}
  end

  def description_value
    [
      __parent__.get_value(description),
      __parent__.get_value(default_description)
    ].join(' ')
  end

  def default_value
    default.respond_to?(:to_proc) ? __parent__.instance_eval(&default) : default
  end

  def to_hash
    default_value
  end

  def accept_visitor(visitor)
    visitor.visit(self)
  end

  def name_array
    (__parent__ ? __parent__.name_array : []) + [__name__]
  end

  def root
    __parent__ ? __parent__.root : nil
  end

  def short_opt
    r = root.mapping[ name_array ]
    r ? "-#{r}" : nil
  end

  def long_opt
    '--' << name_array.join('-').gsub(%r{_}, '-')
  end


end
