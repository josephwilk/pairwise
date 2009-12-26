require 'yaml'
require 'optparse'
module Pairwise
  class Cli
    class << self
      def execute(args)
        new(args).execute!
      end
    end

    def initialize(args, out = STDOUT)
      @args, @out = args, out
      @formatter = Formatter::Cucumber.new(@out)
    end

    def parse!
      @args.extend(::OptionParser::Arguable)
      @args.options do |opts|
        opts.banner = ["Usage: pairwise [options] FILE.yml", "",
        "Example:",
            "pairwise data/inputs.yml", "", "",
          ].join("\n")

        opts.on_tail("--version", "Show version.") do
          @out.puts Pairwise::VERSION
          Kernel.exit(0)
        end
        opts.on_tail("-h", "--help", "You're looking at it.") do
          exit_with_help
        end
      end.parse!

      @input_file = @args[0] unless @args.empty?
    end

    def execute!
      parse!
      exit_with_help if @input_file.nil? || @input_file.empty?
      input_data, input_labels = *load_and_parse_input_file!

      @formatter.display(Pairwise.combinations(*input_data), input_labels)
    end

    private
    def exit_with_help
      @out.puts @args.options.help
      Kernel.exit(0)
    end

    def load_and_parse_input_file!
      inputs = YAML.load_file(@input_file)
      inputs = hash_inputs_to_list(inputs) if inputs.is_a?(Hash)

      raw_inputs = inputs.map {|input| input.values[0]}
      input_labels = input_names(inputs)

      [raw_inputs, input_labels]
    end

    def hash_inputs_to_list(inputs_hash)
      inputs_hash.map {|key, value| {key => value}}
    end

    def input_names(inputs)
      inputs.map{|input| input.keys}.flatten
    end

  end
end
