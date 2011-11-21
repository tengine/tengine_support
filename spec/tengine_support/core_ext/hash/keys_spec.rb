# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

require 'active_support'

# この機能は、activesupport-3.1.0から追加された active_support/core_ext/hash/deep_dup を
# 使っているので、3.1.0以下ではテストせず、pendingのメッセージを出します
if ActiveSupport::VERSION::STRING < "3.1.0"
  describe "tengine/support/core_ext/hash/keys" do
    pending %W[
      depends on active_support/core_ext/hash/deep_dup,
      but activesupport version is #{ActiveSupport::VERSION::STRING}.
      If you need to use Hash#deep_stringify_keys and Hash#deep_symbolize_keys,
      install tengine_support with activesupport >= 3.1.0.
      ].join(' ')
  end
else
  require 'active_support/core_ext/hash/deep_dup'
  require 'tengine/support/core_ext/hash/keys'

  describe "tengine/support/core_ext/hash/keys" do

    test_hashs ={
      :deep_stringify_keys_result => {
        'a' => 1,
        'b' => {
          'foo' => 2,
          'bar' => {
            'hoge' => "3",
            "wake" => {}.freeze,
          }.freeze
        }.freeze,
        'c' => {
          'baz' => "4"
        }.freeze
      }.freeze,

      :deep_symbolize_keys_result => {
        :a => 1,
        :b => {
          :foo => 2,
          :bar => {
            :hoge => "3",
            :wake => {}.freeze,
          }.freeze
        }.freeze,
        :c => {
          :baz => "4"
        }.freeze
      }.freeze,

      :mixed_key_hash => {
        'a' => 1,
        :b => {
          :foo => 2,
          'bar' => {
            'hoge' => "3",
            :wake => {}.freeze,
          }.freeze
        }.freeze,
        :c => {
          'baz' => "4"
        }.freeze
      }.freeze
    }

    [:deep_stringify_keys, :deep_symbolize_keys].each do |method_name|
      test_hashs.keys.each do |target_name|
        context target_name do
          describe ".#{method_name}" do
            it "should returns #{method_name}_result" do
              original = test_hashs[target_name]
              converted = original.send(method_name)
              converted.object_id.should_not == original.object_id # object_id is changed
              converted.should == test_hashs[:"#{method_name}_result"]
              original.should == test_hashs[target_name]
            end
          end
        end
      end


      test_hashs.keys.each do |target_name|
        context target_name do
          describe ".#{method_name}!" do
            it "should equals :#{method_name}_result" do
              original = test_hashs[target_name].deep_dup
              result = original.send(:"#{method_name}!")
              result.object_id.should == original.object_id
              original.should == test_hashs[:"#{method_name}_result"]
            end
          end
        end
      end
    end

  end
end
