require 'yaml'

module Pairwise
  class Cli
    class << self
      def execute(args)
        input_file = ARGV[0]
        inputs = YAML.load_file(input_file)

        test_set = Pairwise.test_set(inputs)
        display(test_set, input_names(inputs))
      end

      private
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
end
