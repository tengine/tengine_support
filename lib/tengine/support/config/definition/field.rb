require 'tengine/support/config/definition'

class Tengine::Support::Config::Definition::Field
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
