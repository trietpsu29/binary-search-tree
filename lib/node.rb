class Node
  include Comparable

  attr_accessor :data, :left, :right

  def initialize(data = 0)
    @data = data
    @left = nil
    @right = nil
  end

  def <=>(other)
    @data <=> other.data
  end
end
