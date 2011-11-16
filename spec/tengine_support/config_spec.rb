# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module App1
  class DbConfig
    include Tengine::Support::Config::Definition
    field :host, 'hostname to connect db.', :default => 'localhost', :type => :string
    field :port, "port to connect db.", :default => 5672, :type => :integer
  end

  class ProcessConfig
    include Tengine::Support::Config::Definition
    field :daemon, "process works on background.", :type => :boolean
    field :pid_dir, "path/to/dir for PID created.", :type => :directory
  end

  class LoggerConfigCommon
    include Tengine::Support::Config::Definition
    field :output, 'file path or "STDOUT" / "STDERR".', :type => :string
    field :rotation, 'rotation file count or daily,weekly,monthly.', :type => :string
    field :rotation_size, 'number of max log file size.', :type => :integer
    field :level, 'debug/info/warn/error/fatal.', :type => :string
  end

  class LoggerConfig < LoggerConfigCommon
    parameter :logger_name
    depends :process_config
    depends :log_common

    field :output,
      :default => lambda{ process_config.daemon ? "./log/#{logger_name}.log" : "STDOUT" },
      :default_description => lambda{"if daemon process then \"./log/#{logger_name}.log\" else \"STDOUT\""}
    field :rotation,
      :default => lambda{ log_common.rotation },
      :default_description => lambda{"value of #{log_common.long}-rotation"}
    field :rotation_size,
      :default => lambda{ log_common.rotation_size },
      :default_description => lambda{"value of #{log_common.long}-rotation-size"}
    field :level,
      :default => lambda{ log_common.level },
      :default_description => lambda{"value of #{log_common.long}-level"}
  end
end

describe "config" do

  context "app1 setting" do
    context "static" do
      describe App1::DbConfig.host do
        it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
        its(:type){ should == :string }
        its(:name){ should == :host }
        its(:description){ should == 'hostname to connect db.'}
        its(:default){ should == 'localhost'}
      end

      describe App1::DbConfig.port do
        it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
        its(:type){ should == :integer }
        its(:name){ should == :port }
        its(:description){ should == 'port to connect db.'}
        its(:default){ should == 5672}
      end

      describe App1::ProcessConfig.daemon do
        it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
        its(:type){ should == :boolean }
        its(:name){ should == :daemon }
        its(:description){ should == 'process works on background.'}
        its(:default){ should == nil}
      end

      describe App1::ProcessConfig.pid_dir do
        it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
        its(:type){ should == :directory }
        its(:name){ should == :pid_dir }
        its(:description){ should == 'path/to/dir for PID created.'}
        its(:default){ should == nil}
      end

      describe App1::LoggerConfigCommon.output do
        it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
        its(:type){ should == :string }
        its(:name){ should == :output }
        its(:description){ should == 'file path or "STDOUT" / "STDERR".'}
        its(:default){ should == nil}
      end

      describe App1::LoggerConfig.output do
        it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
        its(:type){ should == :string }
        its(:name){ should == :output }
        its(:description){ should be_a(Proc)}
        its(:default){ should be_a(Proc)}
      end

    end

#     context "dynamic" do
#       before do
#         root = Tengine::Support::Config.define do
#           group(:basic) do
#             add(:db, App1::DbConfig)
#             add(:process, App1::ProcessConfig)
#             add(:log_common, App1::LoggerConfigCommon)
#             add(:application_log, App1::LoggerConfig,
#               :logger_name => "application",
#               :process_config => :process, :log_common => :log_common)
#             add(:process_stdout_log, App1::LoggerConfig,
#               :logger_name => "#{File.basename($PROGRAM_NAME)}_stdout",
#               :process_config => :process, :log_common => :log_common)
#             add(:process_stderr_log, App1::LoggerConfig,
#               :logger_name => "#{File.basename($PROGRAM_NAME)}_stderr",
#               :process_config => :process, :log_common => :log_common)
#           end
#           short_for({
#               :D => [:basic, :process, :daemon],
#               :O => [:basic, :db, :host],
#               :P => [:basic, :db, :port],
#             })
#         end
#       end
#     end

  end

end
