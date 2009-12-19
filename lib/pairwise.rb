$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'pairwise/test_pair'
require 'pairwise/builder'

module Pairwise
  class InvalidInput < Exception; end

  class << self
    def test_set(inputs)
      raw_inputs = inputs.map {|input| input.values[0]}
      raise InvalidInput, "Minimum of 2 inputs are required to generate pairwise test set" unless valid?(inputs)
      builder = Pairwise::Builder.new(raw_inputs)
      builder.build
    end

    private
    def valid?(inputs)
      inputs.length >= 2 && !inputs[0].empty? && !inputs[1].empty?
    end
  end
end
