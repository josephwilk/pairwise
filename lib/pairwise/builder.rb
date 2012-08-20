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
      @list_of_input_values[2..-1].each_with_index do |input_values, index|
        index += 2
        previously_grown_input_values = @list_of_input_values[0..(index-1)]
        
        input_combinations, uncovered_pairs = IPO::Horizontal.growth(input_combinations, input_values, previously_grown_input_values)
        input_combinations = IPO::Vertical.growth(input_combinations, uncovered_pairs)
      end
      input_combinations = replace_wild_cards(input_combinations) unless @options[:keep_wild_cards]
      input_combinations
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
