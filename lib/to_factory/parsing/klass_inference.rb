module ToFactory
  module Parsing
    class KlassInference
      def initialize
        @mapping = {}
      end

      def infer(klass, parent_klass=nil)
        @mapping[klass] ||= klass.to_s.camelize.constantize
      rescue
        infer(parent_klass)
      end
    end
  end
end
