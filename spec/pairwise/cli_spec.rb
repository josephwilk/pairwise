require File.dirname(__FILE__) + '/../spec_helper'

module Pairwise
  describe Cli do

    before(:each) do
      Kernel.stub!(:exit).and_return(nil)
    end

    def output_stream
      @output_stream ||= StringIO.new
    end

    def prepare_args(args)
      args.is_a?(Array) ? args : args.split(' ')
    end

    def after_parsing(args)
      Pairwise::Cli.new(prepare_args(args), output_stream).parse!
      yield
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
