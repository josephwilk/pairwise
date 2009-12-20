# A pairwise implementation using the IPO strategy.
# Based on: http://ranger.uta.edu/~ylei/paper/ipo-tse.pdf
module Pairwise
  class Builder

    WILD_CARD = :wild_card

    def initialize(inputs)
      @inputs = inputs
      @test_set = []
    end

    def build
      input_sets = generate_pairs_between(@inputs[0], [@inputs[1]], 0)
      @inputs.size > 2 ? ipo(input_sets) : input_sets
    end

    private

    def ipo(input_sets)
      @inputs[2..-1].each_with_index do |input_set, i|
        i += 2
        input_sets, pi = ipo_horizontal(input_sets, input_set, @inputs[0..(i-1)])
        input_sets = ipo_vertical(input_sets, pi)
      end
      replace_wild_cards(input_sets)
    end

    def ipo_horizontal(input_sets, parameter_i, inputs)
      pi = generate_pairs_between(parameter_i, inputs, inputs.size)

      if input_sets.size <= parameter_i.size
        input_sets = input_sets.enum_for(:each_with_index).map do |test, j|
          extended_test = test + [parameter_i[j]]
          pi = remove_pairs_covered_by(extended_test, pi)
          extended_test
        end
      else
        input_sets[0...parameter_i.size] = input_sets[0...parameter_i.size].enum_for(:each_with_index).map do |test, j|
          extended_test = input_sets[j] + [parameter_i[j]]
          pi = remove_pairs_covered_by(extended_test, pi)
          extended_test
        end

        input_sets[parameter_i.size..-1] = input_sets[parameter_i.size..-1].map do |test|
          extended_test = value_that_covers_most_pairs(test, parameter_i, pi)
          pi = remove_pairs_covered_by(extended_test, pi)
          extended_test
        end
      end

      [input_sets, pi]
    end

    def ipo_vertical(input_sets, pi)
      new_input_sets = []

      pi.each do |pair|
        #TODO: Decided if we should replace all matches or single matches?
        if test_position = replace_wild_card?(new_input_sets, pair)
          new_input_sets[test_position][pair.p2_position] = pair.p2
        else
          new_input_set = Array.new(pair.p1_position){WILD_CARD}

          new_input_set[pair.p1_position] = pair.p1
          new_input_set[pair.p2_position] = pair.p2

          new_input_sets << new_input_set
        end
      end

      input_sets + new_input_sets
    end

    def replace_wild_card?(input_sets, pair)
      wild_card_list = input_sets.map do |input_set|
        input_set[pair.p2_position] == WILD_CARD && input_set[pair.p1_position] == pair.p1
      end
      wild_card_list.rindex(true)
    end

    def replace_wild_cards(input_sets)
      input_sets.map do |input_set|
        input_set.enum_for(:each_with_index).map do |input_value, index|
          input_value == WILD_CARD ? pick_random_value(@inputs[index]) : input_value
        end
      end
    end

    def pick_random_value(input_set)
      input_set[rand(input_set.size)]
    end

    def generate_pairs_between(parameter_i, input_sets, p_index)
      pairs = []
      parameter_i.each do |p|
        input_sets.each_with_index do |input_set, q_index|
          input_set.each do |q|
            pairs << TestPair.new(p_index, q_index, p, q)
          end
        end
      end
      pairs
    end

    def remove_pairs_covered_by(extended_input_set, pi)
      pi.reject{|pair| pair.covered_by?(extended_input_set)}
    end

    def value_that_covers_most_pairs(input_set, parameter_i, pi)
      selected_input_set = nil
      parameter_i.reduce(0) do |most_covered, value|
        input_set_candidate = input_set + [value]
        covered = pairs_covered_count(input_set_candidate, pi)
        if covered >= most_covered
          selected_input_set = input_set_candidate
          covered
        else
          most_covered
        end
      end
      selected_input_set
    end

    def pairs_covered_count(input_set, pairs)
      pairs.reduce(0) do |covered_count, pair|
        covered_count += 1 if pair.covered_by?(input_set)
        covered_count
      end
    end
  end
end
