module ToFactory
  class MissingActiveRecordInstanceException < Exception;end
  class MustBeActiveRecordSubClassException < Exception;end

  def self.included base
    base.class_eval do
      unless self.ancestors.include? ActiveRecord::Base
        raise MustBeActiveRecordSubClassException
      end

    end

    base.instance_eval do
      define_method :to_factory do
        Generator.new(self).factory_with_attributes
      end
    end
  end

  class Generator
    attr_accessor :model_class, :object_instance

    def initialize object=nil
      return unless object

      if object.is_a? ActiveRecord::Base
        @model_class = object.class.to_s
        @object_instance = object
      else
        @model_class = object
      end
    end

    def factory
      out = "FactoryGirl.define do\n"
      out << "  factory(:#{name}) do\n"
      out << yield if block_given?
      out << "  end\n"
      out << "end"
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

    def factory_for options
      @object_instance = find_from options
      return nil unless @object_instance
      factory_with_attributes
    end

    private
    def find_from options
      return model_class.find options if options.is_a? Integer
      unless options.is_a? Hash
        raise ArgumentError.new("Expected hash of attributes or integer to look up record")
      end

      options = options.with_indifferent_access

      if id=options['id'].to_i
        return model_class.find(id) if id > 0
      end

      finder, params = finder_and_params_from_options options

      model_class.send finder, *params
    end

    public

    def factory_attribute attr, value=nil
      raise MissingActiveRecordInstanceException unless object_instance

      value = object_instance.send attr unless value

      value = "nil" if value.nil?
      value = "\"#{value}\"" if value.is_a? String
      "    #{attr} #{value}"
    end

    def name
      model_class.to_s.underscore
    end

    private

    def finder_and_params_from_options options
      params =[]
      finder = "find_by_"

      options.keys.each do |k|
        if finder == "find_by_"
          finder << k
        else
          finder << "_and_#{k}"
        end

        value = options[k]
        params << value
      end

      [finder, params]
    end

    def abbreviation
      name[0..0]
    end
  end
end
