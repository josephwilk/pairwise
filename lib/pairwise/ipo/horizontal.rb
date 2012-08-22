module Pairwise
  module IPO

    class Horizontal
      class << self

        def growth(input_combinations, input_values_for_growth, previously_grown_input_values)
          uncovered_pairs = PairCollection.new(input_values_for_growth, previously_grown_input_values, previously_grown_input_values.size)
          input_combinations, uncovered_pairs = grow_input_combinations_and_remove_covered_pairs(input_combinations, input_values_for_growth, uncovered_pairs)
          [input_combinations, uncovered_pairs]
        end

        private
      
        def grow_input_combinations_and_remove_covered_pairs(input_combinations, input_values_for_growth, uncovered_pairs)
          input_combinations = input_combinations.enum_for(:each_with_index).map do |input_combination, input_index|
            extended_input_combination = uncovered_pairs.input_combination_that_covers_most_pairs(input_combination, input_values_for_growth)
            uncovered_pairs.remove_pairs_covered_by!(extended_input_combination)
            extended_input_combination
          end
          [input_combinations, uncovered_pairs]
        end
      end
      
    end
  end
end
