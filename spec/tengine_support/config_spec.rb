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

  class AmqpConnection
    include Tengine::Support::Config::Definition
    field :host , 'hostname to connect queue.', :default => 'localhost', :type => :string
    field :port , "port to connect queue.", :default => 5672, :type => :integer
    field :vhost, "vhost to connect queue.", :type => :string
    field :user , "username to connect queue.", :type => :string
    field :pass , "password to connect queue.", :type => :string
  end

  class AmqpExchange
    include Tengine::Support::Config::Definition
    field :name   , "exchange name.", :type => :string
    field :type   , "exchange type.", :type => :string, :default => 'direct'
    field :durable, "exchange durable.", :type => :boolean, :default => true
  end

  class AmqpQueue
    include Tengine::Support::Config::Definition
    field :name   , "queue name.", :type => :string
    field :durable, "queue durable.", :type => :boolean, :default => true
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

    context "dynamic" do
      subject do
        @suite = Tengine::Support::Config.suite do
          add(:process, App1::ProcessConfig)
          add(:db, App1::DbConfig)
          group(:event_queue) do
            add(:connection, App1::AmqpConnection)
            add(:exchange  , App1::AmqpExchange, :defaults => {:name => 'tengine_event_exchange'})
            add(:queue     , App1::AmqpQueue   , :defaults => {:name => 'tengine_event_queue'})
          end
          add(:log_common, App1::LoggerConfigCommon)
          add(:application_log, App1::LoggerConfig,
            :logger_name => "application",
            :dependencies => {
              :process_config => :process,
              :log_common => :log_common,
            },
            :defaults => {
              :rotation      => 3          ,
              :rotation_size => 1024 * 1024,
              :level         => 'info'     ,
            })
          add(:process_stdout_log, App1::LoggerConfig,
            :logger_name => "#{File.basename($PROGRAM_NAME)}_stdout",
            :process_config => :process, :log_common => :log_common)
          add(:process_stderr_log, App1::LoggerConfig,
            :logger_name => "#{File.basename($PROGRAM_NAME)}_stderr",
            :process_config => :process, :log_common => :log_common)
          mapping({
              [:process, :daemon] => :D,
              [:db, :host] => :O,
              [:db, :port] => :P,
            })
        end
        @suite
      end

      it "suite has children" do
        subject.children.map(&:name).should == [:process, :db, :event_queue, :log_common,
          :application_log, :process_stdout_log, :process_stderr_log]
      end

      it "suite returns child by name" do
        subject.child_by_name(:event_queue).should be_a(Tengine::Support::Config::Definition::Group)
      end

      it "suite returns child by name" do
        subject.child_by_name(:log_common).should be_a(App1::LoggerConfigCommon)
      end

      it "skelton" do
        subject.skelton.should == {
          :process => {
            :daemon => nil,
            :pid_dir => nil,
          },
          :db => {
            :host => 'localhost',
            :port => 27017,
          },
          :event_queue => {
            :connection => {
              :host => 'localhost',
              :port => 5672,
            },
            :exchange => {
              :name => 'tengine_event_exchange',
              :type => 'direct',
              :durable => true,
            },
            :queue => {
              :name => 'tengine_event_queue',
              :durable => true,
            },
          },

          :log_common => {
            :output        => nil        ,
            :rotation      => 3          ,
            :rotation_size => 1024 * 1024,
            :level         => 'info'     ,
          }.freeze,

          :application_log => {
            :output        => nil,
            :rotation      => nil,
            :rotation_size => nil,
            :level         => nil,
          }.freeze,

          :process_stdout_log => {
            :output        => nil,
            :rotation      => nil,
            :rotation_size => nil,
            :level         => nil,
          }.freeze,

          :process_stderr_log => {
            :output        => nil,
            :rotation      => nil,
            :rotation_size => nil,
            :level         => nil,
          }.freeze,
        }
      end
    end

  end

end
