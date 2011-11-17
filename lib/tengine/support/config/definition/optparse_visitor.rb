# -*- coding: utf-8 -*-
require 'tengine/support/config/definition'

require 'optparse' # ここ以外でrequireしないし、関係するクラスを記述しません。

class Tengine::Support::Config::Definition::OptparseVisitor

  attr_reader :option_parser
  def initialize(suite)
    @option_parser = OptionParser.new
    @suite = suite
  end

  alias_method :o, :option_parser

  def visit(d)
    case d
    when Tengine::Support::Config::Definition::Suite then
      option_parser.banner = d.banner
      d.children.each{|child| child.accept_visitor(self)}
    when Tengine::Support::Config::Definition::Group then
      o.separator ""
      o.separator "#{d.__name__}:"
      d.children.each{|child| child.accept_visitor(self)}
    when Tengine::Support::Config::Definition then
      o.separator ""
      o.separator "#{d.__name__}:"
      d.children.each{|child| child.accept_visitor(self)}
    when Tengine::Support::Config::Definition::Field then
      desc = d.description_value
      long_opt = d.long_opt
      args = [d.short_opt, long_opt, desc.respond_to?(:call) ? desc.call : desc].compact
      case d.type
      when :boolean then
        o.on(*args){d.__parent__.send("#{d.__name__}=", true)}
      else
        long_opt << "=VAL"
        if default_value = d.default_value
          long_opt << " default: #{default_value.inspect}"
        end
        o.on(*args){|val| d.__parent__.send("#{d.__name__}=", val)}
      end

    else
      raise "Unsupported definition class #{d.class.name}"
    end

  end
end
