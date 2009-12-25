require 'forwardable'

module Pairwise
  class TestPair
    extend Forwardable

    attr_reader :p1_position, :p2_position
    attr_reader :p1, :p2

    def_delegators :@pair, :+, :inspect, :==

    def initialize(p1_position, p2_position, p1, p2)
      @p1, @p2 = p1, p2
      @p1_position, @p2_position = p1_position, p2_position
      @pair = [@p1, @p2]
    end

    def covered_by?(test_pair)
      test_pair[@p1_position] == @p1 &&
      test_pair[@p2_position] == @p2
    end

  end
end
