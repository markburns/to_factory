module ToFactory
  module Parsing
    ParseException = Class.new ::Exception

    class CouldNotInferClassException < ::Exception
      attr_reader :sexp

      def initialize(sexp)
        @sexp = sexp
      end
    end

    class Syntax
      include Parsing::RubyParsingHelpers
      attr_accessor :contents

      def initialize(contents)
        @contents = contents
      end

      def multiple_factories?
        factories_sexp[0] == :block
      end

      def parse
        factories.map do |x|
          representation_from(x)
        end

      rescue Racc::ParseError, StringScanner::Error => e
        raise ParseException.new("Original exception: #{e.message}\n #{e.backtrace}\nToFactory Error parsing \n#{@contents}\n o")
      end


      def representation_from(x)
        Representation.new(name_from(x), parent_from(x), to_ruby(x))
      rescue CouldNotInferClassException => e
        NullRepresentation.new(e.sexp)
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
      rescue NoMethodError
        raise CouldNotInferClassException.new(sexp)
      end

      private

      def sexp
        @sexp ||= ruby_parser.process(@contents)
      end

    end
  end
end
