module ToFactory
  class FileSync
    def initialize(m  = ToFactory::Finders::Model.new,
                   fw = ToFactory::FileWriter.new,
                   ff = ToFactory::Finders::Factory.new)
      @model_finder = wrap_model(m)
      @file_writer  = fw
      @factory_finder = ff
    end

    def perform
      definitions = Collation.merge(new_definitions, pre_existing)

      @file_writer.write(definitions)
    end

    def new_definitions
      instances = @model_finder.call

      DefinitionGroup.perform(instances)
    end

    private

    def pre_existing
      @factory_finder.call
    end

    def wrap_model(m)
      if m.respond_to?(:call)
        m
      else
        lambda{
          if m.is_a?(ActiveRecord::Base)
            Array m
          else
            m
          end
        }
      end
    end
  end
end
