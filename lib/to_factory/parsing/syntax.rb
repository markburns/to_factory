module ToFactory
  module Parsing
    ParseException = Class.new ::Exception

    class Syntax
      attr_accessor :contents

      def initialize(contents)
        @contents = contents
      end

      def multiple_factories?
        factories_sexp[0] == :block
      end

      def parse
        factories.map do |x|
          Representation.new(name_from(x), parent_from(x), to_ruby(x))
        end

      rescue Racc::ParseError, StringScanner::Error => e
        raise ParseException.new("Original exception: #{e.message}\n #{e.backtrace}\nToFactory Error parsing \n#{@contents}\n o")
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

      def name_from(sexp)
        sexp[1][3][1]
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
