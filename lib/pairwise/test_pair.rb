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
      debugger unless test_pair 
      test_pair[@p1_position] == @p1 &&
      test_pair[@p2_position] == @p2
    end

    def replace_wild_card(new_input_combinations)
      #TODO: Decided if we should replace all matches or single matches?
      if wild_card_index = find_wild_card_index(new_input_combinations)
        new_input_combinations[wild_card_index][@p2_position] = @p2
      else
        new_input_combinations << create_input_list
      end
      new_input_combinations
    end

    private
    def create_input_list
      new_input_list = Array.new(@p1_position){Builder::WILD_CARD}

      new_input_list[@p1_position] = @p1
      new_input_list[@p2_position] = @p2
      new_input_list
    end

    def find_wild_card_index(input_combinations)
      wild_card_list = input_combinations.map do |input_combination|
        input_combination[@p2_position] == Builder::WILD_CARD && input_combination[@p1_position] == @p1
      end
      wild_card_list.rindex(true)
    end

  end
end
