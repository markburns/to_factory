module ToFactory
  class FileWriter
    def initialize(m=ModelFinder.new, f=FileSystem.new)
      @model_finder = m.is_a?(String) ? ModelFinder.new(m) : m
      @file_system  = f.is_a?(String) ? FileSystem .new(f) : f
    end

    def all!
      instances = @model_finder.all

      factory_definitions = instances.inject({}) do |result, record|
        result[record.class.name.underscore.to_sym] = ToFactory(record)
        result
      end

      @file_system.write(factory_definitions)
    end
  end

  class ModelFinder
    def initialize(path="./app/models/path")
      @path = File.expand_path(path)
    end

    def all
      instances = []

      Dir.glob("#{@path}/**/*.rb").each do |file|
        File.readlines(file).each do |f|
          if match = f.match(/class (.*) ?</)
            klass = rescuing_require file, match
            instance = get_active_record_instance(klass)
            instances << instance if instance
          end
        end
      end

      instances
    end

    private

    def rescuing_require(file, match)
      require file
      klass = eval(match[1])

    rescue Exception => e
      warn "Failed to eval #{file}"
      warn e.message
    end

    def get_active_record_instance(klass)
      if klass && klass.ancestors.include?(ActiveRecord::Base)
        begin
          klass.first
        rescue
          klass.find(:first)
        end
      end
    rescue Exception => e
      warn "Failed to get record from #{klass} #{e.message}"
    end
  end

  class FileSystem
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

    private

    def mkdir(name)
      dir = name.to_s.split("/")[0..-2]
      FileUtils.mkdir_p File.join(@path, dir)
    end
  end
end
