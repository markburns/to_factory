module ToFactory
  class FileSync
    def initialize(m=ModelFinder.new, f=FileSystem.new)
      @model_finder = m
      @file_system  = f
    end

    def perform
      instances = @model_finder.all

      factory_definitions = instances.inject({}) do |result, record|
        factory_name = record.class.name.underscore.to_sym
        result[factory_name] = ToFactory(record)
        result
      end

      @file_system.write(factory_definitions)
    end
  end


end
