def build_suite1
  Tengine::Support::Config.suite do
    banner <<EOS
Usage: config_test [-k action] [-f path_to_config]
         [-H db_host] [-P db_port] [-U db_user] [-S db_pass] [-B db_database]

EOS

    field(:action, "test|load|start|enable|stop|force-stop|status|activate", :type => :string, :default => "start")
    field(:config, "path/to/config_file", :type => :string)
    add(:process, App1::ProcessConfig)
    add(:db, Tengine::Support::Config::Mongoid::Connection, :defaults => {:database => "tengine_production"})
    group(:event_queue) do
      add(:connection, Tengine::Support::Config::Amqp::Connection)
      add(:exchange  , Tengine::Support::Config::Amqp::Exchange, :defaults => {:name => 'tengine_event_exchange'})
      add(:queue     , Tengine::Support::Config::Amqp::Queue   , :defaults => {:name => 'tengine_event_queue'})
    end
    add(:log_common, Tengine::Support::Config::Logger,
      :defaults => {
        :rotation      => 3          ,
        :rotation_size => 1024 * 1024,
        :level         => 'info'     ,
      })
    add(:application_log, App1::LoggerConfig,
      :logger_name => "application",
      :dependencies => { :process_config => :process, :log_common => :log_common,})
    add(:process_stdout_log, App1::LoggerConfig,
      :logger_name => "#{File.basename($PROGRAM_NAME)}_stdout",
      :dependencies => { :process_config => :process, :log_common => :log_common,})
    add(:process_stderr_log, App1::LoggerConfig,
      :logger_name => "#{File.basename($PROGRAM_NAME)}_stderr",
      :dependencies => { :process_config => :process, :log_common => :log_common,})
    separator("\nGeneral:")
    __action__(:version, "show version"){ STDOUT.puts "1.1.1"; exit }
    __action__(:help   , "show this help message"){ STDOUT.puts option_parser.help; exit }

    mapping({
        [:action] => :k,
        [:process, :daemon] => :D,
        [:db, :host] => :O,
        [:db, :port] => :P,
        [:db, :username] => :U,
        [:db, :password] => :S,
      })
  end

end

