require 'ruby2ruby'
require 'ruby_parser'
require "to_factory/parsing/ruby_parsing_helpers"
require 'to_factory/parsing/syntax'

module ToFactory
  module Parsing
    class File
      delegate :multiple_factories?, :header?, :parse, :to => :parser
      attr_reader :contents

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
        @parser ||= Syntax.new(@contents)
      end

    end
  end
end
