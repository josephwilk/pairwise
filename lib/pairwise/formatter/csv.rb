module Pairwise
  module Formatter
    class Csv

      def initialize(out)
        @out = out
      end

      def display(test_data, input_labels)
        @out.puts input_labels.join(',')
        test_data.each do |data|
          @out.puts data.join(',')
        end
      end
    end
  end
end