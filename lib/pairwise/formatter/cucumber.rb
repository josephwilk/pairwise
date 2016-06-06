require 'unicode/display_width'

module Pairwise
  module Formatter
    class Cucumber

      def initialize(out)
        @out = out
        @max = {}
      end

      def display(test_data, input_labels)
        @test_data = label_wild_cards(test_data, input_labels)
        @input_labels = input_labels

        @out.print "|"
        @input_labels.each_with_index do |label, column|
          @out.print padded_string(label, column) + "|"
        end
        @out.puts

        @test_data.each do |data|
          @out.print "|"
          data.each_with_index do |datum, column|
            @out.print padded_string(datum, column) + "|"
          end
          @out.puts
        end
      end

      private
      def label_wild_cards(test_data, labels)
        test_data.map do |data|
          data.enum_for(:each_with_index).map do |datum, column|
            datum == IPO::WILD_CARD ? "any_value_of_#{labels[column]}" : datum
          end
        end
      end

      def padded_string(string, column)
        string = string.to_s unless string.is_a? String
        padding_length = max_line_length(column) - string.display_width
        " #{string} " + (" " * padding_length)
      end

      def max_line_length(column)
        @max[column] ||= ([@input_labels[column].to_s.length] + @test_data.map{|data| data[column].to_s.length}).max
      end

    end
  end
end
