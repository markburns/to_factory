module ToFactory
  module Parsing
    class NewSyntax < Syntax
      def header?
        sexp[1][1][1] == :FactoryGirl rescue false
      end

      def multiple_factories?
        factories_sexp[0] == :block
      end

      def parse
        result = {}

        parse_multiple do |factory_name, ruby|
          result[factory_name] = ruby
        end

        result
      end

      def factories
        if multiple_factories?
          factories_sexp[1..-1]
        else
          [factories_sexp]
        end
      end

      def factories_sexp
        header? ?  sexp[3] : sexp
      end

      def parse_multiple(&block)
        factories.each do |x|
          yield name_from(x), to_ruby(x)
        end
      end

      def name_from(sexp)
        sexp[1][-1][-1]
      end
    end
  end
end
