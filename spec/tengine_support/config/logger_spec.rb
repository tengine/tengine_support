# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'logger'
require 'tempfile'

describe 'Tengine::Support::Config::Logger' do

  context "static" do

    describe Tengine::Support::Config::Logger.output do
      it { subject.should be_a(Tengine::Support::Config::Definition::Field)}
      its(:type){ should == :string }
      its(:__name__){ should == :output }
      its(:description){ should == 'file path or "STDOUT" / "STDERR".'}
      its(:default){ should == nil}
    end
  end

  describe :new_logger do
    it "STDOUTの場合" do
      config = Tengine::Support::Config::Logger.new
      config.output = "STDOUT"
      config.level = "warn"
      config.rotation = nil
      config.rotation_size = nil
      config.output.should == "STDOUT"
      config.level.should == "warn"
      config.rotation.should == nil
      config.rotation_size.should == nil

      logger = Logger.new(STDOUT, nil, nil)
      Logger.should_receive(:new).with(STDOUT, nil, nil).and_return(logger)
      logger.should_receive(:level=).with(Logger::WARN)
      config.new_logger.should == logger
    end

    it "STDERRの場合" do
      config = Tengine::Support::Config::Logger.new
      config.output = "STDERR"
      config.level = "warn"
      config.rotation = nil
      config.rotation_size = nil
      logger = Logger.new(STDERR, nil, nil)
      Logger.should_receive(:new).with(STDERR, nil, nil).and_return(logger)
      logger.should_receive(:level=).with(Logger::WARN)
      config.new_logger.should == logger
    end

    context "ファイル名の場合" do
      before do
        @tempfile = Tempfile.new("test.log")
        @filepath = @tempfile.path
      end
      after do
        @tempfile.close
      end

      %w[daily weekly monthly].each do |shift_age|
        it "shift_age が #{shift_age}" do
          config = Tengine::Support::Config::Logger.new
          config.output = @filepath
          config.level = "info"
          config.rotation = shift_age
          config.rotation_size = nil
          logger = Logger.new(@filepath, shift_age, nil)
          Logger.should_receive(:new).with(@filepath, shift_age, nil).and_return(logger)
          logger.should_receive(:level=).with(Logger::INFO)
          config.new_logger.should == logger
        end
      end

      it "shift_ageが整数値" do
        config = Tengine::Support::Config::Logger.new
        config.output = @filepath
        config.level = "info"
        config.rotation = "3"
        config.rotation_size = 10 * 1024 * 1024 # 10MB
        logger = Logger.new(@filepath, 3, 10 * 1024 * 1024)
        Logger.should_receive(:new).with(@filepath, 3, 10 * 1024 * 1024).and_return(logger)
        logger.should_receive(:level=).with(Logger::INFO)
        config.new_logger.should == logger
      end
    end
  end

end
