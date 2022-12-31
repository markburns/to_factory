require "ruby2ruby"
require "ruby_parser"
require "to_factory/parsing/ruby_parsing_helpers"

module ToFactory
  module Parsing
    ParseException = Class.new ::StandardError

    class CouldNotInferClassException < ParseException
      attr_reader :sexp

      def initialize(sexp)
        @sexp = sexp
      end
    end

    class File
      EmptyFileException = Class.new ArgumentError

      include Parsing::RubyParsingHelpers
      attr_accessor :contents

      class << self
        def parse(filename)
          from_file(filename).parse
        end

        def from_file(filename)
          begin
            contents = ::File.read filename
          rescue
            nil
          end
          fail EmptyFileException.new "Invalid file #{filename}" if contents.to_s.strip.length == 0

          new(contents)
        end
      end

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
        raise ParseException.new("Original exception: #{e.message}\n #{e.backtrace.join("\n")}\nToFactory Error parsing \n#{@contents}\n o")
      end

      def header?
        sexp[1][1][1] == :FactoryBot
      rescue
        false
      end

      private

      def representation_from(x)
        Representation.new(name_from(x), parent_from(x), to_ruby(x))
      rescue CouldNotInferClassException => e
        ruby = to_ruby(e.sexp)
        Kernel.warn "ToFactory could not parse\n#{ruby}"
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
        header? ? sexp[3] : sexp
      end

      def name_from(sexp)
        sexp[1][3][1]
      rescue NoMethodError
        raise CouldNotInferClassException.new(sexp)
      end

      def parent_from(x)
        # e.g.
        # s(:call, nil, :factory, s(:lit, :admin), s(:hash, s(:lit, :parent), s(:lit, :"to_factory/user")))
        x[1][4][2][1]
      rescue NoMethodError
        # e.g.
        # s(:call, nil, :factory, s(:lit, :"to_factory/user"))
        x[1][3][1]
      end

      def sexp
        @sexp ||= ruby_parser.process(@contents)
      end
    end
  end
end
