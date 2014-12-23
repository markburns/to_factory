module ToFactory
  class Generator
    attr_accessor :model_class, :object_instance

    def initialize object
      unless object.is_a? ActiveRecord::Base
        raise ToFactory::MissingActiveRecordInstanceException.new("Generator.new expects an ActiveRecord::Base instance")
      end

      @model_class = object.class.to_s
      @object_instance = object
    end

    def factory
      out = "FactoryGirl.define do\n"
      out << "  factory(:#{name}) do\n"
      out << yield if block_given?
      out << "  end\n"
      out << "end\n"
    end

    def factory_with_attributes
      factory do
        to_skip = [:id, :created_at, :updated_at]
        attributes = object_instance.attributes.delete_if{|key, value| to_skip.include? key.to_sym}

        attributes.map do |attr, value|
          factory_attribute(attr, value)
        end.sort.join("\n") << "\n"
      end
    end

    def factory_attribute attr, value=nil
      value ||= object_instance.send(attr)

      "    #{attr} #{value.inspect}"
    end

    def name
      name = model_class.to_s.underscore

      if name["/"]
        "\"#{name}\""
      else
        name
      end
    end
  end
end
