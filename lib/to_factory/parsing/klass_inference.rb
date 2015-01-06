module ToFactory
  module Parsing
    CannotInferClass = Class.new ArgumentError

    class KlassInference
      def initialize
        @mapping = {}
      end

      def setup(klasses_and_parents)
        klasses_and_parents.each do |klass, parent|
          @mapping[klass.to_s] = to_const(parent || klass)
        end
      end

      def infer(klass)
        result = @mapping[klass.to_s]
        return result if result.is_a? Class

        raise CannotInferClass.new(klass) if result.nil?

        infer(result)
      end

      private

      def to_const(klass)
        klass.to_s.camelize.constantize
      rescue NameError
        klass
      end
    end
  end
end
