require 'set'

#TODO: Array gives us too much extract specific behaviour required
module Pairwise
  class TestPair < Array
    attr_reader :p1_position
    attr_reader :p2_position

    def initialize(p1_position, p2_position, p1, p2)
      @p1_position, @p2_position = p1_position, p2_position
      super([p1, p2])
    end

    def p1
      self[0]
    end

    def p2
      self[1]
    end

    def subset?(pair_2)
      pair_1_set, pair_2_set = Set.new(self), Set.new(pair_2)
      pair_1_set.subset?(pair_2_set)
    end

  end
end
