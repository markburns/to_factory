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
          ToFactory::Parsing::File.parse(f)
        end
      end
    end
  end
end
