module ToFactory
  module Parsing
    class Syntax
      attr_accessor :contents

      def initialize(contents)
        @contents = contents
      end

      def parse
        raise NotImplemented
      end

      private

      def to_ruby(sexp)
        ruby2ruby.process sexp.deep_clone
      end

      def sexp
        @sexp ||= ruby_parser.process(@contents)
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
