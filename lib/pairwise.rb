$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'pairwise/test_pair'
require 'pairwise/builder'
require 'pairwise/cli'

require 'yaml'

module Pairwise
  class InvalidInputData < Exception; end

  version = YAML.load_file(File.dirname(__FILE__) + '/../VERSION.yml')
  VERSION = [version[:major], version[:minor], version[:patch], version[:build]].compact.join('.')

  class << self
    def test_set(inputs)
      raise InvalidInputData, "Minimum of 2 inputs are required to generate pairwise test set" unless valid?(inputs)
      Pairwise::Builder.new(inputs).build
    end

    private
    def valid?(inputs)
      inputs.length >= 2 && !inputs[0].empty? && !inputs[1].empty?
    end

  end
end
