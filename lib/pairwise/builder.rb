# A pairwise implementation using the in-parameter-order (IPO) strategy.
# Based on: http://ranger.uta.edu/~ylei/paper/ipo-tse.pdf
module Pairwise
  class Builder

    WILD_CARD = 'wild_card'

    def initialize(inputs, options = {})
      @list_of_input_values = inputs
      @options = options
    end

    def build
      input_combinations = PairCollection.new(@list_of_input_values[0], [@list_of_input_values[1]], 0)
      @list_of_input_values.size > 2 ? in_parameter_order_generation(input_combinations) : input_combinations.to_a
    end

    private

    def in_parameter_order_generation(input_combinations)
      @list_of_input_values[2..-1].each_with_index do |input_values, i|
        i += 2
        input_combinations, uncovered_pairs = horizontal_growth(input_combinations, input_values, @list_of_input_values[0..(i-1)])
        input_combinations = vertical_growth(input_combinations, uncovered_pairs)
      end
      input_combinations = replace_wild_cards(input_combinations) unless @options[:keep_wild_cards]
      input_combinations
    end

    def horizontal_growth(input_combinations, input_values_for_growth, previously_grown_input_values)
      uncovered_pairs = PairCollection.new(input_values_for_growth, previously_grown_input_values, previously_grown_input_values.size)

      if input_combinations.size <= input_values_for_growth.size
        input_combinations, uncovered_pairs = grow_input_combinations_and_remove_covered_pairs(input_combinations, input_values_for_growth, uncovered_pairs)
      else
        range_to_grow = 0...input_values_for_growth.size
        input_combinations[range_to_grow], uncovered_pairs = grow_input_combinations_and_remove_covered_pairs(input_combinations[range_to_grow], input_values_for_growth, uncovered_pairs)

        range_to_grow = input_values_for_growth.size..-1
        input_combinations[range_to_grow] = input_combinations[range_to_grow].map do |input_combination|
          extended_input_combination = uncovered_pairs.input_combination_that_covers_most_pairs(input_combination, input_values_for_growth)
          uncovered_pairs.remove_pairs_covered_by!(extended_input_combination)
          extended_input_combination
        end
      end

      [input_combinations, uncovered_pairs]
    end

    def grow_input_combinations_and_remove_covered_pairs(input_combinations, input_values_for_growth, uncovered_pairs)
      input_combinations = input_combinations.enum_for(:each_with_index).map do |input_combination, input_index|
        extended_input_combination = input_combination + [input_values_for_growth[input_index]]
        uncovered_pairs.remove_pairs_covered_by!(extended_input_combination)
        extended_input_combination
      end
      [input_combinations, uncovered_pairs]
    end
        
    def vertical_growth(input_combinations, uncovered_pairs)
      new_input_combinations = uncovered_pairs.reduce([]) do |new_input_combinations, uncovered_pair|
        new_input_combinations = uncovered_pair.replace_wild_card(new_input_combinations)
      end

      input_combinations + new_input_combinations
    end

    def replace_wild_cards(input_combinations)
      map_each_input_value(input_combinations) do |input_value, index|
        if input_value == WILD_CARD
          if @list_of_input_values[index].length == 1
            @list_of_input_values[index][0]
          else
            pick_random_value(@list_of_input_values[index])
          end
        else
          input_value
        end
      end
    end

    def map_each_input_value(input_combinations)
      input_combinations.map do |input_combination|
        input_combination.enum_for(:each_with_index).map do |input_value, index|
          yield input_value, index
        end
      end
    end

    def pick_random_value(input_combination)
      input_combination[Kernel.rand(input_combination.size)]
    end

  end
end
