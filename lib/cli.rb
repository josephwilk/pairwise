require 'yaml'
require 'pairwise'

class Cli
  class << self
    def execute(args)
      input_file = ARGV[0]
      inputs = YAML.load_file(input_file)

      inputs_list = []
      inputs.each {|key, value| inputs_list << {:key => value}}

      test_data = Pairwise.generate(inputs_list)
      display(test_data, inputs)
    end

    private
    def display(test_data, inputs)
      print "|"
      inputs.keys.each do |key|
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
