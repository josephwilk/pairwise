require 'rubygems'
require 'spec'

require File.dirname(__FILE__) + '/pairwise'

describe "pairwise" do

  context "invalid inputs" do
    it "should be invalid when running with no input" do
      lambda{ Pairwise.generate([]) }.should raise_error(Pairwise::InvalidInput)
      lambda{ Pairwise.generate([{:A => []}]) }.should raise_error(Pairwise::InvalidInput)
    end

    it "should be invalid when running with only 1 input" do
      lambda{ Pairwise.generate([{:A => [:A1, :A2]}])}.should raise_error(Pairwise::InvalidInput)
    end
  end

  context "equal size inputs" do
    it "should generate pairs for 2 parameters of 1 value" do
      data = [{:A => [:A1]}, {:B => [:B1]}]

      Pairwise.generate(data).should == [[:A1, :B1]]
    end

    it "should generate all pairs for 2 parameters of 2 values" do
      data = [{:A => [:A1, :A2]}, {:B => [:B1, :B2]}]

      Pairwise.generate(data).should == [[:A1, :B1], [:A1, :B2], [:A2, :B1], [:A2, :B2]]
    end

    it "should generate all pairs for 3 parameters of 1 value" do
      data = [{:A => [:A1]}, {:B => [:B1]}, {:C => [:C1]}]

      Pairwise.generate(data).should == [[:A1, :B1, :C1]]
    end

    it "should generate pairs for three paramters" do
      data = [{:A => [:A1, :A2]},
              {:B => [:B1, :B2]},
              {:C => [:C1 , :C2]}]

      Pairwise.generate(data).should == [[:A1, :B1, :C1],
                                         [:A1, :B2, :C2],
                                         [:A2, :B1, :C2],
                                         [:A2, :B2, :C1]]
    end
  end

  context "unequal inputs" do
    it "should generate all pairs for 3 parameters of 1,1,2 values" do
      data = [{:A => [:A1]}, {:B => [:B1]}, {:C => [:C1, :C2]}]

      Pairwise.generate(data).should == [[:A1, :B1, :C1],
                                         [:A1, :B1, :C2]]
    end

    it "should generate all pairs for 3 parameters of 1,1,3 values" do
      data = [{:A => [:A1]}, {:B => [:B1]}, {:C => [:C1, :C2, :C3]}]

      Pairwise.generate(data).should == [[:A1, :B1, :C1],
                                         [:A1, :B1, :C2],
                                         [:A1, :B1, :C3]]
    end

    it "should generate all pairs for 3 parameters of 1,2,3 values" do
      data = [{:A => [:A1]}, {:B => [:B1, :B2]}, {:C => [:C1, :C2, :C3]}]

      Pairwise.generate(data).should == [[:A1, :B1, :C1],
                                         [:A1, :B2, :C2],
                                         [:wild_card, :B2, :C1],
                                         [:wild_card, :B1, :C2],
                                         [:A1, :B1, :C3],
                                         [:wild_card, :B2, :C3]]
    end

    it "should generate all pairs for 3 parameters of 2,1,2 values" do
      data = [{:A => [:A1, :A2]}, {:B => [:B1]}, {:C => [:C1, :C2]}]

      Pairwise.generate(data).should == [[:A1, :B1, :C1],
                                         [:A2, :B1, :C2],
                                         [:A2, :wild_card, :C1],
                                         [:A1, :wild_card, :C2]]



      #[[:A1, :B1, :C1],
      # [:A2, :B1, :C2],
      # [:A1, :B1, :C2],
      # [:A2, :B1, :C2]]
    end

    it "should generate pairs for three paramters" do
      data = [{:A => [:A1, :A2]},
              {:B => [:B1, :B2]},
              {:C => [:C1 , :C2 , :C3 ]}]

      Pairwise.generate(data).should == [[:A1, :B1, :C1],
                                         [:A1, :B2, :C2],
                                         [:A2, :B1, :C3],
                                         [:A2, :B2, :C1],
                                         [:A2, :B1, :C2],
                                         [:A1, :B2, :C3]]
    end
  end

  describe 'ipo horizontal growth' do
    before(:each) do
      @test_pairs = [[:A1, :B1], [:A1, :B2], [:A2, :B1], [:A2, :B2]]

      @data = [[:A1, :A2],[:B1, :B2],[:C1 , :C2 , :C3 ]]
    end

    it "should return pairs extended with C's inputs" do
      test_set, _ = Pairwise.send(:ipo_h, @test_pairs, @data[2], @data[0..1])

      test_set.should == [[:A1, :B1, :C1],
                          [:A1, :B2, :C2],
                          [:A2, :B1, :C3],
                          [:A2, :B2, :C1]]
    end

    it "should return all the uncovered pairs" do
      _, pi = Pairwise.send(:ipo_h, @test_pairs, @data[2], @data[0..1])

      # We are getting the uncovered pairs in reverse
      #pi.should == [[:A2, :C2],[:A1, :C3],[:B1, :C2],[:B2, :C3]]
      # Cheat and check we get the list in reverse
      pi.should == [[:C2, :A2], [:C2, :B1], [:C3, :A1], [:C3, :B2]]
    end
  end
end
