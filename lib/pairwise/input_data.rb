module Pairwise
  class InputData
    attr_reader :data, :labels

    def initialize(inputs)
      @data, @labels = *parse_input_data!(inputs)
    end

    private
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