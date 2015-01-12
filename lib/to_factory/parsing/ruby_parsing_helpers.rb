module ToFactory
  module Parsing
    module RubyParsingHelpers
      def to_ruby(sexp)
        ruby2ruby.process sexp.deep_clone
      end

      def ruby2ruby
        @ruby2ruby ||= Ruby2Ruby.new
      end

      def ruby_parser
        @ruby_parseer ||= RubyParser.new
      end
    end
  end
end
