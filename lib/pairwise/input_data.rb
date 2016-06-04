module Pairwise
  class InputData

    def initialize(inputs)
      @inputs = inputs.is_a?(Hash) ? hash_inputs_to_list(inputs) : inputs
    end

    def data
      @data ||= @inputs.map {|input| input.values[0]}
    end

    def labels
      @labels ||= @inputs.map{|input| input.keys}.flatten
    end

    private

    def hash_inputs_to_list(inputs_hash)
      inputs_hash.sort.map do |key, value|
        value = [value] unless value.is_a?(Array)
        {key => value}
      end
    end
  end
end
