module ToFactory
  class DefinitionGroup
    def self.perform(instances)
      new.perform(instances)
    end

    def perform(instances)
      instances.inject({}) do |result, record|
        klass, name, definition = define_factory(record)
        result[klass] ||= {}
        result[klass][name] = definition
        result
      end
    end

    def define_factory(record)
      name, item = if record.is_a?(ActiveRecord::Base)
                     name = calculate_name record.class

                     [name, record]
                   elsif record.is_a?(Array)
                     name, item = record
                     [name, item]
                   else
                     raise NotImplemented
                   end

      definition = ToFactory::Generator.new(item, name).to_factory

      [item.class, name, definition]
    end

    def calculate_name(klass)
      klass.name.to_s.underscore
    end
  end
end


