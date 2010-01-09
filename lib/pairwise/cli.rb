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
      @options = defaults
    end

    def parse!
      @args.extend(::OptionParser::Arguable)
      @args.options do |opts|
        opts.banner = ["Usage: pairwise [options] FILE.yml", "",
        "Example:",
            "pairwise data/inputs.yml", "", "",
          ].join("\n")
        opts.on("-k", "--keep-wild-cards") do
          @options[:keep_wild_cards] = true
        end
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

      inputs = YAML.load_file(@input_file)
      if valid_inputs?(inputs)
        input_data, input_labels = *parse_input_data!(inputs)

        builder = Pairwise::Builder.new(input_data, @options)

        @formatter.display(builder.build, input_labels)
      end
    end

    private
    def defaults
      {:keep_wild_cards => false}
    end

    def valid_inputs?(inputs)
      inputs && (inputs.is_a?(Array) || inputs.is_a?(Hash))
    end

    def exit_with_help
      @out.puts @args.options.help
      Kernel.exit(0)
    end

    def parse_input_data!(inputs)
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
