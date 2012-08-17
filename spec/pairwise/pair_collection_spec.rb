require 'spec_helper'

module Pairwise
  describe PairCollection do
    describe '#input_combination_that_covers_most_pairs' do
      it "should do find the combination that covers most pairs" do
        pair_collection = PairCollection.new([:A2, :B2], [[:A2, :B2], [:B2, :A1]], 1)

        combination = pair_collection.input_combination_that_covers_most_pairs([:A2, :B2], [:C2, :A1])
        
        combination.should == [:A2, :B2, :C2]
      end
    end
  end
end