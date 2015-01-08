module ToFactory
  module Finders
    class Factory
      def call
        all = []

        parse_files do |r|
          all = Collation.representations_from(all, r)
        end

        all
      end

      private

      def parse_files
        Dir.glob(File.join(ToFactory.factories, "**/*.rb")).each do |f|
          yield ToFactory::Parsing::File.parse(f)
        end
      end

    end
  end
end
