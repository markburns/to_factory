module ToFactory
  module Parsing
    class NewSyntax < Syntax
      def header?
        sexp[1][1][1] == :FactoryGirl rescue false
      end

      def parent_from(x)
        # e.g.
        #s(:call, nil, :factory, s(:lit, :admin), s(:hash, s(:lit, :parent), s(:lit, :"to_factory/user")))
        x[1][4][2][1]
      rescue  NoMethodError
        # e.g.
        #s(:call, nil, :factory, s(:lit, :"to_factory/user"))
        x[1][3][1]
      end
    end
  end
end
