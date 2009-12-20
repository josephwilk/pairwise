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

    def covered_by?(pair_2)
      pair_2[@p1_position] == self[0] &&
      pair_2[@p2_position] == self[1]
    end

  end
end
