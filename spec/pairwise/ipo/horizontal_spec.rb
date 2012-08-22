require 'spec_helper'

module Pairwise
module IPO
  
  describe Horizontal do
    describe ".growth" do
      context "when the input_combinations size is smaller than the input values for growth size" do
        it "should extenhd with C's inputs" do
          input_combinations = [[:A1, :B1], [:A1, :B2]]
          data               = [[:A1, :A2], [:C1, :C2, :C3 ]]
        
          test_set, _ = Horizontal.growth(input_combinations, data[1], data[0..1])
          
          test_set.should == [[:A1, :B1, :C1], [:A1, :B2, :C3]]
        end
      end
      
      context "when the input_combinations size is larger than the input values for growth size" do
        before(:each) do
          @test_pairs = [[:A1, :B1], [:A1, :B2], [:A2, :B1], [:A2, :B2]]
          @data       = [[:A1, :A2], [:B1, :B2], [:C1, :C2, :C3 ]]
        end

        it "should return pairs extended with C's inputs" do
          test_set, _ = Horizontal.growth(@test_pairs, @data[2], @data[0..1])

          test_set.should == [[:A1, :B1, :C1], [:A1, :B2, :C3], [:A2, :B1, :C3], [:A2, :B2, :C2]]
        end

        it "should return all the uncovered pairs" do
          _, pi = Horizontal.growth(@test_pairs, @data[2], @data[0..1])

          pi.to_a.should == [[:C1, :A2], [:C1, :B2], [:C2, :A1], [:C2, :B1]]
        end
      
      end
    end
  end

end
end