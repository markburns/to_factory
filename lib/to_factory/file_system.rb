module ToFactory
  class FileSystem
    include HashCollisionDetection

    def initialize
      FileUtils.mkdir_p(ToFactory.factories)
    end

    def write(definitions)
      definitions.each do |name, definition|
        mkdir(name) if name.to_s["/"]
        File.open(File.join(ToFactory.factories, "#{name}.rb"), "w") do |f|
          f << definition
        end
      end
    end

    def read
      all_factories = {}

      Dir.glob(File.join(ToFactory.factories, "**/*.rb")).each do |f|
        factories = ToFactory::Parsing::File.parse(f)

        detect_collisions!(all_factories, factories)
        all_factories.merge!(factories)
      end

      all_factories
    end

    private

    def mkdir(name)
      dir = name.to_s.split("/")[0..-2]
      FileUtils.mkdir_p File.join(ToFactory.factories, dir)
    end
  end
end
