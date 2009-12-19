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
      test_set = generate_pairs_between(@inputs[0], [@inputs[1]], 0)
      @inputs.size > 2 ? ipo(test_set) : test_set
    end

    private

    def ipo(test_set)
      @inputs[2..-1].each_with_index do |input, i|
        i += 2
        test_set, pi = ipo_horizontal(test_set, input, @inputs[0..(i-1)])
        test_set = ipo_vertical(test_set, pi)
      end
      replace_wild_cards(test_set)
    end

    def ipo_horizontal(test_set, parameter_i, inputs)
      pi = generate_pairs_between(parameter_i, inputs, inputs.size)

      if test_set.size <= parameter_i.size
        test_set = test_set.enum_for(:each_with_index).map do |test, j|
          extended_test = test + [parameter_i[j]]
          pi = remove_pairs_covered_by(extended_test, pi)
          extended_test
        end
      else
        test_set[0...parameter_i.size] = test_set[0...parameter_i.size].enum_for(:each_with_index).map do |test, j|
          extended_test = test_set[j] + [parameter_i[j]]
          pi = remove_pairs_covered_by(extended_test, pi)
          extended_test
        end

        test_set[parameter_i.size..-1] = test_set[parameter_i.size..-1].map do |test|
          extended_test = value_that_covers_most_pairs(test, parameter_i, pi)
          pi = remove_pairs_covered_by(extended_test, pi)
          extended_test
        end
      end

      [test_set, pi]
    end

    def ipo_vertical(test_set, pi)
      new_test_set = []

      pi.each do |pair|
        #TODO: Decided if we should replace all matches or single matches?
        if test_position = replace_wild_card?(new_test_set, pair)
          new_test_set[test_position][pair.p2_position] = pair.p2
        else
          new_test = Array.new(pair.p1_position){WILD_CARD}

          new_test[pair.p1_position] = pair.p1
          new_test[pair.p2_position] = pair.p2

          new_test_set << new_test
        end
      end

      test_set + new_test_set
    end

    def replace_wild_card?(test_set, pair)
      wild_card_list = test_set.map do |set|
        set[pair.p2_position] == WILD_CARD && set[pair.p1_position] == pair.p1
      end
      wild_card_list.rindex(true)
    end

    def replace_wild_cards(test_set)
      test_set.map do |test|
        test.enum_for(:each_with_index).map do |value, index|
          value == WILD_CARD ? pick_random_value(@inputs[index]) : value
        end
      end
    end

    def pick_random_value(values)
      values[rand(values.size)]
    end

    def generate_pairs_between(parameter_i, inputs, p_index)
      pairs = []
      parameter_i.each do |p|
        inputs.each_with_index do |input, q_index|
          input.each do |q|
            pairs << TestPair.new(p_index, q_index, p, q)
          end
        end
      end
      pairs
    end

    def remove_pairs_covered_by(extended_test, pi)
      pi.reject{|pair| pair.subset?(extended_test)}
    end

    def value_that_covers_most_pairs(test_value, parameter_i, pi)
      selected_value = nil
      parameter_i.reduce(0) do |most_covered, value|
        temp_value = test_value + [value]
        covered = pairs_covered_count(temp_value, pi)
        if covered >= most_covered
          selected_value = temp_value
          covered
        else
          most_covered
        end
      end
      selected_value
    end

    def pairs_covered_count(value, pairs)
      pairs.reduce(0) do |covered_count, pair|
        covered_count += 1 if pair.subset?(value)
        covered_count
      end
    end
  end
end
