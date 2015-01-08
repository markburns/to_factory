module ToFactory
  class Representation
    delegate :attributes, :to => :record
    attr_accessor :klass, :name, :parent_name, :definition, :hierarchy_order, :record

    class << self
      def from(options)
        new(*parse(options))
      end

      private

      def parse(options)
        case options
        when ActiveRecord::Base
          from_record(options)
        when Array
          from_array(*options)
        end
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

    def initialize(name, parent_name, definition=nil, record=nil)
      @name, @parent_name, @definition, @record =
        name.to_s, parent_name.to_s, definition, record
    end

    def inspect
      "#<ToFactory::Representation:#{object_id} @name: #{@name.inspect}, @parent_name: #{@parent_name.inspect}, @klass: #{klass_name_inspect}>"
    end

    def klass_name_inspect
      @klass.name.inspect rescue "nil"
    end

    def definition
      @definition ||= ToFactory::Generation::Factory.new(self).to_factory
    end
  end
end
