# A pairwise implementation using the in-parameter-order (IPO) strategy.
# Based on: http://ranger.uta.edu/~ylei/paper/ipo-tse.pdf
module Pairwise
  class Builder

    WILD_CARD = :wild_card

    def initialize(inputs)
      @inputs = inputs
    end

    def build
      input_lists = generate_pairs_between(@inputs[0], [@inputs[1]], 0)
      @inputs.size > 2 ? in_parameter_order_generation(input_lists) : input_lists.map{|list| list.to_a}
    end

    private

    def in_parameter_order_generation(input_lists)
      @inputs[2..-1].each_with_index do |input_list, i|
        i += 2
        input_lists, pi = horizontal_growth(input_lists, input_list, @inputs[0..(i-1)])
        input_lists = vertical_growth(input_lists, pi)
      end
      replace_wild_cards(input_lists)
    end

    def horizontal_growth(input_lists, parameter_i, inputs)
      pi = generate_pairs_between(parameter_i, inputs, inputs.size)

      if input_lists.size <= parameter_i.size
        input_lists = input_lists.enum_for(:each_with_index).map do |test, j|
          extended_test = test + [parameter_i[j]]
          pi = remove_pairs_covered_by(extended_test, pi)
          extended_test
        end
      else
        input_lists[0...parameter_i.size] = input_lists[0...parameter_i.size].enum_for(:each_with_index).map do |test, j|
          extended_test = input_lists[j] + [parameter_i[j]]
          pi = remove_pairs_covered_by(extended_test, pi)
          extended_test
        end

        input_lists[parameter_i.size..-1] = input_lists[parameter_i.size..-1].map do |test|
          extended_test = value_that_covers_most_pairs(test, parameter_i, pi)
          pi = remove_pairs_covered_by(extended_test, pi)
          extended_test
        end
      end

      [input_lists, pi]
    end

    def vertical_growth(input_lists, pi)
      new_input_lists = []

      pi.each do |pair|
        #TODO: Decided if we should replace all matches or single matches?
        if test_position = replace_wild_card?(new_input_lists, pair)
          new_input_lists[test_position][pair.p2_position] = pair.p2
        else
          new_input_list = Array.new(pair.p1_position){WILD_CARD}

          new_input_list[pair.p1_position] = pair.p1
          new_input_list[pair.p2_position] = pair.p2

          new_input_lists << new_input_list
        end
      end

      input_lists + new_input_lists
    end

    def replace_wild_card?(input_lists, pair)
      wild_card_list = input_lists.map do |input_list|
        input_list[pair.p2_position] == WILD_CARD && input_list[pair.p1_position] == pair.p1
      end
      wild_card_list.rindex(true)
    end

    def replace_wild_cards(input_lists)
      input_lists.map do |input_list|
        input_list.enum_for(:each_with_index).map do |input_value, index|
          input_value == WILD_CARD ? pick_random_value(@inputs[index]) : input_value
        end
      end
    end

    def pick_random_value(input_list)
      input_list[rand(input_list.size)]
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

    def remove_pairs_covered_by(extended_input_list, pi)
      pi.reject{|pair| pair.covered_by?(extended_input_list)}
    end

    def value_that_covers_most_pairs(input_list, parameter_i, pi)
      selected_input_list = nil
      parameter_i.reduce(0) do |most_covered, value|
        input_list_candidate = input_list + [value]
        covered = pairs_covered_count(input_list_candidate, pi)
        if covered >= most_covered
          selected_input_list = input_list_candidate
          covered
        else
          most_covered
        end
      end
      selected_input_list
    end

    def pairs_covered_count(input_list, pairs)
      pairs.reduce(0) do |covered_count, pair|
        covered_count += 1 if pair.covered_by?(input_list)
        covered_count
      end
    end
  end
end
