# -*- coding: utf-8 -*-
require 'active_support/core_ext/hash/deep_dup'
require 'active_support/core_ext/hash/keys'

class Hash

  # Return a new hash with all keys converted to strings recursively.
  def deep_stringify_keys
    deep_dup.deep_stringify_keys!
  end

  # Destructively convert all keys to strings recursively.
  def deep_stringify_keys!
    stringify_keys! # active_support/core_ext/hash/keysのメソッドをそのまま使う
    values.each do |value|
      value.deep_stringify_keys! if value.respond_to?(:deep_stringify_keys!)
    end
    self
  end

  # Return a new hash with all keys converted to symbols recursively, as long as
  # they respond to +to_sym+.
  def deep_symbolize_keys
    deep_dup.deep_symbolize_keys!
  end

  # Destructively convert all keys to symbols recursively, as long as they respond
  # to +to_sym+.
  def deep_symbolize_keys!
    symbolize_keys! # active_support/core_ext/hash/keysのメソッドをそのまま使う
    values.each do |value|
      value.deep_symbolize_keys! if value.respond_to?(:deep_symbolize_keys!)
    end
    self
  end

end
