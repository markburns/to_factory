module ToFactory
  module Parsing
    CannotInferClass = Class.new ArgumentError

    class KlassInference
      def initialize
        @mapping = {}
      end

      def setup(factory_names_and_parents)
        factory_names_and_parents.each do |factory_name, parent|
          @mapping[factory_name.to_s] = to_const(parent || factory_name)
        end
      end

      def parent(factory_name)
        @mapping[factory_name.to_s]
      end

      def infer(factory_name, count=0)
        result  = parent(factory_name)
        return [result, count] if result.is_a? Class

        raise CannotInferClass.new(factory_name) if result.nil?

        infer(result, count+1)
      end

      def hierarchy
        @collection = {}
        @mapping.each do |name,parent|
          klass = infer(name)
          @collection[klass] ||= []
        end
      end

      private

      def to_const(factory_name)
        factory_name.to_s.camelize.constantize
      rescue NameError
        factory_name
      end
    end
  end
end
