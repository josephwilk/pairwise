module Pairwise
  class InputFile

    class << self
      def load(filename)
        inputs = self.new(filename).load_and_parse
        InputData.new(inputs) if valid?(inputs)
      end

      def valid?(inputs)
        inputs && (inputs.is_a?(Array) || inputs.is_a?(Hash))
      end
    end

    def initialize(filename)
      @filename = filename
      self.extend(input_file_module)
    end

    private

    def input_file_module
      type = @filename[/\.(.+)$/, 1]
      raise "Cannot determine file type for: #{@filename}" unless type
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
      headers = csv_data.shift.map {|head| head.to_s.strip }
      string_data = csv_data.map {|row| row.map {|cell| cell.to_s.strip } }

      inputs = Hash.new {|h,k| h[k] = []}

      string_data.each do |row|
        row.each_with_index { |value, index| inputs[headers[index]] << value }
      end

      inputs
    end
  end
end