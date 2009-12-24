module Pairwise
  module Formatter
    class Cucumber

      def initialize(out)
        @out = out
      end

      def display(test_data, inputs)
        @out.print "|"
        inputs.each do |key|
          @out.print key + "|"
        end
        @out.puts

        test_data.each do |data|
          @out.print "|"
          data.each {|datum| @out.print datum + "|"}
          @out.puts
        end
      end

    end
  end
end
