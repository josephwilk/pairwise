module Pairwise
  class IPO
    class Vertical

      def self.growth(input_combinations, uncovered_pairs)
        new_input_combinations = uncovered_pairs.reduce([]) do |new_input_combinations, uncovered_pair|
          new_input_combinations = uncovered_pair.replace_wild_card(new_input_combinations)
        end

        input_combinations + new_input_combinations
      end

    end
  end
end
