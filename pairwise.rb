require 'rubygems'
require 'set'

class Pairwise

  class InvalidInput < Exception; end

  class << self

    def generate(inputs)
      raise InvalidInput, "Minimum of 2 inputs are required to generate pairwise test set" if inputs.length < 2 || inputs[0].values[0].empty? && inputs[1].values[0].empty?

      inputs_without_labels = inputs.map {|input| input.values[0]}

      test_set = generate_pairs_between(inputs_without_labels[0], [inputs_without_labels[1]])
      count = 0
      if inputs_without_labels.size > 2
        for i in 2.. inputs_without_labels.size-1
          test_set, pi = ipo_h(test_set, inputs_without_labels[i], inputs_without_labels[0..(i-1)])
          test_set = ipo_v(test_set, pi)
        end
      end
      test_set
    end

    private

    #TODO: Look at using zip when extending tests
    def ipo_h(test_set, parameter_i, inputs)
      pi = generate_pairs_between(parameter_i, inputs)
      q = parameter_i.size

      if test_set.size <= q
        for j in 0..test_set.size do
          extended_test = test_set[j] << parameter_i[j]
          pi = remove_pairs_covered_by(extended_test, pi)
        end
      else
        for j in 0...q do
          extended_test = test_set[j] << parameter_i[j]
          pi = remove_pairs_covered_by(extended_test, pi)
        end

        for i in q...test_set.size do
          extended_test = select_value_that_covers_most_pairs(test_set[i], parameter_i, pi)
          pi = remove_pairs_covered_by(extended_test, pi)
          test_set[i] = extended_test
        end
      end

      [test_set, pi]
    end

    def ipo_v(test_set, pi)
      new_test_set = []

      pi.each do |(p1,p2)|
        if wild_card_index = contains_wild_card?(new_test_set)
          new_test_set[wild_card_index] = replace_wild_card(new_test_set[wild_card_index], p2)
        else
          #TODO: need to handle arbitrary set length
          new_test_set << [p2, :wild_card, p1]
        end
      end

      test_set + new_test_set
    end

    def contains_wild_card?(test_set)
      wild_card_list = test_set.map{|set| set.include?(:wild_card) ? true : false}
      wild_card_list.rindex(true)
    end

    def replace_wild_card(set, replace_with_value)
      set.map{|value| value == :wild_card ? replace_with_value : value}
    end

    def generate_pairs_between(parameter_i, inputs)
      pairs = []
      parameter_i.each do |p|
        inputs.each do |input|
          input.each do |q|
            pairs << [p, q]
          end
        end
      end
      pairs
    end

    def remove_pairs_covered_by(extended_test, pi)
      pi.select{ |pair| !matches_pair?(pair, extended_test)}
    end

    def select_value_that_covers_most_pairs(test_value, parameter_i, pi)
      max_value = parameter_i[0]

      selected_value = nil
      parameter_i.reduce(0) do |most_covered, value|
        temp_value = test_value.dup + [value]
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
