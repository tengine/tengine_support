# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

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

end
