require 'yaml'

module Pairwise
  class Cli
    class << self
      def execute(args)
        new(args).execute
      end
    end

    def initialize(args)
      @input_file = args[0]
    end
      
    def execute
      inputs = YAML.load_file(@input_file)
      inputs = hash_inputs_to_list(inputs) if inputs.is_a?(Hash)
     
      test_set = Pairwise.test_set(inputs)
      display(test_set, input_names(inputs))
    end

    private
    def hash_inputs_to_list(inputs_hash)
      inputs_hash.map {|key, value| {key => value}}
    end
    
    def input_names(inputs)
      inputs.map{|input| input.keys}.flatten
    end
        
    def display(test_data, inputs)
      print "|"
      inputs.each do |key|
        print key + "|"
      end
      puts

      test_data.each do |data|
        print "|"
        data.each {|datum| print datum + "|"}
        puts
      end
    end
  end
end
