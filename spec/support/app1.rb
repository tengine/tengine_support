module App1
  class ProcessConfig
    include Tengine::Support::Config::Definition
    field :daemon, "process works on background.", :type => :boolean
    field :pid_dir, "path/to/dir for PID created.", :type => :directory
  end

  class LoggerConfig < Tengine::Support::Config::Logger
    parameter :logger_name
    depends :process_config
    depends :log_common
    field :output,
      :default => proc{
        process_config.daemon ?
        "./log/#{logger_name}.log" : "STDOUT" },
      :default_description => lambda{"if daemon process then \"./log/#{logger_name}.log\" else \"STDOUT\""}
    field :rotation,
      :default => proc{ log_common.rotation },
      :default_description => lambda{"value of #{log_common.long}-rotation"}
    field :rotation_size,
      :default => proc{ log_common.rotation_size },
      :default_description => lambda{"value of #{log_common.long}-rotation-size"}
    field :level,
      :default => proc{ log_common.level },
      :default_description => lambda{"value of #{log_common.long}-level"}
  end
end
