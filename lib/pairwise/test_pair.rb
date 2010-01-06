require 'forwardable'

module Pairwise
  class TestPair
    extend Forwardable

    def_delegators :@pair, :+, :inspect, :to_a, :==

    def initialize(p1_position, p2_position, p1, p2)
      @p1, @p2 = p1, p2
      @p1_position, @p2_position = p1_position, p2_position
      @pair = [@p1, @p2]
    end

    def covered_by?(test_pair)
      test_pair[@p1_position] == @p1 &&
      test_pair[@p2_position] == @p2
    end

    def create_input_list
      new_input_list = Array.new(@p1_position){Builder::WILD_CARD}

      new_input_list[@p1_position] = @p1
      new_input_list[@p2_position] = @p2
      new_input_list
    end

    def replace_wild_card(input_list)
      input_list[@p2_position] = @p2
      input_list
    end

    def replaceable_wild_card?(input_combinations)
      wild_card_list = input_combinations.map do |input_combination|
        input_combination[@p2_position] == Builder::WILD_CARD && input_combination[@p1_position] == @p1
      end
      wild_card_list.rindex(true)
    end

  end
end
