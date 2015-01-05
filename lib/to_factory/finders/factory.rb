module ToFactory
  module Finders
    class Factory
      def call
        all_factories = {}

        Dir.glob(File.join(ToFactory.factories, "**/*.rb")).each do |f|
          factories = ToFactory::Parsing::File.parse(f)

          all_factories = Collation.merge(all_factories, factories)
        end

        all_factories
      end
    end
  end
end
