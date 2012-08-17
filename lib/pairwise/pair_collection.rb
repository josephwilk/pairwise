module Pairwise
  class PairCollection < Array

    def initialize(input_parameter_values, input_value_lists, input_parameter_index)
      pairs = generate_pairs_between(input_parameter_values, input_value_lists, input_parameter_index)
      super(pairs)
    end

    def remove_pairs_covered_by!(extended_input_list)
      self.reject!{|pair| pair.covered_by?(extended_input_list)}
    end

    def input_combination_that_covers_most_pairs(input_combination, input_values_for_growth)
      candidates =  input_values_for_growth.map{|value| input_combination + [value] }
      candidates.max {|combination_1, combination_2| pairs_covered_count(combination_1) <=> pairs_covered_count(combination_2)}
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
  end
end
