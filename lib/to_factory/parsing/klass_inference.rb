module ToFactory
  module Parsing
    CannotInferClass = Class.new ArgumentError

    class KlassInference
      def initialize
        @mapping = {}
        # :name     => :parent_a
        # :parent_a => :parent_b
        # :parent_b => ParentB
        #
        # 
        #fetch(name) ParentB
        # @mapping[:name]
        # => :parent_a
        # @mapping[:parent_a]
        # => :parent_b
        # @mapping[:parent_b]
        # => ParentB
        #
        # @mapping[name]
        #fetch(name2) ParentC
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

      def to_const(parent)
        parent.to_s.camelize.constantize
      rescue NameError
        parent
      end
    end
  end
end
