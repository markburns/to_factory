module ToFactory
  class FileSync
    def initialize(m  = ToFactory::Finders::Model.new,
                   fw = ToFactory::FileWriter.new,
                   ff = ToFactory::Finders::Factory.new)
      @model_finder = wrap_model(m)
      @file_writer  = fw
      @factory_finder = ff
    end

    def perform(exclusions = [])
      @file_writer.write(all_representations(exclusions))
    end

    def all_representations(exclusions = [])
      Collation.organize(
        new_representations(exclusions),
        existing_representations
      )
    end

    def new_representations(exclusions = [])
      instances = @model_finder.call(exclusions: exclusions)

      instances.map { |r| Representation.from(r) }
    end

    private

    def existing_representations
      @factory_finder.call
    end

    def wrap_model(m)
      return m if m.respond_to?(:call)

      lambda do |exclusions = []|
        records = if m.is_a?(ActiveRecord::Base)
                    Array m
                  else
                    m
                  end

        records.reject { |o, _| exclusions.include?(o.class) }
      end
    end
  end
end
