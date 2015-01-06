module ToFactory
  module Parsing
    class OldSyntax < Syntax
      def header?
        false
      end

      def parent_from(x)
        x[1][-1][-1][-1] rescue name_from(x)
      end
    end
  end
end
