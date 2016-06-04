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

      @filename_with_path = @args[0] unless @args.empty?
    end

    def execute!
      parse!
      validate_options!

      if inputs = InputFile.load(@filename_with_path)
        builder = Pairwise::IPO.new(inputs.data, @options)

        formatter.display(builder.build, inputs.labels)
      else
        puts "Error: '#{@filename_with_path}' does not contain the right structure for me to generate the pairwise set!"
      end
    end

    private
    def defaults
      { :keep_wild_cards => false,
        :format => 'cucumber' }
    end

    def validate_options!
      exit_with_help if @filename_with_path.nil? || @filename_with_path.empty?
      raise Errno::ENOENT, @filename_with_path  unless File.exist?(@filename_with_path)
      exit_with_help unless File.file?(@filename_with_path)
    end

    def exit_with_help
      @out.puts @args.options.help
      Kernel.exit(0)
    end

    def formatter
      format = BUILTIN_FORMATS[@options[:format]][0]
      format.new(@out)
    end

  end
end
