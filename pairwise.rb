require 'rubygems'
require 'set'

class TestPair < Array
  attr_reader :p1_position
  attr_reader :p2_position

  def initialize(p1_position, p2_position, p1, p2)
    @p1_position = p1_position
    @p2_position = p2_position
    super([p1, p2])
  end
end

class Pairwise

  class InvalidInput < Exception; end

  class << self

    def generate(inputs)
      raw_inputs = inputs.map {|input| input.values[0]}

      raise InvalidInput, "Minimum of 2 inputs are required to generate pairwise test set" unless valid_inputs?(raw_inputs)

      test_set = generate_pairs_between(raw_inputs[0], [raw_inputs[1]], 0)

      if raw_inputs.size > 2
        for i in 2...raw_inputs.size
          test_set, pi = ipo_h(test_set, raw_inputs[i], raw_inputs[0..(i-1)])
          test_set = ipo_v(test_set, pi)
        end
      end
      test_set
    end

    private

    def valid_inputs?(inputs)
      inputs.length >= 2 && !inputs[0].empty? && !inputs[1].empty?
    end

    def ipo_h(test_set, parameter_i, inputs)
      pi = generate_pairs_between(parameter_i, inputs, inputs.size)
      q = parameter_i.size

      if test_set.size <= q
        test_set = test_set.enum_for(:each_with_index).map do |test, j|
          extended_test = test + [parameter_i[j]]
          pi = remove_pairs_covered_by(extended_test, pi)
          extended_test
        end
      else
        test_set[0...q] = test_set[0...q].enum_for(:each_with_index).map do |test, j|
          extended_test = test_set[j] + [parameter_i[j]]
          pi = remove_pairs_covered_by(extended_test, pi)
          extended_test
        end

        test_set[q..-1] = test_set[q..-1].map do |test|
          extended_test = value_that_covers_most_pairs(test, parameter_i, pi)
          pi = remove_pairs_covered_by(extended_test, pi)
          extended_test
        end
      end

      [test_set, pi]
    end

    def ipo_v(test_set, pi)
      new_test_set = []

      pi.each do |pair|
        if wild_card_index = replace_wild_card?(new_test_set, pair)
          new_test_set[wild_card_index] = replace_wild_card(new_test_set[wild_card_index], pair[1])
        else
          new_test = Array.new(pair.p1_position){:wild_card}

          new_test[pair.p1_position] = pair[0]
          new_test[pair.p2_position] = pair[1]

          new_test_set << new_test
        end
      end

      test_set + new_test_set
    end

    def replace_wild_card?(test_set, pair)
      wild_card_list = test_set.map do |set|
        set[pair.p2_position] == :wild_card && set[pair.p1_position] == pair[0]
      end
      wild_card_list.rindex(true)
    end

    def replace_wild_card(set, replace_with_value)
      set.map{|value| value == :wild_card ? replace_with_value : value}
    end

    def generate_pairs_between(parameter_i, inputs, i_index)
      pairs = []
      parameter_i.each do |p|
        inputs.each_with_index do |input, p_index|
          input.each do |q|
            pairs << TestPair.new(i_index, p_index, p, q)
          end
        end
      end
      pairs
    end

    def remove_pairs_covered_by(extended_test, pi)
      pi.select{ |pair| !matches_pair?(pair, extended_test)}
    end

    def value_that_covers_most_pairs(test_value, parameter_i, pi)
      max_value = parameter_i[0]

      selected_value = nil
      parameter_i.reduce(0) do |most_covered, value|
        temp_value = test_value + [value]
        covered = pairs_covered(temp_value, pi)
        if covered > most_covered
          selected_value = temp_value
          covered
        else
          most_covered
        end
      end
      selected_value
    end

    def pairs_covered(value, pairs)
      covered_count = 0
      covered = pairs.reduce(0) do |covered, pair|
        covered_count += 1 if matches_pair?(pair, value)
      end
      covered_count
    end

    def matches_pair?(pair_1, pair_2)
      pair_1_set, pair_2_set = Set.new(pair_1), Set.new(pair_2)
      pair_1_set.subset?(pair_2_set)
    end

  end
end
