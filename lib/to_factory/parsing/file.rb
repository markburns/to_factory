require 'ruby2ruby'
require 'ruby_parser'
require 'to_factory/parsing/syntax'
require 'to_factory/parsing/new_syntax'

module ToFactory
  module Parsing
    class File
      delegate :multiple_factories?, :header?, :parse, :to => :parser

      def self.parse(filename)
        new(filename).parse
      end

      def initialize(filename)
        @filename = filename
      end

      def parser
        @parser ||= parser_klass.new(@filename)
      end

      private

      def parser_klass
        ToFactory.new_syntax? ? NewSyntax : OldSyntax
      end
    end
  end
end
