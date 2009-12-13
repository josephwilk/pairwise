require 'set'
require File.dirname(__FILE__) + '/test_pair'

# A pairwise implementation using the IPO strategy.
# Based on:
# http://www.google.co.uk/url?sa=t&source=web&ct=res&cd=1&ved=0CAkQFjAA&url=http%3A%2F%2Franger.uta.edu%2F~ylei%2Fpaper%2Fipo-tse.pdf&ei=RGAlS47KKKCrjAeEgf3YBw&usg=AFQjCNESXLOIUQNQuH1f3qLtU3vkeJ24fg&sig2=MPTr0gkSV0iJewtct11AgA
class Pairwise

  class InvalidInput < Exception; end

  class << self

    def generate(inputs)
      raw_inputs = inputs.map {|input| input.values[0]}

      raise InvalidInput, "Minimum of 2 inputs are required to generate pairwise test set" unless valid_inputs?(raw_inputs)

      test_set = generate_pairs_between(raw_inputs[0], [raw_inputs[1]], 0)

      if raw_inputs.size > 2
        raw_inputs[2..-1].each_with_index do |raw_input, i|
          i += 2
          test_set, pi = ipo_h(test_set, raw_input, raw_inputs[0..(i-1)])
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

    def ipo_v(test_set, pi)
      new_test_set = []

      pi.each do |pair|
        #TODO: Decided if we should replace all matches or single matches?
        if test_position = replace_wild_card?(new_test_set, pair)
          new_test_set[test_position][pair.p2_position] = pair.p2
        else
          new_test = Array.new(pair.p1_position){:wild_card}

          new_test[pair.p1_position] = pair.p1
          new_test[pair.p2_position] = pair.p2

          new_test_set << new_test
        end
      end

      test_set + new_test_set
    end

    def replace_wild_card?(test_set, pair)
      wild_card_list = test_set.map do |set|
        set[pair.p2_position] == :wild_card && set[pair.p1_position] == pair.p1
      end
      wild_card_list.rindex(true)
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
        if covered > most_covered
          selected_value = temp_value
          covered
        else
          most_covered
        end
      end
      selected_value
    end

    def pairs_covered_count(value, pairs)
      covered_count = 0
      covered = pairs.reduce(0) do |covered, pair|
        covered_count += 1 if pair.subset?(value)
      end
      covered_count
    end

  end
end
