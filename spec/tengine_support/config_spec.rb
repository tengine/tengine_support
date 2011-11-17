# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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

describe "config" do

  context "app1 setting" do
    context "static" do

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
    end

    context "dynamic" do
      subject do
        @suite = Tengine::Support::Config.suite do
          field(:action, "test|load|start|enable|stop|force-stop|status|activate", :type => :string)
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
          mapping({
              [:process, :daemon] => :D,
              [:db, :host] => :O,
              [:db, :port] => :P,
            })
        end
        @suite
      end

      it "suite has children" do
        subject.children.map(&:name).should == [
          :action, :config,
          :process, :db, :event_queue, :log_common,
          :application_log, :process_stdout_log, :process_stderr_log]
      end

      context "suite returns child by name" do
        {
          :process => App1::ProcessConfig,
          :db => Tengine::Support::Config::Mongoid::Connection,
          :event_queue => Tengine::Support::Config::Definition::Group,
          [:event_queue, :connection] => NilClass,
          [:event_queue, :exchange  ] => NilClass,
          [:event_queue, :queue     ] => NilClass,
          :log_common => Tengine::Support::Config::Logger,
          :application_log => App1::LoggerConfig,
          :process_stdout_log => App1::LoggerConfig,
          :process_stderr_log => App1::LoggerConfig,
        }.each do |name, klass|
          it{ subject.child_by_name(name).should be_a(klass) }
        end

        {
          :process => App1::ProcessConfig,
          :db => Tengine::Support::Config::Mongoid::Connection,
          :event_queue => Tengine::Support::Config::Definition::Group,
          [:event_queue, :connection] => Tengine::Support::Config::Amqp::Connection,
          [:event_queue, :exchange  ] => Tengine::Support::Config::Amqp::Exchange,
          [:event_queue, :queue     ] => Tengine::Support::Config::Amqp::Queue,
          :log_common => Tengine::Support::Config::Logger,
          :application_log => App1::LoggerConfig,
          :process_stdout_log => App1::LoggerConfig,
          :process_stderr_log => App1::LoggerConfig,
        }.each do |name_array, klass|
          it{ subject.find(name_array).should be_a(klass) }
        end
      end

      context "parent and children" do
        it do
          log_common = subject.find(:log_common)
          application_log = subject.find(:application_log)
          log_common.should_not == application_log
          log_common.children.each do |log_common_child|
            application_log_child = application_log.child_by_name(log_common_child.name)
            application_log_child.should_not be_nil
            application_log_child.name.should == log_common_child.name
            application_log_child.object_id.should_not == log_common_child.object_id
            application_log_child.parent.should == application_log
            log_common_child.parent.should == log_common
          end
        end
      end

      context "dependencies" do
        it do
          application_log = subject.find(:application_log)
          application_log.process_config.should_not be_nil
          application_log.process_config.should be_a(App1::ProcessConfig)
          application_log.log_common.should_not be_nil
          application_log.log_common.should be_a(Tengine::Support::Config::Logger)
        end
      end

      it "skelton" do
        subject.skelton.should == {
          :action => nil,
          :config => nil,
          :process => {
            :daemon => nil,
            :pid_dir => nil,
          },
          :db => {
            :host => 'localhost',
            :port => 27017,
            :username => nil,
            :password => nil,
            :database => 'tengine_production'
          },
          :event_queue => {
            :connection => {
              :host => 'localhost',
              :port => 5672,
              :vhost => nil,
              :user  => nil,
              :pass  => nil,
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
            :output        => "STDOUT",
            :rotation      => nil,
            :rotation_size => nil,
            :level         => nil,
          }.freeze,

          :process_stdout_log => {
            :output        => "STDOUT",
            :rotation      => nil,
            :rotation_size => nil,
            :level         => nil,
          }.freeze,

          :process_stderr_log => {
            :output        => "STDOUT",
            :rotation      => nil,
            :rotation_size => nil,
            :level         => nil,
          }.freeze,
        }
      end
    end

  end

end
