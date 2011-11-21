# -*- coding: utf-8 -*-

# active_support/core_ext/hash/deep_dupでHash#deep_dupを定義していますが、
# 対象がHashだけなのでArrayをコピーできません。
# Arrayや他のオブジェクトに対応するためにメソッドを上書きします。
require 'active_support/core_ext/hash/deep_dup'

class Hash
  # Returns a deep copy of hash.
  def deep_dup
    duplicate = self.dup
    duplicate.each_pair do |k,v|
      tv = duplicate[k]
      duplicate[k] = tv.respond_to?(:deep_dup) && v.respond_to?(:deep_dup) ? tv.deep_dup : v
    end
    duplicate
  end

end
