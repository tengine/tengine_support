require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module App1
  class DbConfig
    include Tengine::Support::Config::Definition
    string  :host, 'hostname to connect db.', :default => 'localhost'
    integer :port, "port to connect db.", :default => 5672
  end

  class ProcessConfig
    include Tengine::Support::Config::Definition
    boolean :daemon, "ignored with \"-k test, -k load, -k enable\"."
    directory :pid_dir, "path/to/dir for PID created"
  end
end



describe "config" do

  context "app1 setting" do
    before do
      root = Tengine::Support::Config::DefinitionSuite.new
      root.add_suite(:basic).tap do |basic|
        basic.add(:db, App1::DbConfig)
        basic.add(:process, App1::ProcessConfig)
      end
      root.short_alias = {
        :D => [:basic, :process, :daemon],
        :O => [:basic, :db, :host],
        :P => [:basic, :db, :port],
      }
    end

  end

end
