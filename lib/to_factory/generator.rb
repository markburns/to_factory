module ToFactory
  class Generator
    attr_accessor :model_class, :object_instance

    def initialize object
      unless object.is_a? ActiveRecord::Base
        message = "Generator requires initializing with an ActiveRecord::Base instance"
        message << "\n  but received #{object.inspect}"
        raise ToFactory::MissingActiveRecordInstanceException.new(message)
      end

      @model_class = object.class.to_s
      @object_instance = object
    end

    def to_factory
      header do
        to_skip = [:id, :created_at, :updated_at]
        attributes = object_instance.attributes.delete_if{|key, _| to_skip.include? key.to_sym}

        attributes.map do |attr, value|
          factory_attribute(attr, value)
        end.sort.join("\n") << "\n"
      end
    end


    def header(&block)
      if new_syntax?
        modern_header &block
      else
        header_factory_girl_1 &block
      end
    end

    def modern_header(&block)
      out = "FactoryGirl.define do\n"
      out << "  factory(:#{name}) do\n"
      out << yield.to_s
      out << "  end\n"
      out << "end\n"
    end

    def header_factory_girl_1(&block)
      out = "Factory.define(:#{name}) do |o|\n"
      out << yield.to_s
      out << "end\n"
    end

    def factory_attribute(attr, value)
      if new_syntax?
        "    #{attr} #{inspect_value(value)}"
      else
        "  o.#{attr} #{inspect_value(value)}"
      end
    end

    def name
      name = model_class.to_s.underscore

      if name["/"]
        "\"#{name}\""
      else
        name
      end
    end

    private

    def inspect_value(value)
      case value
      when Time, DateTime
        value.strftime("%Y-%m-%dT%H:%MZ").inspect
      when BigDecimal
        value.to_f.inspect
      when Hash
        hash = value.inject({}){|result, (k, v)| result[k] = inspect_value(v); result}
      when Array
        value.map{|v| inspect_value(v)}
      else
        value.inspect
      end
    end

    def new_syntax?
      if FactoryGirl::VERSION.to_s[0].to_i > 1
        true
      else
        false
      end
    rescue NameError
      false
    end
  end
end
