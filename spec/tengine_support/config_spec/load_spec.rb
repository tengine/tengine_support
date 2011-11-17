# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'tengine/support/yaml_with_erb'

describe "config" do
  shared_examples_for "load_spec_01.yml's data" do
    describe "accessors" do
      it { subject.action.should == nil}
      it { subject.config.should == nil}
      it { subject.process.should be_a(App1::ProcessConfig) }
      it { subject.process.daemon.should == true}
      it { subject.process.pid_dir.should == "./tmp/pids"}
      it { subject.db.should be_a(Tengine::Support::Config::Mongoid::Connection) }
      it { subject.db.host.should == "localhost"}
      it { subject.db.port.should == 27020}
      it { subject.db.username.should == nil}
      it { subject.db.password.should == nil}
      it { subject.db.database.should == "tengine_production"}
      it { subject.event_queue.connection.host.should == "rabbitmq1"}
      it { subject.event_queue.connection.port.should == 5672}
      it { subject.event_queue.exchange.name.should == "tengine_event_exchange"}
      it { subject.event_queue.exchange.type.should == 'direct'}
      it { subject.event_queue.exchange.durable.should == true}
      it { subject.event_queue.queue.name.should == "tengine_event_queue"}
      it { subject.event_queue.queue.durable.should == true}
      it { subject.log_common.output.should == nil}
      it { subject.log_common.rotation.should == 5}
      it { subject.log_common.rotation_size.should == 1024 * 1024 * 1024}
      it { subject.log_common.level.should == "info"}
      it { subject.application_log.output.should == "log/application.log"}
      it { subject.application_log.rotation.should == 'daily'}
      it { subject.application_log.rotation_size.should == 1024 * 1024 * 1024}
      it { subject.application_log.level.should == "debug"}
      it { subject.process_stdout_log.output.should == "log/stdout.log"}
      it { subject.process_stdout_log.rotation.should == 5}
      it { subject.process_stdout_log.rotation_size.should == 1024 * 1024 * 1024}
      it { subject.process_stdout_log.level.should == "warn"}
      it { subject.process_stderr_log.output.should == "log/stderr.log"}
      it { subject.process_stderr_log.rotation.should == 5}
      it { subject.process_stderr_log.rotation_size.should == 1024 * 1024 * 1024}
      it { subject.process_stderr_log.level.should == "info"}
    end
  end


  context "app1 setting" do
    describe :load do
      before(:all) do
        @suite = build_suite1
        @suite.load(YAML.load_file(File.expand_path('load_spec_01.yml.erb', File.dirname(__FILE__))))
      end
      subject{ @suite }
      it_should_behave_like "load_spec_01.yml's data"
    end

    describe :load_file do
      before(:all) do
        @suite = build_suite1
        @suite.load_file(File.expand_path('load_spec_01.yml.erb', File.dirname(__FILE__)))
      end
      subject{ @suite }
      it_should_behave_like "load_spec_01.yml's data"
    end

  end

end
