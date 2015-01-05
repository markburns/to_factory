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
      name, item, parent_klass = extract_details(record)

      definition = ToFactory::Generator.new(item, name).to_factory(parent_klass)

      [item.class, name, definition]
    end

    def calculate_name(klass)
      klass.name.to_s.underscore
    end

    private

    def extract_details(record)
      if record.is_a?(ActiveRecord::Base)
        name = calculate_name record.class

        [name, record, nil]
      elsif record.is_a?(Array)
        name, item = record
        parent_klass_name = calculate_name(item.class)
        parent_klass_name = nil if parent_klass_name.to_s == name.to_s
        [name, item, parent_klass_name]
      else
        raise NotImplemented
      end
    end
  end
end


