module ToFactory
  class OptionsParser
    def initialize(options)
      @options = options
    end

    def get_instance
      args = case @options
             when ActiveRecord::Base
               from_record(@options)
             when Array
               from_array(*@options)
      end

      Representation.new(*args)
    end

    def from_record(record)
      name = calculate_name record.class

      [name, nil, nil, record]
    end

    def from_array(name, record)
      parent_name = calculate_name(record.class)
      parent_name = nil if parent_name.to_s == name.to_s
      [name, parent_name, nil, record]
    end

    def calculate_name(klass)
      klass.name.to_s.underscore
    end
  end
end
