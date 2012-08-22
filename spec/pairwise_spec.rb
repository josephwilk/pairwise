require 'spec_helper'

describe Pairwise do
  before(:each) do
    Kernel.stub!(:rand).and_return(0)
  end

  context "with invalid inputs" do
    it "should be invalid when running with no input" do
      lambda{ Pairwise.combinations([]) }.should raise_error(Pairwise::InvalidInputData)
    end

    it "should be invalid when running with only 1 input" do
      lambda{ Pairwise.combinations([:A1, :A2])}.should raise_error(Pairwise::InvalidInputData)
    end

    it "should be invalid when running with a single list input" do
      lambda{ Pairwise.combinations([:A1, :A2])}.should raise_error(Pairwise::InvalidInputData)
    end
  end

  context "with valid inputs" do
    context "which are equal lengths" do
      it "should generate pairs for 2 parameters of 1 value" do
        data = [[:A1], [:B1]]

        Pairwise.combinations(*data).should == [[:A1, :B1]]
      end

      it "should generate all pairs for 2 parameters of 2 values" do
        data = [[:A1, :A2], [:B1, :B2]]

        Pairwise.combinations(*data).should == [[:A1, :B1], [:A1, :B2], [:A2, :B1], [:A2, :B2]]
      end

      it "should generate all pairs for 3 parameters of 1 value" do
        data = [[:A1], [:B1], [:C1]]

        Pairwise.combinations(*data).should == [[:A1, :B1, :C1]]
      end

      it "should generate pairs for three paramters" do
        data = [[:A1, :A2],
                [:B1, :B2],
                [:C1 , :C2]]

        Pairwise.combinations(*data).should == [[:A1, :B1, :C1],
                                           [:A1, :B2, :C2],
                                           [:A2, :B1, :C2],
                                           [:A2, :B2, :C1]]
      end
    end

    context "which are unequal lengths" do
      it "should generate all pairs for 3 parameters of 1,1,2 values" do
        data = [[:A1], [:B1], [:C1, :C2]]

        Pairwise.combinations(*data).should == [[:A1, :B1, :C1],
                                           [:A1, :B1, :C2]]
      end

      it "should generate all pairs for 3 parameters of 1,1,3 values" do
        data = [[:A1], [:B1], [:C1, :C2, :C3]]

        Pairwise.combinations(*data).should == [[:A1, :B1, :C1],
                                           [:A1, :B1, :C2],
                                           [:A1, :B1, :C3]]
      end

      it "should generate all pairs for 3 parameters of 1,2,3 values" do
        data = [[:A1], [:B1, :B2], [:C1, :C2, :C3]]

        Pairwise.combinations(*data).should == [[:A1, :B1, :C1],
                                           [:A1, :B2, :C2],
                                           [:A1, :B2, :C1],
                                           [:A1, :B1, :C2],
                                           [:A1, :B1, :C3],
                                           [:A1, :B2, :C3]]
      end

      it "should generate all pairs for 3 parameters of 2,1,2 values" do
        data = [[:A1, :A2], [:B1], [:C1, :C2]]

        Pairwise.combinations(*data).should == [[:A1, :B1, :C1],
                                           [:A2, :B1, :C2],
                                           [:A2, :B1, :C1],
                                           [:A1, :B1, :C2]]


        #:A1, :B1, :C1
        #:A1, :B1, :C2
        #:A2, :B1, :C1
        #:A2,any_value_of_B, :C2
      end

      it "should generate all pairs for 4 parameters of 2,1,2,2 values" do
        data = [[:A1, :A2], [:B1], [:C1, :C2], [:D1, :D2]]

        Pairwise.combinations(*data).should == [[:A1, :B1, :C1, :D1], 
                                                [:A2, :B1, :C2, :D2], 
                                                [:A2, :B1, :C1, :D1], 
                                                [:A1, :B1, :C2, :D1], 
                                                [:A1, :B1, :C1, :D2]]
      end

      it "should generate pairs for three parameters" do
        data = [[:A1, :A2],
                [:B1, :B2],
                [:C1 , :C2 , :C3 ]]

        Pairwise.combinations(*data).should == [[:A1, :B1, :C1], 
                                                [:A1, :B2, :C2], 
                                                [:A2, :B1, :C2], 
                                                [:A2, :B2, :C1], 
                                                [:A1, :B2, :C3], 
                                                [:A2, :B1, :C3]]
      end

      describe "replacing wildcards which could have more than one option" do
        it "should generate pairs for 2 parameters of 3,2,3 values" do
          Pairwise.combinations([:A1, :A2, :A3],
                                [:B1, :B2],
                                [:C1, :C2, :C3]).should == [[:A1, :B1, :C1],
                                                            [:A1, :B2, :C2],
                                                            [:A2, :B1, :C3],
                                                            [:A2, :B2, :C1],
                                                            [:A3, :B1, :C2],
                                                            [:A3, :B2, :C3],
                                                            [:A3, :B1, :C1], #B1 is a wildcard replacement
                                                            [:A2, :B1, :C2], #B1 is a wildcard replacement
                                                            [:A1, :B1, :C3]] #B1 is a wildcard replacement
        end
      end
    end

  end
end
