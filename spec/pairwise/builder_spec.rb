require 'spec_helper'

module Pairwise
  describe Builder do

    describe 'ipo horizontal growth' do
      before(:each) do
        @test_pairs = [[:A1, :B1], [:A1, :B2], [:A2, :B1], [:A2, :B2]]
        @data = [[:A1, :A2],[:B1, :B2],[:C1 , :C2 , :C3 ]]

        @builder = Builder.new(@test_pairs)
      end

      it "should return pairs extended with C's inputs" do
        test_set, _ = @builder.send(:horizontal_growth, @test_pairs, @data[2], @data[0..1])

        test_set.should == [[:A1, :B1, :C1],
                            [:A1, :B2, :C2],
                            [:A2, :B1, :C3],
                            [:A2, :B2, :C1]]
      end

      it "should return all the uncovered pairs" do
        _, pi = @builder.send(:horizontal_growth, @test_pairs, @data[2], @data[0..1])

        # We are getting the uncovered pairs in reverse
        #pi.should == [[:A2, :C2],[:A1, :C3],[:B1, :C2],[:B2, :C3]]
        # Cheat and check we get the list in reverse
        pi.to_a.should == [[:C2, :A2], [:C2, :B1], [:C3, :A1], [:C3, :B2]]
      end
    end
  end
end
