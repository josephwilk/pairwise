module Pairwise
  module IPO

    class Horizontal
      class << self

        def growth(input_combinations, input_values_for_growth, previously_grown_input_values)
          uncovered_pairs = PairCollection.new(input_values_for_growth, previously_grown_input_values, previously_grown_input_values.size)

          if input_combinations.size <= input_values_for_growth.size
            input_combinations, uncovered_pairs = grow_input_combinations_and_remove_covered_pairs(input_combinations, input_values_for_growth, uncovered_pairs)
          else
            number_of_list_of_values = input_values_for_growth.size
            
            range_to_grow = 0...number_of_list_of_values 
            input_combinations[range_to_grow], uncovered_pairs = grow_input_combinations_and_remove_covered_pairs(input_combinations[range_to_grow], input_values_for_growth, uncovered_pairs)

            range_to_grow = number_of_list_of_values ..-1
            input_combinations[range_to_grow], uncovered_pairs = grow_input_combinations_and_remove_covered_pairs(input_combinations[range_to_grow], input_values_for_growth, uncovered_pairs, true)
          end

          [input_combinations, uncovered_pairs]
        end

        private
      
        def grow_input_combinations_and_remove_covered_pairs(input_combinations, input_values_for_growth, uncovered_pairs, flag=false)
          input_combinations = input_combinations.enum_for(:each_with_index).map do |input_combination, input_index|
            extended_input_combination = if flag
              uncovered_pairs.input_combination_that_covers_most_pairs(input_combination, input_values_for_growth)
            else
              input_combination + [input_values_for_growth[input_index]]
            end

            uncovered_pairs.remove_pairs_covered_by!(extended_input_combination)
            extended_input_combination
          end
          [input_combinations, uncovered_pairs]
        end
      end
      
    end
  end
end
