module Enumerable
  def deep_freeze
    each do |i|
      case i when Enumerable
        i.deep_freeze
      else
        i.freeze
      end
    end
    freeze
  end
end
