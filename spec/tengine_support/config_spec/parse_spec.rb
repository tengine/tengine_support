# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "config" do
  describe :parse! do
    context "setting1" do
      shared_examples_for "valid_data1" do
        it { subject.action.should == 'start'}
        it { subject.config.should == nil}
        it { subject.process.should be_a(App1::ProcessConfig) }
        it { subject.process.daemon.should == nil}
        it { subject.process.pid_dir.should == nil}
        it { subject.db.should be_a(Tengine::Support::Config::Mongoid::Connection) }
        it { subject.db.host.should == "mongo1"}
        it { subject.db.port.should == 27017}
        it { subject.db.username.should == 'goku'}
        it { subject.db.password.should == 'ideyoshenlong'}
        it { subject.db.database.should == "tengine_production"}
        it { subject.event_queue.connection.host.should == "localhost"}
        it { subject.event_queue.connection.port.should == 5672}
        it { subject.event_queue.exchange.name.should == "tengine_event_exchange"}
        it { subject.event_queue.exchange.type.should == 'direct'}
        it { subject.event_queue.exchange.durable.should == true}
        it { subject.event_queue.queue.name.should == "tengine_event_queue"}
        it { subject.event_queue.queue.durable.should == true}
        it { subject.log_common.output.should == nil}
        it { subject.log_common.rotation.should == 3}
        it { subject.log_common.rotation_size.should == 1024 * 1024}
        it { subject.log_common.level.should == "debug"}
        it { subject.application_log.output.should == "STDOUT"}
        it { subject.application_log.rotation.should == 3}
        it { subject.application_log.rotation_size.should == 1024 * 1024}
        it { subject.application_log.level.should == "debug"}
        it { subject.process_stdout_log.output.should == "STDOUT"}
        it { subject.process_stdout_log.rotation.should == 3}
        it { subject.process_stdout_log.rotation_size.should == 1024 * 1024}
        it { subject.process_stdout_log.level.should == "info"}
      end

      context "use long option name" do
        before(:all) do
          @suite = build_suite1
          @suite.parse!(%w[--action=start --db-host=mongo1 --db-username=goku --db-password=ideyoshenlong --log-common-level=debug --process-stdout-log-level=info])
        end
        subject{ @suite }
        it_should_behave_like "valid_data1"
      end

      context "use short option name" do
        before(:all) do
          @suite = build_suite1
          @suite.parse!(%w[-k start -O mongo1 -U goku -S ideyoshenlong --log-common-level=debug --process-stdout-log-level=info])
        end
        subject{ @suite }
        it_should_behave_like "valid_data1"
      end
    end

  end

end
