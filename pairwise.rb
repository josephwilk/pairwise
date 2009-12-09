require 'rubygems'
require 'ruby-debug'
require 'set'
require 'spec'

class Pairwise

  class InvalidInput < Exception; end

  class << self

    def generate(inputs)
      raise InvalidInput, "Minimum of 2 inputs are required to generate pairwise test set" if inputs.length < 2 || inputs[0].values[0].empty? && inputs[1].values[0].empty?
      test_set = generate_pairs_between(inputs[0].values[0], [inputs[1]])
      count = 0
      if inputs.size > 2
        for i in 2.. inputs.size-1
          test_set, pi = ipo_h(test_set, inputs[i].values[0], inputs[0..(i-1)])
          #ipo_v(test_set, pi)
        end
      end
      test_set
    end

    def pairs_covered(value, pairs)
      covered_count = 0
      pairs.each do |pair|
        covered = value.reduce(true){|covered, single_value| covered && pair.include?(single_value)}
        covered_count += 1 if covered
      end
      covered_count
    end
    
    private

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
          value = select_value_that_covers_most_pairs(test_set[i], parameter_i, pi)
          extended_test = test_set[i] << value
          pi = remove_pairs_covered_by(extended_test, pi)
        end
      end

      [test_set, pi]
    end

    def generate_pairs_between(parameter_i, inputs)
      pairs = []
      parameter_i.each do |p|
        inputs.each do |q|
          q.values[0].each do |q1|
            pairs << [p, q1]
          end
        end
      end
      pairs
    end

    def remove_pairs_covered_by(extended_test, pi)
      pi
    end

    def select_value_that_covers_most_pairs(test_value, parameter_i, pi)
      parameter_i.each do |value|
        temp_value = test_value << value
        pairs_covered(temp_value, pi)
      end
    end
    
  end
end

describe "pairwise" do

  it "should be invalid when running with no input" do
    lambda{ Pairwise.generate([]) }.should raise_error(Pairwise::InvalidInput)
    lambda{ Pairwise.generate([{:A => []}]) }.should raise_error(Pairwise::InvalidInput)
  end

  it "should be invalid when running with only 1 input" do
    lambda{ Pairwise.generate([{:A => [:A1, :A2]}])}.should raise_error(Pairwise::InvalidInput)
  end
  
  it "should generate all pairs for two parameters" do
    data = [{:A => [:A1, :A2]},
            {:B => [:B1, :B2]}]

    Pairwise.generate(data).should == [[:A1, :B1], [:A1, :B2], [:A2, :B1], [:A2, :B2]]
  end

  it "should generate pairs for three paramters" do
    data = [{:A => [:A1, :A2]},
            {:B => [:B1, :B2]},
            {:C => [:C1 , :C2 , :C3 ]}]

    Pairwise.generate(data).should == [[:A1, :B1, :C1],
                                       [:A1, :B1, :C2],
                                       [:A2, :B1, :C3],
                                       [:A2, :B2, :C1]]
  end

end
