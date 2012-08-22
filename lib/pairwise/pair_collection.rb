module Pairwise
  class PairCollection < Array

    def initialize(input_parameter_values, input_value_lists, input_parameter_index)
      pairs = generate_pairs_between(input_parameter_values, input_value_lists, input_parameter_index)
      @combination_history = []
      super(pairs)
    end

    def remove_pairs_covered_by!(extended_input_list)
      self.reject!{|pair| pair.covered_by?(extended_input_list)}
    end

    def input_combination_that_covers_most_pairs(input_combination, input_values_for_growth)
      candidates = input_values_for_growth.map{|value| input_combination + [value]}
      max_combination = candidates.max {|combination_1, combination_2| pairs_covered_count(combination_1) <=> pairs_covered_count(combination_2)}
      possible_max_combinations = candidates.select{|combination| pairs_covered_count(max_combination) == pairs_covered_count(combination)}

      winner = if possible_max_combinations.size > 1 && !@combination_history.empty?
        #Looking back across the picked values find the combination with the greatest difference
        max_difference(possible_max_combinations, @combination_history)
      else
        possible_max_combinations[0]
      end
      @combination_history << winner
      winner
    end
  
    def to_a
      self.map{|list| list.to_a}
    end

    private
    
    def generate_pairs_between(input_parameter_values, input_value_lists, input_parameter_index)
      pairs = []
      input_parameter_values.each do |input_value_a|
        input_value_lists.each_with_index do |input_list, input_value_b_index|
          input_list.each do |input_value_b|
            pairs << TestPair.new(input_parameter_index, input_value_b_index, input_value_a, input_value_b)
          end
        end
      end
      pairs
    end

    def pairs_covered_count(input_combination)
      self.reduce(0) do |covered_count, pair|
        covered_count += 1 if pair.covered_by?(input_combination)
        covered_count
      end
    end
    
    def max_difference(options, previous_choices)
      scores = options.map do |option|
        score(option, previous_choices)
      end.flatten

      _, winner_index = *scores.each_with_index.max
      options[winner_index]
    end
    
    def score(option, previous_choices)
      #O(n^2)
      previous_choices.map do |choice|
        i = 0
        option.each_with_index.reduce(0) do |sum, value| 
          value != choice[i] ? sum : sum = sum+=1
          i+=1
          sum
        end
      end.max
    end
    
  end
end
