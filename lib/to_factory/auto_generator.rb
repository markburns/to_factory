module ToFactory
  class AutoGenerator
    def initialize(model_finder=ModelFinder.new, file_writer=FileWriter.new)
      @model_finder = model_finder
      @file_writer = file_writer
    end

    def all!
      klasses = @model_finder.all

      factory_definitions = klasses.map(&:first).each_with_object({}) do |record, result|
        result[record.class.name.underscore.to_sym] = record.to_factory
      end

      @file_writer.write(factory_definitions)
    end
  end

  class ModelFinder
    def initialize(path="./app/models/path")
      @path = File.expand_path(path)
    end

    def all
      klasses = []

      Dir.glob("#{@path}/**/*.rb").each do |file|
        File.readlines(file).each do |f|
          if match = f.match(/class (.*) ?</)
            require file
            klass = eval(match[1]) rescue nil
            klasses << klass if klass && klass.ancestors.include?(ActiveRecord::Base)
          end
        end
      end

      klasses
    end
  end

  class FileWriter
    def initialize(path="./spec/factories")
      @path = path
      FileUtils.mkdir_p(@path)
    end

    def write(definitions)
      definitions.each do |name, definition|
        mkdir(name) if name["/"]
        File.open(File.join(@path, "#{name}.rb"), "w") do |f|
          f << definition
        end
      end
    end

    private

    def mkdir(name)
      dir = name.to_s.split("/")[0..-2]
      FileUtils.mkdir_p File.join(@path, dir)
    end
  end
end
