require 'optparse'

module Pairwise
  class Cli
    BUILTIN_FORMATS = {
      'cucumber' => [Pairwise::Formatter::Cucumber,
                     'Tables for Cucumber'],
      'csv'      => [Pairwise::Formatter::Csv,
                     'Comma seperated values']}

    max = BUILTIN_FORMATS.keys.map{|s| s.length}.max
    FORMAT_HELP = (BUILTIN_FORMATS.keys.sort.map do |key|
      "  #{key}#{' ' * (max - key.length)} : #{BUILTIN_FORMATS[key][1]}"
    end)

    class << self
      def execute(args)
        new(args).execute!
      end
    end

    def initialize(args, out = STDOUT)
      @args, @out = args, out
      @options = defaults
    end

    def parse!
      @args.extend(::OptionParser::Arguable)
      @args.options do |opts|
        opts.banner = ["Usage: pairwise [options] FILE.[yml|csv]", "",
        "Example:",
            "pairwise data/inputs.yml", "", "",
          ].join("\n")
        opts.on("-k", "--keep-wild-cards",
        "Don't automatically replace any wild-cards which appear",
        "in the pairwise data") do
          @options[:keep_wild_cards] = true
        end
        opts.on('-f FORMAT', '--format FORMAT',
        "How to format pairwise data (Default: cucumber). Available formats:",
        *FORMAT_HELP) do |format|
          @options[:format] = format
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

      inputs = load_inputs!

      if valid_inputs?(inputs)
        input_data, input_labels = *parse_input_data!(inputs)

        builder = Pairwise::Builder.new(input_data, @options)

        formatter.display(builder.build, input_labels)
      else
        puts "Error: '#{@input_file}' does not contain the right yaml structure for me to generate the pairwise set!"
      end
    end

    private
    def defaults
      { :keep_wild_cards => false,
        :format => 'cucumber' }
    end

    def load_inputs!
      case input_file_type
      when 'csv'
        require 'csv'

        inputs = load_and_parse_csv
      when 'yml', 'yaml'
        require 'yaml'

        inputs = YAML.load_file(@input_file)
      else
        raise "Unsupported file type: #{@input_file}"
      end
    end

    def valid_inputs?(inputs)
      inputs && (inputs.is_a?(Array) || inputs.is_a?(Hash))
    end

    def exit_with_help
      @out.puts @args.options.help
      Kernel.exit(0)
    end

    def input_file_type
      @input_file[/\.(.+)$/, 1]
    end

    def load_and_parse_csv
      csv_data = CSV.read @input_file
      headers = csv_data.shift.map {|i| i.to_s.strip }
      string_data = csv_data.map {|row| row.map {|cell| cell.to_s.strip } }

      inputs = Hash.new {|h,k| h[k] = []}

      string_data.each do |row|
        row.each_with_index { |value, index| inputs[headers[index]] << value }
      end

      inputs
    end

    def formatter
      format = BUILTIN_FORMATS[@options[:format]][0]
      format.new(@out)
    end

    def parse_input_data!(inputs)
      inputs = hash_inputs_to_list(inputs) if inputs.is_a?(Hash)

      raw_inputs = inputs.map {|input| input.values[0]}
      input_labels = input_names(inputs)

      [raw_inputs, input_labels]
    end

    def hash_inputs_to_list(inputs_hash)
      inputs_hash.map do |key, value|
        value = [value] unless value.is_a?(Array)
        {key => value}
      end
    end

    def input_names(inputs)
      inputs.map{|input| input.keys}.flatten
    end

  end
end
