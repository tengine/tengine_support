# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'tengine/support/yaml_with_erb'

describe "dump_skelton" do
  context :suite1 do
    suite1_skelton = {
      :action => 'start',
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
        :rotation=>3, :rotation_size=>1048576, :level=>"info"
      }.freeze,

      :process_stdout_log => {
        :output        => "STDOUT",
        :rotation=>3, :rotation_size=>1048576, :level=>"info"
      }.freeze,

      :process_stderr_log => {
        :output        => "STDOUT",
        :rotation=>3, :rotation_size=>1048576, :level=>"info"
      }.freeze,
    }

    it do
      @suite = build_suite1
      STDOUT.should_receive(:puts).with(YAML.dump(suite1_skelton))
      expect{
        @suite.parse!(%w[--dump-skelton])
      }.to raise_error(SystemExit)
    end
  end


  context :suite2 do
    suite2_skelton = {
      :action => 'start',
      :config => nil,
      :process => {
        :daemon => nil,
        :pid_dir => nil,
      },
      :db => nil,
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
        :rotation=>3, :rotation_size=>1048576, :level=>"info"
      }.freeze,

      :process_stdout_log => {
        :output        => "STDOUT",
        :rotation=>3, :rotation_size=>1048576, :level=>"info"
      }.freeze,

      :process_stderr_log => {
        :output        => "STDOUT",
        :rotation=>3, :rotation_size=>1048576, :level=>"info"
      }.freeze,
    }

    it do
      @suite = build_suite2
      STDOUT.should_receive(:puts).with(YAML.dump(suite2_skelton))
      expect{
        @suite.parse!(%w[--dump-skelton])
      }.to raise_error(SystemExit)
    end

  end

end

