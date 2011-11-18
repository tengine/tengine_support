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

      context "show help" do
        it do
          @suite = build_suite1
          STDOUT.should_receive(:puts).with(HELP_MESSAGE)
          expect{
            @suite.parse!(%w[--help])
          }.to raise_error(SystemExit)
        end
      end

    end

  end

end


HELP_MESSAGE = <<END_OF_HELP
Usage: config_test [-k action] [-f path_to_config]
         [-H db_host] [-P db_port] [-U db_user] [-S db_pass] [-B db_database]

    -k, --action=VAL                 test|load|start|enable|stop|force-stop|status|activate  default: "start"
    -f, --config=VAL                 path/to/config_file 

process:
    -D, --process-daemon             process works on background. 
        --process-pid-dir=VAL        path/to/dir for PID created. 

db:
    -O, --db-host=VAL                hostname to connect db.  default: "localhost"
    -P, --db-port=VAL                port to connect db.  default: 27017
    -U, --db-username=VAL            username to connect db. 
    -S, --db-password=VAL            password to connect db. 
        --db-database=VAL            database name to connect db.  default: "tengine_production"

connection:
        --event-queue-connection-host=VAL
                                     hostname to connect queue.  default: "localhost"
        --event-queue-connection-port=VAL
                                     port to connect queue.  default: 5672
        --event-queue-connection-vhost=VAL
                                     vhost to connect queue. 
        --event-queue-connection-user=VAL
                                     username to connect queue. 
        --event-queue-connection-pass=VAL
                                     password to connect queue. 

exchange:
        --event-queue-exchange-name=VAL
                                     exchange name.  default: "tengine_event_exchange"
        --event-queue-exchange-type=VAL
                                     exchange type.  default: "direct"
        --event-queue-exchange-durable
                                     exchange durable. 

queue:
        --event-queue-queue-name=VAL queue name.  default: "tengine_event_queue"
        --event-queue-queue-durable  queue durable. 

log_common:
        --log-common-output=VAL      file path or "STDOUT" / "STDERR". 
        --log-common-rotation=VAL    rotation file count or daily,weekly,monthly.  default: 3
        --log-common-rotation-size=VAL
                                     number of max log file size.  default: 1048576
        --log-common-level=VAL       debug/info/warn/error/fatal.  default: "info"

application_log:
        --application-log-output=VAL file path or "STDOUT" / "STDERR". if daemon process then "./log/.log" else "STDOUT" default: "STDOUT"
        --application-log-rotation=VAL
                                     rotation file count or daily,weekly,monthly. value of --log-common-rotation default: 3
        --application-log-rotation-size=VAL
                                     number of max log file size. value of --log-common-rotation-size default: 1048576
        --application-log-level=VAL  debug/info/warn/error/fatal. value of --log-common-level default: "info"

process_stdout_log:
        --process-stdout-log-output=VAL
                                     file path or "STDOUT" / "STDERR". if daemon process then "./log/.log" else "STDOUT" default: "STDOUT"
        --process-stdout-log-rotation=VAL
                                     rotation file count or daily,weekly,monthly. value of --log-common-rotation default: 3
        --process-stdout-log-rotation-size=VAL
                                     number of max log file size. value of --log-common-rotation-size default: 1048576
        --process-stdout-log-level=VAL
                                     debug/info/warn/error/fatal. value of --log-common-level default: "info"

process_stderr_log:
        --process-stderr-log-output=VAL
                                     file path or "STDOUT" / "STDERR". if daemon process then "./log/.log" else "STDOUT" default: "STDOUT"
        --process-stderr-log-rotation=VAL
                                     rotation file count or daily,weekly,monthly. value of --log-common-rotation default: 3
        --process-stderr-log-rotation-size=VAL
                                     number of max log file size. value of --log-common-rotation-size default: 1048576
        --process-stderr-log-level=VAL
                                     debug/info/warn/error/fatal. value of --log-common-level default: "info"

General:
        --version                    show version 
        --dump-skelton               dump skelton of config 
        --help                       show this help message 
END_OF_HELP
