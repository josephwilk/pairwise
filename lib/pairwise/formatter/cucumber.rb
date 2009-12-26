module Pairwise
  module Formatter
    class Cucumber

      def initialize(out)
        @out = out
        @max = {}
      end

      def display(test_data, inputs)
        @test_data, @inputs = test_data, inputs

        @out.print "|"
        inputs.each_with_index do |key, column|
          @out.print padded_string(key, column) + "|"
        end
        @out.puts

        test_data.each do |data|
          @out.print "|"
          data.each_with_index do |datum, column|
            @out.print padded_string(datum, column) + "|"
          end
          @out.puts
        end
      end

      private
      def padded_string(string, column)
        padding_length = max_line_length(column) - string.length
        " #{string} " + (" " * padding_length)
      end

      def max_line_length(column)
        @max[column] ||= ([@inputs[column].length] + @test_data.map{|data| data[column].length}).max
      end

    end
  end
end
