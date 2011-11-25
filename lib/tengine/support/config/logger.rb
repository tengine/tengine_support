# -*- coding: utf-8 -*-
require 'tengine/support/config'
require 'active_support/hash_with_indifferent_access'

class Tengine::Support::Config::Logger
  include Tengine::Support::Config::Definition

  field :output, 'file path or "STDOUT" / "STDERR" / "NULL".', :type => :string, :default => "STDOUT"
  field :rotation, 'rotation file count or daily,weekly,monthly.' # , :type => :string
  field :rotation_size, 'number of max log file size.', :type => :integer
  field :level, 'Logging severity threshold.', :type => :string,
    :enum => %w[debug info warn error fatal],
    :default => "info"

  field :progname, 'program name to include in log messages.', :type => :string
  field :datetime_format, 'A string suitable for passing to strftime.', :type => :string

  # formatterにはprocしか設定できないので特別設定ファイルやコマンドラインオプションで指定することはできません。
  # もしformatteを指す名前を指定したい場合は、別途定義したfieldをから求めたformatterの値を、
  # オーバーライドしたnew_loggerで設定するようにしてください。
  attr_accessor :formatter
  # field :formatter, 'Logging formatter, as a Proc that will take four arguments and return the formatted message.',
  #   :type => :proc, :hidden => true

  def new_logger(options = {})
    options = ActiveSupport::HashWithIndifferentAccess.new(to_hash).update(options || {})
    case output = options[:output]
    when "NULL" then return Tengine::Support::NullLogger.new
    when "STDOUT" then dev = STDOUT
    when "STDERR" then dev = STDERR
    else dev = output
    end
    rotation = options[:rotation]
    shift_age = (rotation =~ /\A\d+\Z/) ? rotation.to_i : rotation
    result = ::Logger.new(dev, shift_age, options[:rotation_size])
    result.level = ::Logger.const_get(options[:level].to_s.upcase)
    dtf = options[:datetime_format]
    result.datetime_format = dtf if dtf
    progname = options[:progname]
    result.progname = progname if progname
    result
  end

end
