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
      input_combinations = generate_pairs_between(@list_of_input_values[0], [@list_of_input_values[1]], 0)
      @list_of_input_values.size > 2 ? in_parameter_order_generation(input_combinations) : input_combinations.map{|list| list.to_a}
    end

    private

    def in_parameter_order_generation(input_combinations)
      @list_of_input_values[2..-1].each_with_index do |input_values, i|
        i += 2
        input_combinations, uncovered_pairs = horizontal_growth(input_combinations, input_values, @list_of_input_values[0..(i-1)])
        input_combinations = vertical_growth(input_combinations, uncovered_pairs)
      end
      input_combinations = replace_redundant_wild_cards(input_combinations)
      input_combinations = replace_wild_cards(input_combinations) unless @options[:keep_wild_cards]
      input_combinations
    end

    def horizontal_growth(input_combinations, input_values_for_growth, previously_grown_input_values)
      pairs = generate_pairs_between(input_values_for_growth, previously_grown_input_values, previously_grown_input_values.size)

      if input_combinations.size <= input_values_for_growth.size
        input_combinations = input_combinations.enum_for(:each_with_index).map do |input_combination, input_index|
          extended_input_combination = input_combination + [input_values_for_growth[input_index]]
          pairs = remove_pairs_covered_by(extended_input_combination, pairs)
          extended_input_combination
        end
      else
        input_combinations[0...input_values_for_growth.size] = input_combinations[0...input_values_for_growth.size].enum_for(:each_with_index).map do |input_combination, input_index|
          extended_input_combination = input_combination + [input_values_for_growth[input_index]]
          pairs = remove_pairs_covered_by(extended_input_combination, pairs)
          extended_input_combination
        end

        input_combinations[input_values_for_growth.size..-1] = input_combinations[input_values_for_growth.size..-1].map do |input_combination|
          extended_input_combination = input_combination_that_covers_most_pairs(input_combination, input_values_for_growth, pairs)
          pairs = remove_pairs_covered_by(extended_input_combination, pairs)
          extended_input_combination
        end
      end

      [input_combinations, pairs]
    end

    def vertical_growth(input_combinations, uncovered_pairs)
      new_input_combinations = []

      uncovered_pairs.each do |uncovered_pair|
        #TODO: Decided if we should replace all matches or single matches?
        if test_position = uncovered_pair.replaceable_wild_card?(new_input_combinations)
          new_input_combinations[test_position] = uncovered_pair.replace_wild_card(new_input_combinations[test_position])
        else
          new_input_combinations << uncovered_pair.create_input_list
        end
      end

      input_combinations + new_input_combinations
    end

    def replace_redundant_wild_cards(input_combinations)
      map_each_input_value(input_combinations) do |input_value, index|
        if input_value == WILD_CARD && @list_of_input_values[index].length == 1
          @list_of_input_values[index][0]
        else
          input_value
        end
      end
    end

    def replace_wild_cards(input_combinations)
      map_each_input_value(input_combinations) do |input_value, index|
        if input_value == WILD_CARD
          pick_random_value(@inputs[index])
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
      input_combination[rand(input_combination.size)]
    end

    def generate_pairs_between(parameter_i, input_lists, p_index)
      pairs = []
      parameter_i.each do |p|
        input_lists.each_with_index do |input_list, q_index|
          input_list.each do |q|
            pairs << TestPair.new(p_index, q_index, p, q)
          end
        end
      end
      pairs
    end

    def remove_pairs_covered_by(extended_input_list, pairs)
      pairs.reject{|pair| pair.covered_by?(extended_input_list)}
    end

    def input_combination_that_covers_most_pairs(input_combination, input_values_for_growth, pairs)
      selected_input_combination = nil
      input_values_for_growth.reduce(0) do |max_covered_count, value|
        input_combination_candidate = input_combination + [value]
        covered_count = pairs_covered_count(input_combination_candidate, pairs)
        if covered_count >= max_covered_count
          selected_input_combination = input_combination_candidate
          covered_count
        else
          max_covered_count
        end
      end
      selected_input_combination
    end

    def pairs_covered_count(input_combination, pairs)
      pairs.reduce(0) do |covered_count, pair|
        covered_count += 1 if pair.covered_by?(input_combination)
        covered_count
      end
    end
  end
end
