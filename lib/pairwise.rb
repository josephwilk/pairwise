$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'pairwise/test_pair'
require 'pairwise/pair_collection'
require 'pairwise/ipo'
require 'pairwise/ipo/horizontal'
require 'pairwise/ipo/vertical'
require 'pairwise/formatter'
require 'pairwise/input_data'
require 'pairwise/input_file'
require 'pairwise/cli'

require 'yaml'
if RUBY_VERSION != '1.8.7'
  YAML::ENGINE.yamler = 'syck' 
end

module Pairwise
  class InvalidInputData < Exception; end

  VERSION = '0.2.1'

  class << self
    def combinations(*inputs)
      raise InvalidInputData, "Minimum of 2 inputs are required to generate pairwise test set" unless valid?(inputs)
      Pairwise::IPO.new(inputs).build
    end

    private
    def valid?(inputs)
      array_of_arrays?(inputs) &&
        inputs.length >= 2 &&
        !inputs[0].empty? && !inputs[1].empty?
    end

    def array_of_arrays?(data)
      data.reject{|datum| datum.kind_of?(Array)}.empty?
    end

  end
end
