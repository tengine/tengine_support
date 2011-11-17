require 'tengine/support/config/definition'

class Tengine::Support::Config::Definition::Field
  attr_accessor :__name__, :parent
  attr_accessor :type, :default_description, :default
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

  def default_value
    default.respond_to?(:to_proc) ? parent.instance_eval(&default) : default
  end

  def to_hash
    default_value
  end

end
