require 'yaml'
require 'optparse'
module Pairwise
  class Cli
    class << self
      def execute(args)
        new(args).execute
      end
    end

    def initialize(args)
      @args = args
      @args.extend(::OptionParser::Arguable)
      @args.options do |opts|
        opts.banner = ["Usage: pairwise [options] FILE.yml", "",
        "Example:",
            "pairwise data/inputs.yml", "", "",
          ].join("\n")
        opts.on_tail("-h", "--help", "You're looking at it.") do
          exit_with_help
        end
      end.parse!
          
      @input_file = @args[0] unless @args.empty?

      exit_with_help if @input_file.nil? || @input_file.empty?
    end
      
    def execute    
      inputs = YAML.load_file(@input_file)
      inputs = hash_inputs_to_list(inputs) if inputs.is_a?(Hash)
     
      test_set = Pairwise.test_set(inputs)
      display(test_set, input_names(inputs))
    end

    private

    def exit_with_help
      puts @args.options.help
      Kernel.exit(0)
    end
    
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
