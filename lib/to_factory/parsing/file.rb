require 'ruby2ruby'
require 'ruby_parser'
require 'to_factory/parsing/syntax'
require 'to_factory/parsing/new_syntax'
require 'to_factory/parsing/old_syntax'

module ToFactory
  module Parsing
    class File
      delegate :multiple_factories?, :header?, :parse, :to => :parser

      def self.parse(filename)
        from_file(filename).parse
      end

      def self.from_file(filename)
        contents = ::File.read filename rescue nil
        raise ArgumentError.new "Invalid file #{filename}"  if contents.to_s.length == 0

        new(contents)
      end

      def initialize(contents)
        @contents = contents
      end

      def parser
        @parser ||= parser_klass.new(@contents)
      end

      private

      def parser_klass
        ToFactory.new_syntax? ? NewSyntax : OldSyntax
      end
    end
  end
end
