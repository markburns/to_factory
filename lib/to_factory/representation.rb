module ToFactory
  class Representation
    delegate :attributes, :to => :record
    attr_accessor :klass, :name, :parent_name, :definition, :hierarchy_order, :record

    class << self
      def from(record)
        name, record, parent_name = 
          if record.is_a?(ActiveRecord::Base)
            name = calculate_name record.class

            [name, record, nil]
          elsif record.is_a?(Array)
            name, item = record
            parent_name = calculate_name(item.class)
            parent_name = nil if parent_name.to_s == name.to_s
            [name, item, parent_name]
          else
            raise NotImplementedError
          end

        new(name, parent_name).tap do |r|
          r.record = record
        end
      end

      def calculate_name(klass)
        klass.name.to_s.underscore
      end
    end

    def initialize(name, parent_name, definition=nil)
      @name, @parent_name, @definition =
       name.to_s, parent_name.to_s, definition
    end

    def inspect
      "#<ToFactory::Representation:#{object_id} @name: #{@name.inspect}, @parent_name: #{@parent_name.inspect}, @klass: #{klass_name_inspect}>"
    end

    def klass_name_inspect
      @klass.name.inspect rescue "nil"
    end

    def record=(record)
      unless record.is_a? ActiveRecord::Base
        message = "Generation::Representation expects an ActiveRecord::Base instance"
        message << "\n  but received #{record.inspect}"
        raise ToFactory::MissingActiveRecordInstanceException.new(message)
      end

      @record = record
    end

    def definition
      @definition ||= ToFactory::Generation::Factory.new(self).to_factory
    end
  end
end
