require 'tengine/support/config'

class Tengine::Support::Config::Logger
  include Tengine::Support::Config::Definition

  field :output, 'file path or "STDOUT" / "STDERR".', :type => :string
  field :rotation, 'rotation file count or daily,weekly,monthly.', :type => :string
  field :rotation_size, 'number of max log file size.', :type => :integer
  field :level, 'debug/info/warn/error/fatal.', :type => :string

end
