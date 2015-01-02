module ToFactory
  class FileSystem
    include HashCollisionDetection

    def initialize(path="./spec/factories")
      @path = path
      FileUtils.mkdir_p(@path)
    end

    def write(definitions)
      definitions.each do |name, definition|
        mkdir(name) if name.to_s["/"]
        File.open(File.join(@path, "#{name}.rb"), "w") do |f|
          f << definition
        end
      end
    end

    def read
      all_factories = {}

      Dir.glob(File.join(@path, "**/*.rb")).each do |f|
        contents = File.read(f)
        factories = ToFactory::FileParser.parse(contents)
        detect_collisions!(all_factories, factories)
        all_factories.merge!(factories)
      end
    end

    private

    def mkdir(name)
      dir = name.to_s.split("/")[0..-2]
      FileUtils.mkdir_p File.join(@path, dir)
    end
  end
end
