require 'tengine/support/config'

class Tengine::Support::Config::Logger
  include Tengine::Support::Config::Definition

  field :output, 'file path or "STDOUT" / "STDERR".', :type => :string
  field :rotation, 'rotation file count or daily,weekly,monthly.', :type => :string
  field :rotation_size, 'number of max log file size.', :type => :integer
  field :level, 'debug/info/warn/error/fatal.', :type => :string

  def new_logger
    case output
    when "STDOUT" then dev = STDOUT
    when "STDERR" then dev = STDERR
    else dev = output
    end
    shift_age = (rotation =~ /\A\d+\Z/) ? rotation.to_i : rotation
    result = Logger.new(dev, shift_age, rotation_size)
    result.level = Logger.const_get(level.upcase)
    result
  end

end
