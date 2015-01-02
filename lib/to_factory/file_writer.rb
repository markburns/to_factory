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


end
