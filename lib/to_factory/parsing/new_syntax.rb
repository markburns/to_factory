module ToFactory
  module Parsing
    class NewSyntax < Syntax
      def header?
        sexp[1][1][1] == :FactoryGirl rescue false
      end
    end
  end
end
