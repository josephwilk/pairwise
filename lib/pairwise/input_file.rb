module Pairwise
  class InputFile

    class << self
      def load(filename)
        new(filename).load_and_parse
      end
    end

    def initialize(filename)
      @filename = filename
      self.extend(input_file_module)
    end

    def input_file_module
      type = @filename[/\.(.+)$/, 1]
      case type.downcase
      when 'yaml', 'yml' then Yaml
      else
        Pairwise.const_get(type.capitalize) rescue raise "Unsupported file type: #{type}"
      end
    end

  end

  module Yaml
    def load_and_parse
      require 'yaml'

      inputs = YAML.load_file(@filename)
    end
  end

  module Csv
    def load_and_parse
      require 'csv'

      csv_data = CSV.read @filename
      headers = csv_data.shift.map {|i| i.to_s.strip }
      string_data = csv_data.map {|row| row.map {|cell| cell.to_s.strip } }

      inputs = Hash.new {|h,k| h[k] = []}

      string_data.each do |row|
        row.each_with_index { |value, index| inputs[headers[index]] << value }
      end

      inputs
    end
  end
end