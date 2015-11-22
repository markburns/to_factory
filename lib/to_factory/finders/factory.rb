module ToFactory
  module Finders
    class Factory
      def call
        all = []

        parsed_files.each do |r|
          all = Collation.representations_from(all, r)
        end

        all
      end

      private

      def parsed_files
        Dir.glob(File.join(ToFactory.factories, "**/*.rb")).map do |f|
          parse_file(f)
        end.compact
      end

      def parse_file(f)
        ToFactory::Parsing::File.parse(f)
      rescue ToFactory::Parsing::File::EmptyFileException => e
        #ignore empty files
      end
    end
  end
end
