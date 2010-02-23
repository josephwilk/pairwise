require File.dirname(__FILE__) + '/../spec_helper'

module Pairwise
  describe Cli do

    before(:each) do
      Kernel.stub!(:exit).and_return(nil)
    end

    def output_stream
      @output_stream ||= StringIO.new
    end

    def options
      #TODO: push options out to an object and avoid hacking at private instance vars
      @cli.instance_variable_get("@options")
    end

    def prepare_args(args)
      args.is_a?(Array) ? args : args.split(' ')
    end

    def after_parsing(args)
      @cli = Pairwise::Cli.new(prepare_args(args), output_stream)
      @cli.parse!
      yield
    end

   context '--keep-wild-cards' do
      it "displays wild cards in output result" do
        after_parsing('--keep-wild-cards') do
          options[:keep_wild_cards].should == true
        end
      end
    end

    context '-f FORMAT or --format FORMAT' do
      it "defaults to the cucumber format for output" do
        after_parsing('') do
          options[:format].should == 'cucumber'
        end
      end

      it "overides the cucumber format when passed a specific format" do
        after_parsing('--format csv') do
          options[:format].should == 'csv'
        end
      end
    end

    context "--help" do
      it "displays usage" do
        after_parsing('--help') do
          output_stream.string.should =~ /Usage: pairwise \[options\] FILE\.\[yml|csv\]/
        end
      end
    end

    context '--version' do
      it "displays Pairwise's version" do
        after_parsing('--version') do
          output_stream.string.should =~ /#{Pairwise::VERSION}/
        end
      end
    end

  end
end
